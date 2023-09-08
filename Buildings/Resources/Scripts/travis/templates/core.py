#!/usr/bin/env python
# coding: utf-8

# Requires Python >= 3.9

# This file contains imports and functions used by other Python scripts in the same directory.

import inspect
import itertools
import os
import re
import sys

# For CPU- and I/O-heavy jobs, we prefer multiprocessing.Pool because it provides better process isolation.
from multiprocessing import Pool

import pandas as pd

CRED = '\033[91m'
CGREEN = '\033[92m'
CEND = '\033[0m'


def simulate_case(
    arg: tuple[str, list[str], str],
    simulator: str,
) -> tuple[int, str]:
    """Set common parameters and run simulation with buildingspy.

    Args:
        arg: tuple with (model name, list of class modifications, suffix for mat file name)
        simulator: Modelica tool for simulating the model

    Returns:
        (error code, log) tuple: error code is 0 for success
    """
    # Local imports required for multiprocessing in Jupyter notebook.
    import glob
    import json
    import os
    import re
    import shutil
    import tempfile

    if simulator == 'Dymola':
        from buildingspy.simulate.Dymola import Simulator
    elif simulator == 'Optimica':
        from buildingspy.simulate.Optimica import Simulator
    else:
        return 4, f'Unsupported simulation tool: {simulator}.'

    mat_root = re.split(r"\.", arg[0])[-1]
    mat_suffix = re.sub(r"\.", "_", str(arg[2]))
    output_dir_prefix = f"{mat_root}_{mat_suffix}"
    cwd = os.getcwd()
    # We need to create temporary directories at the same level as Buildings because of
    # the way volumes are mounted in docker run, see Buildings/Resources/Scripts/travis/dymola/dymola.
    output_dir_path = tempfile.mkdtemp(prefix=output_dir_prefix, dir=os.path.abspath(os.pardir))

    # The following make Dymola worker cd into outputDirectory.
    s = Simulator(arg[0], outputDirectory=output_dir_path)

    if simulator == 'Dymola':
        s.addPreProcessingStatement(r'Advanced.TranslationInCommandLog:=true;')
        s.addPreProcessingStatement(r'openModel("../Buildings/package.mo", changeDirectory=false);')
    if simulator == 'Optimica':
        # Set MODELICAPATH (only in child process, so this won't affect main process).
        os.environ['MODELICAPATH'] = os.path.abspath(os.pardir)

    for modif in arg[1]:
        s.addModelModifier(modif)

    s.setSolver("CVode")
    s.setTolerance(1e-6)
    s.printModelAndTime()

    try:
        s.simulate()
    except Exception as e:
        toreturn = 2
        print(e)
    finally:
        os.chdir(cwd)

    # Test if simulation succeeded.
    try:
        if simulator == 'Dymola':
            with open(os.path.join(output_dir_path, 'simulator.log')) as fh:
                log = fh.read()
            if re.search('\n = false', log):
                toreturn = 1
            else:
                toreturn = 0
        elif simulator == 'Optimica':
            with open(
                glob.glob(os.path.join(fr'{output_dir_path}', '*buildingspy.json'))[0], 'r'
            ) as f:
                log = json.load(f)
            if log['simulation']['success']:
                toreturn = 0
            else:
                toreturn = 1
    except (FileNotFoundError, IndexError) as e:
        toreturn = 3
        log = e
    finally:
        if toreturn == 0:
            shutil.rmtree(output_dir_path, ignore_errors=True)
        else:
            print(
                f'Simulation failed in {output_dir_path} with the following class modifications:\n'
                + ',\n'.join(arg[1])
                + '\n'
            )

    return toreturn, log


def simulate_cases(
    args: list[tuple[str, list[str]]],
    simulator: str,
    asy: bool = True,
) -> list[tuple[int, str]]:
    """Main method that configures and runs all simulations.

    Returns:
        List of (error code, log) tuples
    """
    # Workaround for multiprocessing that isn't strictly supported on Windows Jupyter Notebook.
    with open('tmp_func.py', 'w') as file:
        file.write(inspect.getsource(simulate_case).replace(simulate_case.__name__, "task"))
    sys.path.append('.')
    from tmp_func import task

    args_with_fixed = [(el, simulator) for el in args]
    results = []
    func = task
    pool = Pool(os.cpu_count())
    if asy:
        results = pool.starmap_async(func, args_with_fixed)
    else:
        results = pool.starmap(func, args_with_fixed)
    pool.close()
    pool.join()

    return results


def generate_modif_list(dic: dict[str, list[str]]) -> list[str]:
    """Generates a list of class modifications.

    Args:
        dic: A dictionary where each key is the component or variable to be modified,
             and the corresponding value is a list of modifications to be applied.
    """
    to_return = []
    for param, val in dic.items():
        if 'redeclare' in param:
            modif = re.sub('(.*)redeclare__(.*)', fr'\g<1>redeclare {val} \g<2>', param)
        else:
            modif = param + '=' + val
        modif = re.sub('__', '(', modif)
        modif = modif + ')' * modif.count('(')
        to_return.append(modif)
    return to_return


# The function below is kept for reference, but it is not used as it yields tags that are too long.
#
# def generate_tag(dic):
#     tag = ''
#     for param, val in dic.items():
#         tag = tag + '_' + re.split(r'\.', val)[-1]
#     return re.sub('^_', '', tag)


def remove_items_by_indices(lst: list, indices: list[int]) -> None:
    """Removes items from list (in place) based on their indices."""
    for idx in sorted(list(dict.fromkeys(indices)), reverse=True):
        if idx < len(lst):
            lst.pop(idx)


def generate_combinations(
    models: list[str],
    modif_grid: dict[str, dict[str, list[str]]],
) -> list[tuple[str, list[str], str]]:
    """Generate all possible combinations.

    Returns: a list of 3-tuples where
        the first item of the tuple is a model to be simulated,
        the second item of the tuple is the list of class modifications,
        the third item of the tuple is a tag.
    """

    # Generate combinations.
    # combinations_dicts is a dictionary where
    #   each key is a model to be simulated,
    #   each value is a list of dictionaries where each key is the component or variable
    #   to be modified, and the corresponding value is the modification to be applied.
    combinations_dicts = dict()
    for model in models:
        keys, values = zip(*modif_grid[model].items())
        combinations_dicts[model] = [dict(zip(keys, v)) for v in itertools.product(*values)]

    combinations = []
    tag = 0  # Simply tag each element with str(index).
    for model, modif_dict_list in combinations_dicts.items():
        for el in modif_dict_list:
            combinations.append((model, generate_modif_list(el), str(tag)))
            tag = tag + 1

    return combinations


def prune_modifications(
    combinations: list[tuple[str, list[str]]],
    remove_modif: dict[str, list[tuple[list[str], list[str]]]],
    exclude: dict[str, list[list[str]]],
) -> None:
    """Remove class modifications.

    Returns:
        None (modifies inplace)
    """
    indices_to_pop = []
    for i, arg in enumerate(combinations):
        tmp = []
        if arg[0] in remove_modif:
            modif_concat = ''.join(arg[1])
            for item in remove_modif[arg[0]]:
                if all(re.search(el, modif_concat) for el in item[0]):
                    for pattern_to_remove in item[1]:
                        for j, modif in enumerate(arg[1]):
                            if re.search(pattern_to_remove, modif):
                                tmp.append(j)
        indices_to_pop.append(tmp)

    for i in range(len(combinations)):
        remove_items_by_indices(combinations[i][1], indices_to_pop[i])

    # Remove duplicates.
    indices_to_pop = []
    for i, arg in enumerate(combinations):
        for j in range(i + 1, len(combinations)):
            if arg[:2] == combinations[j][:2]:  # Compare w/o tag at index 3.
                indices_to_pop.append(j)
    remove_items_by_indices(combinations, indices_to_pop)

    # Exclude cases.
    ## We iterate over a copy of the `combinations` list to allow removing items of `combinations` during iteration.
    for arg in combinations.copy():
        if arg[0] in exclude:
            modif_concat = ''.join(arg[1])
            if any(all(re.search(el, modif_concat) for el in ell) for ell in exclude[arg[0]]):
                combinations.remove(arg)

    print(f'Number of cases to be simulated: {len(combinations)}.\n')


def report_clean(
    combinations: list[tuple[str, list[str]]],
    results: list[tuple[int, str]],
) -> pd.DataFrame:
    """Report and clean after simulations."""

    try:
        os.unlink('tmp_func.py')
        os.unlink('unitTestsTemplates.log')
    except FileNotFoundError:
        pass

    df = pd.DataFrame(
        dict(
            model=[el[0] for el in combinations],
            tag=[el[2] for el in combinations],
            modif=[el[1] for el in combinations],
            errorcode=[r[0] for r in results],
            errorlog=[r[1] for r in results],
        )
    )

    with open('unitTestsTemplates.log', 'w') as FH:
        for idx in df[df.errorcode != 0].index:
            FH.write(
                f'*** Simulation failed for {df.iloc[idx].model} with the error code {df.iloc[idx].errorcode} '
                + 'and the following class modifications and error log.\n\n'
                + ',\n'.join(df.iloc[idx].modif)
                + f'\n\n{df.iloc[idx].errorlog}\n\n'
            )

    return df

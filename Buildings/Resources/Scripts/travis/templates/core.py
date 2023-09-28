#!/usr/bin/env python
# coding: utf-8

"""Provide definitions and common declarations used by other scripts in the same directory.

Args:
    Scripts that import this module take the following optional positional arguments.
    - str: Modelica tool to use (case-insensitive): Dymola or Optimica, defaulting to Dymola.
    - float: Fraction of test coverage between 0 (>) and 1 (<=): 1 should be for used for PR
      against master, other values are for local testing only.
"""

import argparse
import gc
import glob
import itertools
import os
import pickle
import random
import re
import sys
from math import ceil, floor

# For CPU- and I/O-heavy jobs, we prefer multiprocessing.Pool because it provides better process isolation.
from multiprocessing import Pool

import pandas as pd
import yaml

assert sys.version_info >= (3, 8), "This script requires a Python version >= 3.8."

CRED = '\033[91m'
CGREEN = '\033[92m'
CEND = '\033[0m'

# Parse conf.yml.
with open('./Resources/Scripts/BuildingsPy/conf.yml', 'r') as FH:
    CONF = yaml.safe_load(FH)


def parse_args():
    """Parse script arguments."""
    parser = argparse.ArgumentParser(description='Generate combinations and run simulations')
    parser.add_argument(
        "--tool",
        type=str,
        help="tool to run simulations (case-insensitive)",
        default='dymola',
        required=False,
    )
    parser.add_argument(
        "--coverage",
        type=float,
        help="fraction of test coverage between 0 (>) and 1 (<=)",
        default=1,
        required=False,
    )
    parser.add_argument("--generate", help="generate combinations", action="store_true")
    parser.add_argument("--simulate", type=str, help="path of combination file", required=False, default=None)
    args = parser.parse_args()

    assert (
        args.coverage > 0 and args.coverage <= 1
    ), "Fraction of test coverage must be between (>) 0 and (<=) 1."

    return args


def check_conf(model_name, simulator, conf=CONF):
    """Check whether a model is included in conf.yml for the given simulator."""
    simulator = simulator.lower()
    for el in conf:
        list_keys = list(el.keys())
        if model_name == el['model_name'] and simulator in list(el.keys()):
            return True
    return False


def simulate_case(arg, simulator):
    """Set common parameters and run simulation with buildingspy.

    Args:
        arg: tuple[str, list[str], str]: Model name, list of class modifications, suffix for mat file name.
        simulator: str: Modelica tool for simulating the model.

    Returns:
        tuple[int, str]: Error code, log.
    """
    # Local imports required for multiprocessing in Jupyter notebook.
    import glob
    import json
    import os
    import re
    import shutil
    import tempfile

    simulator = simulator.lower()

    if simulator == 'dymola':
        from buildingspy.simulate.Dymola import Simulator
    elif simulator == 'optimica':
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

    if simulator == 'dymola':
        s.addPreProcessingStatement(r'Advanced.TranslationInCommandLog:=true;')
        s.addPreProcessingStatement(r'openModel("../Buildings/package.mo", changeDirectory=false);')
    if simulator == 'optimica':
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
        if simulator == 'dymola':
            with open(os.path.join(output_dir_path, 'simulator.log')) as fh:
                log = fh.read()
            if re.search('\n = false', log):
                toreturn = 1
            else:
                toreturn = 0
        elif simulator == 'optimica':
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
            # We delete the log of successful simulations to limit memory usage.
            log = None

    return toreturn, log


def simulate_cases(args, simulator, asy=False):
    """Configure and run all simulations.

    Args:
        args: list[tuple[str, list[str]]]: List of (model name, list of class modifications, suffix for mat file name).
        simulator: str: Modelica tool for simulating the model.
        asy: bool: If True run simulations asynchronously.

    Returns:
        list[tuple[int, str]]: List of (error code, log).
    """
    args_with_fixed = [(el, simulator) for el in args]
    results = []
    pool = Pool(os.cpu_count())
    if asy:
        results = pool.starmap_async(simulate_case, args_with_fixed)
    else:
        results = pool.starmap(simulate_case, args_with_fixed)
    pool.close()
    pool.join()

    # DEBUG: Try to release memory.
    if not asy:
        del pool
        gc.collect()

    return results


def generate_modif_list(dic):
    """Generate list of class modifications.

    Args:
        dic: dict[str, list[str]]: Dictionary where each key is the component or variable to be modified,
            and each value is a list of modifications to be applied.
            Bindings for parameters of redeclared components can be appended as class modifications, e.g.
            'VAV_1__redeclare__fanSupBlo': [
                'Buildings.Templates.Components.Fans.ArrayVariable(nFan=2)',
            ],

    Returns:
        list[str]: List of class modifications.
    """
    to_return = []
    for param, val in dic.items():
        if 'redeclare' in param:
            modif_val = re.search('(.*)\((.*)\)', val)
            if modif_val is not None:
                comp_type = modif_val.group(1)
                comp_modif = '(' + modif_val.group(2)
            else:
                comp_type = val
                comp_modif = ''
            modif = re.sub(
                '(.*)redeclare__(.*)',
                fr'\g<1>redeclare {comp_type} \g<2>',
                param + comp_modif,
            )
        else:
            modif = param + '=' + val
        modif = re.sub('__', '(', modif)
        modif = modif + ')' * modif.count('(')
        to_return.append(modif)
    return to_return


def remove_items_by_indices(lst, indices):
    """Remove (inplace) items from list based on their indices.

    Args:
        lst: list
        indices: list[int]

    Returns:
        None
    """
    for idx in sorted(list(dict.fromkeys(indices)), reverse=True):
        if idx < len(lst):
            lst.pop(idx)


def generate_combinations(models, modif_grid):
    """Generate all possible combinations.

    Args:
        models: list[str]: List of model names.
        modif_grid: dict[str, dict[str, list[str]]]: Dictionary where each key is a model name,
            and each value is a dictionary where each key resolves into a component to modify
            and each value is a list of modifications to be applied to the component.

    Returns:
        list[tuple[str, list[str], str]]: List of 3-tuples where
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


def prune_modifications(combinations, exclude, remove_modif, fraction_test_coverage):
    """Remove class modifications, and update combination tag.

    Args:
        combinations: list[tuple[str, list[str], str]]: List of combinations as generated
            by `generate_combinations`.
        remove_modif: dict[str, list[tuple[list[str], list[str]]]]: Dictionary providing modifications
            to be removed, see below.
        exclude: dict[str, list[list[str]]]: Dictionary providing modifications to be excluded, see below.
        fraction_test_coverage: float = Fraction (>0 and <=1) of test coverage to further reduce the number
            of combinations (randomly). 1 should be for used for PR against master.

    Returns:
        None (modifies inplace)

    Details:
        A combination is a model and a list of class modifications (and a tag).

        For a given combination:
            - The `remove_modif` argument is used to remove a *single* class modification.
            Removing class modifications this way yields many duplicate combinations.
            These duplicates are pruned afterwards.
            - The `exclude` argument is used to exclude a combination entirely, i.e., *all* class modifications.

        Exclude (first): A combination is excluded if the following exclusion test returns true.
            - Look for the model (key) in exclude (dict).
            - Iterate over the list of list of class modifications for this model (value of exclude[model]).
            - For a given list of class modifications, return true if all strings are found in the original
            class modifications of the combination (concatenated).
            - Note: re patterns are supported, e.g., negative lookahead using (?!pattern)

        Remove (after exclude): A class modification is removed from a combination according to the following rules.
            For each item (2-tuple) of the list provided (as value) for each model (key) in remove_modif (dict):
            - if all patterns of item[0] are found in the original class modifications of the combination (concatenated), and
            - if a class modification contains any item within item[1], then
            - this class modification is removed.
            - Note: re patterns are supported, e.g., negative lookahead using (?!pattern)

        Example:
            - Exclude: For a CHW plant, a combination with chillers in series arrangement and dedicated primary CHW pumps
                can be excluded.
            - Remove single modification: For a VAV air handler, a combination with a electric heating coil and a three-way valve
                for the heating coil should use `remove_modif` to remove the valve component modification. We cannot use
                `exclude` here because there is a modification of the valve component in each combination, so we would end up
                excluding all combinations with a electric heating coil.
    """
    # Exclude cases.
    ## We iterate over a copy of the `combinations` list to allow removing items of `combinations` during iteration.
    if exclude is not None:
        for arg in combinations.copy():
            if arg[0] in exclude:
                modif_concat = ''.join(arg[1])
                if any(
                    all(re.search(modif_ex, modif_concat) for modif_ex in list_modif_ex)
                    for list_modif_ex in exclude[arg[0]]
                ):
                    combinations.remove(arg)

    if remove_modif is not None:
        for i, arg in enumerate(combinations):
            indices_to_pop = []
            if arg[0] in remove_modif:
                modif_concat = ''.join(arg[1])
                for item in remove_modif[arg[0]]:
                    if all(re.search(el, modif_concat) for el in item[0]):
                        for pattern_to_remove in item[1]:
                            for j, modif in enumerate(arg[1]):
                                if re.search(pattern_to_remove, modif):
                                    indices_to_pop.append(j)
            remove_items_by_indices(combinations[i][1], indices_to_pop)

    # Remove duplicates.
    indices_to_pop = []
    for i, arg in enumerate(combinations):
        for j in range(i + 1, len(combinations)):
            if arg[:2] == combinations[j][:2]:  # Compare w/o tag at index 3.
                indices_to_pop.append(j)
    remove_items_by_indices(combinations, indices_to_pop)

    # Apply fraction of test coverage.
    if fraction_test_coverage is not None:
        remove_items_by_indices(
            combinations,
            random.sample(
                range(len(combinations)), int(len(combinations) * (1 - fraction_test_coverage))
            ),
        )

    # Update tags. (Because pruning resulted in a sparse list of indices.)
    for i, arg in enumerate(combinations):
        combinations[i] = (*combinations[i][:2], str(i))


def report_clean(combinations, results):
    """Report, clean and exit(1) if any simulations failed.

    Args:
        combinations: list[tuple[str, list[str], str]]: List of combinations.
        results: list[tuple[int, str]]: List of (error code, log).

    Returns:
        pd.DataFrame
    """
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

    assert len(df) == len(
        combinations
    ), 'Error when trying to retrieve simulation results as a DataFrame.'

    # Log and exit if any simulations failed.
    if df.errorcode.abs().sum() != 0:
        with open('unitTestsTemplates.log', 'w') as FH:
            for idx in df[df.errorcode != 0].index:
                FH.write(
                    f'*** Simulation failed for {df.iloc[idx].model} with the error code {df.iloc[idx].errorcode} '
                    + 'and the following class modifications and error log.\n\n'
                    + ',\n'.join(df.iloc[idx].modif)
                    + f'\n\n{df.iloc[idx].errorlog}\n\n'
                )
        number_failure = df.errorcode.apply(lambda x: 1 if x != 0 else 0).sum()
        print(
            CRED
            + f'{int(number_failure / len(df) * 100)} % of the simulations failed. '
            + CEND
            + 'See the file `unitTestsTemplates.log`.\n'
        )
        sys.exit(1)

    # Release memory.
    del combinations
    del results
    gc.collect()

#!/usr/bin/env python
# coding: utf-8

# This script shall be run from the top level directory within `modelica-buildings`,
# i.e., where `./Buildings` can be found.
# The script takes as an optional positional argument the Modelica tool to use
# (Dymola or Optimica, defaulting to Dymola).
# The script performs the following tasks.
# - Generate all possible combinations of class modifications based on a set of
#   parameter bindings and redeclare statements provided in `MODIF_GRID`.
# - Exclude the combinations based on a match with the patterns provided in `EXCLUDE`.
#   - This allows excluding unsupported configurations.
# - Exclude the class modifications based on a match with the patterns provided in `REMOVE_MODIF`,
#   and prune the resulting duplicated combinations.
#   - This allows reducing the number of simulations by excluding class modifications that
#     yield the same model, i.e., modifications to parameters that are not used (disabled) in
#     the given configuration.
# - For the remaining combinations: run the corresponding simulations for the models in `MODELS`.
# The script returns
# - 0 if all simulations succeed,
# - 1 otherwise.

import inspect
import itertools
import os
import re
import sys
# For CPU- and I/O-heavy jobs, we prefer multiprocessing.Pool because it provides better process isolation.
from multiprocessing import Pool

import numpy as np
import pandas as pd

try:
    SIMULATOR = sys.argv[1]
except IndexError:
    SIMULATOR = 'Dymola'

MODELS = [
    'Buildings.Templates.HeatingPlants.HotWater.Validation.BoilerPlant',
]

CRED = '\033[91m'
CGREEN = '\033[92m'
CEND = '\033[0m'

MODIF_GRID = {
    'Buildings.Templates.HeatingPlants.HotWater.Validation.BoilerPlant':
        dict(
            BOI__typ=[
                'Buildings.Templates.HeatingPlants.HotWater.Types.Boiler.Condensing',
                'Buildings.Templates.HeatingPlants.HotWater.Types.Boiler.NonCondensing',
                'Buildings.Templates.HeatingPlants.HotWater.Types.Boiler.Hybrid',
            ],
            BOI__nBoiCon_select=[
                '2',
            ],
            BOI__nBoiNon_select=[
                '2',
            ],
            BOI__typPumHeaWatPriCon=[
                'Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.Variable',
                'Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.Constant',
                'Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.FactoryVariable',
                'Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.FactoryConstant',
            ],
            BOI__typPumHeaWatPriNon=[
                'Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.Variable',
                'Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.Constant',
                'Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.FactoryVariable',
                'Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.FactoryConstant',
            ],
            BOI__typArrPumHeaWatPriCon_select=[
                'Buildings.Templates.Components.Types.PumpArrangement.Dedicated',
                'Buildings.Templates.Components.Types.PumpArrangement.Headered',
            ],
            BOI__typArrPumHeaWatPriNon_select=[
                'Buildings.Templates.Components.Types.PumpArrangement.Dedicated',
                'Buildings.Templates.Components.Types.PumpArrangement.Headered',
            ],
            BOI__typPumHeaWatSec1_select=[
                'Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.Centralized',
                'Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None',
            ],
            BOI__typPumHeaWatSec2_select=[
                'Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.Centralized',
            ],
            BOI__ctl__typMeaCtlHeaWatPri=[
                'Buildings.Templates.HeatingPlants.HotWater.Types.PrimaryOverflowMeasurement.FlowDecoupler',
                'Buildings.Templates.HeatingPlants.HotWater.Types.PrimaryOverflowMeasurement.FlowDifference',
                'Buildings.Templates.HeatingPlants.HotWater.Types.PrimaryOverflowMeasurement.TemperatureSupplySensor',
                'Buildings.Templates.HeatingPlants.HotWater.Types.PrimaryOverflowMeasurement.TemperatureBoilerSensor',
            ],
            BOI__ctl__have_senDpHeaWatLoc=[
                'true',
                'false',
            ],
            BOI__ctl__locSenVHeaWatPri=[
                'Buildings.Templates.HeatingPlants.HotWater.Types.SensorLocation.Supply',
                'Buildings.Templates.HeatingPlants.HotWater.Types.SensorLocation.Return',
            ],
            BOI__ctl__locSenVHeaWatSec=[
                'Buildings.Templates.HeatingPlants.HotWater.Types.SensorLocation.Supply',
                'Buildings.Templates.HeatingPlants.HotWater.Types.SensorLocation.Return',
            ],
        ),
}

# A case is excluded if the "exclusion test" returns true for any of the items from EXCLUDE.
# Exclusion test:
#   - concatenate all class modifications,
#   - return true if all strings from the item of EXCLUDE are found in the concatenation product.
#   - (re patterns are supported: for instance negative lookahead assertion using (?!pattern).)
EXCLUDE = {
    'Buildings.Templates.HeatingPlants.HotWater.Validation.BoilerPlant': [[
        'Buildings.Templates.HeatingPlants.HotWater.Types.Boiler.Hybrid',
        'Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None',
    ],],
}

# Class modifications are removed for each model to be simulated according to the following rules.
# For each item of the list provided for each model in REMOVE_MODIF:
#   - if all patterns of item[0] are found in the original class modifications, and
#   - if a class modification contains any item within item[1], then it is removed.
#   - (re patterns are supported: for instance negative lookahead assertion using (?!pattern).)
# Removing the class modifications this way yields duplicate sets of class modifications.
# Those are pruned afterwards.
REMOVE_MODIF = {
    'Buildings.Templates.HeatingPlants.HotWater.Validation.BoilerPlant': [
        [
            [
                'typ=Buildings.Templates.HeatingPlants.HotWater.Types.Boiler.Hybrid',
            ],
            [
                'typPumHeaWatSec1_select',
            ],
        ],
        [
            [
                'typ=Buildings.Templates.HeatingPlants.HotWater.Types.Boiler.(?!Hybrid)',
            ],
            [
                'typPumHeaWatSec2_select',
            ],
        ],
        [
            [
                'typ=Buildings.Templates.HeatingPlants.HotWater.Types.Boiler.(?!Hybrid)',
                'typPumHeaWatSec1_select=Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None',
            ],
            [
                'typMeaCtlHeaWatPri',
                'locSenVHeaWatSec',
            ],
        ],
        [
            [
                'typPumHeaWatSec(1|2)_select=Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.(?!None)',
                'typMeaCtlHeaWatPri=Buildings.Templates.HeatingPlants.HotWater.Types.PrimaryOverflowMeasurement.(?!FlowDifference)',
            ],
            [
                'locSenVHeaWatSec',
            ],
        ],
        [
            [
                'typ=Buildings.Templates.HeatingPlants.HotWater.Types.Boiler.Condensing',
                'typPumHeaWatSec1_select=Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.(?!None)',
                'typPumHeaWatPriCon=Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.(Factory)?Constant',
            ],
            [
                'typMeaCtlHeaWatPri',
                'locSenVHeaWatPri',
            ],
        ],
        [
            [
                'typ=Buildings.Templates.HeatingPlants.HotWater.Types.Boiler.NonCondensing',
                'typPumHeaWatSec1_select=Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.(?!None)',
                'typPumHeaWatPriNon=Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.(Factory)?Constant',
            ],
            [
                'typMeaCtlHeaWatPri',
                'locSenVHeaWatPri',
            ],
        ],
        [
            [
                'typ=Buildings.Templates.HeatingPlants.HotWater.Types.Boiler.Condensing',
                'typPumHeaWatSec1_select=Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.(?!None)',
                'typPumHeaWatPriCon=Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.(Factory)?Variable',
                'typMeaCtlHeaWatPri=Buildings.Templates.HeatingPlants.HotWater.Types.PrimaryOverflowMeasurement.(?!FlowDifference)',
            ],
            [
                'locSenVHeaWatPri',
            ],
        ],
        [
            [
                'typ=Buildings.Templates.HeatingPlants.HotWater.Types.Boiler.NonCondensing',
                'typPumHeaWatSec1_select=Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.(?!None)',
                'typPumHeaWatPriNon=Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.(Factory)?Variable',
                'typMeaCtlHeaWatPri=Buildings.Templates.HeatingPlants.HotWater.Types.PrimaryOverflowMeasurement.(?!FlowDifference)',
            ],
            [
                'locSenVHeaWatPri',
            ],
        ],
        [
            [
                'typ=Buildings.Templates.HeatingPlants.HotWater.Types.Boiler.Hybrid',
                'typPumHeaWatSec2_select=Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.(?!None)',
                'typPumHeaWatPri(Con|Non)=Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.(Factory)?Variable',
                'typMeaCtlHeaWatPri=Buildings.Templates.HeatingPlants.HotWater.Types.PrimaryOverflowMeasurement.(?!FlowDifference)',
            ],
            [
                'locSenVHeaWatPri',
            ],
        ],
        [
            [
                'typ=Buildings.Templates.HeatingPlants.HotWater.Types.Boiler.Condensing',
            ],
            [
                'typArrPumHeaWatPriNon_select',
                'nBoiNon_select',
                'typPumHeaWatPriNon',
            ],
        ],
        [
            [
                'typ=Buildings.Templates.HeatingPlants.HotWater.Types.Boiler.NonCondensing',
            ],
            [
                'typArrPumHeaWatPriCon_select',
                'nBoiCon_select',
                'typPumHeaWatPriCon',
            ],
        ],
        [
            [
                'typPumHeaWatPriCon=Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.Factory'
            ],
            [
                'typArrPumHeaWatPriCon_select',
            ],
        ],
        [
            [
                'typPumHeaWatPriNon=Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.Factory'
            ],
            [
                'typArrPumHeaWatPriNon_select',
            ],
        ],
    ],
}


def simulateCase(arg, simulator):
    """Set common parameters and run simulation with buildingspy.

    Args:
        arg: A list of 3 elements:
             [model name, list of class modifications, suffix for mat file name]
        simulator: A string indicating the Modelica tool for simulating the model.

    Returns:
        Error code: 0 if success.
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

    mat_root = re.split(r"\.", arg[0])[-1]
    mat_suffix = re.sub(r"\.", "_", str(arg[2]))
    output_dir_prefix = f"{mat_root}_{mat_suffix}"
    cwd = os.getcwd()
    output_dir_path = tempfile.mkdtemp(prefix=output_dir_prefix, dir=cwd)
    package_relpath = os.path.join('Buildings', 'package.mo')

    if simulator == 'Dymola' or simulator == 'Optimica':
        s = Simulator(arg[0], output_dir_path)
    else:
        print(f'Unsupported simulation tool: {simulator}.')
        return 4
    if simulator == 'Dymola':
        s = Simulator(arg[0], output_dir_path)
        s.addPreProcessingStatement(r'Advanced.TranslationInCommandLog:=true;')
        s.addPreProcessingStatement(fr'openModel("{package_relpath}");')
        s.addPreProcessingStatement(fr'cd("{output_dir_path}");')
    elif simulator == 'Optimica':
        # Set MODELICAPATH (only in child process, so this won't affect main process).
        os.environ['MODELICAPATH'] = os.path.abspath(os.curdir)

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
            with open(glob.glob(os.path.join(fr'{output_dir_path}', '*buildingspy.json'))[0], 'r') as f:
                log = json.load(f)
            if log['simulation']['success']:
                toreturn = 0
            else:
                toreturn = 1
    except (FileNotFoundError, IndexError) as e:
        toreturn = 3
    finally:
        if toreturn == 0:
            shutil.rmtree(output_dir_path, ignore_errors=True)

    return toreturn


def simulate_cases(args, simulator=SIMULATOR, asy=True):
    """Main method that configures and runs all simulations."""

    # Workaround for multiprocessing that isn't strictly supported on Windows Jupyter Notebook.
    with open('tmp_func.py', 'w') as file:
        file.write(inspect.getsource(simulateCase).replace(simulateCase.__name__, "task"))
    sys.path.append('.')
    from tmp_func import task

    args_with_fixed = [(el, simulator) for el in args]
    results = []
    if __name__ == '__main__':
        func = task
        pool = Pool(os.cpu_count())
        if asy:
            results = pool.starmap_async(func, args_with_fixed)
        else:
            results = pool.starmap(func, args_with_fixed)
        pool.close()
        pool.join()

    return results


def generate_modif_list(dic):
    """Generates a list of class modifications.

    Args:
        dic: A dictionary where the keys are the component or variable
             to be modified, and the values are the modifications to be applied.
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


def generate_tag(dic):
    tag = ''
    for param, val in dic.items():
        tag = tag + '_' + re.split(r'\.', val)[-1]
    return re.sub('^_', '', tag)


def remove_items_by_indices(lst, indices):
    """Removes items from list (in place) based on their indices."""
    for idx in sorted(list(dict.fromkeys(indices)), reverse=True):
        if idx < len(lst):
            lst.pop(idx)


if __name__ == '__main__':
    # Generate combinations.
    # combinations_dicts is a dictionary where
    #   each key is a model to be simulated,
    #   each value is a list of dictionaries where the keys are the component or variable
    #   to be modified, and the values are the modifications to be applied.
    combinations_dicts = dict()
    for model in MODELS:
        keys, values = zip(*MODIF_GRID[model].items())
        combinations_dicts[model] = [dict(zip(keys, v)) for v in itertools.product(*values)]
    # args is a list of lists where
    #   the first item is a model to be simulated,
    #   the second item is the list of class modifications.
    args = []
    for model, modif_dict in combinations_dicts.items():
        for el in modif_dict:
            args.append([model, generate_modif_list(el)])

    # Remove class modifications.
    indices_to_pop = []
    for i, arg in enumerate(args):
        tmp = []
        if arg[0] in REMOVE_MODIF:
            modif_concat = ''.join(arg[1])
            for item in REMOVE_MODIF[arg[0]]:
                if all(re.search(el, modif_concat) for el in item[0]):
                    for pattern_to_remove in item[1]:
                        for j, modif in enumerate(arg[1]):
                            if re.search(pattern_to_remove, modif):
                                tmp.append(j)
        indices_to_pop.append(tmp)
    for i in range(len(args)):
        remove_items_by_indices(args[i][1], indices_to_pop[i])

    # Remove duplicates.
    indices_to_pop = []
    for i, arg in enumerate(args):
        for j in range(i+1, len(args)):
            if arg == args[j]:
                indices_to_pop.append(j)
    remove_items_by_indices(args, indices_to_pop)

    # Exclude cases.
    ## (We iterate over a copy of the `args` list to allow removing items of `args` during iteration.)
    for arg in args.copy():
        if arg[0] in EXCLUDE:
            modif_concat = ''.join(arg[1])
            if any(all(re.search(el, modif_concat) for el in ell) for ell in EXCLUDE[arg[0]]):
                args.remove(arg)

    print(f'Number of cases to be simulated with {SIMULATOR}: {len(args)}.\n')

    # Change tag for shorter length (simply use list index).
    for i, arg in enumerate(args):
        args[i].append(str(i))

    # Simulate cases.
    results = simulate_cases(args, asy=False)

    try:
        os.unlink('tmp_func.py')
        os.unlink('unitTestsTemplates.log')
    except FileNotFoundError:
        pass

    df = pd.DataFrame(
        dict(
            model=[el[0] for el in args],
            tag=[el[2] for el in args],
            modif=[el[1] for el in args],
            result=results,
        ))

    with open('unitTestsTemplates.log', 'w') as FH:
        for idx in df[df.result != 0].index:
            FH.writelines([
                f'*** Simulation failed for {df.iloc[idx].model} with the following class modifications:\n',
                ', \n'.join(df.iloc[idx].modif), '\n'
            ])

    if df.result.abs().sum() != 0:
        print(CRED + 'Some simulations failed: ' + CEND + 'see the file `unitTestsTemplates.log`.\n')
        sys.exit(1)
    else:
        print(CGREEN + 'All simulations succeeded.\n' + CEND)
        sys.exit(0)

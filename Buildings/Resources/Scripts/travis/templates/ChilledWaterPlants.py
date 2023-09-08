#!/usr/bin/env python
# coding: utf-8

# This script shall be run from the directory `modelica-buildings/Buildings`,
# i.e., where the top-level `package.mo` file can be found.
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

from core import *

try:
    SIMULATOR = sys.argv[1]
except IndexError:
    SIMULATOR = 'Dymola'

MODELS = [
    # 'Buildings.Templates.ChilledWaterPlants.Validation.AirCooledOpenLoop',
    'Buildings.Templates.ChilledWaterPlants.Validation.WaterCooledOpenLoop',
    # 'Buildings.Templates.ChilledWaterPlants.Validation.WaterCooledG36',
]

CRED = '\033[91m'
CGREEN = '\033[92m'
CEND = '\033[0m'

MODIF_GRID = {
    'Buildings.Templates.ChilledWaterPlants.Validation.AirCooledOpenLoop':
        dict(
            CHI__typArrChi_select=[
                'Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Parallel',
                # 'Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Series',
            ],),
    'Buildings.Templates.ChilledWaterPlants.Validation.WaterCooledOpenLoop':
        dict(
            CHI__typArrChi_select=[
                'Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Parallel',
                # 'Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Series',
            ],
            # CHI__typDisChiWat=[
            #     # 'Buildings.Templates.ChilledWaterPlants.Types.Distribution.Constant1Only',
            #     'Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1Only',
            #     'Buildings.Templates.ChilledWaterPlants.Types.Distribution.Constant1Variable2',
            #     # 'Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1And2',
            #     # 'Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1And2Distributed',
            # ],
            # CHI__typArrPumChiWatPri_select=[
            #     'Buildings.Templates.Components.Types.PumpArrangement.Dedicated',
            #     'Buildings.Templates.Components.Types.PumpArrangement.Headered',
            # ],
            # CHI__typArrPumConWat_select=[
            #     'Buildings.Templates.Components.Types.PumpArrangement.Dedicated',
            #     'Buildings.Templates.Components.Types.PumpArrangement.Headered',
            # ],
            # CHI__have_varPumChiWatPri_select=[
            #     'true',
            #     'false',
            # ],
            # CHI__have_varPumConWat_select=[
            #     'true',
            #     'false',
            # ],
            # CHI__ctl__typCtlHea=[
            #     # 'Buildings.Templates.ChilledWaterPlants.Types.ChillerLiftControl.None',
            #     'Buildings.Templates.ChilledWaterPlants.Types.ChillerLiftControl.BuiltIn',
            #     'Buildings.Templates.ChilledWaterPlants.Types.ChillerLiftControl.External',
            # ],
            # CHI__chi__typValChiWatChiIso_select=[
            #     'Buildings.Templates.Components.Types.Valve.TwoWayModulating',
            #     'Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition',
            # ],
            # CHI__chi__typValConWatChiIso_select=[
            #     'Buildings.Templates.Components.Types.Valve.TwoWayModulating',
            #     'Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition',
            # ],
            # CHI__redeclare__coo=[
            #     'Buildings.Templates.ChilledWaterPlants.Components.CoolerGroups.CoolingTowerOpen',
            # ],
            # CHI__coo__redeclare__valCooOutIso=[
            #     'Buildings.Templates.Components.Valves.TwoWayTwoPosition',
            #     'Buildings.Templates.Components.Valves.None',
            # ],
            # CHI__redeclare__eco=[
            #     'Buildings.Templates.ChilledWaterPlants.Components.Economizers.HeatExchangerWithPump',
            #     'Buildings.Templates.ChilledWaterPlants.Components.Economizers.HeatExchangerWithValve',
            #     'Buildings.Templates.ChilledWaterPlants.Components.Economizers.None',
            # ],
        ),
}

# A case is excluded if the exclusion test returns true for any of the items from EXCLUDE.
# Exclusion test:
#   - concatenate all class modifications,
#   - return true if all strings from the item of EXCLUDE are found in the concatenation product.
EXCLUDE = {
    'Buildings.Templates.ChilledWaterPlants.Validation.WaterCooledOpenLoop': [
        [
            'Economizers.HeatExchanger',
            'typArrPumChiWatPri_select=Buildings.Templates.Components.Types.PumpArrangement.Dedicated',
        ],
        [
            'Economizers.HeatExchanger',
            'typArrPumConWat_select=Buildings.Templates.Components.Types.PumpArrangement.Dedicated',
        ],
        [
            'Economizers.HeatExchanger',
            'have_varPumConWat_select=false',
        ],
        [
            'ChillerArrangement.Series',
            'typArrPumChiWatPri_select=Buildings.Templates.Components.Types.PumpArrangement.Dedicated',
        ],
        [
            'typCtlHea=Buildings.Templates.ChilledWaterPlants.Types.ChillerLiftControl.BuiltIn',
            'have_varPumConWat_select=false',
            'typValConWatChiIso_select=Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition',
        ],
        [
            'typCtlHea=Buildings.Templates.ChilledWaterPlants.Types.ChillerLiftControl.External',
            'have_varPumConWat_select=false',
            'typValConWatChiIso_select=Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition',
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

    try:
        if simulator == 'Dymola':
            s = Simulator(arg[0], output_dir_path)
            s.addPreProcessingStatement(r'Advanced.TranslationInCommandLog:=true;')
            s.addPreProcessingStatement(fr'openModel("{package_relpath}");')
            s.addPreProcessingStatement(fr'cd("{output_dir_path}");')
        elif simulator == 'Optimica':
            s = Simulator(arg[0], output_dir_path)
        else:
            print(f'Unsupported simulation tool: {simulator}.')
            return 4
        for modif in arg[1]:
            s.addModelModifier(modif)
        s.setSolver("CVode")
        s.setTolerance(1e-6)
        s.printModelAndTime()
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
    except FileNotFoundError as e:
        toreturn = 3
        print(e)
    finally:
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
    to_return = list()
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


if __name__ == '__main__':
    # Generate combinations.
    combinations_dicts = dict()
    for model in MODELS:
        keys, values = zip(*MODIF_GRID[model].items())
        combinations_dicts[model] = [dict(zip(keys, v)) for v in itertools.product(*values)]
    args = list()
    for model, modif_list in combinations_dicts.items():
        for el in modif_list:
            args.append([model, generate_modif_list(el), generate_tag(el)])

    # Exclude cases.
    for i, arg in enumerate(args):
        pattern = ''.join(arg[1])
        if arg[0] in EXCLUDE:
            if any(all(el in pattern for el in ell) for ell in EXCLUDE[arg[0]]):
                args.pop(i)
    print(f'Number of cases to be simulated with {SIMULATOR}: {len(args)}.\n')

    # Change tag for shorter length (simply use list index).
    for i, arg in enumerate(args):
        args[i][2] = str(i)

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

    for idx in df[df.result != 0].index:
        with open('unitTestsTemplates.log', 'w') as FH:
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

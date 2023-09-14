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

MODELS = [
    'Buildings.Templates.ChilledWaterPlants.Validation.AirCooledOpenLoop',
    'Buildings.Templates.ChilledWaterPlants.Validation.WaterCooledOpenLoop',
    # 'Buildings.Templates.ChilledWaterPlants.Validation.WaterCooledG36',
]

# Tested modifications should at least cover the options specified at:
# https://github.com/lbl-srg/ctrl-flow-dev/blob/main/server/scripts/sequence-doc/src/version/Current%20G36%20Decisions/Guideline%2036-2021%20(mappings).csv
MODIF_GRID: dict[str, dict[str, list[str]]] = {
    'Buildings.Templates.ChilledWaterPlants.Validation.AirCooledOpenLoop': dict(
        CHI__typArrChi_select=[
            'Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Parallel',
            'Buildings.Templates.ChilledWaterPlants.Types.ChillerArrangement.Series',
        ],
        CHI__typDisChiWat=[
            'Buildings.Templates.ChilledWaterPlants.Types.Distribution.Constant1Only',
            'Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1Only',
            'Buildings.Templates.ChilledWaterPlants.Types.Distribution.Constant1Variable2',
            'Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1And2',
            # 'Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable1And2Distributed',
        ],
        CHI__typArrPumChiWatPri_select=[
            'Buildings.Templates.Components.Types.PumpArrangement.Dedicated',
            'Buildings.Templates.Components.Types.PumpArrangement.Headered',
        ],
        CHI__have_varPumChiWatPri_select=[
            'true',
            'false',
        ],
        CHI__chi__typValChiWatChiIso_select=[
            'Buildings.Templates.Components.Types.Valve.TwoWayModulating',
            'Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition',
        ],
    ),
}
MODIF_GRID['Buildings.Templates.ChilledWaterPlants.Validation.WaterCooledOpenLoop'] = {
    **MODIF_GRID['Buildings.Templates.ChilledWaterPlants.Validation.AirCooledOpenLoop'],
    **dict(
        CHI__ctl__typCtlHea=[
            'Buildings.Templates.ChilledWaterPlants.Types.ChillerLiftControl.None',
            'Buildings.Templates.ChilledWaterPlants.Types.ChillerLiftControl.BuiltIn',
            'Buildings.Templates.ChilledWaterPlants.Types.ChillerLiftControl.External',
        ],
        CHI__typArrPumConWat_select=[
            'Buildings.Templates.Components.Types.PumpArrangement.Dedicated',
            'Buildings.Templates.Components.Types.PumpArrangement.Headered',
        ],
        CHI__have_varPumConWat_select=[
            'true',
            'false',
        ],
        CHI__chi__typValConWatChiIso_select=[
            'Buildings.Templates.Components.Types.Valve.TwoWayModulating',
            'Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition',
        ],
        CHI__redeclare__coo=[
            'Buildings.Templates.ChilledWaterPlants.Components.CoolerGroups.CoolingTowerOpen',
        ],
        CHI__coo__redeclare__valCooOutIso=[
            'Buildings.Templates.Components.Valves.TwoWayTwoPosition',
            'Buildings.Templates.Components.Valves.None',
        ],
        CHI__redeclare__eco=[
            'Buildings.Templates.ChilledWaterPlants.Components.Economizers.HeatExchangerWithPump',
            'Buildings.Templates.ChilledWaterPlants.Components.Economizers.HeatExchangerWithValve',
            'Buildings.Templates.ChilledWaterPlants.Components.Economizers.None',
        ],
    ),
}

# See docstring of `prune_modifications` function for the structure of EXCLUDE.
EXCLUDE = {
    'Buildings.Templates.ChilledWaterPlants.Validation.AirCooledOpenLoop': [
        [
            'ChillerArrangement.Series',
            'typArrPumChiWatPri_select=Buildings.Templates.Components.Types.PumpArrangement.Dedicated',
        ],
        [
            'Buildings.Templates.ChilledWaterPlants.Types.Economizer.(?!None)',
        ],
    ],
}
EXCLUDE['Buildings.Templates.ChilledWaterPlants.Validation.WaterCooledOpenLoop'] = [
    *EXCLUDE['Buildings.Templates.ChilledWaterPlants.Validation.AirCooledOpenLoop'],
    *[
        [
            'Economizers.HeatExchanger',
            'have_varPumConWat_select=false',
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
]

# See docstring of `prune_modifications` function for the structure of REMOVE_MODIF.
REMOVE_MODIF: dict[str, list[tuple[list[str], list[str]]]] = {
    'Buildings.Templates.ChilledWaterPlants.Validation.AirCooledOpenLoop': [
        (
            [
                'typDisChiWat=Buildings.Templates.ChilledWaterPlants.Types.Distribution.Variable',
            ],
            [
                'have_varPumChiWatPri_select',
            ],
        ),
        (
            [
                'typArrPumChiWatPri_select=Buildings.Templates.Components.Types.PumpArrangement.Dedicated',
            ],
            [
                'typValChiWatChiIso_select',
            ],
        ),
    ]
}
REMOVE_MODIF['Buildings.Templates.ChilledWaterPlants.Validation.WaterCooledOpenLoop'] = [
    *REMOVE_MODIF['Buildings.Templates.ChilledWaterPlants.Validation.AirCooledOpenLoop'],
    *[
        (
            [
                'typArrPumConWat_select=Buildings.Templates.Components.Types.PumpArrangement.Dedicated',
            ],
            [
                'typValConWatChiIso_select',
            ],
        ),
        (
            [
                'Buildings.Templates.ChilledWaterPlants.Types.ChillerLiftControl.(?!None)',
            ],
            [
                'typValConWatChiIso_select',
            ],
        ),
        (
            [
                'have_varPumConWat_select=true',
                'Buildings.Templates.ChilledWaterPlants.Components.Economizers.(?!None)',
            ],
            [
                'typValConWatChiIso_select',
            ],
        ),
        (
            [
                'Buildings.Templates.ChilledWaterPlants.Components.Economizers.(?!None)',
            ],
            [
                'typArrPumChiWatPri_select',
                'typArrPumConWat_select',
                'have_varPumConWat_select',
            ],
        ),
    ],
]

if __name__ == '__main__':
    # Generate combinations.
    combinations: list[tuple[str, list[str], str]] = generate_combinations(
        models=MODELS, modif_grid=MODIF_GRID
    )

    # Prune class modifications.
    prune_modifications(combinations=combinations, remove_modif=REMOVE_MODIF, exclude=EXCLUDE)

    print(f'Number of cases to be simulated: {len(combinations)}.\n')

    # FIXME(AntoineGautier PR#3167): Temporarily limit the number of simulations to be run (for testing purposes only).
    combinations = combinations[:2]

    # Simulate cases.
    results = simulate_cases(combinations, simulator=SIMULATOR, asy=False)

    # Report and clean.
    df = report_clean(combinations, results)

    # Log and exit.
    if df.errorcode.abs().sum() != 0:
        print(
            CRED + 'Some simulations failed: ' + CEND + 'see the file `unitTestsTemplates.log`.\n'
        )
        sys.exit(1)
    else:
        print(CGREEN + 'All simulations succeeded.\n' + CEND)
        sys.exit(0)

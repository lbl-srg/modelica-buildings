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
    'Buildings.Templates.HeatingPlants.HotWater.Validation.BoilerPlant',
]

MODIF_GRID = {
    'Buildings.Templates.HeatingPlants.HotWater.Validation.BoilerPlant': dict(
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

# See docstring of `prune_modifications` function for the structure of EXCLUDE.
EXCLUDE = {
    'Buildings.Templates.HeatingPlants.HotWater.Validation.BoilerPlant': [
        [
            'Buildings.Templates.HeatingPlants.HotWater.Types.Boiler.Hybrid',
            'Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None',
        ],
    ],
}

# See docstring of `prune_modifications` function for the structure of REMOVE_MODIF.
REMOVE_MODIF = {
    'Buildings.Templates.HeatingPlants.HotWater.Validation.BoilerPlant': [
        (
            [
                'typ=Buildings.Templates.HeatingPlants.HotWater.Types.Boiler.Hybrid',
            ],
            [
                'typPumHeaWatSec1_select',
            ],
        ),
        (
            [
                'typ=Buildings.Templates.HeatingPlants.HotWater.Types.Boiler.(?!Hybrid)',
            ],
            [
                'typPumHeaWatSec2_select',
            ],
        ),
        (
            [
                'typ=Buildings.Templates.HeatingPlants.HotWater.Types.Boiler.(?!Hybrid)',
                'typPumHeaWatSec1_select=Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.None',
            ],
            [
                'typMeaCtlHeaWatPri',
                'locSenVHeaWatSec',
            ],
        ),
        (
            [
                'typPumHeaWatSec(1|2)_select=Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.(?!None)',
                'typMeaCtlHeaWatPri=Buildings.Templates.HeatingPlants.HotWater.Types.PrimaryOverflowMeasurement.(?!FlowDifference)',
            ],
            [
                'locSenVHeaWatSec',
            ],
        ),
        (
            [
                'typ=Buildings.Templates.HeatingPlants.HotWater.Types.Boiler.Condensing',
                'typPumHeaWatSec1_select=Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.(?!None)',
                'typPumHeaWatPriCon=Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.(Factory)?Constant',
            ],
            [
                'typMeaCtlHeaWatPri',
                'locSenVHeaWatPri',
            ],
        ),
        (
            [
                'typ=Buildings.Templates.HeatingPlants.HotWater.Types.Boiler.NonCondensing',
                'typPumHeaWatSec1_select=Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.(?!None)',
                'typPumHeaWatPriNon=Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.(Factory)?Constant',
            ],
            [
                'typMeaCtlHeaWatPri',
                'locSenVHeaWatPri',
            ],
        ),
        (
            [
                'typ=Buildings.Templates.HeatingPlants.HotWater.Types.Boiler.Condensing',
                'typPumHeaWatSec1_select=Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.(?!None)',
                'typPumHeaWatPriCon=Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.(Factory)?Variable',
                'typMeaCtlHeaWatPri=Buildings.Templates.HeatingPlants.HotWater.Types.PrimaryOverflowMeasurement.(?!FlowDifference)',
            ],
            [
                'locSenVHeaWatPri',
            ],
        ),
        (
            [
                'typ=Buildings.Templates.HeatingPlants.HotWater.Types.Boiler.NonCondensing',
                'typPumHeaWatSec1_select=Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.(?!None)',
                'typPumHeaWatPriNon=Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.(Factory)?Variable',
                'typMeaCtlHeaWatPri=Buildings.Templates.HeatingPlants.HotWater.Types.PrimaryOverflowMeasurement.(?!FlowDifference)',
            ],
            [
                'locSenVHeaWatPri',
            ],
        ),
        (
            [
                'typ=Buildings.Templates.HeatingPlants.HotWater.Types.Boiler.Hybrid',
                'typPumHeaWatSec2_select=Buildings.Templates.HeatingPlants.HotWater.Types.PumpsSecondary.(?!None)',
                'typPumHeaWatPri(Con|Non)=Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.(Factory)?Variable',
                'typMeaCtlHeaWatPri=Buildings.Templates.HeatingPlants.HotWater.Types.PrimaryOverflowMeasurement.(?!FlowDifference)',
            ],
            [
                'locSenVHeaWatPri',
            ],
        ),
        (
            [
                'typ=Buildings.Templates.HeatingPlants.HotWater.Types.Boiler.Condensing',
            ],
            [
                'typArrPumHeaWatPriNon_select',
                'nBoiNon_select',
                'typPumHeaWatPriNon',
            ],
        ),
        (
            [
                'typ=Buildings.Templates.HeatingPlants.HotWater.Types.Boiler.NonCondensing',
            ],
            [
                'typArrPumHeaWatPriCon_select',
                'nBoiCon_select',
                'typPumHeaWatPriCon',
            ],
        ),
        (
            [
                'typPumHeaWatPriCon=Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.Factory'
            ],
            [
                'typArrPumHeaWatPriCon_select',
            ],
        ),
        (
            [
                'typPumHeaWatPriNon=Buildings.Templates.HeatingPlants.HotWater.Types.PumpsPrimary.Factory'
            ],
            [
                'typArrPumHeaWatPriNon_select',
            ],
        ),
    ],
}


if __name__ == '__main__':
    # Generate combinations.
    combinations = generate_combinations(
        models=MODELS, modif_grid=MODIF_GRID
    )

    # Prune class modifications.
    prune_modifications(
        combinations=combinations,
        exclude=EXCLUDE,
        remove_modif=REMOVE_MODIF,
        fraction_test_coverage=FRACTION_TEST_COVERAGE,
    )

    print(f'Number of cases to be simulated: {len(combinations)}.\n')

    # FIXME(AntoineGautier PR#3364): Temporarily limit the number of simulations to be run (for testing purposes only).
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

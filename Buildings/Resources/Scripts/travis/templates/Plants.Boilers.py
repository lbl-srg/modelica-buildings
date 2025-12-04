#!/usr/bin/env python
# coding: utf-8

"""Generate combinations and run simulations.

This script shall be run from the directory `modelica-buildings/Buildings`,
i.e., where the top-level `package.mo` file can be found.

Args:
    - See docstring of core.py for the optional positional arguments of this script.

Returns:
    - 0 if all simulations succeed.
    - 1 otherwise.

Details:
    The script performs the following tasks.
    - Generate all possible combinations of class modifications based on a set of
      parameter bindings and redeclare statements provided in `MODIF_GRID`.
    - Exclude the combinations based on a match with the patterns provided in `EXCLUDE`.
    - This allows excluding unsupported configurations.
    - Exclude the class modifications based on a match with the patterns provided in `REMOVE_MODIF`,
      and prune the resulting duplicated combinations.
    - This allows reducing the number of simulations by excluding class modifications that
      yield the same model, i.e., modifications to parameters that are not used (disabled) in
      the given configuration.
    - For the remaining combinations: run the corresponding simulations for the models in `MODELS`.
"""

import core

MODELS = [
    'Buildings.Templates.Plants.Boilers.HotWater.Validation.BoilerPlant',
]

# See docstring of `generate_combinations` function for the structure of MODIF_GRID.
MODIF_GRID = {
    'Buildings.Templates.Plants.Boilers.HotWater.Validation.BoilerPlant': dict(
        pla__typ=[
            'Buildings.Templates.Plants.Boilers.HotWater.Types.Boiler.Condensing',
            'Buildings.Templates.Plants.Boilers.HotWater.Types.Boiler.NonCondensing',
        ],
        pla__nBoiCon_select=[
            '2',
        ],
        pla__nBoiNon_select=[
            '2',
        ],
        pla__typPumHeaWatPriCon=[
            'Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsPrimary.Variable',
            'Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsPrimary.Constant',
        ],
        pla__typPumHeaWatPriNon=[
            'Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsPrimary.Variable',
            'Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsPrimary.Constant',
        ],
        pla__typArrPumHeaWatPriCon_select=[
            'Buildings.Templates.Components.Types.PumpArrangement.Dedicated',
            'Buildings.Templates.Components.Types.PumpArrangement.Headered',
        ],
        pla__typArrPumHeaWatPriNon_select=[
            'Buildings.Templates.Components.Types.PumpArrangement.Dedicated',
            'Buildings.Templates.Components.Types.PumpArrangement.Headered',
        ],
        pla__typPumHeaWatSec1_select=[
            'Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsSecondary.Centralized',
            'Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsSecondary.None',
        ],
        pla__ctl__typMeaCtlHeaWatPri=[
            'Buildings.Templates.Plants.Boilers.HotWater.Types.PrimaryOverflowMeasurement.FlowDecoupler',
            'Buildings.Templates.Plants.Boilers.HotWater.Types.PrimaryOverflowMeasurement.FlowDifference',
            'Buildings.Templates.Plants.Boilers.HotWater.Types.PrimaryOverflowMeasurement.TemperatureSupplySensor',
            'Buildings.Templates.Plants.Boilers.HotWater.Types.PrimaryOverflowMeasurement.TemperatureBoilerSensor',
        ],
        pla__ctl__have_senDpHeaWatRemWir=[
            'true',
            'false',
        ],
        pla__ctl__locSenVHeaWatPri=[
            'Buildings.Templates.Plants.Boilers.HotWater.Types.SensorLocation.Supply',
            'Buildings.Templates.Plants.Boilers.HotWater.Types.SensorLocation.Return',
        ],
        pla__ctl__locSenVHeaWatSec=[
            'Buildings.Templates.Plants.Boilers.HotWater.Types.SensorLocation.Supply',
            'Buildings.Templates.Plants.Boilers.HotWater.Types.SensorLocation.Return',
        ],
    ),
}

# See docstring of `prune_modifications` function for the structure of EXCLUDE.
EXCLUDE = {}

# See docstring of `prune_modifications` function for the structure of REMOVE_MODIF.
REMOVE_MODIF = {
    'Buildings.Templates.Plants.Boilers.HotWater.Validation.BoilerPlant': [
        (
            [
                'typ=Buildings.Templates.Plants.Boilers.HotWater.Types.Boiler.(?!Hybrid)',
                'typPumHeaWatSec1_select=Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsSecondary.None',
            ],
            [
                'typMeaCtlHeaWatPri',
                'locSenVHeaWatSec',
            ],
        ),
        (
            [
                'typPumHeaWatSec(1|2)_select=Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsSecondary.(?!None)',
                'typMeaCtlHeaWatPri=Buildings.Templates.Plants.Boilers.HotWater.Types.PrimaryOverflowMeasurement.(?!FlowDifference)',
            ],
            [
                'locSenVHeaWatSec',
            ],
        ),
        (
            [
                'typ=Buildings.Templates.Plants.Boilers.HotWater.Types.Boiler.(Non)?Condensing',
                'typPumHeaWatSec1_select=Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsSecondary.(?!None)',
                'typPumHeaWatPri(Con|Non)=Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsPrimary.(Factory)?Constant',
            ],
            [
                'typMeaCtlHeaWatPri',
                'locSenVHeaWatPri',
            ],
        ),
        (
            [
                'typ=Buildings.Templates.Plants.Boilers.HotWater.Types.Boiler.(Non)?Condensing',
                'typPumHeaWatSec1_select=Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsSecondary.(?!None)',
                'typPumHeaWatPri(Con|Non)=Buildings.Templates.Plants.Boilers.HotWater.Types.PumpsPrimary.(Factory)?Variable',
                'typMeaCtlHeaWatPri=Buildings.Templates.Plants.Boilers.HotWater.Types.PrimaryOverflowMeasurement.(?!FlowDifference)',
            ],
            [
                'locSenVHeaWatPri',
            ],
        ),
        (
            [
                'typ=Buildings.Templates.Plants.Boilers.HotWater.Types.Boiler.Condensing',
            ],
            [
                'typArrPumHeaWatPriNon_select',
                'nBoiNon_select',
                'typPumHeaWatPriNon',
            ],
        ),
        (
            [
                'typ=Buildings.Templates.Plants.Boilers.HotWater.Types.Boiler.NonCondensing',
            ],
            [
                'typArrPumHeaWatPriCon_select',
                'nBoiCon_select',
                'typPumHeaWatPriCon',
            ],
        ),
    ],
}


if __name__ == '__main__':
    core.main(models=MODELS, modif_grid=MODIF_GRID, exclude=EXCLUDE, remove_modif=REMOVE_MODIF)

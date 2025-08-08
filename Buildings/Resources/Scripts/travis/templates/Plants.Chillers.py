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
    'Buildings.Templates.Plants.Chillers.Validation.WaterCooled',
    # 'Buildings.Templates.Plants.Chillers.Validation.WaterCooledG36',
]

MODIF_GRID = {
    'Buildings.Templates.Plants.Chillers.Validation.WaterCooled': dict(
        pla__ctl__typCtlHea=[
            'Buildings.Templates.Plants.Chillers.Types.ChillerLiftControl.None',
            'Buildings.Templates.Plants.Chillers.Types.ChillerLiftControl.Chiller',
            'Buildings.Templates.Plants.Chillers.Types.ChillerLiftControl.BAS',
        ],
        pla__have_pumConWatVar_select=[
            'true',
            'false',
        ],
        pla__chi__typValConWatChiIso_select=[
            'Buildings.Templates.Components.Types.Valve.TwoWayModulating',
            'Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition',
        ],
        pla__redeclare__eco=[
            'Buildings.Templates.Plants.Chillers.Components.Economizers.HeatExchangerWithPump',
            'Buildings.Templates.Plants.Chillers.Components.Economizers.HeatExchangerWithValve',
            'Buildings.Templates.Plants.Chillers.Components.Economizers.None',
        ],
    ),
}


# See docstring of `prune_modifications` function for the structure of EXCLUDE.
EXCLUDE = {
    'Buildings.Templates.Plants.Chillers.Validation.WaterCooled': [
        [
            'Economizers.HeatExchanger',
            'have_pumConWatVar_select=false',
        ],
        [
            'typCtlHea=Buildings.Templates.Plants.Chillers.Types.ChillerLiftControl.Chiller',
            'have_pumConWatVar_select=false',
            'typValConWatChiIso_select=Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition',
        ],
        [
            'typCtlHea=Buildings.Templates.Plants.Chillers.Types.ChillerLiftControl.BAS',
            'have_pumConWatVar_select=false',
            'typValConWatChiIso_select=Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition',
        ],
    ],
}

# See docstring of `prune_modifications` function for the structure of REMOVE_MODIF.
REMOVE_MODIF = {
    'Buildings.Templates.Plants.Chillers.Validation.WaterCooled': [
        (
            [
                'Buildings.Templates.Plants.Chillers.Types.ChillerLiftControl.(?!None)',
            ],
            [
                'typValConWatChiIso_select',
            ],
        ),
        (
            [
                'have_pumConWatVar_select=true',
                'Buildings.Templates.Plants.Chillers.Components.Economizers.(?!None)',
            ],
            [
                'typValConWatChiIso_select',
            ],
        ),
        (
            [
                'Buildings.Templates.Plants.Chillers.Components.Economizers.(?!None)',
            ],
            [
                'typArrPumChiWatPri_select',
                'typArrPumConWat_select',
                'have_pumConWatVar_select',
            ],
        ),
    ],
}

if __name__ == '__main__':
    core.main(models=MODELS, modif_grid=MODIF_GRID, exclude=EXCLUDE, remove_modif=REMOVE_MODIF)

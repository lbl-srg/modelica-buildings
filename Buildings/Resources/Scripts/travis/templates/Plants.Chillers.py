#!/usr/bin/env python

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
    - Override experiment attributes (e.g., the integration method) for the combinations
      matching the patterns provided in `EXPERIMENT_MODIF`.
    - For the remaining combinations: run the corresponding simulations for the models in `MODELS`.
"""

import core

MODELS = [
    'Buildings.Templates.Plants.Chillers.Validation.AirCooled',
    'Buildings.Templates.Plants.Chillers.Validation.WaterCooled',
]

MODIF_GRID = {
    'Buildings.Templates.Plants.Chillers.Validation.AirCooled': dict(
        # Always enabled: have_senVChiWatPri is `final` true because typDisChiWat is `final`
        # bound to Variable1Only.
        pla__ctl__locSenFloChiWatPri=[
            'Buildings.Templates.Plants.Chillers.Types.SensorLocation.Return',
            'Buildings.Templates.Plants.Chillers.Types.SensorLocation.Supply',
        ],
        # Always enabled for the same reason.
        pla__ctl__have_senDpChiWatRemWir=[
            'true',
            'false',
        ],
    ),
}

MODIF_GRID.update(
    {
        'Buildings.Templates.Plants.Chillers.Validation.WaterCooled': dict(
            **MODIF_GRID[
                'Buildings.Templates.Plants.Chillers.Validation.AirCooled'
            ],
            pla__ctl__typCtlHea=[
                'Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Types.HeadPressureControl.NotRequired',
                'Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Types.HeadPressureControl.ByChiller',
                'Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Types.HeadPressureControl.ByPlant',
            ],
            pla__have_pumConWatVar_select=[
                'true',
                'false',
            ],
            pla__redeclare__eco=[
                'Buildings.Templates.Plants.Chillers.Components.Economizers.HeatExchangerWithPump',
                'Buildings.Templates.Plants.Chillers.Components.Economizers.HeatExchangerWithValve',
                'Buildings.Templates.Plants.Chillers.Components.Economizers.None',
            ],
        ),
    }
)


# See docstring of `prune_modifications` function for the structure of EXCLUDE.
EXCLUDE = {}

# See docstring of `prune_modifications` function for the structure of REMOVE_MODIF.
REMOVE_MODIF = {
    'Buildings.Templates.Plants.Chillers.Validation.WaterCooled': [
        (
            [
                'Buildings.Templates.Plants.Chillers.Components.Economizers.(?!None)',
            ],
            [
                'have_pumConWatVar_select',
            ],
        ),
    ],
}

# See docstring of `apply_experiment_modifications` function for the structure of EXPERIMENT_MODIF.
EXPERIMENT_MODIF = {
    'Buildings.Templates.Plants.Chillers.Validation.WaterCooled': [
        (
            [
                'Buildings.Templates.Plants.Chillers.Components.Economizers.HeatExchangerWithPump',
                'have_senDpChiWatRemWir=false',
            ],
            {
                'method': 'dassl',
            },
        ),
    ],
}

if __name__ == '__main__':
    core.main(
        models=MODELS,
        modif_grid=MODIF_GRID,
        exclude=EXCLUDE,
        remove_modif=REMOVE_MODIF,
        experiment_modif=EXPERIMENT_MODIF,
    )

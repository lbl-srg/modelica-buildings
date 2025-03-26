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

from core import *

MODELS = [
    'Buildings.Templates.ZoneEquipment.Validation.VAVBoxCoolingOnly',
    'Buildings.Templates.ZoneEquipment.Validation.VAVBoxReheat',
]

# See docstring of `generate_combinations` function for the structure of MODIF_GRID.
# Tested modifications should at least cover the options specified at:
# https://github.com/lbl-srg/ctrl-flow-dev/blob/main/server/scripts/sequence-doc/src/version/Current%20G36%20Decisions/Guideline%2036-2021%20(mappings).csv
MODIF_GRID = {
    'Buildings.Templates.ZoneEquipment.Validation.VAVBoxCoolingOnly': dict(
        VAVBox_1__ctl__have_occSen=[
            'true',
            'false',
        ],
        VAVBox_1__ctl__have_winSen=[
            'true',
            'false',
        ],
        VAVBox_1__ctl__have_CO2Sen=[
            'true',
            'false',
        ],
    ),
}
MODIF_GRID['Buildings.Templates.ZoneEquipment.Validation.VAVBoxReheat'] = {
    **MODIF_GRID['Buildings.Templates.ZoneEquipment.Validation.VAVBoxCoolingOnly'],
    **dict(
        VAVBox_1__redeclare__coiHea=[
            'Buildings.Templates.Components.Coils.WaterBasedHeating'
            + '(typVal=Buildings.Templates.Components.Types.Valve.TwoWayModulating)',
            'Buildings.Templates.Components.Coils.WaterBasedHeating'
            + '(typVal=Buildings.Templates.Components.Types.Valve.ThreeWayModulating)',
            'Buildings.Templates.Components.Coils.ElectricHeating',
        ],
    ),
}

# See docstring of `prune_modifications` function for the structure of EXCLUDE.
EXCLUDE = None

# See docstring of `prune_modifications` function for the structure of REMOVE_MODIF.
REMOVE_MODIF = None


if __name__ == '__main__':
    main(models=MODELS, modif_grid=MODIF_GRID, exclude=EXCLUDE, remove_modif=REMOVE_MODIF)

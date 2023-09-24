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
            'Buildings.Templates.Components.Coils.WaterBasedHeating',
            'Buildings.Templates.Components.Coils.ElectricHeating',
        ],
        VAVBox_1__coiHea__redeclare__val=[
            'Buildings.Templates.Components.Valves.TwoWayModulating',
            'Buildings.Templates.Components.Valves.ThreeWayModulating',
        ],
    ),
}


# See docstring of `prune_modifications` function for the structure of EXCLUDE.
EXCLUDE = None

# See docstring of `prune_modifications` function for the structure of REMOVE_MODIF.
REMOVE_MODIF = {
    'Buildings.Templates.ZoneEquipment.Validation.VAVBoxReheat': [
        (
            [
                'Buildings.Templates.Components.Coils.ElectricHeating',
            ],
            [
                'Buildings.Templates.Components.Valves',
            ],
        ),
    ]
}


if __name__ == '__main__':
    # Exclude model if is included in conf.yml for the given simulator.
    for model_name in MODELS:
        if check_conf(model_name, SIMULATOR):
            MODELS.remove(model_name)
            print(f'Model {model_name} is not simulated based on `conf.yml`.')

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

    # Simulate cases.
    results = simulate_cases(combinations, simulator=SIMULATOR, asy=False)

    # Report, clean and exit.
    report_clean(combinations, results)

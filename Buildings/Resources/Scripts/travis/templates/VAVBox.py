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
    'Buildings.Templates.ZoneEquipment.Validation.VAVBoxCoolingOnly',
    'Buildings.Templates.ZoneEquipment.Validation.VAVBoxReheat',
]

# Tested modifications should at least cover the options specified at:
# https://github.com/lbl-srg/ctrl-flow-dev/blob/main/server/scripts/sequence-doc/src/version/Current%20G36%20Decisions/Guideline%2036-2021%20(mappings).csv
MODIF_GRID: dict[str, dict[str, list[str]]] = {
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
EXCLUDE: dict[str, list[list[str]]] = None

# See docstring of `prune_modifications` function for the structure of REMOVE_MODIF.
REMOVE_MODIF: dict[str, list[tuple[list[str], list[str]]]] = {
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
    # Generate combinations.
    combinations: list[tuple[str, list[str], str]] = generate_combinations(
        models=MODELS, modif_grid=MODIF_GRID
    )

    # Prune class modifications.
    prune_modifications(
        combinations=combinations,
        remove_modif=REMOVE_MODIF,
        exclude=EXCLUDE,
        fraction_test_coverage=FRACTION_TEST_COVERAGE,
    )

    print(f'Number of cases to be simulated: {len(combinations)}.\n')

    # FIXME(AntoineGautier PR#????): Temporarily limit the number of simulations to be run (for testing purposes only).
    with open('unitTestsCombinations.log', 'w') as FH:
        for c in combinations:
            FH.write("*********" + c[0] + "\n\n" + "\n".join(c[1]) + "\n\n")
    # combinations = combinations[:2]

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

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
    'Buildings.Templates.AirHandlersFans.Validation.VAVMultiZone',
]

# Tested modifications should at least cover the options specified at:
# https://github.com/lbl-srg/ctrl-flow-dev/blob/main/server/scripts/sequence-doc/src/version/Current%20G36%20Decisions/Guideline%2036-2021%20(mappings).csv
MODIF_GRID: dict[str, dict[str, list[str]]] = {
    'Buildings.Templates.AirHandlersFans.Validation.VAVMultiZone': dict(
        # FIXME(AntoineGautier #3526): Some options are currently not supported by G36 controller.
        VAV_1__redeclare__coiHeaPre=[
            'Buildings.Templates.Components.Coils.None',
            'Buildings.Templates.Components.Coils.WaterBasedHeating',
            # 'Buildings.Templates.Components.Coils.ElectricHeating',
        ],
        # FIXME(AntoineGautier #3526): Some options are currently not supported by G36 controller.
        VAV_1__redeclare__coiCoo=[
            # 'Buildings.Templates.Components.Coils.None',
            'Buildings.Templates.Components.Coils.WaterBasedCooling',
            # 'Buildings.Templates.Components.Coils.EvaporatorVariableSpeed',
        ],
        VAV_1__secOutRel__redeclare__secOut=[
            'Buildings.Templates.AirHandlersFans.Components.OutdoorSection.DedicatedDampersAirflow',
            'Buildings.Templates.AirHandlersFans.Components.OutdoorSection.DedicatedDampersPressure',
            'Buildings.Templates.AirHandlersFans.Components.OutdoorSection.SingleDamper',
        ],
        # FIXME(AntoineGautier #3526): Some options are currently not supported by G36 controller.
        VAV_1__secOutRel__redeclare__secRel=[
            'Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.ReliefDamper',
            # 'Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.ReliefFan',
            'Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.ReturnFan',
        ],
        VAV_1__ctl__typCtlEco=[
            'Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedDryBulb',
            'Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialDryBulb',
            'Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedDryBulbWithDifferentialDryBulb',
            'Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedEnthalpyWithFixedDryBulb',
            'Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb',
        ],
        VAV_1__ctl__typCtlFanRet=[
            'Buildings.Templates.AirHandlersFans.Types.ControlFanReturn.AirflowMeasured',
            'Buildings.Templates.AirHandlersFans.Types.ControlFanReturn.BuildingPressure',
        ],
        VAV_1__ctl__have_perZonRehBox=[
            'true',
            'false',
        ],
        # FIXME(AntoineGautier #3526): Some options are currently not supported by G36 controller.
        VAV_1__ctl__have_frePro=[
            'true',
            # 'false',
        ],
        # FIXME(AntoineGautier #3526): Some options are currently not supported by G36 controller.
        VAV_1__ctl__typFreSta=[
            'Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.No_freeze_stat',
            # 'Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment',
            'Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_BAS',
        ],
        VAV_1__ctl__have_CO2Sen=[
            'true',
            'false',
        ],
    ),
}

# See docstring of `prune_modifications` function for the structure of EXCLUDE.
EXCLUDE: dict[str, list[list[str]]] = {
    'Buildings.Templates.AirHandlersFans.Validation.VAVMultiZone': [
        # We don't test all combinations of control options to limit the number of simulations.
        [
            'Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.(?!FixedDryBulb)',
            'Buildings.Templates.AirHandlersFans.Types.ControlFanReturn.(?!AirflowMeasured)',
            'have_perZonRehBox=false',
            'have_frePro=false',
            'Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.(?!No_freeze_stat)',
            'have_CO2Sen-false',
        ],
    ],
}

# See docstring of `prune_modifications` function for the structure of REMOVE_MODIF.
REMOVE_MODIF: dict[str, list[tuple[list[str], list[str]]]] = {
    'Buildings.Templates.AirHandlersFans.Validation.VAVMultiZone': [
        (
            [
                'Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.(?!ReturnFan)',
            ],
            [
                'typCtlFanRet',
            ],
        ),
        (
            [
                'have_frePro=false',
            ],
            [
                'typFreSta',
            ],
        ),
        (
            [
                'Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.(?!DedicatedDampersPressure)',
            ],
            [
                'have_CO2Sen',
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
    prune_modifications(combinations=combinations, remove_modif=REMOVE_MODIF, exclude=EXCLUDE)

    print(f'Number of cases to be simulated: {len(combinations)}.\n')

    # FIXME(AntoineGautier PR#????): Temporarily limit the number of simulations to be run (for testing purposes only).
    with open('unitTestsCombinations.log', 'w') as FH:
        for c in combinations:
            FH.write("*********" + c[0] + "\n\n" + "\n".join(c[1]) + "\n\n")
    import random; combinations = [combinations[i] for i in random.sample(range(len(combinations)), 10)]

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

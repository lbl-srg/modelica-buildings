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
    'Buildings.Templates.AirHandlersFans.Validation.VAVMultiZone',
]

# Tested modifications should at least cover the options specified at:
# https://github.com/lbl-srg/ctrl-flow-dev/blob/main/server/scripts/sequence-doc/src/version/Current%20G36%20Decisions/Guideline%2036-2021%20(mappings).csv
MODIF_GRID = {
    'Buildings.Templates.AirHandlersFans.Validation.VAVMultiZone': {
        # FIXME(AntoineGautier #3526): Some options are currently not supported by G36 controller.
        'VAV_1__redeclare__coiHeaPre': [
            'Buildings.Templates.Components.Coils.None',
            'Buildings.Templates.Components.Coils.WaterBasedHeating',
            # 'Buildings.Templates.Components.Coils.ElectricHeating',
        ],
        # FIXME(AntoineGautier #3526): Some options are currently not supported by G36 controller.
        'VAV_1__redeclare__coiCoo': [
            # 'Buildings.Templates.Components.Coils.None',
            'Buildings.Templates.Components.Coils.WaterBasedCooling',
            # 'Buildings.Templates.Components.Coils.EvaporatorVariableSpeed',
        ],
        'VAV_1__secOutRel__redeclare__secOut': [
            'Buildings.Templates.AirHandlersFans.Components.OutdoorSection.DedicatedDampersAirflow',
            'Buildings.Templates.AirHandlersFans.Components.OutdoorSection.DedicatedDampersPressure',
            'Buildings.Templates.AirHandlersFans.Components.OutdoorSection.SingleDamper',
        ],
        # FIXME(AntoineGautier #3526): Some options are currently not supported by G36 controller.
        'VAV_1__secOutRel__redeclare__secRel': [
            'Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.ReliefDamper',
            # 'Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.ReliefFan',
            'Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.ReturnFan',
        ],
        'VAV_1__redeclare__fanSupBlo': [
            'Buildings.Templates.Components.Fans.None',
            'Buildings.Templates.Components.Fans.SingleVariable',
            'Buildings.Templates.Components.Fans.ArrayVariable(nFan=2)',
        ],
        'VAV_1__redeclare__fanSupDra': [
            'Buildings.Templates.Components.Fans.None',
            'Buildings.Templates.Components.Fans.SingleVariable',
            'Buildings.Templates.Components.Fans.ArrayVariable(nFan=2)',
        ],
        'VAV_1__ctl__typCtlEco': [
            'Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedDryBulb',
            'Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialDryBulb',
            # 'Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedDryBulbWithDifferentialDryBulb',
            'Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedEnthalpyWithFixedDryBulb',
            'Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb',
        ],
        'VAV_1__ctl__typCtlFanRet': [
            'Buildings.Templates.AirHandlersFans.Types.ControlFanReturn.AirflowMeasured',
            'Buildings.Templates.AirHandlersFans.Types.ControlFanReturn.BuildingPressure',
        ],
        'VAV_1__ctl__have_perZonRehBox': [
            'true',
            'false',
        ],
        # FIXME(AntoineGautier #3526): Some options are currently not supported by G36 controller.
        'VAV_1__ctl__have_frePro': [
            'true',
            # 'false',
        ],
        # FIXME(AntoineGautier #3526): Some options are currently not supported by G36 controller.
        'VAV_1__ctl__typFreSta': [
            'Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.No_freeze_stat',
            # 'Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_equipment',
            # 'Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.Hardwired_to_BAS',
        ],
        'VAV_1__ctl__have_CO2Sen': [
            'true',
            'false',
        ],
    },
}

# See docstring of `prune_modifications` function for the structure of EXCLUDE.
EXCLUDE = {
    'Buildings.Templates.AirHandlersFans.Validation.VAVMultiZone': [
        [
            'Buildings.Templates.Components.Fans.None fanSupBlo',
            'Buildings.Templates.Components.Fans.None fanSupDra',
        ],
        [
            'Buildings.Templates.Components.Fans.(SingleVariable|ArrayVariable) fanSupBlo',
            'Buildings.Templates.Components.Fans.(SingleVariable|ArrayVariable) fanSupDra',
        ],
        # FIXME(AntoineGautier #3527): Simulation fails with Cvode.
        [
            'Buildings.Templates.Components.Coils.None coiHeaPre',
            'Buildings.Templates.Components.Fans.ArrayVariable fanSup(Blo|Dra)',
        ],
    ],
}

# See docstring of `prune_modifications` function for the structure of REMOVE_MODIF.
REMOVE_MODIF = {
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
        # We don't test all combinations of control options to limit the number of simulations.
        (
            [
                'typCtlEco=Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.(?!FixedDryBulb)',
            ],
            [
                'typCtlFanRet',
                'have_perZonRehBox',
                'have_frePro',
                'typFreSta',
                'have_CO2Sen',
            ],
        ),
        (
            [
                'typCtlFanRet=Buildings.Templates.AirHandlersFans.Types.ControlFanReturn.BuildingPressure',
            ],
            [
                'typCtlEco',
                'have_perZonRehBox',
                'have_frePro',
                'typFreSta',
                'have_CO2Sen',
            ],
        ),
        (
            [
                'have_perZonRehBox=false',
            ],
            [
                'typCtlEco',
                'typCtlFanRet',
                'have_frePro',
                'typFreSta',
                'have_CO2Sen',
            ],
        ),
        (
            [
                'have_frePro=false',
            ],
            [
                'typCtlEco',
                'typCtlFanRet',
                'have_perZonRehBox',
                'typFreSta',
                'have_CO2Sen',
            ],
        ),
        (
            [
                'typFreSta=Buildings.Controls.OBC.ASHRAE.G36.Types.FreezeStat.(?!No_freeze_stat)',
            ],
            [
                'typCtlEco',
                'typCtlFanRet',
                'have_perZonRehBox',
                'have_CO2Sen',
            ],
        ),
        (
            [
                'have_CO2Sen=false',
            ],
            [
                'typCtlEco',
                'typCtlFanRet',
                'have_perZonRehBox',
                'have_frePro',
                'typFreSta',
            ],
        ),
    ]
}


if __name__ == '__main__':
    args = parse_args()

    if args.generate:
        # Exclude model if is included in conf.yml for the given simulator.
        for model_name in MODELS:
            if check_conf(model_name, args.tool):
                MODELS.remove(model_name)
                print(f'Model {model_name} is not simulated based on `conf.yml`.')

        # Generate combinations.
        combinations = generate_combinations(models=MODELS, modif_grid=MODIF_GRID)

        # Prune class modifications.
        prune_modifications(
            combinations=combinations,
            exclude=EXCLUDE,
            remove_modif=REMOVE_MODIF,
            fraction_test_coverage=args.coverage,
        )

        print(f'Number of cases to be simulated: {len(combinations)}.\n')

        # Split combinations into chunks of 100 items.
        for i in range(ceil(len(combinations) / 100)):
            with open(
                f'{os.path.basename(__file__).replace(".py", "_combin") + str(i)}', 'wb'
            ) as FH:
                slc = slice(i * 100, min((i + 1) * 100, len(combinations)))
                pickle.dump(combinations[slc], FH)

    if args.simulate:
        # We launch (parallel) simulations by chunks of 100 items.
        # This gives a chance to exit if any simulation fails within a single chunk.
        for file in glob.glob(f'{os.path.basename(__file__).replace(".py", "_combin")}*'):
            with open(file, 'rb') as FH:
                combinations = pickle.load(FH)

            # Delete combination file that was just consumed.
            os.unlink(file)

            print(
                f'Running {len(combinations)} simulations based on the combinations stored in {file}.\n'
            )

            if len(combinations) > 0:
                # Simulate cases.
                results = simulate_cases(combinations, simulator=args.tool, asy=False)

                # Report, clean and exit(1) if any simulations failed.
                report_clean(combinations, results)

        print(CGREEN + 'All simulations succeeded.\n' + CEND)
        sys.exit(0)

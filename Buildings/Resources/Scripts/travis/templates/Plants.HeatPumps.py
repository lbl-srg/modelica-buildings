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
    'Buildings.Templates.Plants.HeatPumps.Validation.AirToWater',
    'Buildings.Templates.Plants.HeatPumps.Validation.AirToWaterPolyvalent',
    'Buildings.Templates.Plants.HeatPumps.Validation.AirToWaterReversiblePolyvalent',
]

# See docstring of `generate_combinations` function for the structure of MODIF_GRID.
# Tested modifications should at least cover the options specified at:
# https://github.com/lbl-srg/ctrl-flow-dev/blob/main/server/scripts/sequence-doc/src/version/Current%20G36%20Decisions/Guideline%2036-2021%20(mappings).csv
MODIF_GRID = {
    'Buildings.Templates.Plants.HeatPumps.Validation.AirToWaterPolyvalent': {
        'pla__typDis_select1': [
            'Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only',
            'Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Variable2',
        ],
        'pla__typArrPumPri_select': [
            'Buildings.Templates.Components.Types.PumpArrangement.Dedicated',
            'Buildings.Templates.Components.Types.PumpArrangement.Headered',
        ],
        'pla__typPumPri_select': [
            'Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Constant',
            'Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable',
        ],
        'pla__have_pumPriDedComHp_select': [
            'true',
            'false',
        ],
        'pla__ctl__have_senTHeaWatPriRet_select': [
            'true',
            'false',
        ],
        'pla__ctl__have_senTHeaWatSecRet_select': [
            'true',
            'false',
        ],
        'pla__ctl__have_senDpHeaWatRemWir': [
            'true',
            'false',
        ],
        'pla__ctl__have_senVHeaWatPri_select': [
            'true',
            'false',
        ],
    },
}
MODIF_GRID['Buildings.Templates.Plants.HeatPumps.Validation.AirToWater'] = (
    MODIF_GRID[
        'Buildings.Templates.Plants.HeatPumps.Validation.AirToWaterPolyvalent'
    ]
    | {
        'pla__typ': [
            'Buildings.Templates.Plants.Controls.Types.PlantHeatPump.HeatingOnly',
            'Buildings.Templates.Plants.Controls.Types.PlantHeatPump.Reversible',
            'Buildings.Templates.Plants.Controls.Types.PlantHeatPump.ReversibleHeatRecovery',
        ],
    }
)
MODIF_GRID[
    'Buildings.Templates.Plants.HeatPumps.Validation.AirToWaterReversiblePolyvalent'
] = MODIF_GRID[
    'Buildings.Templates.Plants.HeatPumps.Validation.AirToWaterPolyvalent'
]

# See docstring of `prune_modifications` function for the structure of EXCLUDE.
EXCLUDE = {
    'Buildings.Templates.Plants.HeatPumps.Validation.AirToWaterReversiblePolyvalent': [
        # Interfaces/PartialHeatPumpPlant.mo:
        #   // Constant-primary plants with 2-pipe and 4-pipe HP require dedicated pumps.
        [
            'typDis_select1=Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Variable2',
            'typArrPumPri_select=Buildings.Templates.Components.Types.PumpArrangement.Headered',
        ],
    ],
}

# See docstring of `prune_modifications` function for the structure of REMOVE_MODIF.
REMOVE_MODIF = {
    'Buildings.Templates.Plants.HeatPumps.Validation.AirToWaterPolyvalent': [
        # Interfaces/PartialHeatPumpPlant.mo:
        #   // Selection only possible for constant primary-variable secondary plants.
        #   // Constant primary-only plants and variable primary plants require variable speed pumps.
        (
            [
                'Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only',
            ],
            [
                'typPumPri_select',
            ],
        ),
        # Interfaces/PartialHeatPumpPlant.mo:
        #   final parameter Boolean have_pumPriDedComHp=
        #     if have_hp and have_chiWat and typArrPumPri==Dedicated
        #     then have_pumPriDedComHp_select else false;
        # With Headered pumps, have_pumPriDedComHp is forced to false regardless of the selection.
        (
            [
                'Buildings.Templates.Components.Types.PumpArrangement.Headered',
            ],
            [
                'have_pumPriDedComHp_select',
            ],
        ),
        # Same rule as above: with typ=HeatingOnly, have_chiWat=false, so have_pumPriDedComHp
        # is forced to false regardless of the selection.
        # This only has an effect for the AirToWater model, which is the only one that varies
        # pla__typ: see below.
        (
            [
                'Buildings.Templates.Plants.Controls.Types.PlantHeatPump.HeatingOnly',
            ],
            [
                'have_pumPriDedComHp_select',
            ],
        ),
        # Controls/HeatPumps/AirToWater.mo:
        # With typDis=Variable1Only, is_priOnl=true, so have_senVHeaWatSec=have_pumHeaWatSec=false:
        # have_senVHeaWatPri is forced to true, have_senTHeaWatSecRet is forced to false (hence
        # have_senTHeaWatPriRet is also forced to true, see rule below), regardless of selection.
        (
            [
                'Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only',
            ],
            [
                'have_senVHeaWatPri_select',
                'have_senTHeaWatSecRet_select',
                'have_senTHeaWatPriRet_select',
            ],
        ),
        # Controls/HeatPumps/AirToWater.mo: have_senTHeaWatPriRet_select is only used if
        # have_senTHeaWatSecRet is true (see rule above). So whenever have_senTHeaWatSecRet_select
        # is explicitly set to false, have_senTHeaWatPriRet is forced to true regardless of
        # have_senTHeaWatPriRet_select.
        (
            [
                'have_senTHeaWatSecRet_select=false',
            ],
            [
                'have_senTHeaWatPriRet_select',
            ],
        ),
    ]
}
REMOVE_MODIF['Buildings.Templates.Plants.HeatPumps.Validation.AirToWater'] = (
    REMOVE_MODIF[
        'Buildings.Templates.Plants.HeatPumps.Validation.AirToWaterPolyvalent'
    ]
    + [
        # Controls/HeatPumps/AirToWater.mo: with typ=ReversibleHeatRecovery, have_hrc=true, so
        # have_senVHeaWatPri, have_senTHeaWatPriRet and have_senTHeaWatSecRet are all forced to
        # true regardless of their respective selections (see rules above).
        (
            [
                'Buildings.Templates.Plants.Controls.Types.PlantHeatPump.ReversibleHeatRecovery',
            ],
            [
                'have_senVHeaWatPri_select',
                'have_senTHeaWatPriRet_select',
                'have_senTHeaWatSecRet_select',
            ],
        ),
    ]
)
REMOVE_MODIF[
    'Buildings.Templates.Plants.HeatPumps.Validation.AirToWaterReversiblePolyvalent'
] = list(
    REMOVE_MODIF[
        'Buildings.Templates.Plants.HeatPumps.Validation.AirToWaterPolyvalent'
    ]
)
# Controls/HeatPumps/AirToWater.mo: final parameter Boolean have_hp = typ <> Polyvalent.
# For AirToWaterPolyvalent (typ is fixed to Polyvalent), have_hp is always false, so
# have_pumPriDedComHp (see rule above) is always forced to false: the selection has no effect
# at all for this model. This is appended after copying the list above so that it does not leak
# into the AirToWater and AirToWaterReversiblePolyvalent lists.
REMOVE_MODIF[
    'Buildings.Templates.Plants.HeatPumps.Validation.AirToWaterPolyvalent'
].append(
    (
        [],
        [
            'have_pumPriDedComHp_select',
        ],
    )
)

if __name__ == '__main__':
    core.main(
        models=MODELS,
        modif_grid=MODIF_GRID,
        exclude=EXCLUDE,
        remove_modif=REMOVE_MODIF,
    )

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
        'pla__ctl__have_senTPriRet_select': [
            'true',
            'false',
        ],
        'pla__ctl__have_senTLooRet_select': [
            'true',
            'false',
        ],
        'pla__ctl__have_senDpHeaWatRemWir': [
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
        #   final parameter Boolean have_senTPriRet =
        #     if is_priOnl then true else have_senTPriRet_select;
        # With typDis=Variable1Only, is_priOnl=true, so have_senTPriRet_select has no effect.
        (
            [
                'Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only',
            ],
            [
                'have_senTPriRet_select',
            ],
        ),
        # Controls/HeatPumps/AirToWater.mo:
        #   final parameter Boolean have_senTLooRet =
        #     is_priOnl and (if have_hrc then true else have_senTLooRet_select);
        # With typDis=Constant1Variable2, is_priOnl=false, so have_senTLooRet_select has no effect.
        (
            [
                'Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Variable2',
            ],
            [
                'have_senTLooRet_select',
            ],
        ),
    ]
}
REMOVE_MODIF['Buildings.Templates.Plants.HeatPumps.Validation.AirToWater'] = (
    REMOVE_MODIF[
        'Buildings.Templates.Plants.HeatPumps.Validation.AirToWaterPolyvalent'
    ]
    + [
        # Controls/HeatPumps/AirToWater.mo: with typDis=Variable1Only (is_priOnl=true) and
        # typ=ReversibleHeatRecovery (have_hrc=true), have_senTLooRet is forced to true
        # (see rule above), so have_senTLooRet_select has no effect regardless of selection.
        # This only has an effect for the AirToWater model, which is the only one that varies
        # pla__typ: see above.
        (
            [
                'Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only',
                'Buildings.Templates.Plants.Controls.Types.PlantHeatPump.ReversibleHeatRecovery',
            ],
            [
                'have_senTLooRet_select',
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

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
]

# See docstring of `generate_combinations` function for the structure of MODIF_GRID.
# Tested modifications should at least cover the options specified at:
# https://github.com/lbl-srg/ctrl-flow-dev/blob/main/server/scripts/sequence-doc/src/version/Current%20G36%20Decisions/Guideline%2036-2021%20(mappings).csv
MODIF_GRID = {
    'Buildings.Templates.Plants.HeatPumps.Validation.AirToWater': {
        'have_chiWat': [  # Parameter declared at top level with final binding in template instance.
            'true',
            'false',
        ],
        'pla__have_hrc_select': [
            'true',
            'false',
        ],
        'pla__typDis_select1': [
            'Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only',
            'Buildings.Templates.Plants.HeatPumps.Types.Distribution.Constant1Variable2',
        ],
        # Primary headered pumps cause a translation error with Dymola 2024x but not with 2024xRefresh1.
        # This configuration is temporarily removed from tests until CI testing is updated to use Dymola 2024xRefresh1.
        'pla__typArrPumPri': [
            'Buildings.Templates.Components.Types.PumpArrangement.Dedicated',
            # 'Buildings.Templates.Components.Types.PumpArrangement.Headered',
        ],
        'pla__typPumHeaWatPri_select1': [  # typPumChiWatPri_select1=typPumHeaWatPri_select1 by default in the template.
            'Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Constant',
            'Buildings.Templates.Plants.HeatPumps.Types.PumpsPrimary.Variable',
        ],
        'pla__have_pumChiWatPriDed_select': [
            'true',
            'false',
        ],
        'pla__ctl__have_senTHeaWatPriRet_select': [  # have_senTChiWatPriRet_select=have_senTHeaWatPriRet_select by default in the template.
            'true',
            'false',
        ],
        'pla__ctl__have_senTHeaWatSecRet_select': [  # have_senTChiWatSecRet_select=have_senTHeaWatSecRet_select by default in the template.
            'true',
            'false',
        ],
        'pla__ctl__have_senDpHeaWatRemWir': [  # have_senDpChiWatRemWir=have_senDpHeaWatRemWir by default in the template.
            'true',
            'false',
        ],
        'pla__ctl__have_senVHeaWatPri_select': [  # have_senVChiWatPri_select=have_senVHeaWatPri_select by default in the template.
            'true',
            'false',
        ],
    },
}

# See docstring of `prune_modifications` function for the structure of EXCLUDE.
EXCLUDE = {
    'Buildings.Templates.Plants.HeatPumps.Validation.AirToWater': [
        [
            'have_chiWat=false',
            'have_hrc_select=true',
        ],
    ],
}

# See docstring of `prune_modifications` function for the structure of REMOVE_MODIF.
REMOVE_MODIF = {
    'Buildings.Templates.Plants.HeatPumps.Validation.AirToWater': [
        (
            [
                'Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only',
            ],
            [
                'typPumHeaWatPri_select1',
            ],
        ),
        (
            [
                'have_chiWat=true',
                'typArrPumPri=Buildings.Templates.Components.Types.PumpArrangement.Headered',
            ],
            [
                'have_pumChiWatPriDed_select',
            ],
        ),
        (
            [
                'have_chiWat=false',
            ],
            [
                'typPumChiWatPri_select1',
                'have_pumChiWatPriDed_select',
            ],
        ),
        (
            [
                'Buildings.Templates.Plants.HeatPumps.Types.Distribution.Variable1Only',
            ],
            [
                'have_senVHeaWatPri_select',
                'have_senTHeaWatSecRet_select',
            ],
        ),
        (
            [
                'have_hrc_select=true',
            ],
            [
                'have_senVHeaWatPri_select',
                'have_senTHeaWatPriRet_select',
                'have_senTHeaWatSecRet_select',
            ],
        ),
    ]
}


if __name__ == '__main__':
    core.main(
        models=MODELS, modif_grid=MODIF_GRID, exclude=EXCLUDE, remove_modif=REMOVE_MODIF
    )

within Buildings.Rooms.FLEXLAB.Data.Constructions.OpaqueConstructions;
record ASHRAE901Roof =
  Buildings.HeatTransfer.Data.OpaqueConstructions.Generic(final material={
    Buildings.HeatTransfer.Data.Solids.GypsumBoard(x=0.016),
    Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.1016),
    Buildings.HeatTransfer.Data.Solids.Plywood(x=0.0127)},
    final nLay=3)
  "Construction model for a roof minimally compliant with ASHRAE 90.1. Used in test cells 90X3A and 90X3B. 16 mm gypsum, 102 mm insulation, 13 mm plywood";

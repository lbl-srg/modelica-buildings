within Buildings.Rooms.FLEXLAB.Data.Constructions.OpaqueConstructions.Roofs;
record ASHRAE_901_2010Roof =
  Buildings.HeatTransfer.Data.OpaqueConstructions.Generic(final material={
    Buildings.HeatTransfer.Data.Solids.GypsumBoard(x=0.016),
    Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.1016),
    Buildings.HeatTransfer.Data.Solids.Plywood(x=0.0127)},
    final nLay=3) "Construction model for a roof minimally compliant with ASHRAE 90.1. 
      Used in test cells 90X3A, 90X3B, and 90XRA";

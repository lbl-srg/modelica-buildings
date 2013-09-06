within Buildings.Rooms.FLEXLAB.Data.Constructions.OpaqueConstructions.Roofs;
record ASHRAE_901_1975Roof =
  Buildings.HeatTransfer.Data.OpaqueConstructions.Generic(final material={
    Buildings.HeatTransfer.Data.Solids.GypsumBoard(x=0.016),
    Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.09652),
    Buildings.HeatTransfer.Data.Solids.Plywood(x=0.0127)},
    final nLay=3) "Construction model for a roof minimally compliant with ASHRAE 90.1-1975. 
     Used in test cells 90X1A and 90X1B";

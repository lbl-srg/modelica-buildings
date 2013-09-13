within Buildings.Rooms.FLEXLAB.Data.Constructions.OpaqueConstructions.Roofs;
record CA_T24_2013Roof =
  Buildings.HeatTransfer.Data.OpaqueConstructions.Generic(final material={
    Buildings.HeatTransfer.Data.Solids.GypsumBoard(x=0.016),
    Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.1016),
    Buildings.HeatTransfer.Data.Solids.Plywood(x=0.0127)},
    final nLay=3) "Construction model for a roof minimally compliant with CA Title 24-2013. 
      Used in test cells 90X2A and 90X2B";

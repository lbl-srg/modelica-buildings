within Buildings.Rooms.FLEXLAB.Data.Constructions.OpaqueConstructions.ExteriorConstructions;
record Construction1 =
  Buildings.HeatTransfer.Data.OpaqueConstructions.Generic(final material={
    Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.127),
    Buildings.HeatTransfer.Data.Solids.Plywood(x=0.0127),
    Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.2032),
    Buildings.HeatTransfer.Data.Solids.Plywood(x=0.0127),
    Buildings.HeatTransfer.Data.Solids.GypsumBoard(x=0.01588)},
    final nLay = 5)
  "North wall in FLEXLAB closets, west wall in UF90XRA, east wall in UF90XRB, west wall in UF90X1A";

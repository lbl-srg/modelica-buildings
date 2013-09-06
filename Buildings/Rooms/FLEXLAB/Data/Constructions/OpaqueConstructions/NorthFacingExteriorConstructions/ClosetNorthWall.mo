within Buildings.Rooms.FLEXLAB.Data.Constructions.OpaqueConstructions.NorthFacingExteriorConstructions;
record ClosetNorthWall =
  Buildings.HeatTransfer.Data.OpaqueConstructions.Generic(final material={
    Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.127),
    Buildings.HeatTransfer.Data.Solids.Plywood(x=0.0127),
    Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.2032),
    Buildings.HeatTransfer.Data.Solids.Plywood(x=0.0127),
    Buildings.HeatTransfer.Data.Solids.GypsumBoard(x=0.01588)},
    final nLay = 5) "North facing wall in FLEXLAB closets. 127 mm insulation, 13 mm 
     plywood, 203 mm insulation, 13 mm plywood, 16 mm gypsum board";

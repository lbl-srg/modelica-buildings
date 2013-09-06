within Buildings.Rooms.FLEXLAB.Data.Constructions.OpaqueConstructions.SouthFacingWalls;
record ModInsulExtWall =
  Buildings.HeatTransfer.Data.OpaqueConstructions.Generic(final material={
    Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.02413),
    Buildings.HeatTransfer.Data.Solids.Plywood(x=0.0127),
    Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.08255),
    Buildings.HeatTransfer.Data.Solids.GypsumBoard(x=0.01588)},
    final nLay = 4) "Moderately insulated exterior wall. Used on the North side of cell 90X3A. 24 mm 
     of rigid insulation, 13 mm of plywood, 83 mm of rigid insulation, 16 mm of gypsum 
     wallboard";

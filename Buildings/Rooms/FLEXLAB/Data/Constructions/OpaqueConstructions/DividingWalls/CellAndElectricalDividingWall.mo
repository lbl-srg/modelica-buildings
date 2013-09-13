within Buildings.Rooms.FLEXLAB.Data.Constructions.OpaqueConstructions.DividingWalls;
record CellAndElectricalDividingWall =
  Buildings.HeatTransfer.Data.OpaqueConstructions.Generic(final material={
    Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.127),
    Buildings.HeatTransfer.Data.Solids.Plywood(x=0.0127),
    Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.2032),
    Buildings.HeatTransfer.Data.Solids.Plywood(x=0.0127),
    Buildings.HeatTransfer.Data.Solids.Plywood(x=0.01905)},
    final nLay = 5) "Wall separating FLEXLAB test cells from the adjoining
      electrical rooms";

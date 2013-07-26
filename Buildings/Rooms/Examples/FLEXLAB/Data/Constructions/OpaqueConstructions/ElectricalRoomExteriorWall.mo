within Buildings.Rooms.Examples.FLEXLAB.Data.Constructions.OpaqueConstructions;
record ElectricalRoomExteriorWall =
  Buildings.HeatTransfer.Data.OpaqueConstructions.Generic(final material={
    Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.127),
    Buildings.HeatTransfer.Data.Solids.Plywood(x=0.0127),
    Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.2032),
    Buildings.HeatTransfer.Data.Solids.Plywood(x=0.03175)},
    final nLay = 4)
  "Insulated wall used on the exterior of the electrical room. Used on the north side of the electrical room in cell 90X3A. 127 mm insulation, 13 mm plywood, 203 mm insulation, 13 mm plywood, 16 mm gypsum board";

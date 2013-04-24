within Buildings.Rooms.Examples.FLeXLab.Data.Constructions;
record Insul127Ply13Insul203Ply13Gyp16 =
  Buildings.HeatTransfer.Data.OpaqueConstructions.Generic(material={
    Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.127),
    Buildings.HeatTransfer.Data.Solids.Plywood(x=0.0127),
    Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.2032),
    Buildings.HeatTransfer.Data.Solids.Plywood(x=0.0127),
    Buildings.HeatTransfer.Data.Solids.GypsumBoard(x=0.01588)},
    final nLay = 5)
  "Wall construction consiting of 127 mm insulation, 13 mm plywood, 203 mm insulation, 13 mm plywood, 16 mm gypsum board";

within Buildings.Rooms.Examples.FLeXLab.Data.Constructions;
record Gyp16Insul102Ply13Insul103Ply13Insul102Gyp16 =
  Buildings.HeatTransfer.Data.OpaqueConstructions.Generic(final material={
    Buildings.HeatTransfer.Data.Solids.GypsumBoard(x=0.01588),
    Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.1016),
    Buildings.HeatTransfer.Data.Solids.Plywood(x=0.0127),
    Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.2032),
    Buildings.HeatTransfer.Data.Solids.Plywood(x=0.127),
    Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.1016),
    Buildings.HeatTransfer.Data.Solids.GypsumBoard(x=0.1588)},
    nLay = 7)
  "Wall between 90X3A and 90X3B. 16 mm gypsum, 102 mm insulation, 13 mm plywood, 103 mm insulation, 13 mm plywood, 102 mm insulation, 16 mm gypsum.";

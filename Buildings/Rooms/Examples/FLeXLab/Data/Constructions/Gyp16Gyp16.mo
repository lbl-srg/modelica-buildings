within Buildings.Rooms.Examples.FLeXLab.Data.Constructions;
record Gyp16Gyp16 =
   Buildings.HeatTransfer.Data.OpaqueConstructions.Generic(material={
    Buildings.HeatTransfer.Data.Solids.GypsumBoard(x=0.01588),
    Buildings.HeatTransfer.Data.Solids.GypsumBoard(x=0.01588)},
    nLay=3)
  "Model of a partition wall. Air is neglected. 16 mm gypsum board, 16 mm gypsum board fixme - Does air need to be included?";

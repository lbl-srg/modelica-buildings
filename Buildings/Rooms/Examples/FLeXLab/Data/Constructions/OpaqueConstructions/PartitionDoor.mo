within Buildings.Rooms.Examples.FLeXLab.Data.Constructions.OpaqueConstructions;
record PartitionDoor =
   Buildings.HeatTransfer.Data.OpaqueConstructions.Generic(final material={
    Buildings.HeatTransfer.Data.Solids.Plywood(x=0.01588),
    Buildings.HeatTransfer.Data.Solids.Plywood(x=0.01588)},
    final nLay=2)
  "Model of a partition wall door. Air is neglected. 16 mm plywood, 16 mm plywood";

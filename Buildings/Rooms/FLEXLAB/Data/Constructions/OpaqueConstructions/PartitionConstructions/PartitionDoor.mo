within Buildings.Rooms.FLEXLAB.Data.Constructions.OpaqueConstructions.PartitionConstructions;
record PartitionDoor =
   Buildings.HeatTransfer.Data.OpaqueConstructions.Generic(final material={
    Buildings.HeatTransfer.Data.Solids.Plywood(x=0.01588),
    Buildings.HeatTransfer.Data.Solids.Plywood(x=0.01588)},
    final nLay=2) "Model of a partition door. Air is neglected";

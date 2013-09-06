within Buildings.Rooms.FLEXLAB.Data.Constructions.OpaqueConstructions.PartitionConstructions;
record PartitionWall =
   Buildings.HeatTransfer.Data.OpaqueConstructions.Generic(final material={
    Buildings.HeatTransfer.Data.Solids.GypsumBoard(x=0.01588),
    Buildings.HeatTransfer.Data.Solids.GypsumBoard(x=0.01588)},
    final nLay=2) "Model of a partition wall. Air is neglected";

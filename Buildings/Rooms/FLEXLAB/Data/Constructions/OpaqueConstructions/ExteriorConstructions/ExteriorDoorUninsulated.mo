within Buildings.Rooms.FLEXLAB.Data.Constructions.OpaqueConstructions.ExteriorConstructions;
record ExteriorDoorUninsulated =
   Buildings.HeatTransfer.Data.OpaqueConstructions.Generic(final material={
    Buildings.HeatTransfer.Data.Solids.Plywood(x=0.01588),
    Buildings.HeatTransfer.Data.Solids.Plywood(x=0.01588)},
    final nLay=2) "Model of an uninsulated exterior door";

within Buildings.Rooms.FLEXLAB.Data.Constructions.OpaqueConstructions;
record ExteriorDoorInsulated =
   Buildings.HeatTransfer.Data.OpaqueConstructions.Generic(final material={
    Buildings.HeatTransfer.Data.Solids.Plywood(x=0.01588),
    Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.05),
    Buildings.HeatTransfer.Data.Solids.Plywood(x=0.01588)},
    final nLay=3) "Model of an insulated exterior door";

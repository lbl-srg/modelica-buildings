within Buildings.Rooms.Examples.FLEXLAB.Data.Constructions.OpaqueConstructions;
record ExteriorDoor =
   Buildings.HeatTransfer.Data.OpaqueConstructions.Generic(final material={
    Buildings.HeatTransfer.Data.Solids.Plywood(x=0.01588),
    Buildings.HeatTransfer.Data.Solids.InsulationBoard(x=0.05),
    Buildings.HeatTransfer.Data.Solids.Plywood(x=0.01588)},
    final nLay=3)
  "Model of a partition wall door. Air is neglected. 16 mm plywood, 50 mm insulation, 16 mm plywood";

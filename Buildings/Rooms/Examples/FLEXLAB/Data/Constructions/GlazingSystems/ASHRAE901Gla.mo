within Buildings.Rooms.Examples.FLEXLAB.Data.Constructions.GlazingSystems;
record ASHRAE901Gla =
  Buildings.HeatTransfer.Data.GlazingSystems.Generic (
  final glass={Buildings.HeatTransfer.Data.Glasses.ID101(), Buildings.HeatTransfer.Data.Glasses.ID101()},
  final gas = {Buildings.HeatTransfer.Data.Gases.Air(x=0.0127)},
  UFra=1.4,
  final nLay=2)
  "XGL-1 window constuction used in cells 3A, 3B and RA. ASHRAE 90.1 minimally compliant";

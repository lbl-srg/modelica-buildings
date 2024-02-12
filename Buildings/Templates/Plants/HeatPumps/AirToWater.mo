within Buildings.Templates.Plants.HeatPumps;
model AirToWater
  "Air-to-water heat pump plant"
  extends Buildings.Templates.Plants.HeatPumps.Interfaces.PartialHeatPumpPlant(
      redeclare final package MediumSou = MediumAir, cfg(final typMod=hp.typMod));
  Buildings.Templates.Plants.HeatPumps.Components.HeatPumpGroups.AirToWater hp(
    redeclare final package MediumHeaWat = MediumHeaWat,
    redeclare final package MediumAir = MediumAir,
    final nHp=nHp,
    final is_rev=is_rev,
    final dat=dat.hp,
    final allowFlowReversal=allowFlowReversal) "Heat pump group"
    annotation (Placement(transformation(extent={{-100,-160},{100,-80}})));
end AirToWater;

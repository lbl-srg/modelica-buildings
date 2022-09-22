within Buildings.Templates.ChilledWaterPlants;
model AirCooled "Air-cooled chiller plant"
  extends
    Buildings.Templates.ChilledWaterPlants.Interfaces.PartialChilledWaterLoop(
    redeclare replaceable package MediumCon=Buildings.Media.Air,
    final typChi=Buildings.Templates.Components.Types.Chiller.AirCooled,
    final typValCooInlIso=Buildings.Templates.Components.Types.Valve.None,
    final typValCooOutIso=Buildings.Templates.Components.Types.Valve.None);

  // Air loop

end AirCooled;

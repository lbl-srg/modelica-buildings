within Buildings.ThermalZones.EnergyPlus.Validation;
model OneZoneOneOutputVariable
  "Validation model for one zone with one output variable"
  extends Buildings.ThermalZones.EnergyPlus.Validation.OneZone;

  Buildings.ThermalZones.EnergyPlus.OutputVariable equEle(
    key="LIVING ZONE",
    name="Zone Electric Equipment Electric Power",
    y(final unit="W"))
    "Block that reads output from EnergyPlus"
    annotation (Placement(transformation(extent={{70,50},{90,70}})));
  annotation (Documentation(info="<html>
<p>
Simple test case for one building with one thermal zone and one output variable.
</p>
<p>
The room air temperature is free floating.
</p>
</html>", revisions="<html>
<ul><li>
October 7, 2019, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
 __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus/Validation/OneZoneOneOutputVariable.mos"
        "Simulate and plot"),
experiment(
      StopTime=432000,
      Tolerance=1e-06));
end OneZoneOneOutputVariable;

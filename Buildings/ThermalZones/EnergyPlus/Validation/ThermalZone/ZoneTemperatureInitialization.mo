within Buildings.ThermalZones.EnergyPlus.Validation.ThermalZone;
model ZoneTemperatureInitialization
  "This example tests whether the zone mean air temperature is initialized correctly in EnergyPlus"
  extends Buildings.ThermalZones.EnergyPlus.Examples.SingleFamilyHouse.Unconditioned(
    zon(
      T_start=303.15));
  Buildings.ThermalZones.EnergyPlus.OutputVariable TRad(
    key="LIVING ZONE",
    name="Zone Mean Radiant Temperature",
    y(
      final unit="K"))
    "Block that reads output from EnergyPlus"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  annotation (
    Documentation(
      info="<html>
<p>
Simple test case that verifies whether the zone mean air temperature is
initialized correctly by EnergyPlus.
</p>
</html>",
      revisions="<html>
<ul>
<li>
May 19, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus/Validation/ThermalZone/ZoneTemperatureInitialization.mos" "Simulate and plot"),
    experiment(
      StopTime=86400,
      Tolerance=1e-06));
end ZoneTemperatureInitialization;

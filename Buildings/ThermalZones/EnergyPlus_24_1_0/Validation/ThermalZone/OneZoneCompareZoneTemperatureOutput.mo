within Buildings.ThermalZones.EnergyPlus_24_1_0.Validation.ThermalZone;
model OneZoneCompareZoneTemperatureOutput
  "This example tests whether the zone mean air temperature is reported correctly as an EnergyPlus output"
  extends Buildings.ThermalZones.EnergyPlus_24_1_0.Examples.SingleFamilyHouse.Unconditioned;
  Buildings.ThermalZones.EnergyPlus_24_1_0.OutputVariable zonMeaAirTem(
    name="Zone Mean Air Temperature",
    key="LIVING ZONE",
    y(final unit="K",
      displayUnit="degC"))
    "Block that reads output from EnergyPlus"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));
  annotation (
    Documentation(
      info="<html>
<p>
Simple test case that verifies whether the zone mean air temperature is reported correctly by EnergyPlus.
Note that Modelica solves the differential equation for this variable, but this test case
obtains its value from EnergyPlus.
</p>
</html>",
      revisions="<html>
<ul><li>
April 2, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus_24_1_0/Validation/ThermalZone/OneZoneCompareZoneTemperatureOutput.mos" "Simulate and plot"),
    experiment(
      StopTime=172800,
      Tolerance=1e-06));
end OneZoneCompareZoneTemperatureOutput;

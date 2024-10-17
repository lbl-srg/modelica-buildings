within Buildings.ThermalZones.EnergyPlus_24_1_0.Validation.OutputVariable;
model OneZoneTwoDifferentOutputVariables
  "Validation model for one zone with two different output variables"
  extends OneZoneOneOutputVariable;
  Buildings.ThermalZones.EnergyPlus_24_1_0.OutputVariable incBeaSou(
    name="Surface Outside Face Incident Beam Solar Radiation Rate per Area",
    key="Living:South",
    y(final unit="W/m2"))
    "Block that reads incident beam solar radiation on south window from EnergyPlus"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  annotation (
    Documentation(
      info="<html>
<p>
Simple test case for one building with one thermal zone and two different output variables.
This test case validates that the outputs are correct if requested from different
EnergyPlus variables.
</p>
</html>",
      revisions="<html>
<ul><li>
December 13, 2019, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus_24_1_0/Validation/OutputVariable/OneZoneTwoDifferentOutputVariables.mos" "Simulate and plot"),
    experiment(
      StopTime=432000,
      Tolerance=1e-06));
end OneZoneTwoDifferentOutputVariables;

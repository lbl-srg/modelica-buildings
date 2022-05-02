within Buildings.ThermalZones.EnergyPlus_9_6_0.Validation.ThermalZone;
model NegativeStartTime "Validation model for negative start time"
  extends Examples.SingleFamilyHouse.Unconditioned;
  Buildings.ThermalZones.EnergyPlus_9_6_0.OutputVariable sitDirSol(
    name="Site Direct Solar Radiation Rate per Area",
    key="Environment",
    y(final unit="W/m2"))
    "Block that reads incident beam solar radiation on south window from EnergyPlus"
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
  annotation (
  __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus_9_6_0/Validation/ThermalZone/NegativeStartTime.mos" "Simulate and plot"),
    experiment(
      StartTime=-86400,
      StopTime=86400,
      Tolerance=1e-06),
    Documentation(
      info="<html>
<p>
Validation model for negative start time.
This test validates that EnergyPlus correctly simulates if it is started at a negative start time.
</p>
</html>",
     revisions="<html>
<ul>
<li>
May 2, 2022, by Michael Wetter:<br/>
First implementation.<br/>
This is for
<a href=\\\"https://github.com/lbl-srg/modelica-buildings/issues/1938\\\">#1938</a>.
</li>
</ul>
</html>"));
end NegativeStartTime;

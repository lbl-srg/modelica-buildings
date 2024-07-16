within Buildings.ThermalZones.EnergyPlus_9_6_0.Validation.RunPeriod;
model NegativeStartTime "Validation model for negative start time"
  extends Examples.SingleFamilyHouse.Unconditioned;
  Buildings.ThermalZones.EnergyPlus_9_6_0.OutputVariable sitDirSol(
    name="Site Direct Solar Radiation Rate per Area",
    key="Environment",
    y(final unit="W/m2"))
    "Block that reads direct solar radiation from EnergyPlus"
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
  Buildings.ThermalZones.EnergyPlus_9_6_0.OutputVariable sitOutDryBul(
    name="Site Outdoor Air Drybulb Temperature",
    key="Environment",
    y(final unit="K",
      displayUnit="degC"))
    "Block that reads outside dry bulb temperature from EnergyPlus"
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));
  annotation (
  __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus_9_6_0/Validation/RunPeriod/NegativeStartTime.mos" "Simulate and plot"),
    experiment(
      StartTime=-172800,
      StopTime=86400,
      Tolerance=1e-06),
    Documentation(
      info="<html>
<p>
Validation model for negative start time.
This test validates that EnergyPlus correctly simulates if it is started at a negative start time.
The model simulates the last two days of the year and the first day.
For comparison with the Modelica weather data, the model reads the solar irradiation and the outdoor drybulb temperature
from EnergyPlus.
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

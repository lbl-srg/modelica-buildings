within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.Data;
record Generic "Generic record of induction machine parameters"
  extends Modelica.Icons.Record;
  parameter Integer P = 4 "Number of Poles";
  parameter Real J = 0.17 "Moment of Inertia [kg/m²]";
  parameter Real Lr = 0.1458 "Rotor Inductance [H]";
  parameter Real Ls = 0.1457 "Stator Inductance [H]";
  parameter Real Lm = 0.1406 "Mutual Inductance [H]";
  parameter Real Rs = 1 "Stator Resistance [ohm]";
  parameter Real Rr = 1.145 "Rotor Resistance [ohm]";
  parameter Real Freq = 50 "Standard Frequency [Hz]";
  parameter Real Voltage = 400 "Standard Voltage [V]";
  annotation (
  defaultComponentPrefixes = "parameter",
  defaultComponentName = "per",
  Documentation(preferredView="info",
  info="<html>
<p>
This is the base record for Induction Motor models.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 7, 2024, by Viswanathan Ganesh:<br/>
First implementation.
</li>
</ul>
</html>"));
end Generic;

within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses;
model Torque
  "Calculate electromagnetic torque using stator and rotor current"
  extends Modelica.Blocks.Icons.Block;

  parameter Integer P=4 "Number of pole";
  parameter Real Lm(
    start=0.5,
    final fixed=true,
    final unit="H",
    final quantity="Inductance")
    "Mutual inductance";
  parameter Real J(
    start=0.0131,
    final fixed=true,
    final unit="kg.m2",
    final quantity="MomentOfInertia")
    "Moment of inertia";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput i_qs(
    final unit="A",
    final quantity="ElectricCurrent")
    "Q-axis stator current"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput i_ds(
    final unit="A",
    final quantity="ElectricCurrent")
    "D-axis stator current"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput i_qr(
    final unit="A",
    final quantity="ElectricCurrent")
    "Q-axis rotor current"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput i_dr(
    final unit="A",
    final quantity="ElectricCurrent")
    "D-axis rotor current"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput tau_e(
    final quantity="Torque",
    final unit="N.m")
    "Electromagnetic torque"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

equation
  tau_e = ((i_qs*i_dr)-(i_ds*i_qr))*(3/2)*(P/(2))*Lm;

annotation (defaultComponentName="eleTor",
preferredView="info", Documentation(info="<html>
<p>
This block computes the electromagnetic torque of an induction machine using the
stator and rotor currents in the synchronous d–q reference frame.
It implements the standard torque equation derived from the cross product of stator
and rotor flux-producing current components.
</p>
<p>
The implemented relation is:
</p>
<p>
\\[
\\tau_e
=
\\frac{3}{2}\\,\\frac{P}{2}\\,L_m\\,
\\big( i_{qs} i_{dr} - i_{ds} i_{qr} \\big)
\\]
</p>
<p>
where
<i>P</i> is the number of poles, <i>L<sub>m</sub></i> is the mutual inductance,
and <i>i<sub>ds</sub></i>, <i>i<sub>qs</sub></i>, <i>i<sub>dr</sub></i>,
<i>i<sub>qr</sub></i> are the d–q stator and rotor currents.
</p>
<p>
This block is used in
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors\">
Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
May 07, 2024, by Viswanathan Ganesh and Zhanwei He:<br/>
First implementation.
</li>
</ul>
</html>"));
end Torque;

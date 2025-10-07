within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses;
model CurrentDerivative_dRotor
  "Time derivative of the D-axis rotor current"
  extends Modelica.Blocks.Icons.Block;

  parameter Real Lr(
    final unit="H",
    final quantity="Inductance")
    "Rotor inductance";
  parameter Real Rr(
    final unit="Ohm",
    final quantity="Resistance")
    "Rotor resistance";
  parameter Real Lm(
    final unit="H",
    final quantity="Inductance")
    "Mutual inductance";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput v_dr(
    final unit="V",
    final quantity="Voltage")
    "D-axis rotor voltage"
    annotation (Placement(transformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput i_qr(
    final unit="A",
    final quantity="ElectricCurrent")
    "Q-axis rotor current"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput der_i_ds
    "Derivative of D-axis stator current"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput omega_r(
    final quantity="AngularVelocity",
    final unit="rad/s")
    "Rotor frequency"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput i_dr(
    final unit="A",
    final quantity="ElectricCurrent")
    "D-axis rotor current"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput i_qs(
    final unit="A",
    final quantity="ElectricCurrent")
    "Q-axis stator current"
    annotation (Placement(transformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput der_i_dr
    "Derivative of D-axis rotor current"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

equation
  der_i_dr = (((v_dr)/Lr)-((Rr*i_dr)/Lr)-((der_i_ds*Lm)/Lr)+(omega_r*i_qr)
                +((omega_r*Lm*i_qs)/Lr));
annotation (preferredView="info", Documentation(info="<html>
<p>
This block computes the time derivative of the d-axis rotor current in the
synchronous d–q frame. The implemented relation is:
</p>
<p>
\\[
\\frac{d i_{dr}}{dt}
=
\\frac{1}{L_r}\\Big(
v_{dr}
- R_r\\, i_{dr}
- L_m\\, \\frac{d i_{ds}}{dt}
+ \\omega_r\\, L_r\\, i_{qr}
+ \\omega_r\\, L_m\\, i_{qs}
\\Big)
\\]
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
end CurrentDerivative_dRotor;

within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses;
model CurrentDerivative_qStator
  "Time derivative of the Q-axis stator current"
  extends Modelica.Blocks.Icons.Block;

  parameter Real Lr(
    final unit="H",
    final quantity="Inductance")
    "Rotor Inductance";
  parameter Real Rr(
    final unit="Ohm",
    final quantity="Resistance")
    "Rotor Resistance";
  parameter Real Lm(
    final unit="H",
    final quantity="Inductance")
    "Mutual Inductance";
  parameter Real Rs(
    final unit="Ohm",
    final quantity="Resistance")
    "Stator Resistance";
  parameter Real Ls(
    final unit="H",
    final quantity="Inductance")
    "Stator Inductance";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput v_qs(
    final unit="V",
    final quantity="Voltage")
    "Q-axis stator voltage"
    annotation (Placement(transformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput i_qs(
    final unit="A",
    final quantity="ElectricCurrent")
    "Q-axis stator current"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput der_i_qr
    "Derivative of Q-axis rotor current"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput omega(
    final quantity="AngularVelocity",
    final unit="rad/s")
    "Electrical angular frequency"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput i_dr(
    final unit="A",
    final quantity="ElectricCurrent")
    "D-axis rotor current"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput i_ds(
    final unit="A",
    final quantity="ElectricCurrent")
    "D-axis stator current"
    annotation (Placement(transformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput der_i_qs
    "Derivative of Q-axis stator current"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

equation
  der_i_qs =(((v_qs)/Ls)-((Rs*i_qs)/Ls)-((der_i_qr*Lm)/Ls)-(omega*i_ds)-((omega*Lm*i_dr)/Ls));

annotation (preferredView="info", Documentation(info="<html>
<p>
This block computes the time derivative of the q-axis stator current in the
synchronous d–q frame. The implemented relation is:
</p>
<p>
\\[
\\frac{d i_{qs}}{dt}
=
\\frac{1}{L_s}\\Big(
v_{qs}
- R_s\\, i_{qs}
- L_m\\, \\frac{d i_{qr}}{dt}
- \\omega\\, L_s\\, i_{ds}
- \\omega\\, L_m\\, i_{dr}
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
First Implementation.
</li>
</ul>
</html>"));
end CurrentDerivative_qStator;

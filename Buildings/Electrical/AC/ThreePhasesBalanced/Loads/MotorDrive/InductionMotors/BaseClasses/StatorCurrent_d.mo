within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses;
model StatorCurrent_d "d-axis stator current calculation block"
  extends Modelica.Blocks.Icons.Block;
   parameter Real Lr "Rotor Inductance";
   parameter Real Rr "Rotor Resistance";
   parameter Real Lm "Mutual Inductance";
   parameter Real Rs "Stator Resistance";
   parameter Real Ls "Stator Inductance";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput v_ds
    "D-axis stator voltage"
    annotation (Placement(transformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput i_ds
    "D-axis stator current"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput der_i_dr
    "Derivative of D-axis rotore current"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput omega
    "Electrical angular frequency"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput i_qr
    "Q-axis rotor current"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput i_qs
    "Q-axis stator current"
    annotation (Placement(transformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput der_i_ds
    "Derivative of D-axis stator current"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

equation
  der_i_ds =(((v_ds)/Ls)-((Rs*i_ds)/Ls)-((der_i_dr*Lm)/Ls)+(omega*i_qs)+((omega*Lm*i_qr)/Ls));
 annotation (preferredView="info", Documentation(info="<html>
<p>
This block computes the time derivative of the d-axis stator current in the synchronous d–q frame. The implemented relation is:
</p>

<p>
\\[
\\frac{d i_{ds}}{dt}
=
\\frac{1}{L_s}\\Big(
v_{ds}
- R_s\\, i_{ds}
- L_m\\, \\frac{d i_{dr}}{dt}
+ \\omega\\, L_s\\, i_{qs}
+ \\omega\\, L_m\\, i_{qr}
\\Big)
\\]
</p>

<p>
This block is used in 
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors\">
Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors</a>.
</p>
</html>
",        revisions="<html>
<ul>
<li>
May 07, 2024, by Viswanathan Ganesh and Zhanwei He:<br/>
First Implementation.
</li>
</ul>
</html>"));
end StatorCurrent_d;

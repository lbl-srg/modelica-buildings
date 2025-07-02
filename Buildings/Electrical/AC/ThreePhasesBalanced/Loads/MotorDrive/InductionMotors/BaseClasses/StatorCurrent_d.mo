within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses;
model StatorCurrent_d "d-axis stator current calculation block"
  extends Modelica.Blocks.Icons.Block;
   parameter Real Lr;
   parameter Real Rr;
   parameter Real Lm;
   parameter Real Rs;
   parameter Real Ls;
  Buildings.Controls.OBC.CDL.Interfaces.RealInput v_ds
    annotation (Placement(transformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput i_ds
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput der_i_dr
    annotation (Placement(transformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput omega
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput i_qr
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput i_qs
    annotation (Placement(transformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput der_i_ds
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

equation
  der_i_ds =(((v_ds)/Ls)-((Rs*i_ds)/Ls)-((der_i_dr*Lm)/Ls)+(omega*i_qs)+((omega*Lm*i_qr)/Ls));
 annotation (preferredView="info", Documentation(info="<html>
<p>
This block computes d-axis stator current for the models in 
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors\">Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors</a>.
</p>
</html>"));
end StatorCurrent_d;
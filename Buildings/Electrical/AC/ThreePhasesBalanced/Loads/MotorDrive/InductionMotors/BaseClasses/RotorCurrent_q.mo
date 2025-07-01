within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses;
model RotorCurrent_q "q-axis rotor current calculation block"
  extends Modelica.Blocks.Icons.Block;
   parameter Real Lr;
   parameter Real Rr;
   parameter Real Lm;
  Buildings.Controls.OBC.CDL.Interfaces.RealInput v_qr
    annotation (Placement(transformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput i_qr
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput der_i_qs
    annotation (Placement(transformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput omega_r
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput i_dr
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput i_ds
    annotation (Placement(transformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput der_i_qr
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
equation
  der_i_qr = (((v_qr)/Lr)-((Rr*i_qr)/Lr)-((der_i_qs*Lm)/Lr)-(omega_r*i_dr)-((omega_r*Lm*i_ds)/Lr));
annotation (preferredView="info", Documentation(info="<html>
<p>
This block computes q-axis rotor current for the models in 
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors\">Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors</a>.
</p>
</html>"));
end RotorCurrent_q;
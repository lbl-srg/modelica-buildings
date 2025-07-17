within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses;
model TorqueBlock "Calculate Electromagnetic torque using stator and rotor current"
  extends Modelica.Blocks.Icons.Block;
  parameter Integer P=4 "Number of pole";
  parameter Real Lm( start=0.5, fixed=true) "Mutual Inductance";
  parameter Real J( start=0.0131, fixed=true) "Moment of Inertia";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput i_qs "Q-axis stator current"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput i_ds "D-axis stator current"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput i_qr "Q-axis rotor current"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput i_dr "D-axis rotor current"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput tau_e "Electromagnetic torque"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
equation
  tau_e = ((i_qs*i_dr)-(i_ds*i_qr))*(3/2)*(P/(2))*Lm;
  annotation (preferredView="info", Documentation(info="<html>
<p>
This block computes the electrical torque for the models in 
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
end TorqueBlock;

within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses;
model TorqueBlock "Calculate Electromagnetic torque using stator and rotor current"
  extends Modelica.Blocks.Icons.Block;
  parameter Integer P=4 "Number of pole pairs";
  parameter Real Lm( start=0.5, fixed=true);
  parameter Real J( start=0.0131, fixed=true);
  Buildings.Controls.OBC.CDL.Interfaces.RealInput i_qs
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput i_ds
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput i_qr
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput i_dr
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput tau_e
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
equation
  tau_e = ((i_qs*i_dr)-(i_ds*i_qr))*(3/2)*(P/(2))*Lm;
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end TorqueBlock;

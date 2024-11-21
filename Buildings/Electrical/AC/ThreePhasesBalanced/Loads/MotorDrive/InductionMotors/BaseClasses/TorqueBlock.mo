within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses;
model TorqueBlock
  extends Modelica.Blocks.Icons.Block;
  parameter Integer P=4 "Number of pole pairs";
  parameter Real Lm( start=0.5, fixed=true);
  parameter Real J( start=0.0131, fixed=true);
  Modelica.Blocks.Interfaces.RealInput i_qs
    annotation (Placement(transformation(extent={{-138,52},{-100,90}}),
        iconTransformation(extent={{-138,52},{-100,90}})));
  Modelica.Blocks.Interfaces.RealInput i_ds
    annotation (Placement(transformation(extent={{-138,10},{-100,48}}),
        iconTransformation(extent={{-138,10},{-100,48}})));
  Modelica.Blocks.Interfaces.RealInput i_qr
    annotation (Placement(transformation(extent={{-138,-50},{-100,-12}}),
        iconTransformation(extent={{-138,-50},{-100,-12}})));
  Modelica.Blocks.Interfaces.RealInput i_dr
    annotation (Placement(transformation(extent={{-138,-90},{-100,-52}}),
        iconTransformation(extent={{-138,-90},{-100,-52}})));
  Modelica.Blocks.Interfaces.RealOutput tau_e annotation (Placement(
        transformation(extent={{100,-20},{140,20}}),iconTransformation(extent={{100,-20},
            {140,20}})));
equation
  tau_e = ((i_qs*i_dr)-(i_ds*i_qr))*(3/2)*(P/(2))*Lm;
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end TorqueBlock;

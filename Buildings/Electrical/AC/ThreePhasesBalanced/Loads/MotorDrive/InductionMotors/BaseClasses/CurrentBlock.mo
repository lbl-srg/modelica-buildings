within Buildings.Electrical.AC.ThreePhasesBalanced.Loads.MotorDrive.InductionMotors.BaseClasses;
model CurrentBlock
  extends Modelica.Blocks.Icons.Block;
  Modelica.Blocks.Interfaces.RealInput i_ds
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput i_qs
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealInput wt
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealOutput I_a
    annotation (Placement(transformation(extent={{100,60},{140,100}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Modelica.Blocks.Interfaces.RealOutput I_b
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Modelica.Blocks.Interfaces.RealOutput I_c
    annotation (Placement(transformation(extent={{100,-100},{140,-60}}),
        iconTransformation(extent={{100,-100},{140,-60}})));
equation
  I_a = sin(wt)*i_ds+cos(wt)*i_qs;
  I_b = sin(wt-2.0933)*i_ds+cos(wt-2.0933)*i_qs;
  I_c = sin(wt+2.0933)*i_ds+cos(wt+2.0933)*i_qs;
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end CurrentBlock;

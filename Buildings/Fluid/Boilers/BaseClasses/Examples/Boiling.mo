within Buildings.Fluid.Boilers.BaseClasses.Examples;
model Boiling "Test model for water boiling process"
  extends Modelica.Icons.Example;

  package MediumSte = IBPSA.Media.Steam "Steam medium";
  package MediumWat = IBPSA.Media.Water "Water medium";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 1
    "Nominal mass flow rate";

  Modelica.Blocks.Sources.Constant pOutSet(k=1000000)
    "Steam outlet pressure setpoint"
    annotation (Placement(transformation(extent={{-90,60},{-70,80}})));
  Modelica.Blocks.Sources.Constant m_flow(k=m_flow_nominal)
                                               "Mass flow rate"
    annotation (Placement(transformation(extent={{-90,26},{-70,46}})));
  Sources.MassFlowSource_T watSou(
    redeclare package Medium = MediumWat,
    use_m_flow_in=true,
    nPorts=1) "Water source"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Sources.Boundary_pT steSin(redeclare package Medium = MediumSte,
    nPorts=1) "Steam sink"
    annotation (Placement(transformation(extent={{80,0},{60,20}})));
  Buildings.Fluid.Boilers.BaseClasses.Boiling boi "Boiling process"
    annotation (Placement(transformation(extent={{10,0},{30,20}})));
equation
  connect(boi.pOut, pOutSet.y)
    annotation (Line(points={{8,16},{0,16},{0,70},{-69,70}}, color={0,0,127}));
  connect(watSou.m_flow_in, m_flow.y) annotation (Line(points={{-42,18},{-60,18},
          {-60,36},{-69,36}}, color={0,0,127}));
  connect(watSou.ports[1], boi.port_a)
    annotation (Line(points={{-20,10},{10,10}}, color={0,127,255}));
  connect(boi.port_b, steSin.ports[1])
    annotation (Line(points={{30,10},{60,10}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Boiling;

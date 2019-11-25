within Buildings.Applications.DHC.Loads.Validation;
model UnitTestSecondaryFlow
  extends Modelica.Icons.Example;
  package Medium1 = Buildings.Media.Water "Fluid in the pipes";
  package Medium2 = Buildings.Media.Air "Moist air";
  Fluid.Sources.Boundary_pT sin1(
    redeclare package Medium = Medium1,
    p=300000,
    T=heaCoo.T1_b_nominal,
    nPorts=1) "Sink for heating water"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={90,-40})));
  Fluid.Sources.MassFlowSource_T sup1(
    redeclare package Medium = Medium1,
    m_flow=heaCoo.m_flow1_nominal,
    T=heaCoo.T1_a_nominal,
    nPorts=1) "Supply for heating water"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,-40})));
  BaseClasses.SecondaryFlow           heaCoo(
    m_flow1_nominal=0.1,
    T1_a_nominal=313.15,
    T1_b_nominal=308.15) annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine ySou(
    amplitude=0.5,
    freqHz=0.001,
    offset=0.5) annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
equation
  connect(sup1.ports[1], heaCoo.port_a)
    annotation (Line(points={{-80,-40},{-40,-40},{-40,0},{-10,0}}, color={0,127,255}));
  connect(heaCoo.port_b, sin1.ports[1]) annotation (Line(points={{10,0},{40,0},{40,-40},{80,-40}}, color={0,127,255}));
  connect(ySou.y, heaCoo.Q_flow1Act_i[1])
    annotation (Line(points={{-38,70},{-26,70},{-26,-8},{-12,-8}}, color={0,0,127}));
  connect(heaCoo.port_a1, heaCoo.port_b1)
    annotation (Line(points={{10,4},{16,4},{16,20},{-18,20},{-18,4},{-10,4}}, color={0,127,255}));
  connect(ySou.y, heaCoo.m_flow1Req_i[1])
    annotation (Line(points={{-38,70},{-26,70},{-26,8},{-12,8}}, color={0,0,127}));
  annotation (
  experiment(
    StopTime=10000),
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end UnitTestSecondaryFlow;

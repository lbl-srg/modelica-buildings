within Buildings.Applications.DHC.Loads.BaseClasses;
model Test
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water "Fluid in the pipes";
  Fluid.Sources.Boundary_pT sinHea(
    redeclare package Medium = Medium,
    nPorts=2,
    p=300000,
    T=heaCou.T1_b_nominal)
                          "Sink for heating water"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={82,10})));
  Fluid.Sources.MassFlowSource_T           supHea(
    redeclare package Medium = Medium,
    m_flow=heaCou.m_flow1_nominal,
    T=heaCou.T1_a_nominal,
    nPorts=1)
    "Supply for heating water"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,10})));
  HeatingOrCooling heaCou(
    redeclare package Medium = Medium,
    T1_a_nominal=280.15,
    T1_b_nominal=285.15,
    Q_flow_nominal={1000},
    T2_nominal={293.15},
    dp_nominal=0,
    nLoa=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
  HeatTransfer.Sources.PrescribedTemperature prescribedTemperature
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=heaCou.T2_nominal[1])
    annotation (Placement(transformation(extent={{-128,40},{-108,60}})));
  Modelica.Blocks.Sources.RealExpression realExpression2(y=0)
    annotation (Placement(transformation(extent={{-48,-18},{-28,2}})));
  Controls.OBC.CDL.Continuous.Sources.Ramp ram(
    height=1000,
    duration=1000,
    startTime=500) annotation (Placement(transformation(extent={{-48,20},{-28,40}})));
  Fluid.Sources.MassFlowSource_T           supHea1(
    redeclare package Medium = Medium,
    m_flow=heaCou.m_flow1_nominal,
    T=heaCou.T1_a_nominal,
    nPorts=1)
    "Supply for heating water"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,-40})));
equation
  connect(supHea.ports[1], heaCou.port_a) annotation (Line(points={{-80,10},{-10,10}},
                                                                                     color={0,127,255}));
  connect(heaCou.port_b, sinHea.ports[1]) annotation (Line(points={{10,10},{42,10},{42,12},{72,12}},
                                                                                   color={0,127,255}));
  connect(prescribedTemperature.port, heaCou.heaPorLoa[1])
    annotation (Line(points={{-60,50},{0,50},{0,20}}, color={191,0,0}));
  connect(realExpression.y, prescribedTemperature.T) annotation (Line(points={{-107,50},{-82,50}}, color={0,0,127}));
  connect(heaCou.m_flow2[1], realExpression2.y)
    annotation (Line(points={{-12,2},{-20,2},{-20,-8},{-27,-8}},   color={0,0,127}));
  connect(ram.y, heaCou.Q_flowReq[1]) annotation (Line(points={{-27,30},{-18,30},{-18,18},{-12,18}}, color={0,0,127}));
  connect(supHea1.ports[1], heaCouOld.port_a) annotation (Line(points={{-80,-40},{-10,-40}}, color={0,127,255}));
  connect(heaCouOld.port_b, sinHea.ports[2])
    annotation (Line(points={{10,-40},{40,-40},{40,8},{72,8}}, color={0,127,255}));
  connect(ram.y, heaCouOld.Q_flowLoaReq[1])
    annotation (Line(points={{-27,30},{-20,30},{-20,-32},{-12,-32}}, color={0,0,127}));
  connect(prescribedTemperature.port, heaCouOld.heaPorLoa[1])
    annotation (Line(points={{-60,50},{0,50},{0,-30}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)));
end Test;

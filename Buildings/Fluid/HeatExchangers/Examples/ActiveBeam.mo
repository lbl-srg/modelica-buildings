within Buildings.Fluid.HeatExchangers.Examples;
model ActiveBeam
  extends Modelica.Icons.Example;

  Buildings.Fluid.HeatExchangers.ActiveBeams.ActiveBeam activeBeam(
    m1_flow_nominal=0.1,
    m2_flow_nominal=0.1,
    temp_diff_nominal=10,
    m_airflow_nominal=0.08,
    m_waterflow_nominal=0.094,
    P_flow_nominal=1092,
    redeclare package Medium1 = Buildings.Media.Water,
    redeclare package Medium2 = Buildings.Media.Air)
    annotation (Placement(transformation(extent={{-30,34},{-10,54}})));
  Buildings.Fluid.Sources.FixedBoundary bou(redeclare package Medium =
        Buildings.Media.Air, nPorts=1)
    annotation (Placement(transformation(extent={{-92,10},{-72,30}})));
  Buildings.Fluid.Sources.FixedBoundary bou1(redeclare package Medium =
        Buildings.Media.Water, nPorts=1)
    annotation (Placement(transformation(extent={{78,72},{58,90}})));
  Buildings.Fluid.Sources.MassFlowSource_T boundary(
    redeclare package Medium = Buildings.Media.Air,
    m_flow=0.08,
    nPorts=1,
    T=293.15) annotation (Placement(transformation(extent={{80,14},{60,34}})));
  Buildings.Fluid.Sources.MassFlowSource_T boundary1(
    redeclare package Medium = Buildings.Media.Water,
    m_flow=0.094,
    nPorts=1,
    T=287.15) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-82,78})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=
        273.15 + 24)
    annotation (Placement(transformation(extent={{-56,-36},{-44,-24}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(redeclare package Medium =
        Buildings.Media.Water, m_flow_nominal=0.1)
    annotation (Placement(transformation(extent={{20,74},{34,88}})));
equation
  connect(senTem.port_b, bou1.ports[1]) annotation (Line(points={{34,81},{46,81},
          {58,81}},                         color={0,127,255}));
  connect(fixedTemperature.port, activeBeam.port_b3) annotation (Line(points={{-44,-30},
          {-20.6667,-30},{-20.6667,34.2}},          color={191,0,0}));
  connect(boundary1.ports[1], activeBeam.port_a1) annotation (Line(points={{-72,78},
          {-54,78},{-54,50},{-28.3333,50}},     color={0,127,255}));
  connect(boundary.ports[1], activeBeam.port_a2) annotation (Line(points={{60,24},
          {60,24},{0,24},{0,38},{-11.6667,38}},     color={0,127,255}));
  connect(activeBeam.port_b1, senTem.port_a) annotation (Line(points={{-11.6667,
          50},{0,50},{0,81},{20,81}}, color={0,127,255}));
  connect(activeBeam.port_b2, bou.ports[1]) annotation (Line(points={{-28.3333,
          38},{-54,38},{-54,20},{-72,20}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})));
end ActiveBeam;

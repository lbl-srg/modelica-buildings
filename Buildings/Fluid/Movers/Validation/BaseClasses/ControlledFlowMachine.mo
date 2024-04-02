within Buildings.Fluid.Movers.Validation.BaseClasses;
model ControlledFlowMachine

  package Medium = Buildings.Media.Air "Medium model";

  Modelica.Blocks.Sources.Pulse y(
    startTime=0,
    offset=0,
    amplitude=1,
    period=120,
    width=50)    annotation (Placement(transformation(extent={{-140,70},{-120,90}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    use_p_in=false,
    p=101325,
    T=293.15,
    nPorts=3) annotation (Placement(transformation(extent={{-90,20},{-70,40}})));

  Buildings.Fluid.Sensors.MassFlowRate masFloRat1(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  Buildings.Fluid.Sensors.RelativePressure relPre(redeclare package Medium =
        Medium) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        origin={-10,32})));
  replaceable
  Buildings.Fluid.Movers.SpeedControlled_y fan1(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos32slash1to12 per)
    constrainedby Buildings.Fluid.Movers.SpeedControlled_y
    "Fan with normalized control input between 0 and 1"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  Buildings.Fluid.FixedResistances.PressureDrop dp1(
    redeclare package Medium = Medium,
    from_dp=true,
    m_flow_nominal=0.006,
    dp_nominal=50000) "Pressure drop"
    annotation (Placement(transformation(extent={{16,50},{36,70}})));
  Buildings.Fluid.FixedResistances.PressureDrop dp2(
    redeclare package Medium = Medium,
    from_dp=true,
    m_flow_nominal=0.006,
    dp_nominal=50000) "Pressure drop"
    annotation (Placement(transformation(extent={{16,-30},{36,-10}})));
  Buildings.Fluid.Sensors.MassFlowRate masFloRat2(
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  Buildings.Fluid.FixedResistances.PressureDrop dp3(
    redeclare package Medium = Medium,
    from_dp=true,
    m_flow_nominal=0.006,
    dp_nominal=50000) "Pressure drop"
    annotation (Placement(transformation(extent={{16,-70},{36,-50}})));
  Buildings.Fluid.Sensors.MassFlowRate masFloRat3(
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  replaceable
  Buildings.Fluid.Movers.FlowControlled_dp fan3(
    redeclare package Medium = Medium,
    m_flow_nominal=6000/3600*1.2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos32slash1to12 per)
    constrainedby Buildings.Fluid.Movers.FlowControlled_dp
    "Fan with head as input"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
  replaceable
  Buildings.Fluid.Movers.FlowControlled_m_flow fan2(
    redeclare package Medium = Medium,
    m_flow_nominal=6000/3600*1.2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    redeclare Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos32slash1to12 per)
    constrainedby Buildings.Fluid.Movers.FlowControlled_m_flow
    "Fan with mass flow rate as input"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  Buildings.Fluid.FixedResistances.PressureDrop dp5(
    m_flow_nominal=6000/3600*1.2,
    redeclare package Medium = Medium,
    dp_nominal=300,
    from_dp=true) "Pressure drop"
    annotation (Placement(transformation(extent={{-52,50},{-32,70}})));
  Buildings.Fluid.FixedResistances.PressureDrop dp6(
    m_flow_nominal=6000/3600*1.2,
    redeclare package Medium = Medium,
    dp_nominal=300,
    from_dp=true) "Pressure drop"
    annotation (Placement(transformation(extent={{-52,-30},{-32,-10}})));
  Buildings.Fluid.FixedResistances.PressureDrop dp7(
    m_flow_nominal=6000/3600*1.2,
    redeclare package Medium = Medium,
    dp_nominal=300,
    from_dp=true) "Pressure drop"
    annotation (Placement(transformation(extent={{-52,-70},{-32,-50}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    use_p_in=false,
    p=101325,
    T=293.15,
    nPorts=3) annotation (Placement(transformation(extent={{142,20},{122,40}})));
equation

  connect(fan1.port_a, relPre.port_b) annotation (Line(
      points={{-20,60},{-20,32}},
      color={0,127,255}));
  connect(fan1.port_b, relPre.port_a) annotation (Line(
      points={{5.55112e-16,60},{5.55112e-16,46},{0,32},{5.55112e-16,32}},
      color={0,127,255}));
  connect(fan1.port_b, dp1.port_a) annotation (Line(
      points={{5.55112e-16,60},{16,60}},
      color={0,127,255}));
  connect(fan2.port_b, dp2.port_a) annotation (Line(
      points={{5.55112e-16,-20},{16,-20}},
      color={0,127,255}));
  connect(fan3.port_b, dp3.port_a) annotation (Line(
      points={{5.55112e-16,-60},{16,-60}},
      color={0,127,255}));
  connect(masFloRat1.m_flow, fan2.m_flow_in) annotation (Line(
      points={{70,71},{70,86},{42,86},{42,4},{-10,4},{-10,-8}},
      color={0,0,127}));
  connect(relPre.p_rel, fan3.dp_in) annotation (Line(
      points={{-10,23},{-10,8},{-24,8},{-24,-40},{-10,-40},{-10,-48}},
      color={0,0,127}));
  connect(dp5.port_b, fan1.port_a) annotation (Line(
      points={{-32,60},{-20,60}},
      color={0,127,255}));
  connect(dp6.port_b, fan2.port_a) annotation (Line(
      points={{-32,-20},{-20,-20}},
      color={0,127,255}));
  connect(dp7.port_b, fan3.port_a) annotation (Line(
      points={{-32,-60},{-20,-60}},
      color={0,127,255}));
  connect(y.y, fan1.y) annotation (Line(
      points={{-119,80},{-10,80},{-10,72}},
      color={0,0,127}));
  connect(dp5.port_a, sou.ports[1]) annotation (Line(
      points={{-52,60},{-60,60},{-60,28.6667},{-70,28.6667}},
      color={0,127,255}));
  connect(dp6.port_a, sou.ports[2]) annotation (Line(
      points={{-52,-20},{-60,-20},{-60,30},{-70,30}},
      color={0,127,255}));
  connect(dp7.port_a, sou.ports[3]) annotation (Line(
      points={{-52,-60},{-62,-60},{-62,31.3333},{-70,31.3333}},
      color={0,127,255}));
  connect(dp1.port_b, masFloRat1.port_a) annotation (Line(
      points={{36,60},{60,60}},
      color={0,127,255}));
  connect(dp2.port_b, masFloRat2.port_a) annotation (Line(
      points={{36,-20},{60,-20}},
      color={0,127,255}));
  connect(dp3.port_b, masFloRat3.port_a) annotation (Line(
      points={{36,-60},{60,-60}},
      color={0,127,255}));
  connect(masFloRat1.port_b, sin.ports[1]) annotation (Line(
      points={{80,60},{100,60},{100,28.6667},{122,28.6667}},
      color={0,127,255}));
  connect(masFloRat2.port_b, sin.ports[2]) annotation (Line(
      points={{80,-20},{100,-20},{100,30},{122,30}},
      color={0,127,255}));
  connect(masFloRat3.port_b, sin.ports[3]) annotation (Line(
      points={{80,-60},{102,-60},{102,31.3333},{122,31.3333}},
      color={0,127,255}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-160,-100},{160,
            160}})),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-160,-100},{160,160}})),
    Documentation(info="<html>
This example demonstrates the use of the flow model with four different configuration.
At steady-state, all flow models have the same mass flow rate and pressure difference.
</html>", revisions="<html>
<ul>
<li>
March 21, 2023, by Hongxiang Fu:<br/>
Deleted the mover with <code>Nrpm</code> signal.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1704\">IBPSA, #1704</a>.
</li>
</ul>
</html>"));
end ControlledFlowMachine;

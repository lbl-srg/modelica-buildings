within Buildings.Fluid.Movers.Examples.BaseClasses;
model ControlledFlowMachine

  package Medium = Buildings.Media.IdealGases.SimpleAir;

  Modelica.Blocks.Sources.Pulse y(
    startTime=0,
    offset=0,
    amplitude=1,
    period=120,
    width=50)    annotation (Placement(transformation(extent={{-140,70},{-120,90}},
          rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    use_p_in=false,
    p=system.p_ambient,
    T=293.15,
    nPorts=4) annotation (Placement(transformation(extent={{-118,20},{-98,40}},
          rotation=0)));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{120,-80},{140,-60}})));
  Buildings.Fluid.Sensors.MassFlowRate masFloRat1(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  Buildings.Fluid.Sensors.RelativePressure relPre(redeclare package Medium =
        Medium) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-10,32})));
  Buildings.Fluid.Movers.FlowMachine_y fan1(
    redeclare package Medium = Medium,
    pressure(final V_flow={0,1.8,3}, dp={1000,600,0}),
    dynamicBalance=false)
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  FixedResistances.FixedResistanceDpM dp1(
    m_flow_nominal=6000/3600*1.2,
    redeclare package Medium = Medium,
    dp_nominal=300) "Pressure drop"
    annotation (Placement(transformation(extent={{16,50},{36,70}})));
  FixedResistances.FixedResistanceDpM dp2(
    m_flow_nominal=6000/3600*1.2,
    redeclare package Medium = Medium,
    dp_nominal=300) "Pressure drop"
    annotation (Placement(transformation(extent={{16,-30},{36,-10}})));
  Buildings.Fluid.Sensors.MassFlowRate masFloRat2(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  FixedResistances.FixedResistanceDpM dp3(
    m_flow_nominal=6000/3600*1.2,
    redeclare package Medium = Medium,
    dp_nominal=300) "Pressure drop"
    annotation (Placement(transformation(extent={{16,-90},{36,-70}})));
  Buildings.Fluid.Sensors.MassFlowRate masFloRat3(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{60,-90},{80,-70}})));
  Buildings.Fluid.Movers.FlowMachine_dp fan3(
    redeclare package Medium = Medium,
    m_flow_nominal=6000/3600*1.2,
    dynamicBalance=false)
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));
  Buildings.Fluid.Movers.FlowMachine_m_flow fan2(
    redeclare package Medium = Medium,
    m_flow_nominal=6000/3600*1.2,
    dynamicBalance=false)
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  FixedResistances.FixedResistanceDpM dp4(
    m_flow_nominal=6000/3600*1.2,
    redeclare package Medium = Medium,
    dp_nominal=300) "Pressure drop"
    annotation (Placement(transformation(extent={{16,100},{36,120}})));
  Buildings.Fluid.Sensors.MassFlowRate masFloRat4(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{60,100},{80,120}})));
  Buildings.Fluid.Movers.FlowMachine_Nrpm fan4(
    redeclare package Medium = Medium,
    pressure(final V_flow={0,1.8,3}, dp={1000,600,0}),
    dynamicBalance=false)
    annotation (Placement(transformation(extent={{-20,100},{0,120}})));
  Modelica.Blocks.Math.Gain gain(k=1500) "Converts y to nominal rpm"
    annotation (Placement(transformation(extent={{-60,130},{-40,150}})));
  FixedResistances.FixedResistanceDpM dp5(
    m_flow_nominal=6000/3600*1.2,
    redeclare package Medium = Medium,
    dp_nominal=300) "Pressure drop"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  FixedResistances.FixedResistanceDpM dp6(
    m_flow_nominal=6000/3600*1.2,
    redeclare package Medium = Medium,
    dp_nominal=300) "Pressure drop"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  FixedResistances.FixedResistanceDpM dp7(
    m_flow_nominal=6000/3600*1.2,
    redeclare package Medium = Medium,
    dp_nominal=300) "Pressure drop"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  FixedResistances.FixedResistanceDpM dp8(
    m_flow_nominal=6000/3600*1.2,
    redeclare package Medium = Medium,
    dp_nominal=300) "Pressure drop"
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    use_p_in=false,
    p=system.p_ambient,
    T=293.15,
    nPorts=4) annotation (Placement(transformation(extent={{142,20},{122,40}},
          rotation=0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(
    uMax=1E100,
    uMin=0,
    strict=true)
    "Limiter to avoid input signal to be slightly below 0 due to numerical error"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
equation

  connect(fan1.port_a, relPre.port_b) annotation (Line(
      points={{-20,60},{-20,32}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fan1.port_b, relPre.port_a) annotation (Line(
      points={{5.55112e-16,60},{5.55112e-16,46},{0,32},{5.55112e-16,32}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fan1.port_b, dp1.port_a) annotation (Line(
      points={{5.55112e-16,60},{16,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fan2.port_b, dp2.port_a) annotation (Line(
      points={{5.55112e-16,-20},{16,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fan3.port_b, dp3.port_a) annotation (Line(
      points={{0,-80},{16,-80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fan4.port_b, dp4.port_a) annotation (Line(
      points={{5.55112e-16,110},{16,110}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(gain.y, fan4.Nrpm) annotation (Line(
      points={{-39,140},{-10,140},{-10,122}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(masFloRat1.m_flow, fan2.m_flow_in) annotation (Line(
      points={{70,71},{70,86},{42,86},{42,4},{-10.2,4},{-10.2,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dp8.port_b, fan4.port_a) annotation (Line(
      points={{-60,110},{-20,110}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dp5.port_b, fan1.port_a) annotation (Line(
      points={{-60,60},{-20,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dp6.port_b, fan2.port_a) annotation (Line(
      points={{-60,-20},{-20,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dp7.port_b, fan3.port_a) annotation (Line(
      points={{-60,-80},{-20,-80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(y.y, fan1.y) annotation (Line(
      points={{-119,80},{-10,80},{-10,72}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(y.y, gain.u) annotation (Line(
      points={{-119,80},{-100,80},{-100,140},{-62,140}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dp8.port_a, sou.ports[1]) annotation (Line(
      points={{-80,110},{-90,110},{-90,33},{-98,33}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dp5.port_a, sou.ports[2]) annotation (Line(
      points={{-80,60},{-88,60},{-88,31},{-98,31}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dp6.port_a, sou.ports[3]) annotation (Line(
      points={{-80,-20},{-88,-20},{-88,29},{-98,29}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dp7.port_a, sou.ports[4]) annotation (Line(
      points={{-80,-80},{-90,-80},{-90,27},{-98,27}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dp4.port_b, masFloRat4.port_a) annotation (Line(
      points={{36,110},{60,110}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dp1.port_b, masFloRat1.port_a) annotation (Line(
      points={{36,60},{60,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dp2.port_b, masFloRat2.port_a) annotation (Line(
      points={{36,-20},{60,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dp3.port_b, masFloRat3.port_a) annotation (Line(
      points={{36,-80},{60,-80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(masFloRat4.port_b, sin.ports[1]) annotation (Line(
      points={{80,110},{102,110},{102,33},{122,33}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(masFloRat1.port_b, sin.ports[2]) annotation (Line(
      points={{80,60},{100,60},{100,31},{122,31}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(masFloRat2.port_b, sin.ports[3]) annotation (Line(
      points={{80,-20},{100,-20},{100,29},{122,29}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(masFloRat3.port_b, sin.ports[4]) annotation (Line(
      points={{80,-80},{102,-80},{102,27},{122,27}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(relPre.p_rel, limiter.u) annotation (Line(
      points={{-10,23},{-10,10},{-50,10},{-50,-50},{-42,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(limiter.y, fan3.dp_in) annotation (Line(
      points={{-19,-50},{-10.2,-50},{-10.2,-68}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-160,-100},{160,
            160}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-160,-100},{160,160}})),
    Documentation(info="<html>
This example demonstrates the use of the flow model with four different configuration.
At steady-state, all flow models have the same mass flow rate and pressure difference.
</html>",
revisions="<html>
<ul>
<li>
October 1, 2014, by Michael Wetter:<br/>
Added limiter to avoid that the control signal is slighty below
zero due to numerical error. Without this limiter, OpenModelica stops
when running <code>Examples.FlowMachine_dp</code> with
an assert because <code>floMacDyn.dp_in</code> is <i>-1.7E-7</i> which
is below the minimum value for this variable.
</li>
<li>
March 24 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ControlledFlowMachine;

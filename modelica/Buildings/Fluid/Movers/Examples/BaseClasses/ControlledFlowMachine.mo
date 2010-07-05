within Buildings.Fluid.Movers.Examples.BaseClasses;
model ControlledFlowMachine
  import Buildings;

  package Medium = Buildings.Media.IdealGases.SimpleAir;

  Modelica.Blocks.Sources.Trapezoid y(
    rising=0.1,
    width=0.1,
    falling=0.1,
    period=0.5,
    startTime=0,
    offset=0,
    amplitude=1) annotation (Placement(transformation(extent={{-140,70},{-120,90}},
          rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    use_p_in=false,
    p=system.p_ambient,
    T=293.15,
    nPorts=4) annotation (Placement(transformation(extent={{-90,20},{-70,40}},
          rotation=0)));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{120,-80},{140,-60}})));
  Buildings.Fluid.Sensors.MassFlowRate masFloRat1(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-50,50},{-30,70}})));
  Buildings.Fluid.Sensors.RelativePressure relPre(redeclare package Medium =
        Medium) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={34,32})));
  Buildings.Fluid.Movers.FlowMachine_y fan1(
    redeclare package Medium = Medium,
    redeclare function flowCharacteristic =
        Buildings.Fluid.Movers.BaseClasses.Characteristics.quadraticFlow (
          V_flow_nominal={0,1.8,3}, dp_nominal={1000,600,0}),
    m_flow_nominal=6000/3600*1.2,
    dynamicBalance=false)
    annotation (Placement(transformation(extent={{24,50},{44,70}})));
  FixedResistances.FixedResistanceDpM dp1(
    m_flow_nominal=6000/3600*1.2,
    redeclare package Medium = Medium,
    dp_nominal=300) "Pressure drop"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  FixedResistances.FixedResistanceDpM dp2(
    m_flow_nominal=6000/3600*1.2,
    redeclare package Medium = Medium,
    dp_nominal=300) "Pressure drop"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  Buildings.Fluid.Sensors.MassFlowRate masFloRat2(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-46,-30},{-26,-10}})));
  FixedResistances.FixedResistanceDpM dp3(
    m_flow_nominal=6000/3600*1.2,
    redeclare package Medium = Medium,
    dp_nominal=300) "Pressure drop"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Buildings.Fluid.Sensors.MassFlowRate masFloRat3(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-46,-70},{-26,-50}})));
  Buildings.Fluid.Movers.FlowMachine_dp fan3(
    redeclare package Medium = Medium,
    m_flow_nominal=6000/3600*1.2,
    dynamicBalance=false)
    annotation (Placement(transformation(extent={{24,-70},{44,-50}})));
  Buildings.Fluid.Movers.FlowMachine_m_flow fan2(
    redeclare package Medium = Medium,
    m_flow_nominal=6000/3600*1.2,
    dynamicBalance=false)
    annotation (Placement(transformation(extent={{24,-30},{44,-10}})));
  FixedResistances.FixedResistanceDpM dp4(
    m_flow_nominal=6000/3600*1.2,
    redeclare package Medium = Medium,
    dp_nominal=300) "Pressure drop"
    annotation (Placement(transformation(extent={{60,100},{80,120}})));
  Buildings.Fluid.Sensors.MassFlowRate masFloRat4(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-40,100},{-20,120}})));
  Buildings.Fluid.Movers.FlowMachine_Nrpm fan4(
    redeclare package Medium = Medium,
    redeclare function flowCharacteristic =
        Buildings.Fluid.Movers.BaseClasses.Characteristics.quadraticFlow (
          V_flow_nominal={0,1.8,3}, dp_nominal={1000,600,0}),
    m_flow_nominal=6000/3600*1.2,
    dynamicBalance=false)
    annotation (Placement(transformation(extent={{24,100},{44,120}})));
  Modelica.Blocks.Math.Gain gain(k=1500) "Converts y to nominal rpm"
    annotation (Placement(transformation(extent={{-60,130},{-40,150}})));
  FixedResistances.FixedResistanceDpM dp5(
    m_flow_nominal=6000/3600*1.2,
    redeclare package Medium = Medium,
    dp_nominal=300) "Pressure drop"
    annotation (Placement(transformation(extent={{-8,50},{12,70}})));
  FixedResistances.FixedResistanceDpM dp6(
    m_flow_nominal=6000/3600*1.2,
    redeclare package Medium = Medium,
    dp_nominal=300) "Pressure drop"
    annotation (Placement(transformation(extent={{-8,-30},{12,-10}})));
  FixedResistances.FixedResistanceDpM dp7(
    m_flow_nominal=6000/3600*1.2,
    redeclare package Medium = Medium,
    dp_nominal=300) "Pressure drop"
    annotation (Placement(transformation(extent={{-8,-70},{12,-50}})));
  FixedResistances.FixedResistanceDpM dp8(
    m_flow_nominal=6000/3600*1.2,
    redeclare package Medium = Medium,
    dp_nominal=300) "Pressure drop"
    annotation (Placement(transformation(extent={{-8,100},{12,120}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    use_p_in=false,
    p=system.p_ambient,
    T=293.15,
    nPorts=4) annotation (Placement(transformation(extent={{112,20},{92,40}},
          rotation=0)));
equation

  connect(fan1.port_a, relPre.port_b) annotation (Line(
      points={{24,60},{24,32}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fan1.port_b, relPre.port_a) annotation (Line(
      points={{44,60},{44,32}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fan1.port_b, dp1.port_a) annotation (Line(
      points={{44,60},{60,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fan2.port_b, dp2.port_a) annotation (Line(
      points={{44,-20},{60,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fan3.port_b, dp3.port_a) annotation (Line(
      points={{44,-60},{60,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fan4.port_b, dp4.port_a) annotation (Line(
      points={{44,110},{60,110}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(gain.y, fan4.Nrpm) annotation (Line(
      points={{-39,140},{34,140},{34,120}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(masFloRat1.m_flow, fan2.m_flow_in) annotation (Line(
      points={{-40,71},{-40,86},{-20,86},{-20,4},{29,4},{29,-11.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(relPre.p_rel, fan3.dp_in) annotation (Line(
      points={{34,23},{34,8},{20,8},{20,-40},{39,-40},{39,-51.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou.ports[1], masFloRat4.port_a) annotation (Line(
      points={{-70,33},{-60,33},{-60,110},{-40,110}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou.ports[2], masFloRat1.port_a) annotation (Line(
      points={{-70,31},{-56,31},{-56,60},{-50,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou.ports[3], masFloRat2.port_a) annotation (Line(
      points={{-70,29},{-56,29},{-56,-20},{-46,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou.ports[4], masFloRat3.port_a) annotation (Line(
      points={{-70,27},{-66,27},{-66,26},{-60,26},{-60,-60},{-46,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dp4.port_b, sin.ports[1]) annotation (Line(
      points={{80,110},{88,110},{88,33},{92,33}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dp1.port_b, sin.ports[2]) annotation (Line(
      points={{80,60},{84,60},{84,31},{92,31}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dp2.port_b, sin.ports[3]) annotation (Line(
      points={{80,-20},{84,-20},{84,29},{92,29}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dp3.port_b, sin.ports[4]) annotation (Line(
      points={{80,-60},{88,-60},{88,26},{92,26},{92,27}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(masFloRat4.port_b, dp8.port_a) annotation (Line(
      points={{-20,110},{-8,110}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dp8.port_b, fan4.port_a) annotation (Line(
      points={{12,110},{24,110}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(masFloRat1.port_b, dp5.port_a) annotation (Line(
      points={{-30,60},{-20,60},{-20,60},{-8,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dp5.port_b, fan1.port_a) annotation (Line(
      points={{12,60},{24,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(masFloRat2.port_b, dp6.port_a) annotation (Line(
      points={{-26,-20},{-8,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dp6.port_b, fan2.port_a) annotation (Line(
      points={{12,-20},{24,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(masFloRat3.port_b, dp7.port_a) annotation (Line(
      points={{-26,-60},{-8,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dp7.port_b, fan3.port_a) annotation (Line(
      points={{12,-60},{18,-60},{18,-60},{24,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(y.y, fan1.y) annotation (Line(
      points={{-119,80},{34,80},{34,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(y.y, gain.u) annotation (Line(
      points={{-119,80},{-80,80},{-80,140},{-62,140}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-160,-100},{160,
            160}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-160,-100},{160,160}})),
    Documentation(info="<html>
This example demonstrates the use of the flow model with four different configuration.
At steady-state, all flow models have the same mass flow rate and pressure difference.
</html>"),    Diagram);
end ControlledFlowMachine;

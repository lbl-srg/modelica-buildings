within Buildings.Fluid.Movers.Validation;
model FlowControlled_dpSystem
  "Demonstration of the use of prescribedPressure"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air;
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=0.1
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dp_nominal=100
    "Nominal pressure difference";
  Modelica.Blocks.Sources.Ramp y(
    duration=0.5,
    startTime=0.25,
    height=-dp_nominal,
    offset=dp_nominal)
               "Input signal"
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));
  Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    nPorts=2)
    "Source"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Buildings.Fluid.Movers.FlowControlled_dp floConDp(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=false,
    nominalValuesDefineDefaultPressureCurve=true,
    m_flow_nominal=1,
    use_inputFilter=false) "Regular dp controlled fan"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Fluid.Movers.FlowControlled_dp floConDpSystem(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=false,
    nominalValuesDefineDefaultPressureCurve=true,
    m_flow_nominal=1,
    use_inputFilter=false,
    prescribeSystemPressure=true)
    "Dp controlled fan that sets pressure difference at remote point in the system"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Fluid.FixedResistances.PressureDrop heaCoi2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal/2) "Heating coil pressure drop"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Sensors.RelativePressure senRelPre(redeclare package Medium = Medium)
    "Pressure difference across air system"
    annotation (Placement(transformation(extent={{0,-30},{20,-50}})));

  Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    nPorts=4) "Sink"
    annotation (Placement(transformation(extent={{120,-10},{100,10}})));
  MixingVolumes.MixingVolume zone2(
    redeclare package Medium = Medium,
    V=50,
    m_flow_nominal=m_flow_nominal,
    nPorts=2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Mixing volume"
    annotation (Placement(transformation(extent={{80,40},{100,60}})));
  Buildings.Fluid.FixedResistances.PressureDrop heaCoi1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal/2) "Heating coil pressure drop"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Actuators.Dampers.Exponential dam2(
    redeclare package Medium = Medium,
    from_dp=true,
    use_inputFilter=false,
    dpDamper_nominal=10,
    m_flow_nominal=m_flow_nominal/2)
    "Damper"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
  MixingVolumes.MixingVolume zone1(
    redeclare package Medium = Medium,
    V=50,
    m_flow_nominal=m_flow_nominal,
    nPorts=2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Mixing volume"
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Actuators.Dampers.Exponential dam1(
    redeclare package Medium = Medium,
    from_dp=true,
    use_inputFilter=false,
    dpDamper_nominal=10,
    m_flow_nominal=m_flow_nominal/2)
             "Damper"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Actuators.Dampers.Exponential dam3(
    redeclare package Medium = Medium,
    from_dp=true,
    use_inputFilter=false,
    dpDamper_nominal=10,
    m_flow_nominal=m_flow_nominal/2)
             "Damper"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Actuators.Dampers.Exponential dam4(
    redeclare package Medium = Medium,
    from_dp=true,
    use_inputFilter=false,
    dpDamper_nominal=10,
    m_flow_nominal=m_flow_nominal/2)
             "Damper"
    annotation (Placement(transformation(extent={{40,-110},{60,-90}})));
  MixingVolumes.MixingVolume zone3(
    redeclare package Medium = Medium,
    V=50,
    m_flow_nominal=m_flow_nominal,
    nPorts=3,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Mixing volume"
    annotation (Placement(transformation(extent={{80,-60},{100,-40}})));
  MixingVolumes.MixingVolume zone4(
    redeclare package Medium = Medium,
    V=50,
    m_flow_nominal=m_flow_nominal,
    nPorts=2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Mixing volume"
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
  Modelica.Blocks.Sources.Ramp y1(
    duration=0.5,
    height=1,
    offset=0,
    startTime=0)
    "Input signal"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Buildings.Fluid.FixedResistances.PressureDrop duct3(
    redeclare package Medium = Medium,
    dp_nominal=dp_nominal/2,
    m_flow_nominal=m_flow_nominal/2) "Duct pressure drop"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  Buildings.Fluid.FixedResistances.PressureDrop duct4(
    redeclare package Medium = Medium,
    dp_nominal=dp_nominal/2,
    m_flow_nominal=m_flow_nominal/2) "Duct pressure drop"
    annotation (Placement(transformation(extent={{0,-110},{20,-90}})));
  Buildings.Fluid.FixedResistances.PressureDrop duct1(
    redeclare package Medium = Medium,
    dp_nominal=dp_nominal/2,
    m_flow_nominal=m_flow_nominal/2) "Duct pressure drop"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Buildings.Fluid.FixedResistances.PressureDrop duct2(
    redeclare package Medium = Medium,
    dp_nominal=dp_nominal/2,
    m_flow_nominal=m_flow_nominal/2) "Duct pressure drop"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
equation
  connect(y.y, floConDp.dp_in) annotation (Line(points={{-99,90},{-70,90},{-70,
          72}}, color={0,0,127}));
  connect(y.y, floConDpSystem.dp_in) annotation (Line(points={{-99,90},{-90,90},
          {-90,20},{-70,20},{-70,-68},{-70,-68}},
                                           color={0,0,127}));
  connect(zone2.ports[1], sin.ports[1])
    annotation (Line(points={{88,40},{100,40},{100,3}},    color={0,127,255}));
  connect(senRelPre.p_rel, floConDpSystem.dpMea) annotation (Line(points={{10,-31},
          {10,-12},{-78,-12},{-78,-68}}, color={0,0,127}));
  connect(floConDp.port_a, sou.ports[1])
    annotation (Line(points={{-80,60},{-100,60},{-100,2}}, color={0,127,255}));
  connect(floConDpSystem.port_a, sou.ports[2]) annotation (Line(points={{-80,-80},
          {-100,-80},{-100,-2}}, color={0,127,255}));
  connect(zone1.ports[1], sin.ports[2]) annotation (Line(points={{88,80},{88,80},
          {100,80},{100,1}},   color={0,127,255}));
  connect(heaCoi1.port_a, floConDp.port_b)
    annotation (Line(points={{-40,60},{-60,60}}, color={0,127,255}));
  connect(heaCoi2.port_a, floConDpSystem.port_b) annotation (Line(points={{-40,-80},
          {-40,-80},{-60,-80}}, color={0,127,255}));
  connect(dam2.port_b, zone1.ports[2])
    annotation (Line(points={{60,80},{92,80}},   color={0,127,255}));
  connect(dam1.port_b, zone2.ports[2])
    annotation (Line(points={{60,40},{92,40}},   color={0,127,255}));
  connect(zone3.ports[1], sin.ports[3]) annotation (Line(points={{87.3333,-60},
          {100,-60},{100,-1}},color={0,127,255}));
  connect(zone4.ports[1], sin.ports[4])
    annotation (Line(points={{88,-100},{100,-100},{100,-3}},
                                                           color={0,127,255}));
  connect(dam3.port_b, zone3.ports[2])
    annotation (Line(points={{60,-60},{90,-60}}, color={0,127,255}));
  connect(zone4.ports[2], dam4.port_b)
    annotation (Line(points={{92,-100},{60,-100}},        color={0,127,255}));
  connect(y1.y, dam2.y) annotation (Line(points={{-39,100},{50,100},{50,92}},
                     color={0,0,127}));
  connect(senRelPre.port_b, zone3.ports[3]) annotation (Line(points={{20,-40},{
          74,-40},{74,-60},{92.6667,-60}},
                                       color={0,127,255}));
  connect(senRelPre.port_a, heaCoi2.port_b)
    annotation (Line(points={{0,-40},{-20,-40},{-20,-80}},
                                                        color={0,127,255}));
  connect(duct3.port_b, dam3.port_a)
    annotation (Line(points={{20,-60},{40,-60}}, color={0,127,255}));
  connect(duct4.port_b, dam4.port_a) annotation (Line(points={{20,-100},{40,
          -100}},     color={0,127,255}));
  connect(duct2.port_a, heaCoi1.port_b)
    annotation (Line(points={{0,40},{-20,40},{-20,60}}, color={0,127,255}));
  connect(heaCoi1.port_b, duct1.port_a) annotation (Line(points={{-20,60},{-20,60},
          {-20,80},{0,80}}, color={0,127,255}));
  connect(duct1.port_b, dam2.port_a)
    annotation (Line(points={{20,80},{40,80}}, color={0,127,255}));
  connect(duct2.port_b, dam1.port_a)
    annotation (Line(points={{20,40},{40,40}}, color={0,127,255}));
  connect(duct3.port_a, heaCoi2.port_b)
    annotation (Line(points={{0,-60},{-20,-60},{-20,-80}}, color={0,127,255}));
  connect(duct4.port_a, heaCoi2.port_b) annotation (Line(points={{0,-100},{-20,-100},
          {-20,-80}}, color={0,127,255}));
  connect(y1.y, dam1.y) annotation (Line(points={{-39,100},{30,100},{30,60},{50,
          60},{50,52}}, color={0,0,127}));
  connect(y1.y, dam3.y) annotation (Line(points={{-39,100},{30,100},{30,-30},{
          50,-30},{50,-48}}, color={0,0,127}));
  connect(y1.y, dam4.y) annotation (Line(points={{-39,100},{30,100},{30,-80},{
          50,-80},{50,-88}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true,
        extent={{-120,-120},{120,120}})),
experiment(StopTime=1, Tolerance=1e-06),
__Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Movers/Validation/FlowControlled_dpSystem.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example demonstrates and tests the use of
<a href=\"modelica://Buildings.Fluid.Movers.Validation.FlowControlled_dp\">
Buildings.Fluid.Movers.Validation.FlowControlled_dp</a>
movers that use parameter
<code>prescribeSystemPressure</code>.
</p>
<p>
The mass flow rates and actual pressure heads of the two configurations are compared.
</p>
</html>", revisions="<html>
<ul>
<li>
April 9, 2024, by Hongxiang Fu:<br/>
Added nominal curve specification to suppress warning.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3819\">#3819</a>.
</li>
<li>
May 4 2017, by Filip Jorissen:<br/>
First implementation.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/770\">#770</a>.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end FlowControlled_dpSystem;

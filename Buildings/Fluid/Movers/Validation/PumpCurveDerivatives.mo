within Buildings.Fluid.Movers.Validation;
model PumpCurveDerivatives
  "Check for monotoneously increasing pump curve relations between Nrpm, dp and m_flow"
  extends Modelica.Icons.Example;
  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;

  parameter Data.Pumps.Wilo.Stratos80slash1to12 per "Pump performance data"
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));

  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    nPorts=2) "Boundary condition with fixed pressure"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));

  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium =Medium,
    nPorts=2) "Boundary condition with fixed pressure"
    annotation (Placement(transformation(extent={{130,-10},{110,10}})));

  Modelica.Blocks.Sources.Ramp m_flow(
    height=60/3.6,
    offset=0,
    duration=1,
    startTime=0) "Ramp signal for forced mass flow rate"
    annotation (Placement(transformation(extent={{-36,60},{-24,72}})));

  Buildings.Fluid.Movers.SpeedControlled_Nrpm pump1(
    y_start=1,
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    per=per,
    filteredSpeed=false) "Wilo Stratos pump"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Fluid.Movers.SpeedControlled_Nrpm pump2(
    y_start=1,
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    per=per,
    filteredSpeed=false) "Wilo Stratos pump"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));

  Buildings.Fluid.Movers.FlowControlled_m_flow forcedPump1(redeclare package
      Medium = Medium, m_flow_nominal=3,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    filteredSpeed=false) "Pump for forcing a certain mass flow rate"
    annotation (Placement(transformation(extent={{38,30},{58,50}})));

  Modelica.Blocks.Sources.Constant rpm1(k=1000) "Pump speed control signal"
    annotation (Placement(transformation(extent={{-90,54},{-78,66}})));

  Modelica.Blocks.Math.Min min1
    "Minimum for not going outside of the figure range (see documentation)"
                                annotation (Placement(transformation(
        extent={{-5,-5},{5,5}},
        origin={35,63})));

  Modelica.Blocks.Sources.Constant mMax_flow(k=40/3.6)
    "Maximum flow rate of the pump at given rpm"
    annotation (Placement(transformation(extent={{0,46},{12,58}})));

  FixedResistances.FixedResistanceDpM res(
    redeclare package Medium = Medium,
    m_flow_nominal=40/3.6,
    dp_nominal=7e4) "Pressure drop component"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
  Modelica.Blocks.Sources.Ramp m_flow1(
    duration=1,
    startTime=0,
    height=100,
    offset=0) "Ramp signal for speed"
    annotation (Placement(transformation(extent={{-100,-32},{-88,-20}})));
  Sensors.RelativePressure               relPre(redeclare package Medium =
        Medium) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={-50,10})));
  Modelica.Blocks.Continuous.Der ddp_dm_flow
    "Derivative of dp for changing m_flow"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Buildings.Utilities.Diagnostics.AssertInequality assIne(threShold=1e-8)
    "Assertion check for positive derivatives"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Buildings.Fluid.Sensors.RelativePressure relPre1(
    redeclare package Medium = Medium) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        origin={-50,-70})));
  Modelica.Blocks.Continuous.Der ddp_dNrpm "Derivative of dp for changing rpm"
    annotation (Placement(transformation(extent={{0,-120},{20,-100}})));
  Sensors.MassFlowRate senMasFlo(redeclare package Medium = Medium)
    "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{-30,-30},{-10,-50}})));
  Modelica.Blocks.Continuous.Der dm_flow_dNrpm
    "Derivative of m_flow for changing rpm"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  Buildings.Utilities.Diagnostics.AssertInequality assIne1(threShold=1e-8)
    "Assertion check for positive derivatives"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
  Buildings.Utilities.Diagnostics.AssertInequality assIne2(threShold=1e-8)
    "Assertion check for positive derivatives"
    annotation (Placement(transformation(extent={{40,-100},{60,-120}})));
  Modelica.Blocks.Sources.Constant zero(k=0) "Zero threshold"
    annotation (Placement(transformation(extent={{18,-94},{28,-84}})));
equation
  connect(sou.ports[1], pump1.port_a) annotation (Line(
      points={{-100,2},{-70,2},{-70,40},{-60,40}},
      color={0,127,255}));
  connect(forcedPump1.port_a, pump1.port_b) annotation (Line(
      points={{38,40},{-40,40}},
      color={0,127,255}));
  connect(pump1.Nrpm, rpm1.y) annotation (Line(
      points={{-50,52},{-50,60},{-77.4,60}},
      color={0,0,127}));
  connect(pump2.port_a, sou.ports[2]) annotation (Line(
      points={{-60,-40},{-70,-40},{-70,-2},{-100,-2}},
      color={0,127,255}));

  connect(forcedPump1.m_flow_in, min1.y) annotation (Line(
      points={{47.8,52},{48,52},{48,63},{40.5,63}},
      color={0,0,127}));
  connect(min1.u1, m_flow.y) annotation (Line(
      points={{29,66},{2,66},{-23.4,66}},
      color={0,0,127}));
  connect(mMax_flow.y, min1.u2) annotation (Line(points={{12.6,52},{18,52},{18,60},
          {29,60}}, color={0,0,127}));
  connect(forcedPump1.port_b, sin.ports[1]) annotation (Line(
      points={{58,40},{94,40},{94,2},{110,2}},
      color={0,127,255}));

  connect(res.port_b, sin.ports[2]) annotation (Line(points={{60,-40},{94,-40},{
          94,-2},{110,-2}},  color={0,127,255}));
  connect(m_flow1.y, pump2.Nrpm) annotation (Line(points={{-87.4,-26},{-87.4,-26},
          {-50,-26},{-50,-28}},      color={0,0,127}));
  connect(ddp_dm_flow.u, relPre.p_rel) annotation (Line(points={{-2,-10},{-2,
          -10},{-50,-10},{-50,1}}, color={0,0,127}));
  connect(relPre1.port_b, pump2.port_a) annotation (Line(points={{-60,-70},{-60,
          -70},{-60,-40}}, color={0,127,255}));
  connect(relPre1.port_a, pump2.port_b) annotation (Line(points={{-40,-70},{-40,
          -70},{-40,-40}}, color={0,127,255}));
  connect(ddp_dNrpm.u, relPre1.p_rel) annotation (Line(points={{-2,-110},{-2,-110},
          {-50,-110},{-50,-79}},       color={0,0,127}));
  connect(senMasFlo.port_a, pump2.port_b) annotation (Line(points={{-30,-40},{-36,
          -40},{-40,-40}},     color={0,127,255}));
  connect(senMasFlo.port_b, res.port_a)
    annotation (Line(points={{-10,-40},{14,-40},{40,-40}}, color={0,127,255}));
  connect(senMasFlo.m_flow, dm_flow_dNrpm.u)
    annotation (Line(points={{-20,-51},{-20,-70},{-2,-70}}, color={0,0,127}));
  connect(dm_flow_dNrpm.y, assIne1.u1) annotation (Line(points={{21,-70},{22,-70},
          {22,-64},{38,-64}},      color={0,0,127}));
  connect(zero.y, assIne1.u2) annotation (Line(points={{28.5,-89},{28.5,-76},{38,
          -76}},    color={0,0,127}));
  connect(ddp_dNrpm.y, assIne2.u1) annotation (Line(points={{21,-110},{22,-110},
          {22,-116},{38,-116}}, color={0,0,127}));
  connect(assIne2.u2, zero.y) annotation (Line(points={{38,-104},{28.5,-104},{28.5,
          -89}},       color={0,0,127}));
  connect(relPre.port_b, pump1.port_b) annotation (Line(points={{-40,10},{-40,10},
          {-40,40}},              color={0,127,255}));
  connect(relPre.port_a, pump1.port_a)
    annotation (Line(points={{-60,10},{-60,10},{-60,40}}, color={0,127,255}));
  connect(ddp_dm_flow.y, assIne.u1) annotation (Line(points={{21,-10},{22,-10},
          {22,-4},{38,-4}}, color={0,0,127}));
  connect(assIne.u2, zero.y) annotation (Line(points={{38,-16},{28.5,-16},{28.5,
          -89}},  color={0,0,127}));
  annotation (__Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Movers/Validation/PumpCurveDerivatives.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example checks if the pump similarity law implementation results in 
monotoneously increasing or decreasing relations between <code>dp</code>,
<code>m_flow</code> and <code>Nrpm</code>.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 6, 2015, by Michael Wetter:<br/>
Removed dublicate <code>experiment</code> annotation.
This is for
<a href=\"https://github.com/iea-annex60/modelica-annex60/issues/266\">#266</a>.
</li>
<li>
November 26, 2014, by Filip Jorissen:<br/>
Cleaned up implementation
</li>
<li>
February 27, 2014, by Filip Jorissen:<br/>
First implementation. See
<a href=\"https://github.com/lbl-srg/modelica-buildings/pull/202\">#202</a>
for a discussion and validation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-140,-140},{140,120}},
          preserveAspectRatio=false)));
end PumpCurveDerivatives;

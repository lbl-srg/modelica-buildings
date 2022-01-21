within Buildings.Fluid.Movers.Examples;
model StaticReset
  "Comparing different computation paths with a static pressure reset"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Air;

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=0.1
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dp_nominal=500
    "Nominal pressure difference";

  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    use_p_in=false,
    p=101325,
    T=293.15,
    nPorts=2) "Boundary"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
  Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    use_p_in=false,
    p=101325,
    T=293.15,
    nPorts=1) "Boundary"
    annotation (Placement(transformation(extent={{160,-90},{140,-70}})));
  FixedResistances.PressureDrop dp2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal/2)
    "Duct pressure drop after the static pressure measurement point"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));

  Buildings.Fluid.Movers.SpeedControlled_y fan(
    redeclare package Medium = Medium,
    per(pressure(V_flow={0,m_flow_nominal,2*m_flow_nominal}/1.2,
                   dp={2*dp_nominal,dp_nominal,0})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Fan"
    annotation (Placement(transformation(extent={{-12,-30},{8,-10}})));

  Buildings.Controls.Continuous.LimPID conPID(
    Td=1,
    k=0.5,
    Ti=15)
    "PI controller"
    annotation (Placement(transformation(extent={{-50,10},{-30,30}})));

  Sensors.RelativePressure pDucSta(redeclare package Medium = Medium)
    "Duct static pressure" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-40,-50})));
  Modelica.Blocks.Sources.Constant y(k=1)
    "Duct static pressure setpoint"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
  Modelica.Blocks.Sources.Ramp yRam(
    height=m_flow_nominal,
    duration=3600,
    offset=0) "Ramp input for forced flow rate"
    annotation (Placement(transformation(extent={{-90,62},{-70,82}})));
  Controls.OBC.CDL.Continuous.Gain gai(k=1/dp_nominal)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,-20})));

  FixedResistances.PressureDrop dp1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal/2)
    "Duct pressure drop after the static pressure measurement point"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  FlowControlled_m_flow forFlo(
    redeclare package Medium = Medium,
    m_flow_nominal=3,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Mover for forced flow rate"
    annotation (Placement(transformation(extent={{102,-30},{122,-10}})));
equation
  connect(sou.ports[1], fan.port_a) annotation (Line(points={{-80,-81},{-24,-81},
          {-24,-20},{-12,-20}},
                        color={0,127,255}));
  connect(pDucSta.port_b, sou.ports[2]) annotation (Line(
      points={{-50,-50},{-80,-50},{-80,-79}},
      color={0,127,255},
      pattern=LinePattern.Dot));
  connect(y.y, conPID.u_s)
    annotation (Line(points={{-69,20},{-52,20}}, color={0,0,127}));
  connect(pDucSta.p_rel, gai.u)
    annotation (Line(points={{-40,-41},{-40,-32}}, color={0,0,127}));
  connect(gai.y, conPID.u_m)
    annotation (Line(points={{-40,-8},{-40,8}}, color={0,0,127}));
  connect(conPID.y, fan.y)
    annotation (Line(points={{-29,20},{-2,20},{-2,-8}}, color={0,0,127}));
  connect(fan.port_b, dp1.port_a)
    annotation (Line(points={{8,-20},{20,-20}}, color={0,127,255}));
  connect(dp1.port_b, dp2.port_a)
    annotation (Line(points={{40,-20},{60,-20}}, color={0,127,255}));
  connect(pDucSta.port_a, dp2.port_a) annotation (Line(
      points={{-30,-50},{60,-50},{60,-20}},
      color={0,127,255},
      pattern=LinePattern.Dot));
  connect(dp2.port_b, forFlo.port_a)
    annotation (Line(points={{80,-20},{102,-20}}, color={0,127,255}));
  connect(forFlo.port_b, sin.ports[1]) annotation (Line(points={{122,-20},{134,-20},
          {134,-80},{140,-80}}, color={0,127,255}));
  connect(yRam.y, forFlo.m_flow_in)
    annotation (Line(points={{-69,72},{112,72},{112,-8}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{160,
            160}})),
    Documentation(info="<html>
<p>
This example demonstrates the use of a fan with closed loop control.
The fan is controlled to track a required mass flow rate.
</p>
</html>", revisions="<html>
<ul>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
February 14, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Movers/Examples/ClosedLoop_y.mos"
        "Simulate and plot"),
    experiment(
      StopTime=3600,
      Tolerance=1e-06));
end StaticReset;

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
    nPorts=3)
    "Boundary"
    annotation (Placement(transformation(extent={{-90,-90},{-70,-70}})));
  Buildings.Fluid.FixedResistances.PressureDrop dp1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal/2)
    "Duct pressure drop before the static pressure measurement point"
    annotation (Placement(transformation(extent={{70,-30},{90,-10}})));
  FixedResistances.PressureDrop dp2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal/2)
    "Duct pressure drop after the static pressure measurement point"
    annotation (Placement(transformation(extent={{110,-30},{130,-10}})));

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

  Sensors.RelativePressure dpDuc(
    redeclare package Medium = Medium)
    "Duct static pressure"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-40,-50})));
  Modelica.Blocks.Sources.Constant y(
    k=dp_nominal/2)
    "Duct static pressure setpoint"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
  Modelica.Blocks.Sources.Ramp yRam(
    height=-1,
    duration=3600,
    offset=1) "Ramp input for all supply dampers"
    annotation (Placement(transformation(extent={{-90,62},{-70,82}})));
  Actuators.Dampers.Exponential damSup(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dpDamper_nominal=5)
    "Supply air damper"
    annotation (Placement(transformation(extent={{30,-30},{50,-10}})));
  Controls.OBC.CDL.Continuous.Gain gai(k=1)
    annotation (Placement(transformation(extent={{-14,30},{6,50}})));
equation
  connect(dp2.port_b, sou.ports[1]) annotation (Line(points={{130,-20},{140,-20},
          {140,-80},{36,-80},{36,-81.3333},{-70,-81.3333}},
                                       color={0,127,255}));
  connect(dp1.port_b, dp2.port_a)
    annotation (Line(points={{90,-20},{110,-20}},
                                                color={0,127,255}));
  connect(dpDuc.port_a, dp2.port_a)
    annotation (Line(points={{-30,-50},{98,-50},{98,-20},{110,-20}},
                                                        color={0,127,255},pattern=LinePattern.Dot));
  connect(sou.ports[2], fan.port_a) annotation (Line(points={{-70,-80},{-24,-80},
          {-24,-20},{-12,-20}},
                        color={0,127,255}));
  connect(dpDuc.port_b, sou.ports[3]) annotation (Line(points={{-50,-50},{-70,
          -50},{-70,-78.6667}},                                      color={0,127,
          255},pattern=LinePattern.Dot));
  connect(y.y, conPID.u_s)
    annotation (Line(points={{-69,20},{-52,20}}, color={0,0,127}));
  connect(dpDuc.p_rel, conPID.u_m)
    annotation (Line(points={{-40,-41},{-40,8}}, color={0,0,127}));
  connect(damSup.port_b, dp1.port_a)
    annotation (Line(points={{50,-20},{70,-20}}, color={0,127,255}));
  connect(damSup.port_a, fan.port_b)
    annotation (Line(points={{30,-20},{8,-20}}, color={0,127,255}));
  connect(yRam.y, damSup.y)
    annotation (Line(points={{-69,72},{40,72},{40,-8}}, color={0,0,127}));
  connect(conPID.y, gai.u) annotation (Line(points={{-29,20},{-22,20},{-22,40},
          {-16,40}}, color={0,0,127}));
  connect(gai.y, fan.y) annotation (Line(points={{8,40},{14,40},{14,-2},{-2,-2},
          {-2,-8}}, color={0,0,127}));
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

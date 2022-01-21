within Buildings.Fluid.Movers.Examples;
model StaticReset
  "Comparing different computation paths with a static pressure reset"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Air;
  Buildings.Fluid.Movers.Data.Fans.EnglanderNorford1992.Supply per1(
    final powMet=
      Buildings.Fluid.Movers.BaseClasses.Types.PowerMethod.PowerCharacteristic)
    "Performance record for PowerCharacteristic";
  Buildings.Fluid.Movers.Data.Generic per2(
    final powMet=
      Buildings.Fluid.Movers.BaseClasses.Types.PowerMethod.EulerNumber,
    peak=Buildings.Fluid.Movers.BaseClasses.Euler.findPeak(
      pressure=per1.pressure,
      power=per1.power))
    "Performance record for EulerNumber";
  Buildings.Fluid.Movers.Data.Generic per3(
    final powMet=
      Buildings.Fluid.Movers.BaseClasses.Types.PowerMethod.MotorEfficiency,
    hydraulicEfficiency(eta = {1}),
    motorEfficiency(eta = {per2.peak.eta}))
    "Performance record for MotorEfficiency";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=
    per1.pressure.V_flow[end]*1.2/2
    "Nominal mass flow rate, roughly half the maximum";
  parameter Modelica.Units.SI.PressureDifference dp_nominal=
    per1.pressure.dp[1]/2
    "Nominal pressure difference, roughly half the maximum";

  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    use_p_in=false,
    p=101325,
    T=293.15,
    nPorts=4) "Boundary"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
  Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    use_p_in=false,
    p=101325,
    T=293.15,
    nPorts=2) "Boundary"
    annotation (Placement(transformation(extent={{160,-90},{140,-70}})));

  Buildings.Fluid.Movers.SpeedControlled_y fan2(
    redeclare package Medium = Medium,
    per = per2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Fan using MotorEfficiency, assuming constant efficiency"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));
  Buildings.Fluid.Movers.SpeedControlled_y fan3(
    redeclare package Medium = Medium,
    per(pressure(V_flow={0,m_flow_nominal,2*m_flow_nominal}/1.2, dp={2*
            dp_nominal,dp_nominal,0})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Fan using MotorEfficiency, assuming constant efficiency"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));

  FixedResistances.PressureDrop dp21(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal/2)
    "Duct pressure drop before the static pressure measurement point"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  FixedResistances.PressureDrop dp22(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal/2)
    "Duct pressure drop after the static pressure measurement point"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));
  FixedResistances.PressureDrop dp31(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal/2)
    "Duct pressure drop before the static pressure measurement point"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  FixedResistances.PressureDrop dp32(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal/2)
    "Duct pressure drop after the static pressure measurement point"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));

  Buildings.Controls.Continuous.LimPID conPID2(
    Td=1,
    k=0.5,
    Ti=15) "PI controller"
    annotation (Placement(transformation(extent={{-60,100},{-40,120}})));
  Buildings.Controls.Continuous.LimPID conPID3(
    Td=1,
    k=0.5,
    Ti=15) "PI controller"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));

  Sensors.RelativePressure pDucSta2(redeclare package Medium = Medium)
    "Duct static pressure" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-50,50})));
  Sensors.RelativePressure pDucSta3(redeclare package Medium = Medium)
    "Duct static pressure" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-50,-50})));

  Modelica.Blocks.Sources.Constant y(k=1)
    "Duct static pressure setpoint"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,220})));
  Modelica.Blocks.Sources.Ramp yRam(
    height=m_flow_nominal,
    duration=3600,
    offset=0) "Ramp input for forced flow rate"
    annotation (Placement(transformation(extent={{60,210},{80,230}})));

  Controls.OBC.CDL.Continuous.Gain gai2(k=1/dp_nominal) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,78})));
  Controls.OBC.CDL.Continuous.Gain gai3(k=1/dp_nominal) "Gain" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-22})));

  FlowControlled_m_flow forFlo2(
    redeclare package Medium = Medium,
    m_flow_nominal=3,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Mover for forced flow rate"
    annotation (Placement(transformation(extent={{102,70},{122,90}})));
  FlowControlled_m_flow forFlo3(
    redeclare package Medium = Medium,
    m_flow_nominal=3,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Mover for forced flow rate"
    annotation (Placement(transformation(extent={{102,-30},{122,-10}})));

equation
  connect(y.y, conPID3.u_s) annotation (Line(points={{-79,220},{-68,220},{-68,10},
          {-62,10}}, color={0,0,127}));
  connect(pDucSta3.p_rel, gai3.u)
    annotation (Line(points={{-50,-41},{-50,-34}}, color={0,0,127}));
  connect(gai3.y, conPID3.u_m)
    annotation (Line(points={{-50,-10},{-50,-2}}, color={0,0,127}));
  connect(conPID3.y, fan3.y)
    annotation (Line(points={{-39,10},{0,10},{0,-8}}, color={0,0,127}));
  connect(fan3.port_b, dp31.port_a)
    annotation (Line(points={{10,-20},{20,-20}}, color={0,127,255}));
  connect(dp31.port_b, dp32.port_a)
    annotation (Line(points={{40,-20},{60,-20}}, color={0,127,255}));
  connect(pDucSta3.port_a, dp32.port_a) annotation (Line(
      points={{-40,-50},{60,-50},{60,-20}},
      color={0,127,255},
      pattern=LinePattern.Dot));
  connect(dp32.port_b, forFlo3.port_a)
    annotation (Line(points={{80,-20},{102,-20}}, color={0,127,255}));
  connect(yRam.y, forFlo3.m_flow_in) annotation (Line(points={{81,220},{88,220},
          {88,38},{112,38},{112,-8}}, color={0,0,127}));
  connect(fan2.port_b, dp21.port_a)
    annotation (Line(points={{10,80},{20,80}}, color={0,127,255}));
  connect(dp21.port_b, dp22.port_a)
    annotation (Line(points={{40,80},{60,80}}, color={0,127,255}));
  connect(dp22.port_b, forFlo2.port_a)
    annotation (Line(points={{80,80},{102,80}}, color={0,127,255}));
  connect(yRam.y, forFlo2.m_flow_in) annotation (Line(points={{81,220},{88,220},
          {88,98},{112,98},{112,92}}, color={0,0,127}));
  connect(pDucSta2.p_rel, gai2.u)
    annotation (Line(points={{-50,59},{-50,66}}, color={0,0,127}));
  connect(gai2.y, conPID2.u_m)
    annotation (Line(points={{-50,90},{-50,98}}, color={0,0,127}));
  connect(pDucSta2.port_a, dp22.port_a) annotation (Line(
      points={{-40,50},{60,50},{60,80}},
      color={0,127,255},
      pattern=LinePattern.Dot));
  connect(y.y, conPID2.u_s) annotation (Line(points={{-79,220},{-68,220},{-68,110},
          {-62,110}}, color={0,0,127}));
  connect(conPID2.y, fan2.y)
    annotation (Line(points={{-39,110},{0,110},{0,92}}, color={0,0,127}));
  connect(forFlo3.port_b, sin.ports[1]) annotation (Line(points={{122,-20},{134,
          -20},{134,-81},{140,-81}}, color={0,127,255}));
  connect(forFlo2.port_b, sin.ports[2]) annotation (Line(points={{122,80},{134,80},
          {134,-79},{140,-79}}, color={0,127,255}));
  connect(fan3.port_a, sou.ports[1]) annotation (Line(points={{-10,-20},{-18,-20},
          {-18,-81.5},{-80,-81.5}}, color={0,127,255}));
  connect(fan2.port_a, sou.ports[2]) annotation (Line(points={{-10,80},{-18,80},
          {-18,-80.5},{-80,-80.5}}, color={0,127,255}));
  connect(pDucSta3.port_b, sou.ports[3]) annotation (Line(points={{-60,-50},{-70,
          -50},{-70,-79.5},{-80,-79.5}}, color={0,127,255}));
  connect(pDucSta2.port_b, sou.ports[4]) annotation (Line(points={{-60,50},{-70,
          50},{-70,-78.5},{-80,-78.5}},
                                    color={0,127,255}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{160,
            240}})),
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
      Tolerance=1e-06),
    Icon(coordinateSystem(extent={{-100,-100},{160,240}})));
end StaticReset;

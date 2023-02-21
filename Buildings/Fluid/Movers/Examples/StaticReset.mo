within Buildings.Fluid.Movers.Examples;
model StaticReset
  "Comparing different computation paths with a static pressure reset"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Air;

  // Fans and their performance records
  Buildings.Fluid.Movers.SpeedControlled_y fan1(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    redeclare Buildings.Fluid.Movers.Examples.Data.EnglanderNorford1992 per(
      etaHydMet=Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.Power_VolumeFlowRate,
      etaMotMet=Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.NotProvided))
    "Fan using power curves"
    annotation (Placement(transformation(extent={{-10,170},{10,190}})));
  Buildings.Fluid.Movers.SpeedControlled_y fan2(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    per(
      powerOrEfficiencyIsHydraulic=fan1.per.powerOrEfficiencyIsHydraulic,
      pressure=fan1.per.pressure,
      etaHydMet=Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.EulerNumber,
      etaMotMet=Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.NotProvided,
      peak(
        V_flow=23.022856,
        dp=1211.1604,
        eta=0.74030644)))
    "Fan using the Euler number"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));
  Buildings.Fluid.Movers.SpeedControlled_y fan3(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    per(
      powerOrEfficiencyIsHydraulic=fan1.per.powerOrEfficiencyIsHydraulic,
      pressure=fan1.per.pressure,
      etaHydMet=Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.Efficiency_VolumeFlowRate,
      etaMotMet=Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.NotProvided,
      efficiency(eta={0.7}))) "Fan using constant efficiency"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));

  // Define the system curve
  parameter Modelica.Units.SI.VolumeFlowRate V_flow_nominal=21.8
    "Nominal volumetric flow rate of the system";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=V_flow_nominal/1.2
    "Nominal mass flow rate of the system";
  parameter Modelica.Units.SI.PressureDifference dp_nominal=1244.2
    "Nominal pressure rise of the system";

  // Boundaries
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    use_p_in=false,
    p=101325,
    T=293.15,
    nPorts=6) "Boundary"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    use_p_in=false,
    p=101325,
    T=293.15,
    nPorts=3) "Boundary"
    annotation (Placement(transformation(extent={{160,-90},{140,-70}})));

  // Duct pressure drops
  Buildings.Fluid.FixedResistances.PressureDrop dp11(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal/3)
    "Duct pressure drop before the static pressure measurement point"
    annotation (Placement(transformation(extent={{20,170},{40,190}})));
  Buildings.Fluid.FixedResistances.PressureDrop dp12(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal/3)
    "Duct pressure drop after the static pressure measurement point"
    annotation (Placement(transformation(extent={{60,170},{80,190}})));
  Buildings.Fluid.FixedResistances.PressureDrop dp21(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal/3)
    "Duct pressure drop before the static pressure measurement point"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Buildings.Fluid.FixedResistances.PressureDrop dp22(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal/3)
    "Duct pressure drop after the static pressure measurement point"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));
  Buildings.Fluid.FixedResistances.PressureDrop dp31(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal/3)
    "Duct pressure drop before the static pressure measurement point"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Buildings.Fluid.FixedResistances.PressureDrop dp32(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal/3)
    "Duct pressure drop after the static pressure measurement point"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));

  // PI controllers and components
  Buildings.Fluid.Sensors.RelativePressure pDucSta1(
    redeclare package Medium = Medium)
    "Duct static pressure"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-50,152})));
  Buildings.Fluid.Sensors.RelativePressure pDucSta2(
    redeclare package Medium = Medium)
    "Duct static pressure"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-50,50})));
  Buildings.Fluid.Sensors.RelativePressure pDucSta3(
    redeclare package Medium = Medium)
    "Duct static pressure"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-50,-50})));
  Buildings.Controls.Continuous.LimPID conPID1(
    Td=1,
    k=0.5,
    Ti=15) "PI controller"
    annotation (Placement(transformation(extent={{-60,200},{-40,220}})));
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
  Modelica.Blocks.Math.Gain gai1(k=2/dp_nominal) "Gain"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,180})));
  Modelica.Blocks.Math.Gain gai2(k=2/dp_nominal) "Gain"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,78})));
  Modelica.Blocks.Math.Gain gai3(k=2/dp_nominal) "Gain"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-22})));
  Modelica.Blocks.Sources.Constant y(k=1)
    "Duct static pressure setpoint (normalised)"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,220})));

  // VAV boxes
  Actuators.Dampers.Exponential damExp1(
    redeclare final package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dpDamper_nominal=dp_nominal/3,
    y_start=0) "Damper representing a VAV box"
    annotation (Placement(transformation(extent={{100,170},{120,190}})));
  Actuators.Dampers.Exponential damExp2(
    redeclare final package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dpDamper_nominal=dp_nominal/3,
    y_start=0) "Damper representing a VAV box"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));
  Actuators.Dampers.Exponential damExp3(
    redeclare final package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dpDamper_nominal=dp_nominal/3,
    y_start=0) "Damper representing a VAV box"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
  Modelica.Blocks.Sources.Ramp yDam(
    height=1,
    duration=3600,
    offset=0) "Ramp input for damper position"
    annotation (Placement(transformation(extent={{60,200},{80,220}})));

equation
  connect(y.y, conPID3.u_s) annotation (Line(points={{-79,220},{-68,220},{-68,10},
          {-62,10}}, color={0,0,127}));
  connect(pDucSta3.p_rel, gai3.u)
    annotation (Line(points={{-50,-41},{-50,-34}}, color={0,0,127}));
  connect(gai3.y, conPID3.u_m)
    annotation (Line(points={{-50,-11},{-50,-2}}, color={0,0,127}));
  connect(conPID3.y, fan3.y)
    annotation (Line(points={{-39,10},{0,10},{0,-8}}, color={0,0,127}));
  connect(fan3.port_b, dp31.port_a)
    annotation (Line(points={{10,-20},{20,-20}}, color={0,127,255}));
  connect(dp31.port_b, dp32.port_a)
    annotation (Line(points={{40,-20},{60,-20}}, color={0,127,255}));
  connect(fan2.port_b, dp21.port_a)
    annotation (Line(points={{10,80},{20,80}}, color={0,127,255}));
  connect(dp21.port_b, dp22.port_a)
    annotation (Line(points={{40,80},{60,80}}, color={0,127,255}));
  connect(pDucSta2.p_rel, gai2.u)
    annotation (Line(points={{-50,59},{-50,66}}, color={0,0,127}));
  connect(gai2.y, conPID2.u_m)
    annotation (Line(points={{-50,89},{-50,98}}, color={0,0,127}));
  connect(pDucSta2.port_a, dp22.port_a) annotation (Line(
      points={{-40,50},{60,50},{60,80}},
      color={0,127,255},
      pattern=LinePattern.Dot));
  connect(y.y, conPID2.u_s) annotation (Line(points={{-79,220},{-68,220},{-68,110},
          {-62,110}}, color={0,0,127}));
  connect(conPID2.y, fan2.y)
    annotation (Line(points={{-39,110},{0,110},{0,92}}, color={0,0,127}));
  connect(fan1.port_b, dp11.port_a)
    annotation (Line(points={{10,180},{20,180}}, color={0,127,255}));
  connect(dp11.port_b, dp12.port_a)
    annotation (Line(points={{40,180},{60,180}}, color={0,127,255}));
  connect(pDucSta1.p_rel,gai1. u)
    annotation (Line(points={{-50,161},{-50,168}},
                                                 color={0,0,127}));
  connect(gai1.y,conPID1. u_m)
    annotation (Line(points={{-50,191},{-50,198}},
                                                 color={0,0,127}));
  connect(y.y, conPID1.u_s) annotation (Line(points={{-79,220},{-68,220},{-68,
          210},{-62,210}},
                      color={0,0,127}));
  connect(pDucSta1.port_a, dp12.port_a) annotation (Line(
      points={{-40,152},{60,152},{60,180}},
      color={0,127,255},
      pattern=LinePattern.Dot));
  connect(conPID1.y, fan1.y)
    annotation (Line(points={{-39,210},{0,210},{0,192}}, color={0,0,127}));
  connect(pDucSta3.port_a, dp32.port_a) annotation (Line(
      points={{-40,-50},{60,-50},{60,-20}},
      color={0,127,255},
      pattern=LinePattern.Dot));
  connect(fan3.port_a, sou.ports[1]) annotation (Line(points={{-10,-20},{-18,
          -20},{-18,-81.6667},{-80,-81.6667}},
                                          color={0,127,255}));
  connect(fan2.port_a, sou.ports[2]) annotation (Line(points={{-10,80},{-18,80},
          {-18,-81},{-80,-81}}, color={0,127,255}));
  connect(fan1.port_a, sou.ports[3]) annotation (Line(points={{-10,180},{-18,
          180},{-18,-80.3333},{-80,-80.3333}},
                                          color={0,127,255}));
  connect(pDucSta3.port_b, sou.ports[4]) annotation (Line(
      points={{-60,-50},{-78,-50},{-78,-79.6667},{-80,-79.6667}},
      color={0,127,255},
      pattern=LinePattern.Dot));
  connect(pDucSta2.port_b, sou.ports[5]) annotation (Line(
      points={{-60,50},{-78,50},{-78,-79},{-80,-79}},
      color={0,127,255},
      pattern=LinePattern.Dot));
  connect(pDucSta1.port_b, sou.ports[6]) annotation (Line(
      points={{-60,152},{-78,152},{-78,-78},{-80,-78},{-80,-78.3333}},
      color={0,127,255},
      pattern=LinePattern.Dot));
  connect(dp12.port_b, damExp1.port_a)
    annotation (Line(points={{80,180},{100,180}}, color={0,127,255}));
  connect(damExp1.port_b, sin.ports[1]) annotation (Line(points={{120,180},{134,
          180},{134,-81.3333},{140,-81.3333}}, color={0,127,255}));
  connect(yDam.y, damExp1.y)
    annotation (Line(points={{81,210},{92,210},{92,202},{110,202},{110,192}},
                                                            color={0,0,127}));
  connect(dp22.port_b,damExp2. port_a)
    annotation (Line(points={{80,80},{100,80}}, color={0,127,255}));
  connect(damExp2.port_b, sin.ports[2]) annotation (Line(points={{120,80},{134,80},
          {134,-80},{140,-80}}, color={0,127,255}));
  connect(dp32.port_b,damExp3. port_a)
    annotation (Line(points={{80,-20},{100,-20}}, color={0,127,255}));
  connect(damExp3.port_b, sin.ports[3]) annotation (Line(points={{120,-20},{134,
          -20},{134,-78.6667},{140,-78.6667}}, color={0,127,255}));
  connect(yDam.y, damExp2.y) annotation (Line(points={{81,210},{92,210},{92,100},
          {110,100},{110,92}},                     color={0,0,127}));
  connect(yDam.y, damExp3.y) annotation (Line(points={{81,210},{92,210},{92,0},
          {110,0},{110,-8}},                   color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{160,
            240}})),
    Documentation(info="<html>
<p>
This example model compares the three power computation methods in a scenario
where the fan performance (<i>P</i> vs. <i>V&#775;</i>) is examined
to verify savings of a static pressure reset. The fan speed is controlled
to track the duct static pressure at a point downstream while the damper
(representing a VAV box) moves from fully closed to fully open.
The system was described in Englander and Norford (1992).
The fan data are implemented in
<a href=\"Modelica://Buildings.Fluid.Movers.Examples.Data.EnglanderNorford1992\">
Buildings.Fluid.Movers.Examples.Data.EnglanderNorford1992</a>.
</p>
<ul>
<li>
The first fan uses the fan curve to estimate the shaft power at reduced speed.
</li>
<li>
The second fan uses the Euler number and its correlation to estimate
the hydraulic efficiency.
</li>
<li>
The third fan assumes a constant hydraulic efficiency.
</li>
</ul>
<p>
In the results, <i>P</i> computed from the Euler number and from the power curve
agree on the trend of <i>P</i> vs. <i>V&#775;</i>. Both of them are also able
to prevent <i>P</i> from incorrectly going to zero as <i>V&#775;</i> approaches
zero, which the method with constant efficiency failed.
</p>
<h4>References</h4>
<p>
Englander, S. L., and L. K. Norford.
\"Saving fan energy in VAV systems- part 1: analysis of a variable-speed-drive retrofit.\"
<i>ASHRAE Winter Meeting, Anaheim, CA, USA, 01/25-29/92.</i> 1992.
</p>
</html>", revisions="<html>
<ul>
<li>
January 24, 2022, by Hongxiang Fu and David Blum:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">#2668</a>.
</li>
</ul>
</html>"),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Movers/Examples/StaticReset.mos"
        "Simulate and plot"),
    experiment(
      StopTime=3600,
      Tolerance=1e-06));
end StaticReset;

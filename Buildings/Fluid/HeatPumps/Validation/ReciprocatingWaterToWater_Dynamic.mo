within Buildings.Fluid.HeatPumps.Validation;
model ReciprocatingWaterToWater_Dynamic
  "Test model for variable speed reciprocating water to water heat pump"
  extends Modelica.Icons.Example;
  package Medium1 = Buildings.Media.Water "Medium model";
  package Medium2 = Buildings.Media.Water "Medium model";

  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal = 0.47
    "Nominal mass flow rate on the condenser side";
  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal = 0.47
    "Nominal mass flow rate on the evaporator side";

  parameter Modelica.SIunits.MassFlowRate Flow_Source = 0.79
    "Mass flow rate on the condenser side";
  parameter Modelica.SIunits.MassFlowRate Flow_Load = 0.47
    "Mass flow rate on the evaporator side";

  Buildings.Fluid.Sources.FixedBoundary sin2(
    redeclare package Medium = Medium2, nPorts=2) "Source side sink"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        origin={-32,20})));
  Buildings.Fluid.Sources.FixedBoundary sin1(
    redeclare package Medium = Medium1, nPorts=2) "Load side sink"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        origin={44,20})));
  Modelica.Fluid.Sources.MassFlowSource_T loa(
    redeclare package Medium = Medium1,
    m_flow=Flow_Load,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1) "Load side flow source"
    annotation (Placement(transformation(extent={{-60,48},{-40,68}})));
  Modelica.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium2,
    m_flow=Flow_Source,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1) "Source side flow source"
    annotation (Placement(transformation(extent={{60,36},{40,56}})));
  Modelica.Blocks.Sources.RealExpression mLoa(y=Flow_Load)
    "Load side mass flwo rate"
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  Modelica.Blocks.Sources.RealExpression mSou(y=Flow_Source)
    "Source side mass flow rate"
    annotation (Placement(transformation(extent={{100,-62},{80,-42}})));
  Buildings.Fluid.HeatPumps.ReciprocatingWaterToWater heaPum(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    dp1_nominal=1000,
    dp2_nominal=1000,
    redeclare package ref =
        Buildings.Fluid.HeatPumps.Compressors.Refrigerants.R410A,
    pisDis=0.00162,
    cleFac=0.0690,
    etaEle=0.696,
    dTSup=9.82,
    UACon=2210,
    UAEva=1540,
    PLos=100,
    pDro=99290) "Reciprocating water to water heat pump"
    annotation (Placement(transformation(extent={{-10,42},{10,62}})));
  Buildings.Fluid.HeatPumps.ReciprocatingWaterToWater heaPum1(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    dp1_nominal=1000,
    dp2_nominal=1000,
    redeclare package ref =
        Buildings.Fluid.HeatPumps.Compressors.Refrigerants.R410A,
    pisDis=0.00162,
    cleFac=0.0690,
    etaEle=0.696,
    dTSup=9.82,
    UACon=2210,
    UAEva=1540,
    PLos=100,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    tau1=15,
    tau2=15,
    pDro=99290) "Reciprocating water to water heat pump with transient effects"
             annotation (Placement(transformation(extent={{-10,-64},{10,-44}})));
  Modelica.Blocks.Sources.Pulse N(width=60, period=500)
    "Heat pump control signal"
    annotation (Placement(transformation(extent={{-98,70},{-78,90}})));
  Modelica.Fluid.Sources.MassFlowSource_T loa1(
    redeclare package Medium = Medium1,
    m_flow=Flow_Load,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1) "Load side flow source"
    annotation (Placement(transformation(extent={{-60,-58},{-40,-38}})));
  Modelica.Fluid.Sources.MassFlowSource_T sou1(
    redeclare package Medium = Medium2,
    m_flow=Flow_Source,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1) "Source side flow source"
    annotation (Placement(transformation(extent={{60,-70},{40,-50}})));
  Modelica.Blocks.Sources.Constant TLoa(k=285.15) "Load side fluid temperature"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));
  Modelica.Blocks.Sources.Constant TSou(k=283.15)
    "Source side fluid temperature"
    annotation (Placement(transformation(extent={{100,-90},{80,-70}})));
  Modelica.Blocks.Sources.RealExpression appCap(y=heaPum1.port_a1.m_flow*(
        senSpeEnt1.h_out - senSpeEnt.h_out))
    "Apparent capacity of the heat pump"
    annotation (Placement(transformation(extent={{80,70},{100,90}})));
  Buildings.Fluid.Sensors.SpecificEnthalpyTwoPort senSpeEnt(
    redeclare package Medium = Medium1,
    m_flow_nominal=m1_flow_nominal,
    tau=0.01,
    initType=Modelica.Blocks.Types.Init.SteadyState)
    annotation (Placement(transformation(extent={{-34,-52},{-26,-44}})));
  Buildings.Fluid.Sensors.SpecificEnthalpyTwoPort senSpeEnt1(
    redeclare package Medium = Medium1,
    m_flow_nominal=m1_flow_nominal,
    tau=0.01,
    initType=Modelica.Blocks.Types.Init.SteadyState)
    annotation (Placement(transformation(extent={{16,-52},{24,-44}})));
equation
  connect(mSou.y, sou.m_flow_in)
    annotation (Line(points={{79,-52},{74,-52},{74,54},{60,54}},
                                                             color={0,0,127}));
  connect(heaPum.port_a2, sou.ports[1])
    annotation (Line(points={{10,46},{40,46}},           color={0,127,255}));
  connect(heaPum.port_b1, sin1.ports[1]) annotation (Line(points={{10,58},{34,58},
          {34,22}},         color={0,127,255}));
  connect(heaPum.port_a1, loa.ports[1])
    annotation (Line(points={{-10,58},{-34,58},{-40,58}},color={0,127,255}));
  connect(heaPum.port_b2, sin2.ports[1]) annotation (Line(points={{-10,46},{-22,
          46},{-22,22}},            color={0,127,255}));
  connect(sin2.ports[2], heaPum1.port_b2) annotation (Line(points={{-22,18},{-22,
          18},{-22,-60},{-10,-60}}, color={0,127,255}));
  connect(N.y,heaPum.y)  annotation (Line(points={{-77,80},{-18,80},{-18,55},{-12,
          55}}, color={0,0,127}));
  connect(N.y,heaPum1.y)  annotation (Line(points={{-77,80},{-18,80},{-18,-51},{
          -12,-51}}, color={0,0,127}));
  connect(mLoa.y, loa.m_flow_in) annotation (Line(points={{-79,-40},{-74,-40},{-74,
          66},{-60,66}}, color={0,0,127}));
  connect(mLoa.y, loa1.m_flow_in)
    annotation (Line(points={{-79,-40},{-68,-40},{-60,-40}}, color={0,0,127}));
  connect(sou1.ports[1], heaPum1.port_a2)
    annotation (Line(points={{40,-60},{26,-60},{10,-60}}, color={0,127,255}));
  connect(mSou.y, sou1.m_flow_in)
    annotation (Line(points={{79,-52},{74,-52},{60,-52}}, color={0,0,127}));
  connect(TSou.y, sou1.T_in) annotation (Line(points={{79,-80},{70,-80},{70,-56},
          {62,-56}}, color={0,0,127}));
  connect(sou.T_in, sou1.T_in) annotation (Line(points={{62,50},{70,50},{70,-56},
          {62,-56}}, color={0,0,127}));
  connect(TLoa.y, loa1.T_in) annotation (Line(points={{-79,-60},{-70,-60},{-70,-44},
          {-62,-44}}, color={0,0,127}));
  connect(TLoa.y, loa.T_in) annotation (Line(points={{-79,-60},{-70,-60},{-70,62},
          {-62,62}}, color={0,0,127}));
  connect(heaPum1.port_b1, senSpeEnt1.port_a)
    annotation (Line(points={{10,-48},{16,-48}}, color={0,127,255}));
  connect(senSpeEnt1.port_b, sin1.ports[2])
    annotation (Line(points={{24,-48},{34,-48},{34,18}}, color={0,127,255}));
  connect(loa1.ports[1], senSpeEnt.port_a)
    annotation (Line(points={{-40,-48},{-34,-48}}, color={0,127,255}));
  connect(senSpeEnt.port_b, heaPum1.port_a1)
    annotation (Line(points={{-26,-48},{-10,-48}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/Validation/ReciprocatingWaterToWater_Dynamic.mos"
        "Simulate and plot"),
    experiment(
      StopTime=1000),
    Documentation(info="<html>
<p>
Model that demonstrates the use of the
<a href=\"modelica://Buildings.Fluid.HeatPumps.ReciprocatingWaterToWater\">
Buildings.Fluid.HeatPumps.ReciprocatingWaterToWater</a> heat pump model.
</p>
<p>
With constant inlet source and load water temperatures, the heat pumps cycle on
and off. The apparent capacity of the dynamic model is compared to the 
steady-state model and to the condenser heat transfer rate. 
</p>
</html>", revisions="<html>
<ul>
<li>
November 14, 2016, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end ReciprocatingWaterToWater_Dynamic;

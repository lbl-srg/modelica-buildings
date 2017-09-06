within Buildings.Fluid.HeatPumps.Validation;
model ScrollWaterToWater_VariableSpeed
  "Test model for scroll water to water heat pump"
  extends Modelica.Icons.Example;
  package Medium1 = Buildings.Media.Water "Medium model";
  package Medium2 = Buildings.Media.Water "Medium model";

  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal = 0.47
    "Nominal mass flow rate on the condenser side";
  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal = 0.47
    "Nominal mass flow rate on the evaporator side";

  parameter Modelica.SIunits.MassFlowRate flowSource = 0.79
    "Mass flow rate on the condenser side";
  parameter Modelica.SIunits.MassFlowRate flowLoad = 0.47
    "Mass flow rate on the evaporator side";

  Buildings.Fluid.Sources.FixedBoundary sin2(
    redeclare package Medium = Medium2, nPorts=1) "Source side sink"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        origin={-70,-40})));
  Buildings.Fluid.Sources.FixedBoundary sin1(
    redeclare package Medium = Medium1, nPorts=1) "Load side sink"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        origin={58,20})));
  Modelica.Fluid.Sources.MassFlowSource_T loa(
    redeclare package Medium = Medium1,
    m_flow=flowLoad,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1) "Load side flow source"
    annotation (Placement(transformation(extent={{-66,10},{-46,30}})));
  Modelica.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium2,
    m_flow=flowSource,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1) "Source side flow source"
    annotation (Placement(transformation(extent={{68,-16},{48,4}})));
  Modelica.Blocks.Sources.RealExpression mLoa(y=flowLoad)
    "Load side mass flow rate"
    annotation (Placement(transformation(extent={{-100,18},{-80,38}})));
  Modelica.Blocks.Sources.RealExpression mSou(y=flowSource)
    "Source side mass flwo rate"
    annotation (Placement(transformation(extent={{100,-8},{80,12}})));
  Buildings.Fluid.HeatPumps.ScrollWaterToWater heaPum(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    dp1_nominal=1000,
    dp2_nominal=1000,
    redeclare package ref =
        Buildings.Media.Refrigerants.R410A,
    show_T=true,
    datHeaPum(
      etaEle=0.696,
      PLos=500,
      dTSup=10,
      UACon=4400,
      UAEva=4400,
      volRat=2,
      V_flow_nominal=0.003,
      leaCoe=0.01),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    enable_temperature_protection=false)
    "Scroll water to water heat pump"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Ramp N(
    duration=800,
    startTime=100,
    height=1.0,
    offset=0.0) "Heat pump control signal"
    annotation (Placement(transformation(extent={{-52,-26},{-40,-14}})));
  Modelica.Blocks.Sources.Constant TLoa(k=285.15) "Load side fluid temperature"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Modelica.Blocks.Sources.Constant TSou(k=283.15)
    "Source side fluid temperature"
    annotation (Placement(transformation(extent={{100,-38},{80,-18}})));
equation
  connect(mSou.y, sou.m_flow_in)
    annotation (Line(points={{79,2},{79,2},{68,2}},          color={0,0,127}));
  connect(mLoa.y, loa.m_flow_in) annotation (Line(points={{-79,28},{-79,28},{
          -66,28}},      color={0,0,127}));
  connect(N.y,heaPum.y)  annotation (Line(points={{-39.4,-20},{-32,-20},{-32,3},
          {-12,3}},color={0,0,127}));
  connect(TSou.y, sou.T_in)
    annotation (Line(points={{79,-28},{81,-28},{72,-28},{72,-2},{70,-2}},
                                                       color={0,0,127}));
  connect(TLoa.y, loa.T_in)
    annotation (Line(points={{-79,0},{-74,0},{-74,24},{-68,24}},
                                                            color={0,0,127}));
  connect(sin2.ports[1], heaPum.port_b2) annotation (Line(points={{-60,-40},{
          -20,-40},{-20,-6},{-10,-6}}, color={0,127,255}));
  connect(loa.ports[1], heaPum.port_a1) annotation (Line(points={{-46,20},{-20,
          20},{-20,6},{-10,6}}, color={0,127,255}));
  connect(heaPum.port_b1, sin1.ports[1]) annotation (Line(points={{10,6},{20,6},
          {20,20},{48,20}}, color={0,127,255}));
  connect(heaPum.port_a2, sou.ports[1])
    annotation (Line(points={{10,-6},{48,-6}}, color={0,127,255}));
  annotation (    __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/Validation/ScrollWaterToWater_VariableSpeed.mos"
        "Simulate and plot"),
    experiment(
      Tolerance=1e-6, StopTime=1000),
    Documentation(info="<html>
<p>
Model that demonstrates the use of the
<a href=\"modelica://Buildings.Fluid.HeatPumps.ScrollWaterToWater\">
Buildings.Fluid.HeatPumps.ScrollWaterToWater</a> heat pump model.
</p>
<p>
With constant inlet source and load water temperatures, the compressor frequency
is increased linearly to its full load value.
</p>
</html>", revisions="<html>
<ul>
<li>
November 11, 2016, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end ScrollWaterToWater_VariableSpeed;

within Buildings.Fluid.HeatPumps.Validation;
model ReciprocatingWaterToWater_VariableSpeed
  "Test model for reciprocating water to water heat pump"
  import Buildings;
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
    redeclare package Medium = Medium2, nPorts=1)
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        origin={-48,-48})));
  Buildings.Fluid.Sources.FixedBoundary sin1(
    redeclare package Medium = Medium1, nPorts=1)
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        origin={50,40})));
  Modelica.Fluid.Sensors.Temperature eva_in(
    redeclare package Medium = Medium2)
    annotation (Placement(transformation(extent={{18,-60},{38,-40}})));
  Modelica.Fluid.Sensors.Temperature eva_out(
    redeclare package Medium = Medium2)
    annotation (Placement(transformation(extent={{-22,-60},{-2,-40}})));
  Modelica.Fluid.Sensors.Temperature con_in(
    redeclare package Medium = Medium1)
    annotation (Placement(transformation(extent={{-22,60},{-2,80}})));
  Modelica.Fluid.Sensors.Temperature con_out(
    redeclare package Medium = Medium1)
    annotation (Placement(transformation(extent={{10,60},{30,80}})));
  Modelica.Fluid.Sources.MassFlowSource_T loa(
    redeclare package Medium = Medium1,
    m_flow=Flow_Load,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=2)
    annotation (Placement(transformation(extent={{-60,-4},{-40,16}})));
  Modelica.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium2,
    m_flow=Flow_Source,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=2)
    annotation (Placement(transformation(extent={{60,-16},{40,4}})));
  Modelica.Blocks.Sources.RealExpression mLoa(y=Flow_Load)
    annotation (Placement(transformation(extent={{-100,4},{-80,24}})));
  Modelica.Blocks.Sources.RealExpression mSou(y=Flow_Source)
    annotation (Placement(transformation(extent={{100,-8},{80,12}})));
  Buildings.Fluid.HeatPumps.ReciprocatingWaterToWater heaPum(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    dp1_nominal=1000,
    dp2_nominal=1000,
    redeclare package ref =
        Buildings.Fluid.Chillers.Compressors.Refrigerants.R410A,
    pisDis=0.00162,
    cleFac=0.0690,
    etaEle=0.696,
    dTSup=9.82,
    UACon=2210,
    UAEva=1540,
    PLos=100,
    pDro=99290)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Ramp N(
    duration=800,
    startTime=100,
    height=1.0,
    offset=0.0)
    annotation (Placement(transformation(extent={{-52,-26},{-40,-14}})));
  Modelica.Blocks.Sources.Constant TLoa(k=285.15)
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Modelica.Blocks.Sources.Constant TSou(k=283.15)
    annotation (Placement(transformation(extent={{100,-40},{80,-20}})));
equation
  connect(mSou.y, sou.m_flow_in)
    annotation (Line(points={{79,2},{79,2},{60,2}},          color={0,0,127}));
  connect(mLoa.y, loa.m_flow_in) annotation (Line(points={{-79,14},{-79,14},{
          -60,14}},      color={0,0,127}));
  connect(heaPum.port_a2, sou.ports[1])
    annotation (Line(points={{10,-6},{40,-6},{40,-5.5}}, color={0,127,255}));
  connect(heaPum.port_b1, sin1.ports[1]) annotation (Line(points={{10,6},{20,6},
          {20,40},{40,40}}, color={0,127,255}));
  connect(heaPum.port_a1, loa.ports[1])
    annotation (Line(points={{-10,6},{-40,6},{-40,6.5}}, color={0,127,255}));
  connect(heaPum.port_b2, sin2.ports[1]) annotation (Line(points={{-10,-6},{-20,
          -6},{-20,-48},{-38,-48}}, color={0,127,255}));
  connect(con_in.port, loa.ports[2]) annotation (Line(points={{-12,60},{-12,5.5},
          {-40,5.5}}, color={0,127,255}));
  connect(eva_in.port, sou.ports[2]) annotation (Line(points={{28,-60},{20,-60},
          {20,-6.5},{40,-6.5}}, color={0,127,255}));
  connect(eva_out.port, heaPum.port_b2) annotation (Line(points={{-12,-60},{-20,
          -60},{-20,-6},{-10,-6}}, color={0,127,255}));
  connect(con_out.port, heaPum.port_b1) annotation (Line(points={{20,60},{20,60},
          {20,6},{10,6}}, color={0,127,255}));
  connect(N.y, heaPum.N) annotation (Line(points={{-39.4,-20},{-24,-20},{-24,3},
          {-12,3}},color={0,0,127}));
  connect(TSou.y, sou.T_in)
    annotation (Line(points={{79,-30},{79,-30},{86,-30},{70,-30},{70,-2},{62,-2}},
                                                       color={0,0,127}));
  connect(TLoa.y, loa.T_in)
    annotation (Line(points={{-79,-10},{-79,-10},{-70,-10},{-70,10},{-62,10}},
                                                            color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/Validation/ReciprocatingWaterToWater_VariableSpeed.mos"
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
With constant inlet source and load water temperatures, the compressor frequency
is increased linearly to its full load value.
</p>
</html>", revisions="<html>
<ul>
<li>
November 14, 2016, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end ReciprocatingWaterToWater_VariableSpeed;

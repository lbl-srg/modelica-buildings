within Buildings.Fluid.HeatPumps.Validation;
model ScrollWaterToWater
  "Test model for scroll water to water heat pump"
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
        origin={-70,-40})));
  Buildings.Fluid.Sources.FixedBoundary sin1(
    redeclare package Medium = Medium1, nPorts=1)
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        origin={50,40})));
  Modelica.Blocks.Sources.Constant          isOn(k=1)
    annotation (Placement(transformation(extent={{-52,-26},{-40,-14}})));
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
  Buildings.Fluid.HeatPumps.ScrollWaterToWater heaPum(
    redeclare package Medium1 =
        Medium1,
    redeclare package Medium2 =
        Medium2,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    dp1_nominal=1000,
    dp2_nominal=1000,
    redeclare package ref =
        Buildings.Fluid.Chillers.Compressors.Refrigerants.R410A,
    UACon=4400,
    UAEva=4400,
    volRat=2,
    v_flow=0.003,
    leaCoe=0.01,
    etaEle=0.696,
    PLos=500,
    dTSup=10,
    enable_variable_speed=false)
              annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Ramp yLoa(
    height=20,
    duration=750,
    offset=293.15,
    startTime=250)
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Modelica.Blocks.Sources.Ramp ySou(
    height=20,
    duration=750,
    offset=283.15,
    startTime=0)
    annotation (Placement(transformation(extent={{100,-40},{80,-20}})));
equation
  connect(mSou.y, sou.m_flow_in)
    annotation (Line(points={{79,2},{80,2},{60,2}},          color={0,0,127}));
  connect(mLoa.y, loa.m_flow_in) annotation (Line(points={{-79,14},{-60,14}},
                         color={0,0,127}));
  connect(heaPum.port_a2, sou.ports[1])
    annotation (Line(points={{10,-6},{40,-6},{40,-5.5}}, color={0,127,255}));
  connect(heaPum.port_b1, sin1.ports[1]) annotation (Line(points={{10,6},{20,6},
          {20,40},{40,40}}, color={0,127,255}));
  connect(heaPum.port_a1, loa.ports[1])
    annotation (Line(points={{-10,6},{-40,6},{-40,6.5}}, color={0,127,255}));
  connect(heaPum.port_b2, sin2.ports[1]) annotation (Line(points={{-10,-6},{-20,
          -6},{-20,-40},{-60,-40}}, color={0,127,255}));
  connect(con_in.port, loa.ports[2]) annotation (Line(points={{-12,60},{-12,5.5},
          {-40,5.5}}, color={0,127,255}));
  connect(eva_in.port, sou.ports[2]) annotation (Line(points={{28,-60},{20,-60},
          {20,-6.5},{40,-6.5}}, color={0,127,255}));
  connect(yLoa.y, loa.T_in) annotation (Line(points={{-79,-10},{-68,-10},{-68,
          10},{-62,10}}, color={0,0,127}));
  connect(ySou.y, sou.T_in) annotation (Line(points={{79,-30},{72,-30},{72,-2},
          {62,-2}}, color={0,0,127}));
  connect(eva_out.port, heaPum.port_b2) annotation (Line(points={{-12,-60},{-20,
          -60},{-20,-6},{-10,-6}}, color={0,127,255}));
  connect(con_out.port, heaPum.port_b1) annotation (Line(points={{20,60},{20,60},
          {20,6},{10,6}}, color={0,127,255}));
  connect(isOn.y, heaPum.N) annotation (Line(points={{-39.4,-20},{-32,-20},{-32,
          3},{-12,3}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/Validation/ScrollWaterToWater.mos"
        "Simulate and plot"),
    experiment(
      StopTime=1000),
    Documentation(info="<html>
<p>
Model that demonstrates the use of the
<a href=\"modelica://Buildings.Fluid.HeatPumps.ScrollWaterToWater\">
Buildings.Fluid.HeatPumps.ScrollWaterToWater</a> heat pump model.
</p>
<p>
The heat pump power, condenser heat transfer rate and evaporator heat transfer
rate are calculated for given water temperatures and flow rates on the
evaporator and condenser sides.
</p>
</html>", revisions="<html>
<ul>
<li>
October 18, 2016, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end ScrollWaterToWater;

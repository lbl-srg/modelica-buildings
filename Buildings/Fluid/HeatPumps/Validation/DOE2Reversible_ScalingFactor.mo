within Buildings.Fluid.HeatPumps.Validation;
model DOE2Reversible_ScalingFactor
  "Test model for scaling up the reversible DOE2 heat pump"
 extends Modelica.Icons.Example;
 package Medium = Buildings.Media.Water "Medium model";

  parameter Data.DOE2Reversible.EnergyPlus per
    "Reverse heat pump performance data"
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  parameter Modelica.SIunits.MassFlowRate mSou_flow_nominal=per.m2_flow_nominal
    "Source heat exchanger nominal mass flow rate";
  parameter Modelica.SIunits.MassFlowRate mLoa_flow_nominal=per.m1_flow_nominal
    "Load heat exchanger nominal mass flow rate";
  parameter Real scaling_factor=2
    "Scaling factor for heat pump capacity";

  Buildings.Fluid.Sources.Boundary_pT sin2(
    redeclare package Medium = Medium, nPorts=2)
    "Source side sink"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}}, origin={-50,0})));
  Buildings.Fluid.Sources.Boundary_pT sin1(
    redeclare package Medium = Medium, nPorts=2)
    "Load side sink"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}}, origin={40,0})));
  Modelica.Fluid.Sources.MassFlowSource_T loa(
    redeclare package Medium = Medium,
    m_flow=mLoa_flow_nominal,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1)
    "Load side flow source"
    annotation (Placement(transformation(extent={{-60,32},{-40,52}})));
  Modelica.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    m_flow=mSou_flow_nominal,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1)
    "Source side flow source"
    annotation (Placement(transformation(extent={{46,34},{26,54}})));
  Buildings.Fluid.HeatPumps.DOE2Reversible heaPum(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    per=per,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Equation fit reverse heat pump"
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));
  Buildings.Fluid.HeatPumps.DOE2Reversible heaPum1(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    per=per,
    scaling_factor=scaling_factor,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Scaled equation fit reverse heat pump"
    annotation (Placement(transformation(extent={{-10,-64},{10,-44}})));
  Modelica.Fluid.Sources.MassFlowSource_T loa1(
    redeclare package Medium = Medium,
    m_flow=mLoa_flow_nominal,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1)
    "Load side flow source"
    annotation (Placement(transformation(extent={{-60,-58},{-40,-38}})));
  Modelica.Fluid.Sources.MassFlowSource_T sou1(
    redeclare package Medium = Medium,
    m_flow=mSou_flow_nominal,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1)
    "Source side flow source"
    annotation (Placement(transformation(extent={{50,-70},{30,-50}})));
  Modelica.Blocks.Sources.Constant TLoa(k=30 + 273.15)
    "Load side fluid temperature"
    annotation (Placement(transformation(extent={{-100,-22},{-80,-2}})));
  Modelica.Blocks.Sources.Constant TSou(k=11 + 273.15)
    "Source side fluid temperature"
    annotation (Placement(transformation(extent={{92,-90},{72,-70}})));
  Modelica.Blocks.Sources.RealExpression capErr(y=(heaPum1.QLoa_flow -
        scaling_factor*heaPum.QLoa_flow))
    "Apparent capacity of the heat pump"
    annotation (Placement(transformation(extent={{70,70},{90,90}})));
  Modelica.Blocks.Sources.RealExpression mLoa(y=mLoa_flow_nominal)
    "Load side mass flwo rate"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Modelica.Blocks.Sources.RealExpression mSou(y=mSou_flow_nominal)
    "Source side mass flow rate"
    annotation (Placement(transformation(extent={{92,42},{72,62}})));
  Modelica.Blocks.Math.RealToInteger reaToInt
    "Real to integer conversion"
    annotation (Placement(transformation(extent={{-58,-90},{-38,-70}})));
  Controls.OBC.CDL.Continuous.Sources.Ramp TSetHea(
    height=1,
    duration(displayUnit="h") = 14400,
    offset=35 + 273.15,
    startTime=0) "Load side setpoint water temperature in heating mode"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Modelica.Blocks.Sources.Pulse uMod(
    amplitude=1,
    width=70,
    period=500,
    offset=0,
    startTime=0) "Heat pump signal to operate in heating mode"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
  Modelica.Blocks.Sources.RealExpression mSou1(y=
    mSou_flow_nominal*scaling_factor)
    "Source side mass flow rate"
    annotation (Placement(transformation(extent={{90,-62},{70,-42}})));
  Modelica.Blocks.Sources.RealExpression mLoa1(y=
    mLoa_flow_nominal*scaling_factor)
    "Load side mass flwo rate"
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TEvaLvgMin(k=6 + 273.15)
    "Minimum evaporator leaving water temperature "
      annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TEvaLvgMax(k=10 + 273.15)
    "Maximum evaporator leaving water temperature"
      annotation (Placement(transformation(extent={{-100,86},{-80,106}})));
equation
  connect(heaPum.port_a2, sou.ports[1])
    annotation (Line(points={{10,44},{26,44}},color={0,127,255}));
  connect(heaPum.port_b1, sin1.ports[1])
    annotation (Line(points={{10,56},{20,56},{20,2},{30,2}},color={0,127,255}));
  connect(heaPum.port_a1, loa.ports[1])
    annotation (Line(points={{-10,56},{-24,56},{-24,42},{-40,42}},color={0,127,255}));
  connect(heaPum.port_b2, sin2.ports[1])
    annotation (Line(points={{-10,44},{-20,44},{-20,2},{-40,2}},color={0,127,255}));
  connect(sin2.ports[2], heaPum1.port_b2)
    annotation (Line(points={{-40,-2},{-20,-2},{-20,-60},{-10,-60}}, color={0,127,255}));
  connect(sou1.ports[1], heaPum1.port_a2)
    annotation (Line(points={{30,-60},{10,-60}},          color={0,127,255}));
  connect(TSou.y, sou1.T_in)
    annotation (Line(points={{71,-80},{60,-80},{60,-56},{52,-56}}, color={0,0,127}));
  connect(sou.T_in, sou1.T_in)
    annotation (Line(points={{48,48},{60,48},{60,-56},{52,-56}}, color={0,0,127}));
  connect(TLoa.y, loa1.T_in)
    annotation (Line(points={{-79,-12},{-72,-12},{-72,-44},{-62,-44}}, color={0,0,127}));
  connect(TLoa.y, loa.T_in)
    annotation (Line(points={{-79,-12},{-72,-12},{-72,46},{-62,46}}, color={0,0,127}));
  connect(loa1.ports[1], heaPum1.port_a1)
    annotation (Line(points={{-40,-48},{-10,-48}},                    color={0,127,255}));
  connect(heaPum1.port_b1, sin1.ports[2])
    annotation (Line(points={{10,-48},{20,-48},{20,-2},{30,-2}}, color={0,127,255}));
  connect(mLoa.y, loa.m_flow_in)
    annotation (Line(points={{-79,70},{-68,70},{-68,50},{-60,50}},
                                                color={0,0,127}));
  connect(mSou.y, sou.m_flow_in)
    annotation (Line(points={{71,52},{46,52}},color={0,0,127}));
  connect(TSetHea.y, heaPum.TSet) annotation (Line(points={{-38,80},{-30,80},{-30,
          60},{-11,60},{-11,59}}, color={0,0,127}));
  connect(reaToInt.y, heaPum.uMod)
    annotation (Line(points={{-37,-80},{-16,-80},{-16,53},{-11,53}},color={255,127,0}));
  connect(reaToInt.y, heaPum1.uMod)
    annotation (Line(points={{-37,-80},{-16,-80},{-16,-51},{-11,-51}},color={255,127,0}));
  connect(reaToInt.u, uMod.y)
    annotation (Line(points={{-60,-80},{-79,-80}}, color={0,0,127}));
  connect(TSetHea.y, heaPum1.TSet) annotation (Line(points={{-38,80},{-30,80},{-30,
          -45},{-11,-45}}, color={0,0,127}));
  connect(sou1.m_flow_in, mSou1.y)
    annotation (Line(points={{50,-52},{69,-52}},                  color={0,0,127}));
  connect(loa1.m_flow_in, mLoa1.y)
    annotation (Line(points={{-60,-40},{-79,-40}},                    color={0,0,127}));
  connect(heaPum.TSouMaxLvg,TEvaLvgMax. y)
    annotation (Line(points={{-11,50},{-22,50},{-22,96},{-78,96}},
                               color={0,0,127}));
  connect(heaPum.TSouMinLvg,TEvaLvgMin. y)
    annotation (Line(points={{-11,47},{-22,47},{-22,30},{-78,30}},
                                 color={0,0,127}));
  connect(TEvaLvgMax.y, heaPum1.TSouMaxLvg)
    annotation (Line(points={{-78,96},{-22,
          96},{-22,-54},{-11,-54}}, color={0,0,127}));
  connect(TEvaLvgMin.y, heaPum1.TSouMinLvg)
    annotation (Line(points={{-78,30},{-24,
          30},{-24,-57},{-11,-57}}, color={0,0,127}));
annotation (    __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/Validation/DOE2Reversible_ScalingFactor.mos"
        "Simulate and plot"),
    experiment(StopTime=1500, Tolerance=1e-06),
    Documentation(info="<html>
<p>
Model that demonstrates the use of the
<a href=\"modelica://Buildings.Fluid.HeatPumps.DOE2Reversible\">
Buildings.Fluid.HeatPumps.DOE2Reversible</a> heat pump model. This
validation case also tests scaling the heat pump model.
</p>
<p>
The capacity, pressure drop and coefficient of performance
of the scaled heat pump model are compared to the values
of the non-scaled model.
</p>
</html>", revisions="<html>
<ul>
<li>
February 10, 2020, by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-120,-120},{120,120}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end DOE2Reversible_ScalingFactor;

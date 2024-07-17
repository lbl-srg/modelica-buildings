within Buildings.Fluid.CHPs.OrganicRankine.Validation;
model VariableSource
  "ORC with waste heat stream with variable flow rate and temperature"
  extends Modelica.Icons.Example;

  package MediumHot = Buildings.Media.Air "Evaporator hot fluid";
  package MediumCol = Buildings.Media.Water "Condenser cold fluid";

  parameter Buildings.Fluid.CHPs.OrganicRankine.Data.WorkingFluids.R245fa pro
    "Property record of the working fluid"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  parameter Modelica.Units.SI.MassFlowRate mHot_flow_nominal = 1
    "Nominal mass flow rate of evaporator hot fluid";
  parameter Modelica.Units.SI.MassFlowRate mCol_flow_nominal = 1
    "Nominal mass flow rate of condenser cold fluid";

  Buildings.Fluid.CHPs.OrganicRankine.Cycle orc(
    redeclare package Medium1 = MediumHot,
    redeclare package Medium2 = MediumCol,
    pro=pro,
    tau1=0,
    tau2=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    T1_start(displayUnit="K") = 350,
    T2_start(displayUnit="K") = 290,
    dpHot_nominal = 0,
    dpCol_nominal = 0,
    mHot_flow_nominal=mHot_flow_nominal,
    mCol_flow_nominal=mCol_flow_nominal,
    mWor_flow_max =
      3E4 / (
        Buildings.Utilities.Math.Functions.smoothInterpolation(
          x = orc.TWorEva,
          xSup = pro.T,
          ySup = pro.hSatVap) -
        Buildings.Utilities.Math.Functions.smoothInterpolation(
          x = 300,
          xSup = pro.T,
          ySup = pro.hSatLiq)),
    mWor_flow_min = orc.mWor_flow_max * 0.2,
    TWorEva=350,
    etaExp=0.7,
    etaPum=0.7) "Organic Rankine cycle"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Fluid.Sources.MassFlowSource_T souHot(
    redeclare final package Medium = MediumHot,
    m_flow=mHot_flow_nominal,
    T=orc.TWorEva + 20,
    nPorts=1,
    use_m_flow_in=true,
    use_T_in=true) "Evaporator hot fluid source"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Fluid.Sources.Boundary_pT sinHot(
    redeclare final package Medium = MediumHot,
    nPorts=1) "Evaporator hot fluid sink"
    annotation (Placement(transformation(extent={{80,20},{60,40}})));
  Buildings.Fluid.Sources.MassFlowSource_T souCol(
    redeclare final package Medium = MediumCol,
    m_flow=mCol_flow_nominal,
    nPorts=1) "Condenser cold fluid source"
    annotation (Placement(transformation(extent={{40,-40},{20,-20}})));
  Buildings.Fluid.Sources.Boundary_pT sinCol(
    redeclare final package Medium = MediumCol,
    nPorts=1) "Condenser cold fluid sink"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort THotOut(
    redeclare final package Medium = MediumHot,
    final m_flow_nominal=mHot_flow_nominal,
    tau=0) "Outgoing temperature of evaporator hot fluid"
    annotation (Placement(transformation(extent={{30,20},{50,40}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TColOut(
    redeclare final package Medium = MediumCol,
    final m_flow_nominal=mCol_flow_nominal,
    tau=0) "Outgoing temperature of condenser cold fluid"
    annotation (Placement(transformation(extent={{-30,-40},{-50,-20}})));

  Modelica.Blocks.Sources.BooleanConstant tru(k=true) "Constant true"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  Modelica.Blocks.Sources.TimeTable mHot_flow_set(table=[
    0,0;
    20,0;
    50,mHot_flow_nominal*1.5;
    250,mHot_flow_nominal*1.5;
    280,0;
    300,0])
    "Sets the hot fluid flow rate in the evaporator"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.TimeTable THotIn_set(table=[
    0,orc.TWorEva + 20;
    100,orc.TWorEva + 20;
    150,orc.TWorEva - 5;
    200,orc.TWorEva + 20;
    300,orc.TWorEva + 20])
    "Sets the hot fluid incoming temperature in the evaporator"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
equation
  connect(souHot.ports[1],orc. port_a1) annotation (Line(points={{-20,30},{-16,30},
          {-16,6},{-10,6}}, color={0,127,255}));
  connect(souCol.ports[1],orc. port_a2) annotation (Line(points={{20,-30},{16,-30},
          {16,-6},{10,-6}}, color={0,127,255}));
  connect(sinHot.ports[1],THotOut. port_b)
    annotation (Line(points={{60,30},{50,30}}, color={0,127,255}));
  connect(THotOut.port_a,orc. port_b1) annotation (Line(points={{30,30},{16,30},
          {16,6},{10,6}}, color={0,127,255}));
  connect(TColOut.port_a,orc. port_b2) annotation (Line(points={{-30,-30},{-16,-30},
          {-16,-6},{-10,-6}}, color={0,127,255}));
  connect(sinCol.ports[1], TColOut.port_b)
    annotation (Line(points={{-60,-30},{-50,-30}}, color={0,127,255}));
  connect(tru.y, orc.ena)
    annotation (Line(points={{-19,0},{-11,0}},color={255,0,255}));
  connect(mHot_flow_set.y, souHot.m_flow_in) annotation (Line(points={{-59,50},{
          -50,50},{-50,38},{-42,38}}, color={0,0,127}));
  connect(THotIn_set.y, souHot.T_in) annotation (Line(points={{-59,10},{-50,10},
          {-50,34},{-42,34}}, color={0,0,127}));
  annotation(experiment(StopTime=300,Tolerance=1E-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/CHPs/OrganicRankine/Validation/VariableSource.mos"
  "Simulate and plot"),
  Documentation(info="<html>
<p>
This model demonstrates how the ORC model reacts to variable flow rate
and temperature of the incoming hot fluid carrying waste heat.
Normally, the working fluid flow rate of the cycle
<i>m&#775;<sub>w</sub></i> is found from
the set point for the evaporator pinch point temperature differential
<i>&Delta;T<sub>pin,eva</sub></i>.
This constraint is relaxed under any of the following two conditions:
</p>
<ul>
<li>
If the hot fluid flow rate or temperature is too high,
i.e. it carries more heat than the cycle can process,
<i>m&#775;<sub>w</sub></i> would exceed its upper limit.
The flow rate <i>m&#775;<sub>w</sub></i> is then fixed at its upper limit and
<i>&Delta;T<sub>pin,eva</sub></i> is allowed higher than its set point.
</li>
<li>
If the hot fluid flow rate or temperature is too low,
i.e. it carries to little heat,
<i>m&#775;<sub>w</sub></i> would be lower than a threshold.
The flow rate <i>m&#775;<sub>w</sub></i> is then set to zero.
This effectively shuts down the cycle and
the set point of <i>&Delta;T<sub>pin,eva</sub></i> is ignored.
</li>
</ul>
</html>",revisions="<html>
<ul>
<li>
January 26, 2024, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3433\">#3433</a>.
</li>
</ul>
</html>"));
end VariableSource;

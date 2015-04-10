within Buildings.Fluid.Movers.Validation;
model Power "Power calculation comparison among three mover types"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Medium model";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=3
    "Nominal mass flow rate";

  parameter Data.Pumps.Wilo.Stratos30slash1to8 per "Pump performance data"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));

  parameter Data.FlowControlled perMod(
    use_powerCharacteristic = true,
    hydraulicEfficiency=efficiency,
    motorEfficiency=efficiency,
    power=per.power)
    "Pump performance data with data from the instance efficiency"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));

  // Compute the actual efficiencies
  parameter
    Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters
    efficiency(V_flow=per.pressure.V_flow, eta=sqrt(per.pressure.V_flow.*per.pressure.dp./
    {Buildings.Fluid.Movers.BaseClasses.Characteristics.power(
      per=per.power,
      V_flow=i,
      r_N=1,
      delta=0.01,
      d=Buildings.Utilities.Math.Functions.splineDerivatives(
      x=per.power.V_flow,
      y=per.power.P))
      for i in per.pressure.V_flow})) "Hydraulic and motor efficiency";

  Buildings.Fluid.Movers.SpeedControlled_Nrpm pump_Nrpm(
    redeclare package Medium = Medium,
    per=per,
    filteredSpeed=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial)
    "Pump with RPM as control signal"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Fluid.Movers.FlowControlled_dp  pump_dp(
    redeclare package Medium = Medium,
    per=perMod,
    filteredSpeed=false,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial)
    "Pump with pressure rise as control signal"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pump_m_flow(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    per=perMod,
    filteredSpeed=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial)
    "Pump with mass flow rate as control signal"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));

  Buildings.Fluid.Sources.Boundary_pT bou(
    nPorts=3,
    redeclare package Medium = Medium) "Pressure source"
    annotation (Placement(transformation(extent={{-102,10},{-82,30}})));

  Buildings.Fluid.FixedResistances.FixedResistanceDpM[3] res(
    redeclare each package Medium = Medium,
    each m_flow_nominal=m_flow_nominal,
    each dp_nominal=40000) "Flow resistance"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Buildings.Fluid.Sources.Boundary_pT sink(
    nPorts=3,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{100,10},{80,30}})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=100,
    startTime=10,
    height=1000,
    offset=2400) "Ramp for pump speed control signal"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Modelica.Blocks.Sources.RealExpression dpSet(y=pump_Nrpm.port_b.p - pump_Nrpm.port_a.p)
    "Pressure rise across pump"
    annotation (Placement(transformation(extent={{82,30},{6,50}})));
  Modelica.Blocks.Sources.RealExpression m_flowSet(y=pump_Nrpm.port_a.m_flow)
    "Pump mass flow rate"
    annotation (Placement(transformation(extent={{82,-10},{6,10}})));
  Modelica.Blocks.Routing.Multiplex3 result
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
equation
  connect(bou.ports[1], pump_Nrpm.port_a) annotation (Line(
      points={{-82,22.6667},{-82,60},{-60,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pump_dp.port_a, bou.ports[2]) annotation (Line(
      points={{-60,20},{-82,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pump_m_flow.port_a, bou.ports[3]) annotation (Line(
      points={{-60,-20},{-82,-20},{-82,17.3333}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pump_Nrpm.port_b, res[1].port_a) annotation (Line(
      points={{-40,60},{0,60},{0,20},{20,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pump_dp.port_b, res[2].port_a) annotation (Line(
      points={{-40,20},{20,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pump_m_flow.port_b, res[3].port_a) annotation (Line(
      points={{-40,-20},{0,-20},{0,20},{20,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sink.ports[1:3], res.port_b) annotation (Line(
      points={{80,17.3333},{60,17.3333},{60,20},{40,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(ramp.y, pump_Nrpm.Nrpm) annotation (Line(
      points={{-59,80},{-50,80},{-50,72}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_flowSet.y, pump_m_flow.m_flow_in) annotation (Line(
      points={{2.2,0},{-50.2,0},{-50.2,-8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(result.u1[1], pump_Nrpm.P) annotation (Line(
      points={{18,-43},{-30,-43},{-30,68},{-39,68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(result.u2[1], pump_dp.P) annotation (Line(
      points={{18,-50},{-30,-50},{-30,28},{-39,28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(result.u3[1], pump_m_flow.P) annotation (Line(
      points={{18,-57},{-30,-57},{-30,-12},{-39,-12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dpSet.y, pump_dp.dp_in) annotation (Line(
      points={{2.2,40},{-50.2,40},{-50.2,32}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (    experiment(StopTime=200),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Movers/Validation/Power.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example compares the power consumed by pumps that
take three different control signals.
Each pump has identical mass flow rate and pressure rise.
</p>
<p>
Note that for the instances
<a href=\"modelica://Buildings.Fluid.Movers.FlowControlled_dp\">
Buildings.Fluid.Movers.FlowControlled_dp</a>
and
<a href=\"modelica://Buildings.Fluid.Movers.FlowControlled_m_flow\">
Buildings.Fluid.Movers.FlowControlled_m_flow</a>,
we had to assign the efficiencies (otherwise the default constant
efficiency of <i>0.7</i> would have been used).
We also had to set <code>use_powerCharacteristic=true</code>.
Otherwise, the power consumption would have been computed
using similarity laws, but using the mass flow rate as opposed
to the speed, because speed is not known in these two models.
This would yield an error at operating points in which
the speed is different from the nominal speed <code>N_nominal</code>
because similarity laws are valid for speed and not for
mass flow rate.
To see the error, change the assignment
</p>
<pre>
  parameter Data.FlowControlled perMod(
    use_powerCharacteristic = true,
    hydraulicEfficiency=efficiency,
    motorEfficiency=efficiency,
    power=per.power)
    \"Pump performance data with data from the instance efficiency\";
</pre>
<p>
to
</p>
<pre>
  parameter Data.FlowControlled perMod
    \"Pump performance data with data from the instance efficiency\";
</pre>
</html>", revisions="<html>
<ul>
<li>
November 22, 2014, by Michael Wetter:<br/>
Revised implementation.
</li>
</ul>
</html>"));
end Power;

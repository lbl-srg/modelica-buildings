within Buildings.Fluid.Movers.Validation;
model PowerSimplified
  "Power calculation comparison among three mover types, using simplified power computation for m_flow and dp"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Medium model";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=3
    "Nominal mass flow rate";

  parameter Data.Pumps.Wilo.Stratos30slash1to8 per "Pump performance data"
    annotation (Placement(transformation(extent={{50,60},{70,80}})));

  Buildings.Fluid.Movers.SpeedControlled_Nrpm pump_Nrpm(
    redeclare package Medium = Medium,
    per=per,
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial)
    "Pump with RPM as control signal"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Fluid.Movers.FlowControlled_dp pump_dp(
    redeclare package Medium = Medium,
    redeclare Data.Pumps.Wilo.Stratos30slash1to8 per(
      pressure(V_flow={0,0}, dp={0,0}),
      use_powerCharacteristic=false,
      hydraulicEfficiency(V_flow={0}, eta={0.3577}),
      motorEfficiency(V_flow={0}, eta={1})),
    use_inputFilter=false,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial)
    "Pump with pressure rise as control signal"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pump_m_flow(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    redeclare Data.Pumps.Wilo.Stratos30slash1to8 per(
      pressure(V_flow={0,0}, dp={0,0}),
      use_powerCharacteristic=false,
      hydraulicEfficiency(V_flow={0}, eta={0.3577}),
      motorEfficiency(V_flow={0}, eta={1})),
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial)
    "Pump with mass flow rate as control signal"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));

  Buildings.Fluid.Sources.Boundary_pT bou(
    nPorts=3,
    redeclare package Medium = Medium) "Pressure source"
    annotation (Placement(transformation(extent={{-102,10},{-82,30}})));

  Buildings.Fluid.FixedResistances.PressureDrop[3] res(
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
      points={{-82,18.6667},{-82,60},{-60,60}},
      color={0,127,255}));
  connect(pump_dp.port_a, bou.ports[2]) annotation (Line(
      points={{-60,20},{-82,20}},
      color={0,127,255}));
  connect(pump_m_flow.port_a, bou.ports[3]) annotation (Line(
      points={{-60,-20},{-82,-20},{-82,21.3333}},
      color={0,127,255}));
  connect(pump_Nrpm.port_b, res[1].port_a) annotation (Line(
      points={{-40,60},{0,60},{0,20},{20,20}},
      color={0,127,255}));
  connect(pump_dp.port_b, res[2].port_a) annotation (Line(
      points={{-40,20},{20,20}},
      color={0,127,255}));
  connect(pump_m_flow.port_b, res[3].port_a) annotation (Line(
      points={{-40,-20},{0,-20},{0,20},{20,20}},
      color={0,127,255}));
  connect(sink.ports[1:3], res.port_b) annotation (Line(
      points={{80,21.3333},{60,21.3333},{60,20},{40,20}},
      color={0,127,255}));
  connect(ramp.y, pump_Nrpm.Nrpm) annotation (Line(
      points={{-59,80},{-50,80},{-50,72}},
      color={0,0,127}));
  connect(m_flowSet.y, pump_m_flow.m_flow_in) annotation (Line(
      points={{2.2,0},{-50,0},{-50,-8}},
      color={0,0,127}));
  connect(result.u1[1], pump_Nrpm.P) annotation (Line(
      points={{18,-43},{-30,-43},{-30,69},{-39,69}},
      color={0,0,127}));
  connect(result.u2[1], pump_dp.P) annotation (Line(
      points={{18,-50},{-30,-50},{-30,29},{-39,29}},
      color={0,0,127}));
  connect(result.u3[1], pump_m_flow.P) annotation (Line(
      points={{18,-57},{-30,-57},{-30,-11},{-39,-11}},
      color={0,0,127}));
  connect(dpSet.y, pump_dp.dp_in) annotation (Line(
      points={{2.2,40},{-50,40},{-50,32}},
      color={0,0,127}));
  annotation (    experiment(Tolerance=1e-6, StopTime=200),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Movers/Validation/PowerSimplified.mos"
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
In these models, the power consumption is computed
using similarity laws, but using the mass flow rate as opposed
to the speed, because speed is not known in these two models.
This is an approximation at operating points in which
the speed is different from the nominal speed <code>N_nominal</code>
because similarity laws are valid for speed and not for
mass flow rate.
</p>
<p>
The figure below shows the approximation error for the
power calculation where the speed <i>N<sub>rpm</sub></i> differs from
the nominal speed <i>N<sub>nominal</sub></i>.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Movers/Validation/PowerSimplified.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
October 15, 2021, by Hongxiang Fu:<br/>
Fixed the image in the documentation which was cut off
at the <i>y</i>-axis. This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1533\">IBPSA, #1533</a>.
</li>
<li>
March 11, 2016, by Michael Wetter:<br/>
Revised implementation by assigning the data record directly in the
instances <code>pump_dp</code> and <code>pump_m_flow</code>, because
using a <code>parameter</code> and assigning this <code>parameter</code> leads
in OpenModelica to the error message
<code>expected subtype of record Buildings.Fluid.Movers.Data.Generic</code>.
</li>
<li>
March 2, 2016, by Filip Jorissen:<br/>
Revised implementation for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/417\">#417</a>.
</li>
<li>
November 5, 2015, by Michael Wetter:<br/>
Changed parameters since the power is no longer a parameter for the movers
that take mass flow rate or head as an input.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/457\">issue 457</a>.
</li>
<li>
November 22, 2014, by Michael Wetter:<br/>
Revised implementation.
</li>
</ul>
</html>"));
end PowerSimplified;

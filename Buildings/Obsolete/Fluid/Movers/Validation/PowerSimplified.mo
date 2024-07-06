within Buildings.Obsolete.Fluid.Movers.Validation;
model PowerSimplified
  "Power calculation comparison among three mover types, using simplified power computation for m_flow and dp"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Medium model";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=3
    "Nominal mass flow rate";

  parameter Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos30slash1to8 per
    "Pump performance data"
    annotation (Placement(transformation(extent={{50,40},{70,60}})));

  Buildings.Fluid.Movers.SpeedControlled_y pump_y(
    redeclare package Medium = Medium,
    per=per,
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial)
    "Pump with normalised speed y as control signal"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Fluid.Movers.FlowControlled_dp pump_dp(
    redeclare package Medium = Medium,
    redeclare Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos30slash1to8 per(
      pressure(V_flow={0,0}, dp={0,0}),
      etaHydMet=Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.Efficiency_VolumeFlowRate,
      etaMotMet=Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.Efficiency_VolumeFlowRate,
      efficiency(V_flow={0}, eta={0.3577}),
      motorEfficiency(V_flow={0}, eta={1})),
    use_inputFilter=false,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial)
    "Pump with pressure rise as control signal"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  Buildings.Fluid.Movers.FlowControlled_m_flow pump_m_flow(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    redeclare Buildings.Fluid.Movers.Data.Pumps.Wilo.Stratos30slash1to8 per(
      pressure(V_flow={0,0}, dp={0,0}),
      etaHydMet=Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.Efficiency_VolumeFlowRate,
      etaMotMet=Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.Efficiency_VolumeFlowRate,
      efficiency(V_flow={0}, eta={0.3577}),
      motorEfficiency(V_flow={0}, eta={1})),
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial)
    "Pump with mass flow rate as control signal"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));

  Buildings.Fluid.Sources.Boundary_pT bou(
    nPorts=3,
    redeclare package Medium = Medium) "Pressure source"
    annotation (Placement(transformation(extent={{-102,-10},{-82,10}})));

  Buildings.Fluid.FixedResistances.PressureDrop[3] res(
    redeclare each package Medium = Medium,
    each m_flow_nominal=m_flow_nominal,
    each dp_nominal=40000) "Flow resistance"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Fluid.Sources.Boundary_pT sink(
    nPorts=3,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{100,-10},{80,10}})));
  Modelica.Blocks.Sources.Ramp y(
    y(unit="1"),
    duration=100,
    startTime=10,
    height=(3400 - 2400)/3040,
    offset=2400/3040) "Ramp for pump normalised speed control signal"
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));
  Modelica.Blocks.Sources.RealExpression dpSet(y=pump_y.port_b.p - pump_y.port_a.p)
    "Pressure rise across pump"
    annotation (Placement(transformation(extent={{82,10},{6,30}})));
  Modelica.Blocks.Sources.RealExpression m_flowSet(y=pump_y.port_a.m_flow)
    "Pump mass flow rate"
    annotation (Placement(transformation(extent={{82,-30},{6,-10}})));
  Modelica.Blocks.Routing.Multiplex3 result
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
equation
  connect(bou.ports[1], pump_y.port_a) annotation (Line(points={{-82,-1.33333},{
          -82,40},{-60,40}}, color={0,127,255}));
  connect(pump_dp.port_a, bou.ports[2]) annotation (Line(
      points={{-60,0},{-82,0}},
      color={0,127,255}));
  connect(pump_m_flow.port_a, bou.ports[3]) annotation (Line(
      points={{-60,-40},{-82,-40},{-82,1.33333}},
      color={0,127,255}));
  connect(pump_y.port_b, res[1].port_a) annotation (Line(points={{-40,40},{0,40},
          {0,0},{20,0}}, color={0,127,255}));
  connect(pump_dp.port_b, res[2].port_a) annotation (Line(
      points={{-40,0},{20,0}},
      color={0,127,255}));
  connect(pump_m_flow.port_b, res[3].port_a) annotation (Line(
      points={{-40,-40},{0,-40},{0,0},{20,0}},
      color={0,127,255}));
  connect(sink.ports[1:3], res.port_b) annotation (Line(
      points={{80,1.33333},{60,1.33333},{60,0},{40,0}},
      color={0,127,255}));
  connect(m_flowSet.y, pump_m_flow.m_flow_in) annotation (Line(
      points={{2.2,-20},{-50,-20},{-50,-28}},
      color={0,0,127}));
  connect(result.u1[1], pump_y.P) annotation (Line(points={{18,-63},{-30,-63},{-30,
          49},{-39,49}}, color={0,0,127}));
  connect(result.u2[1], pump_dp.P) annotation (Line(
      points={{18,-70},{-30,-70},{-30,9},{-39,9}},
      color={0,0,127}));
  connect(result.u3[1], pump_m_flow.P) annotation (Line(
      points={{18,-77},{-30,-77},{-30,-31},{-39,-31}},
      color={0,0,127}));
  connect(dpSet.y, pump_dp.dp_in) annotation (Line(
      points={{2.2,20},{-50,20},{-50,12}},
      color={0,0,127}));
  connect(y.y, pump_y.y)
    annotation (Line(points={{-69,80},{-50,80},{-50,52}}, color={0,0,127}));
  annotation (    experiment(Tolerance=1e-6, StopTime=200),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Obsolete/Fluid/Movers/Validation/PowerSimplified.mos"
        "Simulate and plot"),
    obsolete = "Obsolete model - refer to Buildings.Fluid.Movers.Validation.ComparePowerInput",
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
the speed is different from the nominal speed <code>y_nominal</code>
because similarity laws are valid for speed and not for
mass flow rate.
</p>
<p>
The figure below shows the approximation error for the
power calculation where the speed <i>y</i> differs from
the nominal speed <i>y<sub>nominal</sub></i>.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Obsolete/Fluid/Movers/Validation/PowerSimplified.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
May 14, 2024, by Hongxiang Fu:<br/>
Corrected efficiency assignment and moved this model to the Obsolete package.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1880\">IBPSA, #1880</a>.
</li>
<li>
March 21, 2023, by Hongxiang Fu:<br/>
Replaced the pump with <code>Nrpm</code> signal with one with <code>y</code>
signal.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1704\">IBPSA, #1704</a>.
</li>
<li>
March 8, 2022, by Hongxiang Fu:<br/>
Refactored the model by replacing <code>not use_powerCharacteristic</code>
with the enumeration
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod\">
Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod</a>.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">#2668</a>.
</li>
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

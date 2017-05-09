within Buildings.Fluid.Examples.Performance.BaseClasses;
partial model Example1 "Example 1 partial model"
  extends Modelica.Icons.Example;

  package Medium = Modelica.Media.Water.ConstantPropertyLiquidWater;
  parameter Real m_flow_nominal=0.1 "Gain value multiplied with input signal";

  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = Medium,
    nPorts=1) "Boundary for pressure boundary condition"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        origin={-50,20})));
  Fluid.Movers.FlowControlled_m_flow pump(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    use_inputFilter=false,
    allowFlowReversal=allowFlowReversal.k,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nominalValuesDefineDefaultPressureCurve=true)
    "Pump model with unidirectional flow"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Buildings.Fluid.HeatExchangers.Heater_T hea(
    redeclare package Medium = Medium,
    dp_nominal=1000,
    QMax_flow=1000,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal=allowFlowReversal.k) "Heater"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Modelica.Blocks.Sources.Pulse pulse(period=1000) "Pulse input"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Modelica.Blocks.Math.Gain gain(k=m_flow_nominal) "Gain for m_flow_nominal"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Buildings.Fluid.Actuators.Valves.ThreeWayLinear val(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=1000,
    l={0.002,0.002},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    use_inputFilter=false,
    portFlowDirection_1=if allowFlowReversal.k then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=if allowFlowReversal.k then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=if allowFlowReversal.k then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering)
    "Three way valve with constant input"
    annotation (Placement(transformation(extent={{10,20},{30,40}})));
  Modelica.Blocks.Sources.Constant const(k=0.5) "Constant valve set point"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Blocks.Sources.BooleanConstant allowFlowReversal(k=true)
    "Block for setting allowFlowReversal in components"
    annotation (Placement(transformation(extent={{-88,70},{-68,90}})));
  Buildings.Fluid.FixedResistances.PressureDrop[nRes.k] res(
    redeclare package Medium = Medium,
    each allowFlowReversal=allowFlowReversal.k,
    each m_flow_nominal=m_flow_nominal,
    each dp_nominal=1000,
    each from_dp=from_dp.k) "Fluid resistance for splitting flow"
    annotation (Placement(transformation(extent={{70,20},{90,40}})));
  Modelica.Blocks.Sources.IntegerConstant nRes(k=20)
    "Number of parallel branches"
    annotation (Placement(transformation(extent={{-88,10},{-68,30}})));
  Modelica.Blocks.Sources.BooleanConstant from_dp(k=false)
    "Block for setting from_dp in res"
    annotation (Placement(transformation(extent={{-88,40},{-68,60}})));
equation
  connect(bou.ports[1],hea. port_a) annotation (Line(
      points={{-40,20},{-30,20},{-30,30},{-20,30}},
      color={0,127,255}));
  connect(pulse.y,hea. TSet) annotation (Line(
      points={{-39,80},{-30,80},{-30,38},{-24,38},{-24,38},{-22,38},{-22,38}},
      color={0,0,127}));
  connect(pump.m_flow_in, gain.y) annotation (Line(
      points={{49.8,42},{49.8,80},{21,80}},
      color={0,0,127}));
  connect(gain.u,pulse. y) annotation (Line(
      points={{-2,80},{-39,80}},
      color={0,0,127}));
  connect(hea.port_b,val. port_1) annotation (Line(
      points={{0,30},{10,30}},
      color={0,127,255}));
  connect(val.port_2, pump.port_a) annotation (Line(
      points={{30,30},{40,30}},
      color={0,127,255}));
  connect(const.y,val. y) annotation (Line(
      points={{-39,50},{20,50},{20,42}},
      color={0,0,127}));
  connect(val.port_3,hea. port_a) annotation (Line(
      points={{20,20},{20,-10},{-30,-10},{-30,30},{-20,30}},
      color={0,127,255}));
  for i in 1:nRes.k loop
    connect(pump.port_b, res[i].port_a) annotation (Line(
        points={{60,30},{70,30}},
        color={0,127,255}));
  end for;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-20},{100,
            100}}), graphics),
    Documentation(info="<html>
<p>
This partial model is extended by
<a href=\"modelica://Buildings.Fluid.Examples.Performance.Example1v1\">
Buildings.Fluid.Examples.Performance.Example1v1</a>
and
<a href=\"modelica://Buildings.Fluid.Examples.Performance.Example1v2\">
Buildings.Fluid.Examples.Performance.Example1v2</a>
and is created to avoid errors in the implementation of the two depending examples.
</p>
</html>", revisions="<html>
<ul>
<li>
May 8, 2017, by Michael Wetter:<br/>
Updated heater model.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/763\">
Buildings, #763</a>.
</li>
<li>
February 22, 2016, by Michael Wetter:<br/>
Removed parameter <code>dynamicBalance</code> for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/411\">issue 411</a>.
</li>
<li>
July 14, 2015, by Michael Wetter:<br/>
Revised documentation.
</li>
<li>
April 17, 2015, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"));
end Example1;

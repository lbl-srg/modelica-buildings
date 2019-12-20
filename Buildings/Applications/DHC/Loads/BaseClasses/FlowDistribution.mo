within Buildings.Applications.DHC.Loads.BaseClasses;
model FlowDistribution
  "Model for computing secondary flow distribution based on terminal units demand"
  // Suffix _i is to distinguish vector variable from (total) scalar variable on the source side (1) only.
  // Each variable related to load side (2) quantities is a vector by default.
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    redeclare final package Medium=Medium1,
    final m_flow_nominal=m1_flow_nominal,
    final show_T=true,
    final allowFlowReversal=false);
  replaceable package Medium1 =
    Buildings.Media.Water
    "Source side medium"
      annotation (choices(
        choice(redeclare package Medium1 = Buildings.Media.Water "Water"),
        choice(redeclare package Medium1 =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
              property_T=293.15,
              X_a=0.40)
              "Propylene glycol water, 40% mass fraction")));
  parameter Integer nLoa = 1
    "Number of connected loads"
    annotation(Evaluate=true);
  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal
    "Source side total mass flow rate at nominal conditions"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dp1_nominal(
    min=0, displayUnit="Pa") = 0
    "Source side total pressure drop at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Temperature T_a1_nominal(
    min=Modelica.SIunits.Conversions.from_degC(0), displayUnit="degC")
    "Source side supply temperature at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Temperature T_b1_nominal(
    min=Modelica.SIunits.Conversions.from_degC(0), displayUnit="degC")
    "Source side return temperature at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  // Dynamics
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics = energyDynamics
    "Type of mass balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  parameter Modelica.SIunits.Time tau = 30
    "Time constant at nominal flow (if energyDynamics <> SteadyState)"
     annotation (Dialog(tab = "Dynamics", group="Nominal condition"));
  // Advanced
  parameter Boolean homotopyInitialization = true
    "If true, use homotopy method"
    annotation(Evaluate=true, Dialog(tab="Advanced"));
  // IO connectors
  Modelica.Blocks.Interfaces.RealInput m1Req_flow_i[nLoa](
    each quantity="MassFlowRate")
    "Heating or chilled water flow required to meet the load" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,220}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-80})));
  Modelica.Blocks.Interfaces.RealOutput m1Req_flow(
    quantity="MassFlowRate") "Heating or chilled water flow required to meet the load"
    annotation (Placement(transformation(extent={{100,200},
            {140,240}}),iconTransformation(extent={{100,-70},{120,-50}})));
  // Building blocks
  Buildings.Fluid.HeatExchangers.HeaterCooler_u heaCoo(
    redeclare final package Medium=Medium1,
    final dp_nominal=dp1_nominal,
    final m_flow_nominal=m1_flow_nominal,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final tau=tau,
    T_start=T_a1_nominal,
    final Q_flow_nominal=1,
    final allowFlowReversal=allowFlowReversal)
    "Heat exchange with water stream"
    annotation (Placement(transformation(extent={{68,-10},{88,10}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(
    k=fill(1, nLoa), nin=nLoa)
    "Total required water mass flow rate"
    annotation (Placement(transformation(extent={{-10,210}, {10,230}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou_m1_flow_i[nLoa](
    redeclare each final package Medium = Medium1,
    each final use_m_flow_in=true,
    each final use_T_in=true,
    each final nPorts=1)
    annotation (Placement(transformation(extent={{32,150},{52,170}})));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_a1[nLoa](
    redeclare each final package Medium = Medium1,
    each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    each h_outflow(start=Medium1.h_default, nominal=Medium1.h_default))
    "Fluid connectors b (positive design flow direction is from port_a to ports_b)"
    annotation (Placement(transformation(extent={{-110,120},{-90,200}}),
      iconTransformation(extent={{90,20},{110,100}})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_b1[nLoa](
    redeclare each final package Medium = Medium1,
    each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    each h_outflow(start=Medium1.h_default, nominal=Medium1.h_default))
    "Fluid connectors b (positive design flow direction is from port_a to ports_b)"
    annotation (Placement(transformation(extent={{90,120},{110,200}}),
      iconTransformation(extent={{-110,20},{-90,100}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare final package Medium=Medium1,
    final nPorts=nLoa)
    annotation (Placement(transformation(extent={{-40,150},{-60,170}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum Q_flow1Sum(
    final nin=nLoa)
    annotation (Placement(transformation(extent={{28,90},{48,110}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow1Act(
    each quantity="HeatFlowRate")
    "Heat flow rate transferred to the source (<0 for heating)"
    annotation (Placement(transformation(extent={{100,80},{140,120}}),
      iconTransformation(extent={{100,-90},{120,-70}})));
  Modelica.Blocks.Sources.RealExpression m1Act_flow_i[nLoa](y=m1Req_flow_i .*
        Buildings.Utilities.Math.Functions.smoothMin(
        1,
        port_a.m_flow/Buildings.Utilities.Math.Functions.smoothMax(
          m1Req_flow,
          m_flow_small,
          m_flow_small),
        1E-2))
    "Actual mass flow rate (constrained by sum(m1Act_flow_i)<=port_a.m_flow)"
    annotation (Placement(transformation(extent={{-20,158},{0,178}})));
  Modelica.Blocks.Sources.RealExpression Q_flow1Act_i[nLoa](y=m1Act_flow_i.y .*
        (inStream(ports_a1.h_outflow) - ports_b1.h_outflow))
    "Actual heat flow rate transferred to the source"
    annotation (Placement(transformation(extent={{-20,90},{0,110}})));
  Modelica.Blocks.Sources.RealExpression T_port_a[nLoa](y=fill(sta_a.T, nLoa))
    "Inlet temperature"
    annotation (Placement(transformation(extent={{-20,134},{0,154}})));
equation
  connect(heaCoo.port_b, port_b)
    annotation (Line(points={{88,0},{100,0}}, color={0,127,255}));
  connect(mulSum.y, m1Req_flow)
    annotation (Line(points={{12,220},{120,220}},                color={0,0,127}));
  connect(Q_flow1Sum.y, heaCoo.u)
    annotation (Line(points={{50,100},{60,100},{60,6},{66,6}},
                      color={0,0,127}));
  connect(m1Req_flow_i, mulSum.u)
    annotation (Line(points={{-120,220},{-12,
          220}}, color={0,0,127}));
  connect(m1Act_flow_i.y, sou_m1_flow_i.m_flow_in)
    annotation (Line(points={{1,168},{30,168}},  color={0,0,127}));
  connect(Q_flow1Sum.y, Q_flow1Act)
    annotation (Line(points={{50,100},{120,100}},                                 color={0,0,127}));
  connect(Q_flow1Act_i.y, Q_flow1Sum.u)
    annotation (Line(points={{1,100},{26,100}},                                                                        color={0,0,127}));
  connect(ports_a1, sin.ports)
    annotation (Line(points={{-100,160},{-60,160}}, color={0,127,255}));
  connect(port_a, heaCoo.port_a)
    annotation (Line(points={{-100,0},{-16,0},{-16, 0},{68,0}}, color={0,127,255}));
  connect(sou_m1_flow_i.ports[1], ports_b1)
    annotation (Line(points={{52,160},{100,160}}, color={0,127,255}));
  connect(T_port_a.y, sou_m1_flow_i.T_in) annotation (Line(points={{1,144},{20,144},
          {20,164},{30,164}}, color={0,0,127}));
annotation (
defaultComponentName="disFlo",
Documentation(
info="<html>
<p>
This model represents a hydraulic distribution system serving multiple terminal units.
It is primarily intended to be used in conjunction with models that derive from
<a href=\"modelica://Buildings.Applications.DHC.Loads.BaseClasses.PartialTerminalUnit\">
Buildings.Applications.DHC.Loads.BaseClasses.PartialTerminalUnit</a>.
</p>
<p>
The fluid flow modeling is decoupled between a main distribution loop and several terminal
branch circuits:
<ul>
<li>
The flow rate in each branch circuit is equal to the flow rate demand yielded by the terminal
unit model, constrained by the condition that the sum of all demands is lower or equal to
the flow rate in the main loop.
</li>
<li>
The inlet temperature in each branch circuit is equal to the inlet temperature in the main loop.
The outlet temperature in the main loop results from transferring the enthalpy flow rate of each
individual fluid stream to the main fluid stream.
</li>
<li>
The pressure drop in the main distribution loop corresponds to the pressure drop 
over the whole distribution system (the pump head): it is governed by an equation representing 
the control logic of the main distribution pump. The pressure drop in each branch circuit is
irrelevant: <code>dp_nominal</code> must be set to zero for each terminal unit component.
</li>
</ul>
<p>
This modeling approach aims to minimize the number of algebraic equations by avoiding an explicit
modeling of the terminal actuators and the whole flow network.
</p>
<p>
In addition the assumption <code>allowFlowReversal = false</code> is used systematically
together with boundary conditions which actually ensure that no reverse flow conditions are
encountered in simulation. This allows directly accessing the inlet temperature value of a
component from the fluid port <code>port_a</code> with option <code>show_T = true</code>,
or the inlet enthalpy with the built-in function <code>inStream</code>.
This approach is preferred to the use of temperature or enthalpy two-port sensors which
introduce a state to ensure a smooth transition at flow reversal. All connected components
must meet the same requirements.
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-100,-100},{100,100}}),
    graphics={
        Rectangle(
          extent={{-101,5},{100,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
          Rectangle(extent={{-100,100},{100,-100}}, lineColor={95,95,95})}),
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-20},
            {100,240}}),                                                                    graphics={Text(
          extent={{-100,268},{100,240}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="Implement piping heat loss.")}));
end FlowDistribution;

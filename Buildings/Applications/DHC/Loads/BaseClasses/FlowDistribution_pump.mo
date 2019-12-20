within Buildings.Applications.DHC.Loads.BaseClasses;
model FlowDistribution_pump
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
  parameter Integer mode = 1
    "Heating (1) or cooling (-1) mode [TODO: convert into input connector]";
  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal
    "Total mass flow rate at nominal conditions"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dp1_nominal(
    min=0, displayUnit="Pa")
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
  parameter Modelica.SIunits.Time tau = 120
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
        origin={-110,-40})));
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
    annotation (Placement(transformation(extent={{44,-10},{64,10}})));
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
    final nin=1)
    annotation (Placement(transformation(extent={{-52,90},{-32,110}})));
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
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));
  Modelica.Blocks.Sources.RealExpression T_port_a[nLoa](y=fill(sta_a.T, nLoa))
    "Inlet temperature"
    annotation (Placement(transformation(extent={{-20,134},{0,154}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pum(
    redeclare final package Medium = Medium1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final m_flow_nominal=m1_flow_nominal,
    nominalValuesDefineDefaultPressureCurve=true,
    final dp_nominal=dp1_nominal,
    final show_T=true)
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear val(
    redeclare final package Medium = Medium1,
    use_inputFilter=false,
    l={0.01, 0.01},
    final m_flow_nominal=m1_flow_nominal,
    final dpValve_nominal=0.1*dp1_nominal)
    annotation (Placement(transformation(extent={{-10,10},{10,-10}}, origin={-60,0})));
  Buildings.Fluid.Movers.BaseClasses.IdealSource idealSource(
    redeclare final package Medium = Medium1,
    final control_m_flow=false,
    final control_dp=true,
    final m_flow_small=m_flow_small)
    annotation (Placement(transformation(extent={{0,10},{20,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(k=0.9*dp1_nominal)
    annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));
  Modelica.Blocks.Interfaces.RealInput m_flowPum(
    final quantity="MassFlowRate")
    "Prescribed flow rate of the pump"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,60}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-60})));
  Buildings.Fluid.FixedResistances.Junction spl(
    redeclare final package Medium = Medium1,
    final m_flow_nominal=m1_flow_nominal*{1,1,1},
    final dp_nominal=0*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Splitter/mixer"
    annotation (Placement(transformation(
      extent={{-10,10},{10,-10}}, origin={80,0})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conTSup(
    final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    k=0.1,
    final Ti=120,
    final yMax=1,
    final yMin=0,
    final reverseAction=(mode==-1))
    "PI controller tracking supply temperature"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
  Modelica.Blocks.Interfaces.RealInput TSupSet(
    final quantity="ThermodynamicTemperature",
    displayUnit="degC")
    "Supply temperature set point"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-80})));
  Modelica.Blocks.Sources.RealExpression TPumOutVal(y=pum.sta_b.T)
    "Pump outlet temperature"
    annotation (Placement(transformation(extent={{-20,-130},{-40,-110}})));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y=m1Req_flow <=
        m1_flow_nominal*1E-2)
    annotation (Placement(transformation(extent={{-100,-66},{-80,-46}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(k=1)
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    annotation (Placement(transformation(extent={{-48,-66},{-28,-46}})));
equation
  connect(mulSum.y, m1Req_flow)
    annotation (Line(points={{12,220},{120,220}},                color={0,0,127}));
  connect(Q_flow1Sum.y, heaCoo.u)
    annotation (Line(points={{-30,100},{30,100},{30,6},{42,6}},
                      color={0,0,127}));
  connect(m1Req_flow_i, mulSum.u)
    annotation (Line(points={{-120,220},{-12,
          220}}, color={0,0,127}));
  connect(m1Act_flow_i.y, sou_m1_flow_i.m_flow_in)
    annotation (Line(points={{1,168},{30,168}},  color={0,0,127}));
  connect(Q_flow1Sum.y, Q_flow1Act)
    annotation (Line(points={{-30,100},{120,100}},                                color={0,0,127}));
  connect(ports_a1, sin.ports)
    annotation (Line(points={{-100,160},{-60,160}}, color={0,127,255}));
  connect(sou_m1_flow_i.ports[1], ports_b1)
    annotation (Line(points={{52,160},{100,160}}, color={0,127,255}));
  connect(T_port_a.y, sou_m1_flow_i.T_in) annotation (Line(points={{1,144},{20,144},
          {20,164},{30,164}}, color={0,0,127}));
  connect(port_a, val.port_1)
    annotation (Line(points={{-100,0},{-70,0}}, color={0,127,255}));
  connect(val.port_2, pum.port_a)
    annotation (Line(points={{-50,0},{-30,0}}, color={0,127,255}));
  connect(pum.port_b, idealSource.port_a)
    annotation (Line(points={{-10,0},{0,0}},   color={0,127,255}));
  connect(Q_flow1Act_i.y, Q_flow1Sum.u[1:1])
    annotation (Line(points={{-79,100},{-54,100}}, color={0,0,127}));
  connect(idealSource.port_b, heaCoo.port_a)
    annotation (Line(points={{20,0},{44,0}},color={0,127,255}));
  connect(con.y, idealSource.dp_in)
    annotation (Line(points={{12,-50},{16,-50},{16,-8}},color={0,0,127}));
  connect(m_flowPum, pum.m_flow_in)
    annotation (Line(points={{-120,60},{-20,60},{-20,12}}, color={0,0,127}));
  connect(heaCoo.port_b, spl.port_1)
    annotation (Line(points={{64,0},{70,0}}, color={0,127,255}));
  connect(spl.port_2, port_b)
    annotation (Line(points={{90,0},{100,0}}, color={0,127,255}));
  connect(spl.port_3, val.port_3) annotation (Line(points={{80,10},{80,40},{-60,
          40},{-60,10}}, color={0,127,255}));
  connect(TSupSet, conTSup.u_s)
    annotation (Line(points={{-120,-100},{-82,-100}}, color={0,0,127}));
  connect(TPumOutVal.y, conTSup.u_m) annotation (Line(points={{-41,-120},{-70,-120},
          {-70,-112}}, color={0,0,127}));
  connect(booleanExpression.y, swi.u2)
    annotation (Line(points={{-79,-56},{-50,-56}}, color={255,0,255}));
  connect(con1.y, swi.u1) annotation (Line(points={{-78,-30},{-70,-30},{-70,-48},
          {-50,-48}}, color={0,0,127}));
  connect(conTSup.y, swi.u3) annotation (Line(points={{-58,-100},{-54,-100},{
          -54,-64},{-50,-64}}, color={0,0,127}));
  connect(swi.y, val.y) annotation (Line(points={{-26,-56},{-20,-56},{-20,-20},
          {-60,-20},{-60,-12}}, color={0,0,127}));
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
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-160},
            {100,240}}),                                                                    graphics={Text(
          extent={{-100,270},{100,242}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="Implement piping heat loss using eps-ntu model with nominal dT")}));
end FlowDistribution_pump;

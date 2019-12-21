within Buildings.Applications.DHC.Loads.BaseClasses;
model FlowDistribution_pump
  "Model for computing secondary flow distribution based on terminal units demand"
  // Suffix _i is to distinguish vector variable from (total) scalar variable on the source side (1) only.
  // Each variable related to load side (2) quantities is a vector by default.
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    redeclare final package Medium=Medium1,
    final m_flow_nominal=m1_flow_nominal,
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
        mSup_flow/Buildings.Utilities.Math.Functions.smoothMax(
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
  Modelica.Blocks.Sources.RealExpression T_port_a[nLoa](y=fill(TSup, nLoa))
    "Inlet temperature"
    annotation (Placement(transformation(extent={{-20,134},{0,154}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pum(
    redeclare final package Medium = Medium1,
    final m_flow_nominal=m1_flow_nominal,
    nominalValuesDefineDefaultPressureCurve=true,
    final dp_nominal=dp1_nominal,
    final allowFlowReversal=allowFlowReversal)
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear val(
    redeclare final package Medium = Medium1,
    final portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Entering,
    final use_inputFilter=false,
    final m_flow_nominal=m1_flow_nominal,
    final dpValve_nominal=0.1*dp1_nominal,
    final linearized={true,true})
    annotation (Placement(transformation(extent={{-10,10},{10,-10}}, origin={-60,0})));
  Buildings.Fluid.Movers.BaseClasses.IdealSource idealSource(
    redeclare final package Medium = Medium1,
    final control_m_flow=false,
    final control_dp=true,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_small=m_flow_small)
    annotation (Placement(transformation(extent={{0,10},{20,-10}})));
  Modelica.Blocks.Interfaces.RealInput mPum_flow(
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
    final portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final m_flow_nominal=m1_flow_nominal*{1,1,1},
    final dp_nominal=0*{1,1,1})
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
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Modelica.Blocks.Interfaces.RealInput TSupSet(
    final quantity="ThermodynamicTemperature",
    displayUnit="degC")
    "Supply temperature set point"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-40}),  iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-30})));
  Modelica.Blocks.Sources.RealExpression TSupVal(y=TSup) "Supply temperature"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-20,-150})));
  Modelica.SIunits.Temperature TSup = Medium1.temperature(
    state=Medium1.setState_phX(
      p=pum.port_b.p, h=pum.port_b.h_outflow, X=pum.port_b.Xi_outflow))
    "Supply temperature";
  Modelica.SIunits.MassFlowRate mSup_flow = pum.m_flow
    "Supply mass flow rate";
  Utilities.Math.Polynominal polynominal(a={0.9*dp1_nominal})
    annotation (Placement(transformation(extent={{40,-50},{20,-30}})));
  Modelica.Blocks.Sources.RealExpression mSup_flowVal(y=mSup_flow)
    "Supply mass flow rate"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={20,-150})));
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
  connect(mPum_flow, pum.m_flow_in)
    annotation (Line(points={{-120,60},{-20,60},{-20,12}}, color={0,0,127}));
  connect(heaCoo.port_b, spl.port_1)
    annotation (Line(points={{64,0},{70,0}}, color={0,127,255}));
  connect(spl.port_2, port_b)
    annotation (Line(points={{90,0},{100,0}}, color={0,127,255}));
  connect(spl.port_3, val.port_3) annotation (Line(points={{80,10},{80,40},{-60,
          40},{-60,10}}, color={0,127,255}));
  connect(TSupSet, conTSup.u_s)
    annotation (Line(points={{-120,-40},{-92,-40}},   color={0,0,127}));
  connect(TSupVal.y, conTSup.u_m) annotation (Line(points={{-20,-139},{-20,-60},
          {-80,-60},{-80,-52}},
                       color={0,0,127}));
  connect(mSup_flowVal.y, polynominal.u)
    annotation (Line(points={{20,-139},{20,-120},{60,-120},{60,-40},{42,-40}},
                                                 color={0,0,127}));
  connect(polynominal.y, idealSource.dp_in)
    annotation (Line(points={{19,-40},{16,-40},{16,-8}}, color={0,0,127}));
  connect(conTSup.y, val.y) annotation (Line(points={{-68,-40},{-60,-40},{-60,
          -12}}, color={0,0,127}));
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
          textString="Implement piping heat loss using eps-ntu model with nominal dT"),               Text(
          extent={{-96,-64},{104,-92}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString=
              "CPU time for integration is twice lower when Dynamics of valve, pump and splitter are NOT steady state!?"),
                                                                                                      Text(
          extent={{-100,-88},{100,-116}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="TODO: generalize FixedInitial")}));
end FlowDistribution_pump;

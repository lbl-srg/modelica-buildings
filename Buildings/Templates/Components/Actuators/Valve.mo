within Buildings.Templates.Components.Actuators;
model Valve "Multiple-configuration valve"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    final m_flow_nominal=dat.m_flow_nominal)
    annotation(__ctrlFlow(enable=false));

  parameter Buildings.Templates.Components.Types.Valve typ
    "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  // The following proxy parameters are not evaluated when used in Dialog(enable)
  // annotations with Dymola: explicit expressions are required.
  final parameter Boolean is_twoWay=
    typ==Buildings.Templates.Components.Types.Valve.TwoWayModulating
    or typ==Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
    "Evaluate to true in case of two-way valve"
    annotation(Evaluate=true);
  final parameter Boolean is_thrWay=
    typ==Buildings.Templates.Components.Types.Valve.ThreeWayModulating
    or typ==Buildings.Templates.Components.Types.Valve.ThreeWayTwoPosition
    "Evaluate to true in case of three-way valve"
    annotation(Evaluate=true);
  final parameter Boolean is_actTwo=
    typ==Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition
    or typ==Buildings.Templates.Components.Types.Valve.ThreeWayTwoPosition
    "Evaluate to true in case of two-position actuator"
    annotation(Evaluate=true);
  final parameter Boolean is_actMod=
    typ==Buildings.Templates.Components.Types.Valve.ThreeWayModulating
    or typ==Buildings.Templates.Components.Types.Valve.TwoWayModulating
    "Evaluate to true in case of modulating actuator"
    annotation(Evaluate=true);

  parameter Buildings.Templates.Components.Types.ValveCharacteristicTwoWay chaTwo=
    if is_actMod then Buildings.Templates.Components.Types.ValveCharacteristicTwoWay.EqualPercentage
    else Buildings.Templates.Components.Types.ValveCharacteristicTwoWay.Linear
    "Flow characteristic"
    annotation (Evaluate=true,
    __ctrlFlow(enable=false),
    Dialog(group="Configuration",
    enable=typ==Buildings.Templates.Components.Types.Valve.TwoWayModulating
    or typ==Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition));
  parameter Buildings.Templates.Components.Types.ValveCharacteristicThreeWay chaThr=
    if is_actMod then Buildings.Templates.Components.Types.ValveCharacteristicThreeWay.EqualPercentageLinear
    else Buildings.Templates.Components.Types.ValveCharacteristicThreeWay.Linear
    "Flow characteristic"
    annotation (Evaluate=true,
    __ctrlFlow(enable=false),
    Dialog(group="Configuration",
    enable=typ==Buildings.Templates.Components.Types.Valve.ThreeWayModulating
    or typ==Buildings.Templates.Components.Types.Valve.ThreeWayTwoPosition));

  replaceable parameter Buildings.Fluid.Actuators.Valves.Data.Generic flowCharacteristics(
    y={0,1},
    phi={0.0001,1})
    "Table with flow characteristics"
    annotation (
    __ctrlFlow(enable=false),
    Dialog(group="Configuration",
    enable=(typ==Buildings.Templates.Components.Types.Valve.TwoWayModulating
    or typ==Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition) and
    chaTwo==Buildings.Templates.Components.Types.ValveCharacteristicTwoWay.Table),
    choicesAllMatching=true,
    Placement(transformation(extent={{-90,-140},{-70,-120}})));
  replaceable parameter Buildings.Fluid.Actuators.Valves.Data.Generic flowCharacteristics1(
    y={0,1},
    phi={0.0001,1})
    "Table with flow characteristics for direct flow path at port_1"
    annotation (
    __ctrlFlow(enable=false),
    Dialog(group="Configuration",
    enable=(typ==Buildings.Templates.Components.Types.Valve.ThreeWayModulating
    or typ==Buildings.Templates.Components.Types.Valve.ThreeWayTwoPosition) and
    chaThr==Buildings.Templates.Components.Types.ValveCharacteristicThreeWay.Table),
    choicesAllMatching=true,
    Placement(transformation(extent={{-60,-140},{-40,-120}})));
  replaceable parameter Buildings.Fluid.Actuators.Valves.Data.Generic flowCharacteristics3(
    y={0,1},
    phi={0.0001,1})
    "Table with flow characteristics for bypass flow path at port_3"
    annotation (
    __ctrlFlow(enable=false),
    Dialog(group="Configuration",
    enable=(typ==Buildings.Templates.Components.Types.Valve.ThreeWayModulating
    or typ==Buildings.Templates.Components.Types.Valve.ThreeWayTwoPosition) and
    chaThr==Buildings.Templates.Components.Types.ValveCharacteristicThreeWay.Table),
    choicesAllMatching=true,
    Placement(transformation(extent={{-30,-140},{-10,-120}})));
  parameter Real fraK(min=0, max=1) = 1.0
    "Fraction Kv(port_3&rarr;port_2)/Kv(port_1&rarr;port_2)"
    annotation (
    __ctrlFlow(enable=false),
    Dialog(group="Configuration",
    enable=typ==Buildings.Templates.Components.Types.Valve.ThreeWayModulating
    or typ==Buildings.Templates.Components.Types.Valve.ThreeWayTwoPosition));

  parameter Buildings.Templates.Components.Data.Valve dat(final typ=typ)
    "Design and operating parameters"
    annotation (
    __ctrlFlow(enable=false),
    Dialog(enable=typ<>Buildings.Templates.Components.Types.Damper.None),
    Placement(transformation(extent={{70,70},{90,90}})));

  final parameter Modelica.Units.SI.PressureDifference dpValve_nominal=
    dat.dpValve_nominal
    "Nominal pressure drop of fully open valve";
  final parameter Modelica.Units.SI.PressureDifference dpFixed_nominal=
    dat.dpFixed_nominal
    "Nominal pressure drop of pipes and other equipment in flow leg";
  final parameter Modelica.Units.SI.PressureDifference dpFixedByp_nominal=
    dat.dpFixedByp_nominal
    "Nominal pressure drop in the bypass line";

  parameter Boolean use_inputFilter=true
    "= true, if opening is filtered with a 2nd order CriticalDamping filter"
    annotation(__ctrlFlow(enable=false),
    Dialog(tab="Dynamics", group="Filtered opening",
    enable=typ<>Buildings.Templates.Components.Types.Valve.None));
  parameter Modelica.Units.SI.Time riseTime=120
    "Rise time of the filter (time to reach 99.6 % of an opening step)"
    annotation (__ctrlFlow(enable=false),
    Dialog(
      tab="Dynamics",
      group="Filtered opening",
      enable=use_inputFilter and typ<>Buildings.Templates.Components.Types.Valve.None));
  parameter Modelica.Blocks.Types.Init init=Modelica.Blocks.Types.Init.InitialOutput
    "Type of initialization (no init/steady state/initial state/initial output)"
    annotation(__ctrlFlow(enable=false),
    Dialog(tab="Dynamics", group="Filtered opening",
    enable=use_inputFilter and typ<>Buildings.Templates.Components.Types.Valve.None));
  parameter Real y_start=1 "Initial position of actuator"
    annotation(__ctrlFlow(enable=false),
    Dialog(tab="Dynamics", group="Filtered opening",
    enable=use_inputFilter and typ<>Buildings.Templates.Components.Types.Valve.None));

  parameter Modelica.Units.SI.Time tau=10
    "Time constant at nominal flow"
    annotation (Dialog(tab="Dynamics", group="Nominal condition",
      enable=energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState and (
      typ==Buildings.Templates.Components.Types.Valve.ThreeWayModulating or
      typ==Buildings.Templates.Components.Types.Valve.ThreeWayTwoPosition)),
      __ctrlFlow(enable=false));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations",
      enable=typ==Buildings.Templates.Components.Types.Valve.ThreeWayModulating or
      typ==Buildings.Templates.Components.Types.Valve.ThreeWayTwoPosition),
      __ctrlFlow(enable=false));

  parameter Integer text_rotation = 0
    "Text rotation angle in icon layer"
    annotation(Dialog(tab="Graphics", enable=false));
  parameter Boolean text_flip = false
    "True to flip text horizontally in icon layer"
    annotation(Dialog(tab="Graphics", enable=false));

  Modelica.Fluid.Interfaces.FluidPort_a portByp_a(
    redeclare final package Medium = Medium,
    p(start=Medium.p_default),
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    if typ==Buildings.Templates.Components.Types.Valve.ThreeWayTwoPosition or
      typ==Buildings.Templates.Components.Types.Valve.ThreeWayModulating
    "Fluid connector with bypass line"
    annotation (Placement(transformation(extent={{-10,-170},{10,-150}}),
        iconTransformation(extent={{-10,-110},{10,-90}})));
  Buildings.Templates.Components.Interfaces.Bus bus
    if typ<>Buildings.Templates.Components.Types.Valve.None
    "Control bus"
    annotation (Placement(
      transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,160}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,100})));

  Controls.OBC.CDL.Conversions.BooleanToReal y1(final realTrue=1, final
      realFalse=0) if is_actTwo "Two-position signal" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-80,120})));
  Modelica.Blocks.Routing.RealPassThrough y if is_actMod
    "Modulating signal"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,120})));
  Modelica.Blocks.Routing.RealPassThrough y_actual if is_actMod
    "Position feedback"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={0,120})));
  Controls.OBC.CDL.Reals.GreaterThreshold y1_actual(t=0.99, h=0.5E-2)
    if is_actTwo
    "Open end switch status"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={80,120})));
  Controls.OBC.CDL.Reals.LessThreshold y0_actual(t=0.01, h=0.5E-2)
    if is_actTwo
    "Closed end switch status"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={40,120})));

  Routing.PassThroughFluid non(
    redeclare final package Medium = Medium)
    if typ==Buildings.Templates.Components.Types.Valve.None
    "No valve"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage equ(
    redeclare final package Medium=Medium,
    final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    final m_flow_nominal=m_flow_nominal,
    final dpValve_nominal=dpValve_nominal,
    final dpFixed_nominal=dpFixed_nominal,
    final use_inputFilter=use_inputFilter,
    final riseTime=riseTime,
    final init=init,
    final y_start=y_start,
    final allowFlowReversal=allowFlowReversal,
    final show_T=show_T)
    if is_twoWay
    and chaTwo==Buildings.Templates.Components.Types.ValveCharacteristicTwoWay.EqualPercentage
    "Two-way valve with equal percentage characteristic"
    annotation (
      __ctrlFlow(enable=false),
      Placement(
        transformation(
        extent={{-50,-10},{-30,10}},
        rotation=0)));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear lin(
    redeclare final package Medium=Medium,
    final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    final m_flow_nominal=m_flow_nominal,
    final dpValve_nominal=dpValve_nominal,
    final dpFixed_nominal=dpFixed_nominal,
    final use_inputFilter=use_inputFilter,
    final riseTime=riseTime,
    final init=init,
    final y_start=y_start,
    final allowFlowReversal=allowFlowReversal,
    final show_T=show_T)
    if is_twoWay
    and chaTwo==Buildings.Templates.Components.Types.ValveCharacteristicTwoWay.Linear
    "Two-way valve with linear characteristic"
    annotation (
      __ctrlFlow(enable=false),
      Placement(
        transformation(
        extent={{-70,10},{-50,30}},
        rotation=0)));
  Buildings.Fluid.Actuators.Valves.TwoWayPressureIndependent ind(
    redeclare final package Medium=Medium,
    final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    final m_flow_nominal=m_flow_nominal,
    final dpValve_nominal=dpValve_nominal,
    final dpFixed_nominal=dpFixed_nominal,
    final use_inputFilter=use_inputFilter,
    final riseTime=riseTime,
    final init=init,
    final y_start=y_start,
    final allowFlowReversal=allowFlowReversal,
    final show_T=show_T)
    if is_twoWay
    and chaTwo==Buildings.Templates.Components.Types.ValveCharacteristicTwoWay.PressureIndependent
    "Pressure independent two-way valve"
    annotation (
      __ctrlFlow(enable=false),
      Placement(
        transformation(
        extent={{-30,-30},{-10,-10}},
        rotation=0)));
  Buildings.Fluid.Actuators.Valves.TwoWayTable tab(
    redeclare final package Medium=Medium,
    final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    final flowCharacteristics=flowCharacteristics,
    final m_flow_nominal=m_flow_nominal,
    final dpValve_nominal=dpValve_nominal,
    final dpFixed_nominal=dpFixed_nominal,
    final use_inputFilter=use_inputFilter,
    final riseTime=riseTime,
    final init=init,
    final y_start=y_start,
    final allowFlowReversal=allowFlowReversal,
    final show_T=show_T)
    if is_twoWay
    and chaTwo==Buildings.Templates.Components.Types.ValveCharacteristicTwoWay.Table
    "Pressure independent two-way valve"
    annotation (
      __ctrlFlow(enable=false),
      Placement(
        transformation(
        extent={{-10,-50},{10,-30}},
        rotation=0)));
  Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear equLin(
    redeclare final package Medium=Medium,
    final fraK=fraK,
    final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    final m_flow_nominal=m_flow_nominal,
    final dpValve_nominal=dpValve_nominal,
    final dpFixed_nominal={dpFixed_nominal, dpFixedByp_nominal},
    final energyDynamics=energyDynamics,
    final tau=tau,
    final use_inputFilter=use_inputFilter,
    final riseTime=riseTime,
    final init=init,
    final y_start=y_start,
    final portFlowDirection_1=if allowFlowReversal then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional
    else Modelica.Fluid.Types.PortFlowDirection.Entering)
    if is_thrWay
    and chaThr==Buildings.Templates.Components.Types.ValveCharacteristicThreeWay.EqualPercentageLinear
    "Three-way valve with equal percentage and linear characteristics"
    annotation (
      __ctrlFlow(enable=false),
      Placement(
        transformation(
        extent={{30,-90},{50,-70}},
        rotation=0)));
  Fluid.Actuators.Valves.ThreeWayLinear linLin(
    redeclare final package Medium = Medium,
    final fraK=fraK,
    final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    final m_flow_nominal=m_flow_nominal,
    final dpValve_nominal=dpValve_nominal,
    final dpFixed_nominal={dpFixed_nominal,dpFixedByp_nominal},
    final energyDynamics=energyDynamics,
    final tau=tau,
    final use_inputFilter=use_inputFilter,
    final riseTime=riseTime,
    final init=init,
    final y_start=y_start,
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering)
    if is_thrWay
    and chaThr==Buildings.Templates.Components.Types.ValveCharacteristicThreeWay.Linear
    "Three-way valve with linear characteristics"
    annotation (
      __ctrlFlow(enable=false),
      Placement(
        transformation(
        extent={{10,-70},{30,-50}},
        rotation=0)));
  Fluid.Actuators.Valves.ThreeWayTable tabTab(
    redeclare final package Medium = Medium,
    final flowCharacteristics1=flowCharacteristics1,
    final flowCharacteristics3=flowCharacteristics3,
    final fraK=fraK,
    final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    final m_flow_nominal=m_flow_nominal,
    final dpValve_nominal=dpValve_nominal,
    final dpFixed_nominal={dpFixed_nominal,dpFixedByp_nominal},
    final energyDynamics=energyDynamics,
    final tau=tau,
    final use_inputFilter=use_inputFilter,
    final riseTime=riseTime,
    final init=init,
    final y_start=y_start,
    final portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering)
    if is_thrWay
    and chaThr==Buildings.Templates.Components.Types.ValveCharacteristicThreeWay.Table
    "Three-way valve with table-specified characteristics"
    annotation (
      __ctrlFlow(enable=false),
      Placement(
        transformation(
        extent={{50,-110},{70,-90}},
        rotation=0)));
equation
  /* Control point connection - start */
  connect(y1.y, lin.y);
  connect(y.y, lin.y);
  connect(y_actual.u, lin.y_actual);
  connect(y0_actual.u, lin.y_actual);
  connect(y1_actual.u, lin.y_actual);
  connect(y1.y, equ.y);
  connect(y.y, equ.y);
  connect(y_actual.u, equ.y_actual);
  connect(y0_actual.u, equ.y_actual);
  connect(y1_actual.u, equ.y_actual);
  connect(y1.y, tab.y);
  connect(y.y, tab.y);
  connect(y_actual.u, tab.y_actual);
  connect(y0_actual.u, tab.y_actual);
  connect(y1_actual.u, tab.y_actual);
  connect(y1.y, ind.y);
  connect(y.y, ind.y);
  connect(y_actual.u, ind.y_actual);
  connect(y0_actual.u, ind.y_actual);
  connect(y1_actual.u, ind.y_actual);
  connect(y1.y, equLin.y);
  connect(y.y, equLin.y);
  connect(y_actual.u, equLin.y_actual);
  connect(y0_actual.u, equLin.y_actual);
  connect(y1_actual.u, equLin.y_actual);
  connect(y1.y, linLin.y);
  connect(y.y, linLin.y);
  connect(y_actual.u, linLin.y_actual);
  connect(y0_actual.u, linLin.y_actual);
  connect(y1_actual.u, linLin.y_actual);
  connect(y1.y, tabTab.y);
  connect(y.y, tabTab.y);
  connect(y_actual.u, tabTab.y_actual);
  connect(y0_actual.u, tabTab.y_actual);
  connect(y1_actual.u, tabTab.y_actual);
  /* Control point connection - stop */
  connect(port_a, non.port_a)
    annotation (Line(points={{-100,0},{-74,0},{-74,40},{-10,40}}, color={0,127,255}));
  connect(non.port_b, port_b)
    annotation (Line(points={{10,40},{80,40},{80,0},{100,0}}, color={0,127,255}));
  connect(port_a, equ.port_a) annotation (Line(points={{-100,0},{-50,0}},
                     color={0,127,255}));
  connect(equ.port_b, port_b) annotation (Line(points={{-30,0},{100,0}},
                   color={0,127,255}));
  connect(lin.port_b, port_b) annotation (Line(points={{-50,20},{80,20},{80,0},
          {100,0}},color={0,127,255}));
  connect(port_a, lin.port_a) annotation (Line(points={{-100,0},{-74,0},{-74,20},
          {-70,20}}, color={0,127,255}));
  connect(port_a, ind.port_a) annotation (Line(points={{-100,0},{-74,0},{-74,
          -20},{-30,-20}},
                      color={0,127,255}));
  connect(port_a, tab.port_a) annotation (Line(points={{-100,0},{-74,0},{-74,
          -40},{-10,-40}},
                      color={0,127,255}));
  connect(ind.port_b, port_b) annotation (Line(points={{-10,-20},{80,-20},{80,0},
          {100,0}}, color={0,127,255}));
  connect(tab.port_b, port_b) annotation (Line(points={{10,-40},{80,-40},{80,0},
          {100,0}}, color={0,127,255}));
  connect(bus.y1, y1.u) annotation (Line(
      points={{0,160},{0,140},{-80,140},{-80,132}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.y, y.u) annotation (Line(
      points={{0,160},{0,140},{-40,140},{-40,132}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.y_actual, y_actual.y) annotation (Line(
      points={{0,160},{0,131}},
      color={255,204,51},
      thickness=0.5));
  connect(equLin.port_3, portByp_a)
    annotation (Line(points={{40,-90},{40,-120},{0,-120},{0,-160}},
                                                 color={0,127,255}));
  connect(port_a, equLin.port_1) annotation (Line(points={{-100,0},{-74,0},{-74,
          -80},{30,-80}},    color={0,127,255}));
  connect(equLin.port_2, port_b) annotation (Line(points={{50,-80},{80,-80},{80,
          0},{100,0}}, color={0,127,255}));
  connect(bus.y0_actual, y0_actual.y) annotation (Line(
      points={{0,160},{0,140},{40,140},{40,132}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.y1_actual, y1_actual.y) annotation (Line(
      points={{0,160},{0,140},{80,140},{80,132}},
      color={255,204,51},
      thickness=0.5));
  connect(tabTab.port_2, port_b) annotation (Line(points={{70,-100},{80,-100},{
          80,0},{100,0}},
                       color={0,127,255}));
  connect(tabTab.port_3, portByp_a) annotation (Line(points={{60,-110},{60,-120},
          {0,-120},{0,-160}}, color={0,127,255}));
  connect(port_a, tabTab.port_1) annotation (Line(points={{-100,0},{-74,0},{-74,
          -100},{50,-100}},           color={0,127,255}));
  connect(port_a, linLin.port_1) annotation (Line(points={{-100,0},{-74,0},{-74,
          -60},{10,-60}},  color={0,127,255}));
  connect(linLin.port_3, portByp_a)
    annotation (Line(points={{20,-70},{20,-120},{0,-120},{0,-160}},
                                                        color={0,127,255}));
  connect(linLin.port_2, port_b) annotation (Line(points={{30,-60},{80,-60},{80,
          0},{100,0}}, color={0,127,255}));
  annotation (
  Icon(graphics={
    Line(
      points={{-100,0},{-40,0}},
      color={0,0,0},
      thickness=5),
    Line(
      points={{40,0},{100,0}},
      color={0,0,0},
      thickness=5),
    Line(
      visible=is_thrWay,
      points={{0,-100},{0,-40}},
      color={0,0,0},
      thickness=5),
    Bitmap(
      visible=is_actMod,
      extent=if text_flip then {{40,60},{-40,140}} else {{-40,60},{40,140}},
      rotation=text_rotation,
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulating.svg"),
    Bitmap(
      visible=is_actTwo,
      extent=if text_flip then {{40,60},{-40,140}} else {{-40,60},{40,140}},
      rotation=text_rotation,
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Bitmap(
      visible=is_twoWay,
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=-90),
    Bitmap(
      visible=is_thrWay,
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/ThreeWay.svg",
          rotation=-90),
    Line(
      visible=typ<>Buildings.Templates.Components.Types.Valve.None,
      points={{0,60},{0,0}}, color={0,0,0})}),
    Documentation(info="<html>
<p>
This is a container model that can be used to represent a variety of valves,
with a variety of characteristics.
The supported types of valve are described in the enumeration
<a href=\"modelica://Buildings.Templates.Components.Types.Valve\">
Buildings.Templates.Components.Types.Valve</a>.
The supported flow characteristics are described in the enumeration
<a href=\"modelica://Buildings.Templates.Components.Types.ValveCharacteristicTwoWay\">
Buildings.Templates.Components.Types.ValveCharacteristicTwoWay</a>
for two-way valves, and in the enumeration
<a href=\"modelica://Buildings.Templates.Components.Types.ValveCharacteristicThreeWay\">
Buildings.Templates.Components.Types.ValveCharacteristicThreeWay</a>
for three-way valves.
</p>
<h4>Control points</h4>
<p>
The following input and output points are available.
</p>
<p>
For modulating valves:
</p>
<ul>
<li>
The valve position is modulated with a fractional position
signal <code>y</code> (real).<br/>
<code>y = 0</code> corresponds to fully closed (fully open bypass for three-way valves).
<code>y = 1</code> corresponds to fully open (fully closed bypass for three-way valves).
</li>
<li>
The actual valve position <code>y_actual</code> (real) is returned.<br/>
<code>y_actual = 0</code> corresponds to fully closed.
<code>y_actual = 1</code> corresponds to fully open.
</li>
</ul>
<p>
For two-position valves:
</p>
<ul>
<li>
The valve position is commanded with a Boolean signal <code>y1</code>.<br/>
<code>y1 = false</code> corresponds to fully closed (fully open bypass for three-way valves).
<code>y1 = true</code> corresponds to fully open (fully closed bypass for three-way valves).
</li>
<li>
The open end switch status <code>y1_actual</code> and
closed end switch status <code>y0_actual</code> (Booleans)
are returned.<br/>
<code>y1_actual = false</code> corresponds to fully closed.
<code>y1_actual = true</code> corresponds to fully open.
And the opposite for <code>y0_actual</code>.
</li>
</ul>
<h4>Model parameters</h4>
<p>
The design operating point is specified with an instance of
<a href=\"modelica://Buildings.Templates.Components.Data.Valve\">
Buildings.Templates.Components.Data.Valve</a>.
</p>
<p>
The default characteristic is equal percentage (resp. equal percentage
and linear) for modulating two-way valves (resp. modulating three-way valves).
The default characteristic is linear for two-position actuators.
</p>
<p>
For three-way valves, the default setting for the ratio of
the <i>Kvs</i> coefficient between the bypass branch and the
direct branch is <code>fraK=1.0</code>, see
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.UsersGuide.ControlValves\">
Buildings.Fluid.HydronicConfigurations.UsersGuide.ControlValves</a>
for the rationale.
</p>
</html>", revisions="<html>
<ul>
<li>
September 27, 2023, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-100,-160},{100,160}})));
end Valve;

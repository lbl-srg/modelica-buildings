within Buildings.Templates.Components.Actuators;
model Valve "Multiple-configuration valve"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    final m_flow_nominal=dat.m_flow_nominal)
    annotation(__ctrlFlow(enable=false));

  parameter Buildings.Templates.Components.Types.Valve typ
    "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  parameter Buildings.Templates.Components.Data.Valve dat(final typ=typ)
    "Design and operating parameters"
    annotation (Placement(transformation(extent={{70,70},{90,90}})),
    __ctrlFlow(enable=false));

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
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  Buildings.Templates.Components.Interfaces.Bus bus
    if typ<>Buildings.Templates.Components.Types.Valve.None
    "Control bus"
    annotation (Placement(
      transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,100})));
  Routing.PassThroughFluid non(
    redeclare final package Medium = Medium)
    if typ==Buildings.Templates.Components.Types.Valve.None
    "No valve"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage equ(
    redeclare final package Medium=Medium,
    final m_flow_nominal=m_flow_nominal,
    final dpValve_nominal=dpValve_nominal,
    final dpFixed_nominal=dpFixed_nominal,
    final use_inputFilter=use_inputFilter,
    final riseTime=riseTime,
    final init=init,
    final y_start=y_start,
    final allowFlowReversal=allowFlowReversal,
    final show_T=show_T) "Two-way valve with equal percentage characteristic"
    annotation (
      __ctrlFlow(enable=false),
      choicesAllMatching=true,
      Placement(
        transformation(
        extent={{-40,10},{-20,30}},
        rotation=0)));
equation
  connect(port_a, non.port_a)
    annotation (Line(points={{-100,0},{-80,0}}, color={0,127,255}));
  connect(non.port_b, port_b)
    annotation (Line(points={{-60,0},{100,0}}, color={0,127,255}));
  connect(port_a, equ.port_a) annotation (Line(points={{-100,0},{-70,0},{-70,20},
          {-40,20}}, color={0,127,255}));
  connect(equ.port_b, port_b) annotation (Line(points={{-20,20},{0,20},{0,0},{
          100,0}}, color={0,127,255}));
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
      visible=typ==Buildings.Templates.Components.Types.Valve.ThreeWayTwoPosition or
        typ==Buildings.Templates.Components.Types.Valve.ThreeWayModulating,
      points={{0,-100},{0,-40}},
      color={0,0,0},
      thickness=5),
    Bitmap(
      visible=typ==Buildings.Templates.Components.Types.Valve.TwoWayModulating or
        typ==Buildings.Templates.Components.Types.Valve.ThreeWayModulating,
      extent=if text_flip then {{40,60},{-40,140}} else {{-40,60},{40,140}},
      rotation=text_rotation,
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulating.svg"),
    Bitmap(
      visible=typ==Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition or
        typ==Buildings.Templates.Components.Types.Valve.ThreeWayTwoPosition,
      extent=if text_flip then {{40,60},{-40,140}} else {{-40,60},{40,140}},
      rotation=text_rotation,
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
    Bitmap(
      visible=typ==Buildings.Templates.Components.Types.Valve.TwoWayTwoPosition or
        typ==Buildings.Templates.Components.Types.Valve.TwoWayModulating,
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
      rotation=-90),
    Bitmap(
      visible=typ==Buildings.Templates.Components.Types.Valve.ThreeWayTwoPosition or
        typ==Buildings.Templates.Components.Types.Valve.ThreeWayModulating,
      extent={{-100,-100},{100,100}},
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/ThreeWay.svg",
          rotation=-90),
    Line(
      visible=typ<>Buildings.Templates.Components.Types.Valve.None,
      points={{0,60},{0,0}}, color={0,0,0})}),
    Documentation(info="<html>
<p>
This partial class provides a standard interface for valve models.
</p>
</html>"));
end Valve;

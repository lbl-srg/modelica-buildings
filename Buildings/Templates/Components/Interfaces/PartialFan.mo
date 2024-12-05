within Buildings.Templates.Components.Interfaces;
partial model PartialFan "Interface class for fan"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    final m_flow_nominal=dat.m_flow_nominal)
    annotation(__ctrlFlow(enable=false));

  parameter Buildings.Templates.Components.Types.Fan typ
    "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_senFlo = false
    "Set to true for air flow measurement"
    annotation (Evaluate=true, Dialog(group="Configuration",
    enable=typ<>Buildings.Templates.Components.Types.Fan.None));

  parameter Modelica.Units.SI.Time tau=1
    "Time constant of fluid volume for nominal flow, used if energy or mass balance is dynamic"
    annotation (Dialog(
      tab="Dynamics",
      group="Nominal condition",
      enable=typ<>Buildings.Templates.Components.Types.Fan.None and
      energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState),
      __ctrlFlow(enable=false));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true,
      Dialog(tab = "Dynamics", group="Conservation equations",
      enable=typ<>Buildings.Templates.Components.Types.Fan.None),
      __ctrlFlow(enable=false));

  parameter Buildings.Templates.Components.Types.FanSingle typSin=
    Buildings.Templates.Components.Types.FanSingle.Housed
    "Type of single fan"
    annotation(Dialog(tab="Graphics", enable=false));
  parameter Integer text_rotation = 0
    "Text rotation angle in icon layer"
    annotation(Dialog(tab="Graphics", enable=false));
  parameter Boolean text_flip = false
    "True to flip text horizontally in icon layer"
    annotation(Dialog(tab="Graphics", enable=false));

  parameter Buildings.Templates.Components.Data.Fan dat(
    final typ=typ,
    final nFan=nFan)
    "Design and operating parameters"
    annotation(Placement(transformation(extent={{70,70},{90,90}})),
    __ctrlFlow(enable=false));

  parameter Integer nFan(
    final min=0,
    start=0)
    "Number of fans"
    annotation (Dialog(group="Configuration",
      enable=typ==Buildings.Templates.Components.Types.Fan.ArrayVariable));
  final parameter Modelica.Units.SI.PressureDifference dp_nominal=dat.dp_nominal
    "Total pressure rise";

  Buildings.Templates.Components.Interfaces.Bus bus
    if typ <> Buildings.Templates.Components.Types.Fan.None
    "Control bus"
    annotation (Placement(
      transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,100})));
  Buildings.Templates.Components.Sensors.VolumeFlowRate V_flow(
    redeclare final package Medium = Medium,
    final have_sen=have_senFlo,
    final m_flow_nominal=m_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorVolumeFlowRate.AFMS)
    "Air volume flow rate sensor"
    annotation (
      Placement(transformation(extent={{70,-10},{90,10}})));
equation
  /* Control point connection - start */
  connect(V_flow.y, bus.V_flow);
  /* Control point connection - stop */
  connect(port_b, V_flow.port_b)
    annotation (Line(points={{100,0},{90,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
    Line( visible=typ == Buildings.Templates.Components.Types.Fan.SingleVariable
               or typ == Buildings.Templates.Components.Types.Fan.ArrayVariable,
          points={{0,-30},{0,-160}},
          color={0,0,0}),
    Bitmap(
      visible=typ==Buildings.Templates.Components.Types.Fan.ArrayVariable,
        extent={{-100,-100},{100,100}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Fans/Array.svg"),
    Bitmap(
      visible=(typ==Buildings.Templates.Components.Types.Fan.SingleVariable or
        typ==Buildings.Templates.Components.Types.Fan.SingleConstant) and
        typSin==Buildings.Templates.Components.Types.FanSingle.Housed,
        extent={{-100,-100},{100,100}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Fans/Housed.svg"),
    Bitmap(
      visible=(typ==Buildings.Templates.Components.Types.Fan.SingleVariable or
        typ==Buildings.Templates.Components.Types.Fan.SingleConstant) and
        typSin==Buildings.Templates.Components.Types.FanSingle.Plug,
        extent={{-100,-100},{100,100}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Fans/Plug.svg"),
    Bitmap(
      visible=(typ==Buildings.Templates.Components.Types.Fan.SingleVariable or
        typ==Buildings.Templates.Components.Types.Fan.SingleConstant) and
        typSin==Buildings.Templates.Components.Types.FanSingle.Propeller,
        extent={{-100,-100},{100,100}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Fans/Propeller.svg"),
    Bitmap(
      visible=have_senFlo and typ<>Buildings.Templates.Components.Types.Fan.None,
        extent=if text_flip then {{-140,-240},{-220,-160}} else {{-220,-240},{-140,-160}},
        rotation=text_rotation,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Sensors/VolumeFlowRate.svg"),
    Bitmap(
      visible=typ==Buildings.Templates.Components.Types.Fan.SingleVariable or
        typ==Buildings.Templates.Components.Types.Fan.ArrayVariable,
        extent=if text_flip then {{100,-360},{-100,-160}} else {{-100,-360},{100,-160}},
        rotation=text_rotation,
          fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/VFD.svg"),
        Polygon(
          points={{-185,-160},{-185,5},{-100,5},{-100,-5},{-175,-5},{-175,-160},
              {-185,-160}},
          lineColor={0,0,0},
          visible=have_senFlo and typ <> Buildings.Templates.Components.Types.Fan.None)}),
    Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This partial class provides a standard interface for fan models.
</p>
</html>"));
end PartialFan;

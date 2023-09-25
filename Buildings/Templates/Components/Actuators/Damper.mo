within Buildings.Templates.Components.Actuators;
model Damper "Multiple-configuration damper"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    final m_flow_nominal=dat.m_flow_nominal)
    annotation(__ctrlFlow(enable=false));

  parameter Buildings.Templates.Components.Types.Damper typ
    "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  parameter Buildings.Templates.Components.Data.Damper dat(final typ=typ)
    "Design and operating parameters"
    annotation (Placement(transformation(extent={{70,70},{90,90}})));

  final parameter Modelica.Units.SI.PressureDifference dp_nominal=
    dat.dp_nominal
    "Damper pressure drop";

  parameter Boolean use_inputFilter=true
    "= true, if opening is filtered with a 2nd order CriticalDamping filter"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",
    enable=typ<>Buildings.Templates.Components.Types.Damper.None));
  parameter Modelica.Units.SI.Time riseTime=120
    "Rise time of the filter (time to reach 99.6 % of an opening step)"
    annotation (Dialog(
      tab="Dynamics",
      group="Filtered opening",
      enable=use_inputFilter and typ<>Buildings.Templates.Components.Types.Damper.None));
  parameter Modelica.Blocks.Types.Init init=Modelica.Blocks.Types.Init.InitialOutput
    "Type of initialization (no init/steady state/initial state/initial output)"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",
    enable=use_inputFilter and typ<>Buildings.Templates.Components.Types.Damper.None));
  parameter Real y_start=1 "Initial position of actuator"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",
    enable=use_inputFilter and typ<>Buildings.Templates.Components.Types.Damper.None));

  parameter Buildings.Templates.Components.Types.DamperBlades typBla=
    Buildings.Templates.Components.Types.DamperBlades.Parallel
    "Type of blades"
    annotation(Dialog(tab="Graphics", enable=false));
  parameter Integer text_rotation = 0
    "Text rotation angle in icon layer"
    annotation(Dialog(tab="Graphics", enable=false));
  parameter Boolean text_flip = false
    "True to flip text horizontally in icon layer"
    annotation(Dialog(tab="Graphics", enable=false));

  Buildings.Templates.Components.Interfaces.Bus bus
    if typ <> Buildings.Templates.Components.Types.Damper.None
    "Control bus"
    annotation (Placement(
      transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,100}),
      iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,100})));

  Buildings.Fluid.Actuators.Dampers.Exponential exp(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final dpDamper_nominal=dp_nominal,
    final dpFixed_nominal=dat.dpFixed_nominal,
    final use_inputFilter=use_inputFilter,
    final riseTime=riseTime,
    final init=init,
    final y_start=y_start,
    final allowFlowReversal=allowFlowReversal,
    final show_T=show_T)
    if typ==Buildings.Templates.Components.Types.Damper.Modulating or
       typ==Buildings.Templates.Components.Types.Damper.TwoPosition
    "Damper with exponential characteristic"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Fluid.Actuators.Dampers.PressureIndependent ind(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final dpDamper_nominal=dp_nominal,
    final dpFixed_nominal=dat.dpFixed_nominal,
    final use_inputFilter=use_inputFilter,
    final riseTime=riseTime,
    final init=init,
    final y_start=y_start,
    final allowFlowReversal=allowFlowReversal,
    final show_T=show_T)
    if typ==Buildings.Templates.Components.Types.Damper.PressureIndependent
    "Pressure independent damper"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  Buildings.Templates.Components.Routing.PassThroughFluid non(
    redeclare final package Medium = Medium)
    if typ==Buildings.Templates.Components.Types.Damper.None
    "No damper"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(
    final realTrue=1,
    final realFalse=0)
    if typ==Buildings.Templates.Components.Types.Damper.TwoPosition
    "Signal conversion"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,50})));
  Modelica.Blocks.Routing.RealPassThrough pasCom
    if typ == Buildings.Templates.Components.Types.Damper.Modulating
    or typ == Buildings.Templates.Components.Types.Damper.PressureIndependent
    "Pass through signal without modification"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,50})));
  Controls.OBC.CDL.Reals.LessThreshold evaClo(t=0.01, h=0.5E-2)
    if typ==Buildings.Templates.Components.Types.Damper.TwoPosition
    "Return true if closed (closed end switch contact)"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,-50})));
  Controls.OBC.CDL.Reals.GreaterThreshold evaOpe(t=0.99, h=0.5E-2)
    if typ==Buildings.Templates.Components.Types.Damper.TwoPosition
    "Return true if open (open end switch contact)"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,-50})));
  Modelica.Blocks.Routing.RealPassThrough pasRet
    if typ == Buildings.Templates.Components.Types.Damper.Modulating
    or typ == Buildings.Templates.Components.Types.Damper.PressureIndependent
    "Pass through signal without modification" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={60,50})));
equation
  connect(port_a, non.port_a)
    annotation (Line(points={{-100,0},{-80,0}}, color={0,127,255}));
  connect(non.port_b, port_b)
    annotation (Line(points={{-60,0},{100,0}}, color={0,127,255}));
  connect(port_a,exp. port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(exp.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(port_a, ind.port_a)
    annotation (Line(points={{-100,0},{50,0}}, color={0,127,255}));
  connect(ind.port_b, port_b)
    annotation (Line(points={{70,0},{100,0}}, color={0,127,255}));
  connect(bus.y1, booToRea.u) annotation (Line(
      points={{0,100},{0,80},{-20,80},{-20,62}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.y, pasCom.u) annotation (Line(
      points={{0,100},{0,80},{20,80},{20,62}},
      color={255,204,51},
      thickness=0.5));
  connect(booToRea.y,exp. y) annotation (Line(points={{-20,38},{-20,20},{0,20},{
          0,12}}, color={0,0,127}));
  connect(pasCom.y, exp.y)
    annotation (Line(points={{20,39},{20,20},{0,20},{0,12}}, color={0,0,127}));
  connect(pasCom.y, ind.y) annotation (Line(points={{20,39},{20,20},{60,20},{60,
          12}}, color={0,0,127}));
  connect(exp.y_actual, evaOpe.u)
    annotation (Line(points={{5,7},{20,7},{20,-38}}, color={0,0,127}));
  connect(exp.y_actual, evaClo.u) annotation (Line(points={{5,7},{20,7},{20,-20},
          {-20,-20},{-20,-38}}, color={0,0,127}));
  connect(exp.y_actual, pasRet.u) annotation (Line(points={{5,7},{40,7},{40,30},
          {60,30},{60,38}}, color={0,0,127}));
  connect(ind.y_actual, pasRet.u) annotation (Line(points={{65,7},{80,7},{80,30},
          {60,30},{60,38}}, color={0,0,127}));
  connect(evaClo.y, bus.y0_actual) annotation (Line(points={{-20,-62},{-20,-80},
          {-40,-80},{-40,96},{0,96},{0,100}},
                                        color={255,0,255}));
  connect(pasRet.y, bus.y_actual)
    annotation (Line(points={{60,61},{60,94},{0,94},{0,100}},
                                                        color={0,0,127}));
  connect(evaOpe.y, bus.y1_actual) annotation (Line(points={{20,-62},{20,-78},{-38,
          -78},{-38,94},{0,94},{0,100}}, color={255,0,255}));
  annotation (
    Icon(
    graphics={
     Bitmap(
        visible=typ==Buildings.Templates.Components.Types.Damper.TwoPosition,
        extent=if text_flip then {{40,-240},{-40,-160}} else {{-40,-240},{40,-160}},
        rotation=text_rotation,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/TwoPosition.svg"),
     Bitmap(
        visible=typ==Buildings.Templates.Components.Types.Damper.Modulating or
          typ==Buildings.Templates.Components.Types.Damper.PressureIndependent,
        extent=if text_flip then {{40,-240},{-40,-160}} else {{-40,-240},{40,-160}},
        rotation=text_rotation,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulating.svg"),
     Bitmap(
        extent={{-130,-160},{130,100}},
        visible=typ<>Buildings.Templates.Components.Types.Damper.None and
          typBla==Buildings.Templates.Components.Types.DamperBlades.Opposed,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Dampers/BladesOpposed.svg"),
     Bitmap(
        extent={{-130,-160},{130,100}},
        visible=typ<>Buildings.Templates.Components.Types.Damper.None and
          typBla==Buildings.Templates.Components.Types.DamperBlades.Parallel,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Dampers/BladesParallel.svg"),
     Bitmap(
        extent={{-130,-160},{130,100}},
        visible=typ<>Buildings.Templates.Components.Types.Damper.None and
          typBla==Buildings.Templates.Components.Types.DamperBlades.VAV,
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Dampers/BladesVAV.svg")},
      coordinateSystem(preserveAspectRatio=false,
      extent={{-100,-100},{100,100}})),
     Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
This partial class provides a standard interface for damper models.
</p>
</html>"));
end Damper;

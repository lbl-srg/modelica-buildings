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
    if typ==Buildings.Templates.Components.Types.Damper.TwoPosition then
      Buildings.Templates.Components.Types.DamperBlades.Opposed
    elseif typ==Buildings.Templates.Components.Types.Damper.PressureIndependent then
      Buildings.Templates.Components.Types.DamperBlades.VAV
    else Buildings.Templates.Components.Types.DamperBlades.Parallel
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
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal y1(final realTrue=1,
      final realFalse=0)
    if typ == Buildings.Templates.Components.Types.Damper.TwoPosition
    "Two-position signal" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-80,40})));
  Modelica.Blocks.Routing.RealPassThrough y if typ == Buildings.Templates.Components.Types.Damper.Modulating
     or typ == Buildings.Templates.Components.Types.Damper.PressureIndependent
    "Modulating signal" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,40})));
  Controls.OBC.CDL.Reals.LessThreshold y0_actual(t=0.01, h=0.5E-2)
    if typ == Buildings.Templates.Components.Types.Damper.TwoPosition
    "Closed end switch status" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={40,40})));
  Controls.OBC.CDL.Reals.GreaterThreshold y1_actual(t=0.99, h=0.5E-2)
    if typ == Buildings.Templates.Components.Types.Damper.TwoPosition
    "Open end switch status" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={80,40})));
  Modelica.Blocks.Routing.RealPassThrough y_actual if typ == Buildings.Templates.Components.Types.Damper.Modulating
     or typ == Buildings.Templates.Components.Types.Damper.PressureIndependent
    "Position feedback" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={0,40})));
equation
  /* Control point connection - start */
  connect(y1.y, exp.y);
  connect(y.y, exp.y);
  connect(y_actual.u, exp.y_actual);
  connect(y0_actual.u, exp.y_actual);
  connect(y1_actual.u, exp.y_actual);
  connect(y1.y, ind.y);
  connect(y.y, ind.y);
  connect(y_actual.u, ind.y_actual);
  connect(y0_actual.u, ind.y_actual);
  connect(y1_actual.u, ind.y_actual);
  /* Control point connection - stop */
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
  connect(bus.y1, y1.u) annotation (Line(
      points={{0,100},{0,60},{-80,60},{-80,52}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.y, y.u) annotation (Line(
      points={{0,100},{0,60},{-40,60},{-40,52}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.y_actual, y_actual.y) annotation (Line(
      points={{0,100},{0,51}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.y0_actual, y0_actual.y) annotation (Line(
      points={{0,100},{0,60},{40,60},{40,52}},
      color={255,204,51},
      thickness=0.5));
  connect(bus.y1_actual, y1_actual.y) annotation (Line(
      points={{0,100},{0,60},{80,60},{80,52}},
      color={255,204,51},
      thickness=0.5));
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
This is a container model that can be used to represent a variety of dampers.
The supported damper types are described in the enumeration
<a href=\"modelica://Buildings.Templates.Components.Types.Damper\">
Buildings.Templates.Components.Types.Damper</a>.
</p>
<h4>Control points</h4>
<p>
The following input and output points are available.
</p>
<p>
For modulating dampers:
</p>
<ul>
<li>
The damper opening is modulated with a fractional opening
signal <code>y</code> (real).<br/>
<code>y = 0</code> corresponds to fully closed.
<code>y = 1</code> corresponds to fully open.
</li>
<li>
The actual damper position <code>y_actual</code> (real) is returned.<br/>
<code>y_actual = 0</code> corresponds to fully closed.
<code>y_actual = 1</code> corresponds to fully open.
</li>
</ul>
<p>
For pressure-independent dampers:
</p>
<ul>
<li>
The airflow setpoint is modulated with a fractional
airflow signal <code>y</code> (real).<br/>
<code>y = 0</code> corresponds to zero airflow.
<code>y = 1</code> corresponds to the maximum airflow.
</li>
<li>
The actual damper position <code>y_actual</code> (real) is returned.<br/>
<code>y_actual = 0</code> corresponds to fully closed.
<code>y_actual = 1</code> corresponds to fully open.
</li>
</ul>
<p>
For two-position dampers:
</p>
<ul>
<li>
The damper is commanded open with a Boolean signal <code>y1</code>.<br/>
<code>y1 = 0</code> corresponds to fully closed.
<code>y1 = 1</code> corresponds to fully open.
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
<a href=\"modelica://Buildings.Templates.Components.Data.Damper\">
Buildings.Templates.Components.Data.Damper</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 27, 2023, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end Damper;

within Buildings.Templates.Plants.Controls.HeatPumps.Subsequences;
block AssertMinimumRuntime
  "Assert that heat pumps are not short cycling"
  parameter Boolean have_chiWat
    "Set to true for reversible HP, false for heating-only HP"
    annotation(Evaluate=true);
  parameter Boolean use_runTim = true
    "Set to true to assert minimum runtime, false for minimum off time"
    annotation(Evaluate=true);
  parameter Integer nUni(final min=1) "Number of units";
  parameter Real dt_min(final min=0, final unit="s") = 10 * 60
    "Minimum runtime or off-time";
  parameter String message = if use_runTim then "HP minimum runtime is not met."
    else "HP minimum off-time is not met."
    "Warning message";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1[nUni]
    "HP on/off command"
    annotation(Placement(transformation(extent={{-160,40},{-120,80}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Hea[nUni]
    if have_chiWat
    "HP heating/cooling mode command: true=heating, false=cooling"
    annotation(Placement(transformation(extent={{-160,-100},{-120,-60}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold holOn[nUni](
    each final trueHoldDuration=if use_runTim then dt_min else 0,
    each final falseHoldDuration=if use_runTim then 0 else dt_min)
    "On/off command held for minimum runtime or off-time"
    annotation(Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.Logical.Xor xorOn[nUni]
    "True if on/off command differs from held command"
    annotation(Placement(transformation(extent={{0,50},{20,70}})));
  Utilities.PlaceholderLogical phHea[nUni](
    each final have_inp=have_chiWat,
    each final u_internal=true)
    "Placeholder signal"
    annotation(Placement(transformation(extent={{-110,-90},{-90,-70}})));
  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold holHea[nUni](
    each final trueHoldDuration=dt_min,
    each final falseHoldDuration=dt_min)
    "Mode command held for minimum runtime or off-time"
    annotation(Placement(transformation(extent={{-60,-90},{-40,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Xor xorHea[nUni]
    "True if mode command differs from held command"
    annotation(Placement(transformation(extent={{0,-90},{20,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Nor nor[nUni]
    "True if minimum runtime or off-time is met"
    annotation(Placement(transformation(extent={{50,-10},{70,10}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assRunTim[nUni](
    each message=message)
    "Assert that minimum runtime or off-time is met"
    annotation(Placement(transformation(extent={{90,-10},{110,10}})));
equation
  connect(u1, holOn.u)
    annotation(Line(points={{-140,60},{-62,60}},
      color={255,0,255}));
  connect(u1, xorOn.u1)
    annotation(Line(points={{-140,60},{-80,60},{-80,80},{-10,80},{-10,60},{-2,60}},
      color={255,0,255}));
  connect(holOn.y, xorOn.u2)
    annotation(Line(points={{-38,60},{-20,60},{-20,52},{-2,52}},
      color={255,0,255}));
  connect(u1Hea, phHea.u)
    annotation(Line(points={{-140,-80},{-112,-80}},
      color={255,0,255}));
  connect(phHea.y, holHea.u)
    annotation(Line(points={{-88,-80},{-62,-80}},
      color={255,0,255}));
  connect(phHea.y, xorHea.u1)
    annotation(Line(points={{-88,-80},{-80,-80},{-80,-60},{-10,-60},{-10,-80},{-2,-80}},
      color={255,0,255}));
  connect(holHea.y, xorHea.u2)
    annotation(Line(points={{-38,-80},{-20,-80},{-20,-88},{-2,-88}},
      color={255,0,255}));
  connect(xorOn.y, nor.u1)
    annotation(Line(points={{22,60},{40,60},{40,0},{48,0}},
      color={255,0,255}));
  connect(xorHea.y, nor.u2)
    annotation(Line(points={{22,-80},{40,-80},{40,-8},{48,-8}},
      color={255,0,255}));
  connect(nor.y, assRunTim.u)
    annotation(Line(points={{72,0},{88,0}},
      color={255,0,255}));
annotation(defaultComponentName="assMinRunTimHp",
  Icon(coordinateSystem(preserveAspectRatio=false),
    graphics={Text(extent={{-150,150},{150,110}},
      textString="%name",
      textColor={0,0,255}),
    Rectangle(extent={{-100,100},{100,-100}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid),
    Polygon(points={{0,76},{-80,-64},{80,-64},{0,76}},
      fillColor={0,0,0},
      fillPattern=FillPattern.Solid,
      pattern=LinePattern.None,
      lineColor={0,0,0}),
    Polygon(points={{0,68},{-72,-60},{72,-60},{0,68}},
      lineColor={0,0,0},
      fillColor={255,255,170},
      fillPattern=FillPattern.Solid),
    Rectangle(extent={{-4,38},{2,-24}},
      fillColor={0,0,0},
      fillPattern=FillPattern.Solid,
      pattern=LinePattern.None),
    Ellipse(extent={{-6,-32},{4,-42}},
      pattern=LinePattern.None,
      fillColor={0,0,0},
      fillPattern=FillPattern.Solid)}),
  Diagram(coordinateSystem(preserveAspectRatio=false,
    extent={{-120,-140},{120,140}})),
  Documentation(
    info="<html>
<p>
  This block asserts that each heat pump does not short cycle, based on its
  enable and heating/cooling mode commands.
</p>
<p>
  If <code>use_runTim=true</code> (default), it asserts that the heat pump has
  been enabled in the same mode for at least <code>dt_min</code> before its
  enable command turns <code>false</code> or its mode command changes.
</p>
<p>
  If <code>use_runTim=false</code>, it asserts that the heat pump has been
  commanded off and its mode command hasn't changed for at least
  <code>dt_min</code> before its enable command turns <code>true</code> again
  or its mode command changes.
</p>
</html>",
    revisions="<html>
<ul>
  <li>
    July 10, 2026, by Antoine Gautier:<br />
    First implementation.
  </li>
</ul>
</html>"));
end AssertMinimumRuntime;

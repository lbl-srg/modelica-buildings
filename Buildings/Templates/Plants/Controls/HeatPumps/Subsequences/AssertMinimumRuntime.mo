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
  Buildings.Controls.OBC.CDL.Logical.Timer timOnOff[nUni](each final t=dt_min)
    "Timer for on/off state"
    annotation(Placement(transformation(extent={{-60,70},{-40,90}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdgOn[nUni]
    if use_runTim
    "Falling edge of on/off command"
    annotation(Placement(transformation(extent={{-100,38},{-80,58}})));
  // The bindings below for pre_u_start make translation fail with OCT 1.66.
  Buildings.Controls.OBC.CDL.Logical.Pre preTimOnOff[nUni](
    each pre_u_start=true)
    "Left-limit of timer status, before it is reset by the falling/rising edge"
    annotation(Placement(transformation(extent={{-20,50},{0,70}})));
  Buildings.Controls.OBC.CDL.Logical.Pre preHea[nUni](each pre_u_start=true)
    "Left-limit of timer status, before it is reset by the falling/rising edge"
    annotation(Placement(transformation(extent={{30,-110},{50,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swiRunHea[nUni]
    "Select minimum runtime/off-time status at falling/rising edge of heating command"
    annotation(Placement(transformation(extent={{20,30},{40,50}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timNotChaHea[nUni](
    each final t=dt_min)
    "Timer for stable heating/cooling mode command"
    annotation(Placement(transformation(extent={{-10,-110},{10,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant tru[nUni](each k=true)
    "Constant true signal used absent a falling edge"
    annotation(Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swiRunCoo[nUni]
    "Select minimum runtime/off-time status at falling/rising edge of cooling command"
    annotation(Placement(transformation(extent={{20,-50},{40,-30}})));
  Buildings.Controls.OBC.CDL.Logical.And and2[nUni]
    "True if minimum runtime/off-time met with stable heating/cooling mode"
    annotation(Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assRunTim[nUni](
    each message=message)
    "Assert that minimum runtime/off-time is met"
    annotation(Placement(transformation(extent={{90,-10},{110,10}})));
  Buildings.Controls.OBC.CDL.Logical.Not off[nUni]
    if not use_runTim
    "True if off"
    annotation(Placement(transformation(extent={{-100,70},{-80,90}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edgOn[nUni]
    if not use_runTim
    "Rising edge of on/off command"
    annotation(Placement(transformation(extent={{-100,10},{-80,30}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator pasOn[nUni]
    if use_runTim
    "Direct pass-through for on/off command"
    annotation(Placement(transformation(extent={{-100,100},{-80,120}})));
  Buildings.Controls.OBC.CDL.Logical.Change chaHea[nUni]
    "True if heating command changes"
    annotation(Placement(transformation(extent={{-80,-91},{-60,-69}})));
  Utilities.PlaceholderLogical phHea[nUni](
    each final have_inp=have_chiWat,
    each final u_internal=true)
    "Placeholder signal"
    annotation(Placement(transformation(extent={{-110,-90},{-90,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Not notChaHea[nUni]
    "True if heating command doesn't change"
    annotation(Placement(transformation(extent={{-40,-111},{-20,-89}})));
equation
  connect(timOnOff.passed, preTimOnOff.u)
    annotation(Line(points={{-38,72},{-30,72},{-30,60},{-22,60}},
      color={255,0,255}));
  connect(falEdgOn.y, swiRunHea.u2)
    annotation(Line(points={{-78,48},{-60,48},{-60,40},{18,40}},
      color={255,0,255}));
  connect(preTimOnOff.y, swiRunHea.u1)
    annotation(Line(points={{2,60},{10,60},{10,48},{18,48}},
      color={255,0,255}));
  connect(tru.y, swiRunHea.u3)
    annotation(Line(points={{2,0},{14,0},{14,32},{18,32}},
      color={255,0,255}));
  connect(preHea.y, swiRunCoo.u1)
    annotation(Line(
      points={{52,-100},{60,-100},{60,-60},{0,-60},{0,-32},{18,-32}},
      color={255,0,255}));
  connect(timNotChaHea.passed, preHea.u)
    annotation(Line(points={{12,-108},{20,-108},{20,-100},{28,-100}},
      color={255,0,255}));
  connect(tru.y, swiRunCoo.u3)
    annotation(Line(points={{2,0},{14,0},{14,-48},{18,-48}},
      color={255,0,255}));
  connect(swiRunHea.y, and2.u1)
    annotation(Line(points={{42,40},{50,40},{50,0},{58,0}},
      color={255,0,255}));
  connect(swiRunCoo.y, and2.u2)
    annotation(Line(points={{42,-40},{50,-40},{50,-8},{58,-8}},
      color={255,0,255}));
  connect(and2.y, assRunTim.u)
    annotation(Line(points={{82,0},{88,0}},
      color={255,0,255}));
  connect(off.y, timOnOff.u)
    annotation(Line(points={{-78,80},{-62,80}},
      color={255,0,255}));
  connect(u1, off.u)
    annotation(Line(points={{-140,60},{-110,60},{-110,80},{-102,80}},
      color={255,0,255}));
  connect(u1, pasOn.u)
    annotation(Line(points={{-140,60},{-110,60},{-110,110},{-102,110}},
      color={255,0,255}));
  connect(pasOn.y[1], timOnOff.u)
    annotation(Line(points={{-78,110},{-70,110},{-70,80},{-62,80}},
      color={255,0,255}));
  connect(u1, falEdgOn.u)
    annotation(Line(points={{-140,60},{-110,60},{-110,48},{-102,48}},
      color={255,0,255}));
  connect(u1, edgOn.u)
    annotation(Line(points={{-140,60},{-110,60},{-110,20},{-102,20}},
      color={255,0,255}));
  connect(edgOn.y, swiRunHea.u2)
    annotation(Line(points={{-78,20},{-60,20},{-60,40},{18,40}},
      color={255,0,255}));
  connect(u1Hea, phHea.u)
    annotation(Line(points={{-140,-80},{-112,-80}},
      color={255,0,255}));
  connect(phHea.y, chaHea.u)
    annotation(Line(points={{-88,-80},{-82,-80}},
      color={255,0,255}));
  connect(chaHea.y, swiRunCoo.u2)
    annotation(Line(points={{-58,-80},{-50,-80},{-50,-40},{18,-40}},
      color={255,0,255}));
  connect(chaHea.y, notChaHea.u)
    annotation(Line(points={{-58,-80},{-50,-80},{-50,-100},{-42,-100}},
      color={255,0,255}));
  connect(notChaHea.y, timNotChaHea.u)
    annotation(Line(points={{-18,-100},{-12,-100}},
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
    July 1, 2026, by Antoine Gautier:<br />
    First implementation.
  </li>
</ul>
</html>"));
end AssertMinimumRuntime;

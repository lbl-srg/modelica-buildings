within Buildings.Templates.Plants.Controls.PolyvalentHeatPumps;
block AssertMinimumRuntime
  "Assert that polyvalent heat pumps are not short cycling"
  parameter Boolean use_runTim = true
    "Set to true to assert minimum runtime, false for minimum off time"
    annotation(Evaluate=true);
  parameter Integer nUni(final min=1) "Number of units";
  parameter Real dt_min(final min=0, final unit="s") = 10 * 60
    "Minimum runtime or off-time";
  parameter String message =
    if use_runTim
    then "Polyvalent HP minimum runtime is not met."
    else "Polyvalent HP minimum off-time is not met."
    "Warning message";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Hea[nUni]
    "Polyvalent HP heating on/off command"
    annotation(Placement(transformation(extent={{-160,40},{-120,80}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Coo[nUni]
    "Polyvalent HP cooling on/off command"
    annotation(Placement(transformation(extent={{-160,-100},{-120,-60}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timHea[nUni](each final t=dt_min)
    "Timer for heating mode"
    annotation(Placement(transformation(extent={{-60,70},{-40,90}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdgHea[nUni]
    if use_runTim
    "Falling edge of heating on/off command"
    annotation(Placement(transformation(extent={{-100,38},{-80,58}})));
  Buildings.Controls.OBC.CDL.Logical.Pre preHea[nUni](each pre_u_start=true)
    "Left-limit of timer status, before it is reset by the falling/rising edge"
    annotation(Placement(transformation(extent={{-20,50},{0,70}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swiRunHea[nUni]
    "Select minimum runtime/off-time status at falling/rising edge of heating command"
    annotation(Placement(transformation(extent={{20,30},{40,50}})));
  Buildings.Controls.OBC.CDL.Logical.Timer timCoo[nUni](each final t=dt_min)
    "Timer for cooling on/off command"
    annotation(Placement(transformation(extent={{-60,-90},{-40,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant tru[nUni](each k=true)
    "Constant true signal used absent a falling edge"
    annotation(Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdgCoo[nUni]
    if use_runTim
    "Falling edge of cooling on/off command"
    annotation(Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Pre preCoo[nUni](each pre_u_start=true)
    "Left-limit of timer status, before it is reset by the falling/rising edge"
    annotation(Placement(transformation(extent={{-20,-70},{0,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swiRunCoo[nUni]
    "Select minimum runtime/off-time status at falling/rising edge of cooling command"
    annotation(Placement(transformation(extent={{20,-50},{40,-30}})));
  Buildings.Controls.OBC.CDL.Logical.And and2[nUni]
    "True if minimum runtime/off-time is met in both heating and cooling command"
    annotation(Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assRunTim[nUni](
    each message=message)
    "Assert that minimum runtime/off-time is met"
    annotation(Placement(transformation(extent={{90,-10},{110,10}})));
  Buildings.Controls.OBC.CDL.Logical.Not notHea[nUni]
    if not use_runTim
    "True if heating disabled"
    annotation(Placement(transformation(extent={{-100,70},{-80,90}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edgHea[nUni]
    if not use_runTim
    "Rising edge of heating on/off command"
    annotation(Placement(transformation(extent={{-100,10},{-80,30}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator pasHea[nUni]
    if use_runTim
    "Direct pass-through for heating command"
    annotation(Placement(transformation(extent={{-100,100},{-80,120}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edgCoo[nUni]
    if not use_runTim
    "Rising edge of cooling on/off command"
    annotation(Placement(transformation(extent={{-100,-30},{-80,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Not notCoo[nUni]
    if not use_runTim
    "True if cooling disabled"
    annotation(Placement(transformation(extent={{-100,-122},{-80,-102}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator pasCoo[nUni]
    if use_runTim
    "Direct pass-through for cooling command"
    annotation(Placement(transformation(extent={{-100,-90},{-80,-70}})));
equation
  connect(timHea.passed, preHea.u)
    annotation(Line(points={{-38,72},{-30,72},{-30,60},{-22,60}},
      color={255,0,255}));
  connect(falEdgHea.y, swiRunHea.u2)
    annotation(Line(points={{-78,48},{-60,48},{-60,40},{18,40}},
      color={255,0,255}));
  connect(preHea.y, swiRunHea.u1)
    annotation(Line(points={{2,60},{10,60},{10,48},{18,48}},
      color={255,0,255}));
  connect(tru.y, swiRunHea.u3)
    annotation(Line(points={{2,0},{14,0},{14,32},{18,32}},
      color={255,0,255}));
  connect(falEdgCoo.y, swiRunCoo.u2)
    annotation(Line(points={{-78,-50},{-60,-50},{-60,-40},{18,-40}},
      color={255,0,255}));
  connect(preCoo.y, swiRunCoo.u1)
    annotation(Line(points={{2,-60},{10,-60},{10,-32},{18,-32}},
      color={255,0,255}));
  connect(timCoo.passed, preCoo.u)
    annotation(Line(points={{-38,-88},{-30,-88},{-30,-60},{-22,-60}},
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
  connect(u1Coo, falEdgCoo.u)
    annotation(Line(points={{-140,-80},{-110,-80},{-110,-50},{-102,-50}},
      color={255,0,255}));
  connect(notHea.y, timHea.u)
    annotation(Line(points={{-78,80},{-62,80}},
      color={255,0,255}));
  connect(u1Hea, notHea.u)
    annotation(Line(points={{-140,60},{-110,60},{-110,80},{-102,80}},
      color={255,0,255}));
  connect(u1Hea, pasHea.u)
    annotation(Line(points={{-140,60},{-110,60},{-110,110},{-102,110}},
      color={255,0,255}));
  connect(pasHea.y[1], timHea.u)
    annotation(Line(points={{-78,110},{-70,110},{-70,80},{-62,80}},
      color={255,0,255}));
  connect(u1Hea, falEdgHea.u)
    annotation(Line(points={{-140,60},{-110,60},{-110,48},{-102,48}},
      color={255,0,255}));
  connect(u1Hea, edgHea.u)
    annotation(Line(points={{-140,60},{-110,60},{-110,20},{-102,20}},
      color={255,0,255}));
  connect(edgHea.y, swiRunHea.u2)
    annotation(Line(points={{-78,20},{-60,20},{-60,40},{18,40}},
      color={255,0,255}));
  connect(u1Coo, edgCoo.u)
    annotation(Line(points={{-140,-80},{-110,-80},{-110,-20},{-102,-20}},
      color={255,0,255}));
  connect(u1Coo, pasCoo.u)
    annotation(Line(points={{-140,-80},{-102,-80}},
      color={255,0,255}));
  connect(pasCoo.y[1], timCoo.u)
    annotation(Line(points={{-78,-80},{-62,-80}},
      color={255,0,255}));
  connect(u1Coo, notCoo.u)
    annotation(Line(points={{-140,-80},{-110,-80},{-110,-112},{-102,-112}},
      color={255,0,255}));
  connect(notCoo.y, timCoo.u)
    annotation(Line(points={{-78,-112},{-70,-112},{-70,-80},{-62,-80}},
      color={255,0,255}));
  connect(edgCoo.y, swiRunCoo.u2)
    annotation(Line(points={{-78,-20},{-60,-20},{-60,-40},{18,-40}},
      color={255,0,255}));
annotation(defaultComponentName="assMinRunTimPhp",
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
  This block asserts that each polyvalent heat pump does not short cycle,
  based on its heating and cooling on/off commands.
</p>
<p>
  If <code>use_runTim=true</code> (default), it asserts that each mode command
  remains <code>true</code> for at least <code>dt_min</code> before it turns
  <code>false</code>.
</p>
<p>
  If <code>use_runTim=false</code>, it asserts that each mode command remains
  <code>false</code> for at least <code>dt_min</code> before it turns
  <code>true</code>.
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

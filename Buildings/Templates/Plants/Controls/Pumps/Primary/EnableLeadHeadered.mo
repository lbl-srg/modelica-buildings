within Buildings.Templates.Plants.Controls.Pumps.Primary;
block EnableLeadHeadered
  "Lead pump enabling/disabling for plants with headered primary pumps"
  parameter Buildings.Templates.Plants.Controls.Types.EquipmentConnection typCon
    "Type of connection between equipment and primary loop"
    annotation (Evaluate=true);
  parameter Buildings.Templates.Plants.Controls.Types.Actuator typValIso=
    Buildings.Templates.Plants.Controls.Types.Actuator.TwoPosition
    "Type of isolation valve"
    annotation (Evaluate=true);
  parameter Integer nValIso(
    final min=1)
    "Number of isolation valves"
    annotation (Evaluate=true);
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1ValIso[nValIso]
    if typValIso == Buildings.Templates.Plants.Controls.Types.Actuator.TwoPosition
    "Isolation valve command"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uValIso[nValIso]
    if typValIso == Buildings.Templates.Plants.Controls.Types.Actuator.Modulating
    "Isolation valve command"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1
    "Lead pump enable signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyOpePar(
    nin=nValIso)
    if typCon == Buildings.Templates.Plants.Controls.Types.EquipmentConnection.Parallel
    "Return true if any valve is commanded open - Parallel piped equipment"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd allCloPar(
    nin=nValIso)
    if typCon == Buildings.Templates.Plants.Controls.Types.EquipmentConnection.Parallel
    "Return true if all valves are commanded closed - Parallel piped equipment"
    annotation (Placement(transformation(extent={{10,-50},{30,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Not cloParMod[nValIso]
    if typValIso == Buildings.Templates.Plants.Controls.Types.Actuator.Modulating
      and typCon == Buildings.Templates.Plants.Controls.Types.EquipmentConnection.Parallel
    "Return true if valve is commanded closed"
    annotation (Placement(transformation(extent={{-30,-50},{-10,-30}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold opeParMod[nValIso](
    each final t=0)
    if typValIso == Buildings.Templates.Plants.Controls.Types.Actuator.Modulating
      and typCon == Buildings.Templates.Plants.Controls.Types.EquipmentConnection.Parallel
    "Return true if valve commanded > 0 % open"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Clear enable signal if disable conditions are met"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyCloSer(
    nin=nValIso)
    if typCon == Buildings.Templates.Plants.Controls.Types.EquipmentConnection.Series
    "Return true if any valve is commanded closed - Series piped equipment"
    annotation (Placement(transformation(extent={{10,70},{30,90}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd allOpeSer(
    nin=nValIso)
    if typCon == Buildings.Templates.Plants.Controls.Types.EquipmentConnection.Series
    "Return true if all valves are commanded open - Series piped equipment"
    annotation (Placement(transformation(extent={{10,30},{30,50}})));
  Buildings.Controls.OBC.CDL.Reals.LessThreshold cloSerMod[nValIso](
    each final t=0.99)
    if typValIso == Buildings.Templates.Plants.Controls.Types.Actuator.Modulating
      and typCon == Buildings.Templates.Plants.Controls.Types.EquipmentConnection.Series
    "Return true if valve commanded < 99 % open"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Not opeSerMod[nValIso]
    if typValIso == Buildings.Templates.Plants.Controls.Types.Actuator.Modulating
      and typCon == Buildings.Templates.Plants.Controls.Types.EquipmentConnection.Series
    "Return true if valve is commanded open"
    annotation (Placement(transformation(extent={{-30,-90},{-10,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Not cloTwo[nValIso]
    if typValIso == Buildings.Templates.Plants.Controls.Types.Actuator.TwoPosition
    "Return true if valve is commanded closed"
    annotation (Placement(transformation(extent={{-30,10},{-10,30}})));
equation
  connect(uValIso, opeParMod.u)
    annotation (Line(points={{-120,-40},{-82,-40}},color={0,0,127}));
  connect(opeParMod.y, cloParMod.u)
    annotation (Line(points={{-58,-40},{-32,-40}},color={255,0,255}));
  connect(lat.y, y1)
    annotation (Line(points={{92,0},{120,0}},color={255,0,255}));
  connect(anyOpePar.y, lat.u)
    annotation (Line(points={{32,0},{68,0}},color={255,0,255}));
  connect(allCloPar.y, lat.clr)
    annotation (Line(points={{32,-40},{50,-40},{50,-6},{68,-6}},color={255,0,255}));
  connect(allOpeSer.y, lat.clr)
    annotation (Line(points={{32,40},{50,40},{50,-6},{68,-6}},color={255,0,255}));
  connect(anyCloSer.y, lat.u)
    annotation (Line(points={{32,80},{60,80},{60,0},{68,0}},color={255,0,255}));
  connect(uValIso, cloSerMod.u)
    annotation (Line(points={{-120,-40},{-90,-40},{-90,-80},{-82,-80}},color={0,0,127}));
  connect(cloSerMod.y, opeSerMod.u)
    annotation (Line(points={{-58,-80},{-32,-80}},color={255,0,255}));
  connect(u1ValIso, cloTwo.u)
    annotation (Line(points={{-120,0},{-60,0},{-60,20},{-32,20}},color={255,0,255}));
  connect(cloTwo.y, anyCloSer.u)
    annotation (Line(points={{-8,20},{0,20},{0,80},{8,80}},color={255,0,255}));
  connect(u1ValIso, anyOpePar.u)
    annotation (Line(points={{-120,0},{8,0}},color={255,0,255}));
  connect(cloTwo.y, allCloPar.u)
    annotation (Line(points={{-8,20},{0,20},{0,-40},{8,-40}},color={255,0,255}));
  connect(u1ValIso, allOpeSer.u)
    annotation (Line(points={{-120,0},{0,0},{0,40},{8,40}},color={255,0,255}));
  connect(cloParMod.y, allCloPar.u)
    annotation (Line(points={{-8,-40},{0,-40},{0,-40},{8,-40}},color={255,0,255}));
  connect(cloSerMod.y, anyCloSer.u)
    annotation (Line(points={{-58,-80},{-40,-80},{-40,80},{8,80}},color={255,0,255}));
  connect(opeSerMod.y, allOpeSer.u)
    annotation (Line(points={{-8,-80},{0,-80},{0,40},{8,40}},color={255,0,255}));
  connect(opeParMod.y, anyOpePar.u)
    annotation (Line(points={{-58,-40},{-40,-40},{-40,0},{8,0}},color={255,0,255}));
  annotation (
    defaultComponentName="enaLea",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255})}),
    Documentation(
      info="<html>
<p>
For parallel piped equipment (as specified by the parameter <code>typCon</code>):
</p>
<ul>
<li>
The lead primary pump is enabled when any equipment isolation valve is commanded open.
</li>
<li>
The lead primary pump is disabled when all equipment isolation valves are commanded closed.
</li>
</ul>
<p>
For series piped equipment (as specified by the parameter <code>typCon</code>):
</p>
<ul>
<li>
The lead primary pump is enabled when any equipment isolation valve is commanded closed.
</li>
<li>
The lead primary pump is disabled when all equipment isolation valves are commanded open.
</li>
</ul>
<p>
For modulating valves and parallel piped equipment, the \"valve commanded open\"
condition is evaluated based on a command signal <i>&gt;&nbsp;0&nbsp;%</i>.
The \"valve commanded closed\" condition is evaluated as the negation of the previous condition.
</p>
<p>
For modulating valves and series piped equipment, the \"valve commanded closed\"
condition is evaluated based on a command signal <i>&lt;&nbsp;100&nbsp;%</i>.
The \"valve commanded open\" condition is evaluated as the negation of the previous condition.
</p>
<p>
No hysteresis is used to evaluate these conditions because the
modulating valve command signal is generated by the
enabling or staging logic, both of which contain minimum runtime conditions.
Therefore, the valve command signal is not subject to any oscillatory
behavior.
</p>
<h4>Details</h4>
<p>This logic is prescribed in ASHRAE, 2021 for:
</p>
<ul>
<li>
headered primary pumps in chiller plants with parallel chillers
and without a waterside economizer,
</li>
<li>
primary pumps in chiller plants with series chillers
and without a waterside economizer,
</li>
<li>
headered primary pumps in boiler plants.
</li>
</ul>
<p>
The valve <i>command</i> is used in contrast to the feedback of the
valve position or the end switch status, as prescribed by Guideline 36.
</p>
<h4>References</h4>
<ul>
<li id=\"ASHRAE2021\">
ASHRAE, 2021. Guideline 36-2021, High-Performance Sequences of Operation
for HVAC Systems. Atlanta, GA.
</li>
</ul>
</html>"));
end EnableLeadHeadered;

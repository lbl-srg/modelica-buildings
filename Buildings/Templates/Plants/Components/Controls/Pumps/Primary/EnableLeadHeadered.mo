within Buildings.Templates.Plants.Components.Controls.Pumps.Primary;
block EnableLeadHeadered "Plants with headered primary pumps"

  parameter Buildings.Templates.Plants.Components.Controls.Types.EquipmentConnection
    typCon "Type of connection between equipment and primary loop"
    annotation (Evaluate=true);
  parameter Buildings.Templates.Plants.Components.Controls.Types.Actuator typValIso=
    Buildings.Templates.Plants.Components.Controls.Types.Actuator.TwoPosition
    "Type of isolation valve"
    annotation(Evaluate=true);
  parameter Integer nValIso(final min=1)
    "Number of isolation valves"
    annotation(Evaluate=true);

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1ValIso[nValIso]
    if typValIso==Buildings.Templates.Plants.Components.Controls.Types.Actuator.TwoPosition
    "Isolation valve command"
    annotation (Placement(
        transformation(extent={{-140,-20},{-100,20}}), iconTransformation(
          extent={{-300,-56},{-260,-16}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uValIso[nValIso]
    if typValIso==Buildings.Templates.Plants.Components.Controls.Types.Actuator.Modulating
    "Isolation valve command"
    annotation (Placement(
        transformation(extent={{-140,-60},{-100,-20}}), iconTransformation(
          extent={{-244,-92},{-204,-52}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1
    "Lead pump enable signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
    iconTransformation(extent={{-300,-56},{-260,-16}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr anyOpe(nin=nValIso)
    if typCon==Buildings.Templates.Plants.Components.Controls.Types.EquipmentConnection.Parallel
    "Return true if any valve is commanded open"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd allClo(nin=nValIso)
    if typCon==Buildings.Templates.Plants.Components.Controls.Types.EquipmentConnection.Parallel
    "Return true if all valves are commanded closed"
    annotation (Placement(transformation(extent={{10,-50},{30,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Not clo[nValIso]
    "Return true if valve is commanded closed"
    annotation (Placement(transformation(extent={{-30,-50},{-10,-30}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold ope[nValIso](each final t=0)
    if typValIso==Buildings.Templates.Plants.Components.Controls.Types.Actuator.Modulating
    "Return true if valve commanded > 0 % open"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Clear enable signal if disable conditions are met"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyClo(nin=nValIso)
    if typCon==Buildings.Templates.Plants.Components.Controls.Types.EquipmentConnection.Series
    "Return true if any valve is commanded closed"
    annotation (Placement(transformation(extent={{10,70},{30,90}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd allOpe(nin=nValIso)
    if typCon==Buildings.Templates.Plants.Components.Controls.Types.EquipmentConnection.Series
    "Return true if all valves are commanded open"
    annotation (Placement(transformation(extent={{10,30},{30,50}})));
equation
  connect(u1ValIso, anyOpe.u)
    annotation (Line(points={{-120,0},{8,0}},  color={255,0,255}));
  connect(u1ValIso, clo.u) annotation (Line(points={{-120,0},{-40,0},{-40,-40},
          {-32,-40}},color={255,0,255}));
  connect(uValIso, ope.u)
    annotation (Line(points={{-120,-40},{-82,-40}}, color={0,0,127}));
  connect(ope.y, clo.u)
    annotation (Line(points={{-58,-40},{-32,-40}}, color={255,0,255}));
  connect(clo.y, allClo.u)
    annotation (Line(points={{-8,-40},{8,-40}},  color={255,0,255}));
  connect(lat.y, y1)
    annotation (Line(points={{92,0},{120,0}}, color={255,0,255}));
  connect(anyOpe.y, lat.u)
    annotation (Line(points={{32,0},{68,0}}, color={255,0,255}));
  connect(allClo.y, lat.clr) annotation (Line(points={{32,-40},{50,-40},{50,-6},
          {68,-6}}, color={255,0,255}));
  connect(clo.y, anyClo.u) annotation (Line(points={{-8,-40},{0,-40},{0,80},{8,
          80}},    color={255,0,255}));
  connect(u1ValIso, allOpe.u) annotation (Line(points={{-120,0},{-40,0},{-40,40},
          {8,40}},  color={255,0,255}));
  connect(allOpe.y, lat.clr) annotation (Line(points={{32,40},{50,40},{50,-6},{
          68,-6}}, color={255,0,255}));
  connect(anyClo.y, lat.u) annotation (Line(points={{32,80},{60,80},{60,0},{68,
          0}}, color={255,0,255}));
  annotation (
    defaultComponentName="enaLea",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Line(
          points={{-90,-80.3976},{68,-80.3976}},
          color={192,192,192}),
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255})}),
    Documentation(info="<html>
<p>Used in Guideline 36 for:
</p>
<ul>
<li>
chiller plants with parallel chillers, headered primary pumps, 
and without a waterside economizer,
</li>
<li>
chiller plants with series chillers and without a waterside 
economizer,
</li>
<li>
boiler plants with headered primary pumps.
</li>
</ul>
<p>
The valve <i>command</i> is used in contrast to the feedback of the 
valve position or the end switch status, as prescribed by Guideline 36.
</p>
<p>
For modulating valves, the \"valve commanded open\" condition is evaluated
based on a commanded position <i>>&nbsp;0&nbsp;%</i>.
No hysteresis is used here because the valve command is generated by the
enabling or staging logic, both of which contain minimum runtime conditions.
Therefore, the valve command signal is not subject to any oscillatory
behavior.
</p>
</html>"));
end EnableLeadHeadered;

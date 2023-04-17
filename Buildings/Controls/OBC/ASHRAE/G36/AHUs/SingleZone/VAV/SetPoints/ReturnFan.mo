within Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints;
block ReturnFan "Return fan control for single zone AHU"

  parameter Real speDif=-0.1
    "Speed difference between supply and return fan to maintain building pressure at desired pressure"
    annotation (__cdl(ValueInReference=False));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uSupFan_actual(
    final min=0,
    final max=1,
    final unit="1")
    "Actual supply fan speed"
    annotation (Placement(transformation(extent={{-160,40},{-120,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1SupFan
    "Supply fan command on"
    annotation (Placement(transformation(extent={{-160,-20},{-120,20}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ExhDam
    "Exhaust damper commanded on"
    annotation (Placement(transformation(extent={{120,60},{160,100}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRetFan(
    final unit="1",
    final min=0,
    final max=1)
    "Return fan commanded speed"
    annotation (Placement(transformation(extent={{120,-20},{160,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1RetFan
    "Return fan command on"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}}),
        iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(
    final p=speDif)
    "Adjusted return fan speed"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi "Return fan speed"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=0) "Zero speed"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));

equation
  connect(uSupFan_actual, addPar.u)
    annotation (Line(points={{-140,60},{-62,60}}, color={0,0,127}));
  connect(u1SupFan, swi.u2)
    annotation (Line(points={{-140,0},{38,0}}, color={255,0,255}));
  connect(con.y, swi.u3) annotation (Line(points={{-38,-50},{20,-50},{20,-8},{38,
          -8}}, color={0,0,127}));
  connect(addPar.y, swi.u1) annotation (Line(points={{-38,60},{20,60},{20,8},{38,
          8}}, color={0,0,127}));
  connect(swi.y, yRetFan)
    annotation (Line(points={{62,0},{140,0}}, color={0,0,127}));
  connect(u1SupFan, y1ExhDam) annotation (Line(points={{-140,0},{0,0},{0,80},{140,
          80}}, color={255,0,255}));
  connect(u1SupFan, y1RetFan) annotation (Line(points={{-140,0},{0,0},{0,-60},{
          120,-60}}, color={255,0,255}));
annotation (
  defaultComponentName = "retFan",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
    graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-96,68},{-34,52}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uSupFan_actual"),
        Text(
          extent={{-98,-52},{-52,-66}},
          textColor={255,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="u1SupFan"),
        Text(
          extent={{58,8},{98,-6}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yRetFan"),
        Text(
          extent={{52,70},{98,56}},
          textColor={255,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="y1ExhDam"),
        Text(
          extent={{52,-52},{98,-66}},
          textColor={255,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="y1RetFan")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,120}})),
 Documentation(info="<html>
<p>
Sequence for controlling return fan <code>yRetFan</code> for single AHUs.
It is implemented according to Section 5.18.10 of ASHRAE Guideline G36, May 2020.
</p>
<ul>
<li>
Exhaust damper shall open whenever associated supply fan is proven on.
</li>
<li>
Return fan shall run whenever associated supply fan is proven on.
</li>
<li>
Return fan speed shall be the same as supply fan speed with a user adjustable offset.
See Section 3.2.1.5 for details about the offset.
</li>
<li>
Exhaust damper shall be closed when return fan is disabled.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
May 20, 2021, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ReturnFan;

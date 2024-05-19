within Buildings.Controls.OBC.ASHRAE.G36.AHUs.SingleZone.VAV.SetPoints;
block ReliefDamper
  "Relief damper control for AHUs using actuated dampers without fan"

  parameter Real relDam_min
    "Relief-damper position that maintains a building pressure of 12 Pa while the economizer damper is positioned to provide minimum outdoor air while the supply fan is at minimum speed";
  parameter Real relDam_max
    "Relief-damper position that maintains a building pressure of 12 Pa while the economizer damper is fully open and the fan speed is at cooling maximum";
  parameter Real posHys=0.05
    "Hysteresis for damper position check"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOutDam_min(
    final min=0,
    final max=1,
    final unit="1")
    "Outdoor air damper minimum position"
    annotation (Placement(transformation(extent={{-160,80},{-120,120}}),
        iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOutDam(
    final min=0,
    final max=1,
    final unit="1")
    "Outdoor damper position"
    annotation (Placement(transformation(extent={{-160,30},{-120,70}}),
        iconTransformation(extent= {{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1SupFan
    "Supply fan command on"
    annotation (Placement(transformation(extent={{-160,-100},{-120,-60}}),
        iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yRelDam(
    final unit="1",
    final min=0,
    final max=1)
    "Relief damper commanded position"
    annotation (Placement(transformation(extent={{120,-60},{160,-20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr(
    final t=0.05,
    final h=posHys)
    "Check if the outdoor damper is open"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Check if the relief damper should be open"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    "Check if relief damper should be enabled"
    annotation (Placement(transformation(extent={{80,-50},{100,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zerDam(
    final k=0) "Close damper when disabled"
    annotation (Placement(transformation(extent={{-20,-110},{0,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant minRel(
    final k=relDam_min)
    "Minimum relief damper position"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant maxRel(
    final k=relDam_max)
    "Maximum relief damper position"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant fulOpe(
    final k=1)
    "Fully open relief damper"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  Buildings.Controls.OBC.CDL.Reals.Line relDam(
    final limitBelow=true,
    final limitAbove=true)
    "Relief damper signal is linearly proportional to the control signal between signal limits"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));

equation
  connect(zerDam.y, swi.u3)
    annotation (Line(points={{2,-100},{60,-100},{60,-48},{78,-48}}, color={0,0,127}));
  connect(swi.y, yRelDam)
    annotation (Line(points={{102,-40},{140,-40}},color={0,0,127}));
  connect(greThr.y, and2.u1)
    annotation (Line(points={{-58,-40},{-22,-40}}, color={255,0,255}));
  connect(u1SupFan, and2.u2) annotation (Line(points={{-140,-80},{-40,-80},{-40,
          -48},{-22,-48}}, color={255,0,255}));
  connect(and2.y, swi.u2)
    annotation (Line(points={{2,-40},{78,-40}}, color={255,0,255}));
  connect(uOutDam, relDam.u)
    annotation (Line(points={{-140,50},{18,50}}, color={0,0,127}));
  connect(uOutDam_min, relDam.x1) annotation (Line(points={{-140,100},{-40,100},
          {-40,58},{18,58}}, color={0,0,127}));
  connect(minRel.y, relDam.f1) annotation (Line(points={{-78,80},{-60,80},{-60,54},
          {18,54}}, color={0,0,127}));
  connect(relDam.y, swi.u1) annotation (Line(points={{42,50},{60,50},{60,-32},{78,
          -32}}, color={0,0,127}));
  connect(uOutDam, greThr.u) annotation (Line(points={{-140,50},{-110,50},{-110,
          -40},{-82,-40}}, color={0,0,127}));
  connect(fulOpe.y, relDam.x2) annotation (Line(points={{-78,20},{-60,20},{-60,46},
          {18,46}}, color={0,0,127}));
  connect(maxRel.y, relDam.f2) annotation (Line(points={{-18,20},{0,20},{0,42},{
          18,42}}, color={0,0,127}));

annotation (
  defaultComponentName = "relDam",
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
          extent={{-96,78},{-50,64}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uOutDam_min"),
        Text(
          extent={{-98,8},{-60,-6}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uOutDam"),
        Text(
          extent={{-100,-62},{-54,-76}},
          textColor={255,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="u1SupFan"),
        Text(
          extent={{52,8},{98,-6}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yRelDam")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,120}})),
 Documentation(info="<html>
<p>
Sequence for controlling actuated relief damper <code>yRelDam</code> for AHUs using
actuated relief damper without a fan.
It is implemented according to Section 5.18.8 of ASHRAE Guideline G36, May 2020.
</p>
<p>
In Section 3.2.2.3, find the relief damper position setpoint limits:
</p>
<ul>
<li>
<code>relDam_min</code>: the relief damper position that maintainx a building pressure
of 12 Pa (0.05 in. of water) while the economizer is positioned to provide minimum
outdoor airflow while the supply fan is at minimum speed.
</li>
<li>
<code>relDam_max</code>: the relief damper position that maintainx a building pressure
of 12 Pa (0.05 in. of water) while the economizer damper is fully open and the fan
speed is at cooling maximum.
</li>
</ul>
<p>
Relief damper shall be enabled when the associated supply fan is proven on and any
outdoor air damper is open, and disabled and closed otherwise.
</p>
<p>
Relief damper position shall be reset lineary from <code>relDam_min</code> to
<code>relDam_max</code> as the commanded economizer damper position goes from
<code>uOutDam_min</code> to 100% open.
</p>
<p align=\"center\">
<img alt=\"Image of the relief damper control chart for single zone AHU\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36/AHUs/SingleZone/VAV/SetPoints/ReliefDamper.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
May 20, 2021, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ReliefDamper;

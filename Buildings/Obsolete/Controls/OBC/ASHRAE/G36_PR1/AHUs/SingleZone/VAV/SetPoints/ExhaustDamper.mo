within Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.SetPoints;
block ExhaustDamper
  "Control of actuated exhaust  dampers without fans"
  parameter Real minExhDamPos(
    min=0,
    max=1,
    final unit="1") = 0.2
    "Exhaust damper position maintaining building static pressure at setpoint when the system is at minPosMin"
    annotation(Dialog(group="Nominal parameters"));
  parameter Real maxExhDamPos(
    min=0,
    max=1,
    final unit="1") = 0.9
    "Exhaust damper position maintaining building static pressure at setpoint when outdoor air damper is fully open and fan speed is at cooling maximum"
    annotation(Dialog(group="Nominal parameters"));
  parameter Real minOutPosMin(
    min=0,
    max=1,
    final unit="1") = 0.4
    "Outdoor air damper position when fan operating at minimum speed to supply minimum outdoor air flow"
    annotation(Dialog(group="Nominal parameters"));
  parameter Real outDamPhyPosMax(
    min=0,
    max=1,
    final unit="1")=1
    "Physical or at the comissioning fixed maximum position of the outdoor air damper"
    annotation(Dialog(group="Nominal parameters"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSupFan "Supply fan status"
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uOutDamPos(
    min=0,
    max=1,
    final unit="1")
    "Outdoor air damper position"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yExhDamPos(
    min=0,
    max=1,
    final unit="1") "Exhaust damper position"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Reals.Line exhDamPos
    "Linearly map exhaust damper position to the outdoor air damper position"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1
    "Check if exhaust damper should be open"
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis greThr(
    final uLow=0.02,
    final uHigh=0.05)
    "Check if outdoor air damper is open"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Check if exhaust damper should be activated"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zerDam(
    final k=0)
    "Close damper when disabled"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant minExhDam(
    final k=minExhDamPos)
    "Exhaust damper position maintaining building static pressure at setpoint while the system is at minPosMin"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant maxExhDam(
    final k=maxExhDamPos)
    "Exhaust damper position maintaining building static pressure at setpoint when outdoor air damper is fully open and fan speed is at cooling maximum"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant minPosAtMinSpd(
    final k=minOutPosMin)
    "Outdoor air damper position when fan operating at minimum speed to supply minimum outdoor air flow"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant outDamPhyPosMaxSig(
    final k=outDamPhyPosMax)
    "Physical or at the comissioning fixed maximum position of the outdoor air damper"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));

equation
  connect(outDamPhyPosMaxSig.y, exhDamPos.x2)
    annotation (Line(points={{-18,40},{-4,40},{-4,-4},{18,-4}},
      color={0,0,127}));
  connect(maxExhDam.y, exhDamPos.f2)
    annotation (Line(points={{-58,20},{-12,20},{-12,-8},{18,-8}},
      color={0,0,127}));
  connect(uOutDamPos, exhDamPos.u)
    annotation (Line(points={{-120,0},{18,0}},
      color={0,0,127}));
  connect(zerDam.y, swi1.u3)
    annotation (Line(points={{42,-80},{50,-80},{50,-58},{58,-58}},
      color={0,0,127}));
  connect(and2.y, swi1.u2)
    annotation (Line(points={{2,-50},{58,-50}},
      color={255,0,255}));
  connect(minPosAtMinSpd.y, exhDamPos.x1)
    annotation (Line(points={{-18,80},{12,80},{12,8},{18,8}},
      color={0,0,127}));
  connect(minExhDam.y, exhDamPos.f1)
    annotation (Line(points={{-58,60},{4,60},{4,4},{18,4}},
      color={0,0,127}));
  connect(uOutDamPos, greThr.u)
    annotation (Line(points={{-120,0},{-80,0},{-80,-30},{-62,-30}},
      color={0,0,127}));
  connect(uSupFan, and2.u2)
    annotation (Line(points={{-120,-50},{-60,-50},{-60,-58},{-22,-58}},
      color={255,0,255}));
  connect(greThr.y, and2.u1)
    annotation (Line(points={{-38,-30},{-32,-30},{-32,-50},{-22,-50}},
      color={255,0,255}));
  connect(exhDamPos.y, swi1.u1)
    annotation (Line(points={{42,0},{50,0},{50,-42},{58,-42}},
      color={0,0,127}));
  connect(swi1.y, yExhDamPos)
    annotation (Line(points={{82,-50},{90,-50},{90,0},{120,0}},    color={0,0,127}));

annotation (
  defaultComponentName = "exhDam",
  Icon(graphics={Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-96,78},{-42,40}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uOutDamPos"),
        Text(
          extent={{-94,-48},{-62,-72}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uSupFan"),
        Text(
          extent={{46,18},{96,-18}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yExhDamPos"),
        Polygon(
          points={{-46,92},{-54,70},{-38,70},{-46,92}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-46,82},{-46,-86}}, color={192,192,192}),
        Line(points={{-56,-78},{68,-78}}, color={192,192,192}),
        Polygon(
          points={{72,-78},{50,-70},{50,-86},{72,-78}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-46,-78},{14,62},{80,62}}, color={0,0,127}),
        Text(
          extent={{-100,140},{100,100}},
          textColor={0,0,255},
          textString="%name")}),
   Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
 Documentation(info="<html>
<p>
Control sequence for exhaust dampers without fans. It is implemented according
to ASHRAE Guidline 35 (G36), PART 5.N.8.(for multi zone VAV AHU), PART 5.P.6
and PART3.2B.3 (for single zone VAV AHU).
</p>

<h4>Single zone VAV AHU: Control of actuated exhaust dampers without fans (PART 5.P.6)</h4>
<ol>
<li>Exhaust damper position setpoints (PART3.2B.3)
<ul>
<li><code>minExhDamPos</code> is the exhaust damper position that maintains a building
pressure of <i>12</i> Pa (<i>0.05</i> inchWC) while the system is at <code>minOutPosMin</code>
(i.e., the economizer damper is positioned to provide minimum outdoor air while
the supply fan is at minimum speed).
</li>
<li>
<code>maxExhDamPos</code> is the exhaust damper position that maintains a building
pressure of <i>12</i> Pa (<i>0.05</i> inchWC) while the economizer damper is fully
open and the fan speed is at cooling maximum.
</li>
</ul>
</li>
<li>
The exhaust damper is enabled when the associated supply fan is proven on and
any outdoor air damper is open <code>uOutDamPos &gt; 0</code> and disabled and closed
otherwise.
</li>
<li>
The exhaust damper position is reset linearly from <code>minExhDamPos</code> to
<code>maxExhDamPos</code> as the commanded economizer damper position goes from
<code>minOutPosMin</code> to <code>outDamPhyPosMax</code>.
</li>
</ol>
<p>
The control sequence is as follows:
</p>
<p align=\"center\">
<img alt=\"Image of the exhaust damper control chart for single zone AHU\"
src=\"modelica://Buildings/Resources/Images/Obsolete/Controls/OBC/ASHRAE/G36_PR1/AHUs/SingleZone/VAV/SetPoints/ExhaustDamper.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
October 18, 2017, by Michael Wetter:<br/>
Revised documentation.
</li>
<li>
May 12, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ExhaustDamper;

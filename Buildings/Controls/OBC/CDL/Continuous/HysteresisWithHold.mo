within Buildings.Controls.OBC.CDL.Continuous;
block HysteresisWithHold
  "Hysteresis block that optionally allows to specify a hold time"

  parameter Real uLow "if y=true and u<=uLow, switch to y=false";
  parameter Real uHigh "if y=false and u>=uHigh, switch to y=true";

  parameter Modelica.SIunits.Time trueHoldDuration
    "true hold duration";

  parameter Modelica.SIunits.Time falseHoldDuration = trueHoldDuration
    "false hold duration";

  Interfaces.RealInput u "Real input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Interfaces.BooleanOutput y "Boolean output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
      iconTransformation(extent={{100,-10},{120,10}})));

protected
  Continuous.Hysteresis hysteresis(
    final uLow=uLow,
    final uHigh=uHigh)
    "Transform Real to Boolean signal with Hysteresis"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  Logical.TrueFalseHold truFalHol(
    final trueHoldDuration=trueHoldDuration,
    final falseHoldDuration=falseHoldDuration) "True/false hold"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

equation
  connect(u, hysteresis.u)
    annotation (Line(points={{-120,0},{-100,0},{-42,0}}, color={0,0,127}));

  connect(hysteresis.y, truFalHol.u)
    annotation (Line(points={{-19,0},{39,0}}, color={255,0,255}));
  connect(truFalHol.y, y)
    annotation (Line(points={{61,0},{110,0}}, color={255,0,255}));
annotation (
  defaultComponentName="hysWitHol",
  Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          lineThickness=5.0,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Text(
          extent={{-66,-40},{62,-82}},
          lineColor={0,0,0},
          textString="%uLow     %uHigh"),
          Polygon(
            points={{-22,8},{-10,2},{-22,-4},{-22,8}},
            lineColor={0,0,0},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid),
          Line(points={{-48,2},{-16,2}}),
          Line(points={{-10,34},{-10,-36}}),
          Line(points={{-18,2},{18,2}}),
          Polygon(
            points={{12,8},{24,2},{12,-4},{12,8}},
            lineColor={0,0,0},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid),
          Rectangle(extent={{24,18},{62,-16}}, lineColor={0,0,0}),
          Rectangle(extent={{-86,18},{-48,-16}}, lineColor={0,0,0}),
        Text(
          extent={{-140,148},{160,108}},
          textString="%name",
          lineColor={0,0,255}),
        Ellipse(
          extent={{71,7},{85,-7}},
          lineColor=DynamicSelect({235,235,235}, if y then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if y then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid)}),
  Documentation(info="<html>
<p>
Model for a hysteresis block that optionally allows to specify a hold time.
During the hold time, the output is not allowed to switch.
</p>
<p>
When the input <code>u</code> becomes greater than <code>uHigh</code>, the
output <code>y</code> becomes <code>true</code> and remains <code>true</code>
for at least <code>trueHoldDuration</code> seconds, after which time it is allowed
to switch immediately.
</p>
<p>
When the input <code>u</code> becomes less than <code>uLow</code>, the output
<code>y</code> becomes <code>false</code> and remains <code>false</code> for
at least <code>falseHoldDuration</code> seconds, after which time it is allowed
to switch immediately.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Controls/OBC/CDL/Continuous/HysteresisWithHold.png\"
alt=\"Input and output of the block\"/>
</p>
<p>
This model for example could be used to disable an economizer, and not re-enable
it for <i>10</i> minutes, and vice versa. Using hysteresis can avoid the
distraction from the input noise.
</p>
</html>", revisions="<html>
<ul>
<li>
September 18, 2017, by Michael Wetter:<br/>
Refactored model to use <a href=\"modelica://Buildings.Controls.OBC.CDL.Logical.TrueFalseHold\">
Buildings.Controls.OBC.CDL.Logical.TrueFalseHold</a>.
</li>
<li>
June 26, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end HysteresisWithHold;

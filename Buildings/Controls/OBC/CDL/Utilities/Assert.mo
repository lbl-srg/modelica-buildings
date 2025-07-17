within Buildings.Controls.OBC.CDL.Utilities;
block Assert
  "Print a warning message when input becomes false"
  parameter String message
    "Message written when u becomes false";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u
    "Boolean input that triggers assert when it becomes false"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

equation
  assert(u, message, AssertionLevel.warning);
  annotation (
    defaultComponentName="assMes",
    Icon(
      graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,80},{-80,-60},{80,-60},{0,80}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Text(
          extent={{-100,160},{100,106}},
          textColor={0,0,255},
          textString="%name"),
        Polygon(
          points={{0,72},{-72,-56},{72,-56},{0,72}},
          lineColor={0,0,0},
          fillColor={255,255,170},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-4,38},{2,-24}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Ellipse(
          extent={{-6,-32},{4,-42}},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
    Documentation(
      info="<html>
<p>
Block that writes a warning if the input becomes <code>false</code>.
</p>
<p>
Tools or control systems are expected to write <code>message</code> together
with a time stamp to an output device and/or a log file.
</p>
</html>",
      revisions="<html>
<ul>
<li>
November 6, 2017, by Michael Wetter:<br/>
Simplified implementation.
</li>
<li>
November 3, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Assert;

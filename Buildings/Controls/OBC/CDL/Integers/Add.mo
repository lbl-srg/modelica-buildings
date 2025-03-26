within Buildings.Controls.OBC.CDL.Integers;
block Add
  "Output the sum of the two inputs"
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput u1
    "Connector of Integer input signal 1"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput u2
    "Connector of Integer input signal 2"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput y
    "Connector of Integer output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

equation
  y=u1+u2;

annotation (defaultComponentName="addInt",
  Documentation(info="<html>
<p>
Block that outputs <code>y</code> as the sum of the
two Integer input signals <code>u1</code> and <code>u2</code>,
</p>
<pre>
    y = u1 + u2.
</pre>
</html>",
revisions="<html>
<ul>
<li>
January 27, 2022, by Jianjun Hu:<br/>
Removed gain factors.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2865\">issue 2865</a>.
</li>
<li>
January 3, 2017, by Michael Wetter:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"),
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255}),
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={255,127,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-100,60},{-74,24},{-44,24}},
          color={255,127,0}),
        Line(
          points={{-100,-60},{-74,-28},{-42,-28}},
          color={255,127,0}),
        Ellipse(
          lineColor={255,127,0},
          extent={{-50,-50},{50,50}}),
        Line(
          points={{50,0},{100,0}},
          color={255,127,0}),
        Text(
          extent={{-36,-24},{40,44}},
          textString="+")}));
end Add;

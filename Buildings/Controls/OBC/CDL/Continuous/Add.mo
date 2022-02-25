within Buildings.Controls.OBC.CDL.Continuous;
block Add
  "Output the sum of the two inputs"
  Interfaces.RealInput u1
    "Connector of Real input signal 1"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Interfaces.RealInput u2
    "Connector of Real input signal 2"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Interfaces.RealOutput y
    "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

equation
  y=u1+u2;
  annotation (
    defaultComponentName="add2",
    Documentation(
      info="<html>
<p>
Block that outputs <code>y</code> as the sum of the
two input signals <code>u1</code> and <code>u2</code>,
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
March 2, 2020, by Michael Wetter:<br/>
Changed icon to display dynamically the output value.
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
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          lineColor={0,0,127},
          extent={{-50,-50},{50,50}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255}),
        Line(
          points={{-100,60},{-74,24},{-44,24}},
          color={0,0,127}),
        Line(
          points={{-100,-60},{-74,-28},{-42,-28}},
          color={0,0,127}),
        Line(
          points={{50,0},{100,0}},
          color={0,0,127}),
        Text(
          extent={{-36,-26},{40,42}},
          textString="+"),
        Text(
          extent={{226,60},{106,10}},
          textColor={0,0,0},
          textString=DynamicSelect("",String(y,
            leftJustified=false,
            significantDigits=3)))}));
end Add;

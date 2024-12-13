within Buildings.Controls.OBC.CDL.Conversions;
block RealToInteger
  "Convert Real to Integer signal"
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u
    "Real signal to be converted to an Integer signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput y
    "Converted input signal as an Integer"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

equation
  y=if
      (u > 0) then
      integer(
        floor(
          u+0.5))
    else
      integer(
        ceil(
          u-0.5));
  annotation (
    defaultComponentName="reaToInt",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100.0,-100.0},{100.0,100.0}}),
      graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={255,127,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          textColor={0,0,127},
          extent={{-100.0,-40.0},{0.0,40.0}},
          textString="R"),
        Text(
          textColor={255,127,0},
          extent={{20.0,-40.0},{120.0,40.0}},
          textString="I"),
        Polygon(
          lineColor={255,127,0},
          fillColor={255,127,0},
          fillPattern=FillPattern.Solid,
          points={{50.0,0.0},{30.0,20.0},{30.0,10.0},{0.0,10.0},{0.0,-10.0},{30.0,-10.0},{30.0,-20.0},{50.0,0.0}}),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255})}),
    Documentation(
      info="<html>
<p>
Block that outputs <code>y</code>
as the nearest integer value of the input <code>u</code>.
</p>
<p>
The block outputs
</p>
<pre>
    y = integer( floor( u + 0.5 ) )  if u &gt; 0,
    y = integer( ceil ( u - 0.5 ) )  otherwise.
</pre>
</html>",
      revisions="<html>
<ul>
<li>
January 3, 2017, by Michael Wetter:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end RealToInteger;

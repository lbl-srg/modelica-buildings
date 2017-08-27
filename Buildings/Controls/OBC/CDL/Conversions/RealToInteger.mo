within Buildings.Controls.OBC.CDL.Conversions;
block RealToInteger "Convert Real to Integer signal"

  Interfaces.RealInput u "Connector of Real input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Interfaces.IntegerOutput y
    "Connector of Integer output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  y = if (u > 0) then integer(floor(u + 0.5)) else integer(ceil(u - 0.5));

annotation (
defaultComponentName="reaToInt",
Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100.0,-100.0},{100.0,100.0}}),
        graphics={
        Rectangle(
            extent={{-100,-100},{100,100}},
            lineColor={255,127,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
        Text(
          lineColor={0,0,127},
          extent={{-100.0,-40.0},{0.0,40.0}},
          textString="R"),
        Text(
          lineColor={255,127,0},
          extent={{20.0,-40.0},{120.0,40.0}},
          textString="I"),
        Polygon(
          lineColor={255,127,0},
          fillColor={255,127,0},
          fillPattern=FillPattern.Solid,
          points={{50.0,0.0},{30.0,20.0},{30.0,10.0},{0.0,10.0},{0.0,-10.0},{
              30.0,-10.0},{30.0,-20.0},{50.0,0.0}}),
                                            Text(
            extent={{-150,150},{150,110}},
            textString="%name",
            lineColor={0,0,255})}),
Documentation(info="<html>
<p>
Block that outputs <code>y</code>
as the nearest integer value of the input <code>u</code>.
</p>
<p>
The block outputs
</p>
<pre>
    y = integer( floor( u + 0.5 ) )  for  u &gt; 0,
    y = integer( ceil ( u - 0.5 ) )  for  u &lt; 0.
</pre>
</html>", revisions="<html>
<ul>
<li>
January 3, 2017, by Michael Wetter:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end RealToInteger;

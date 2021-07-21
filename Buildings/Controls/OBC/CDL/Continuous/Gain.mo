within Buildings.Controls.OBC.CDL.Continuous;
block Gain
  "Output the product of a gain value with the input signal"
  parameter Real k
    "Gain value multiplied with input signal";
  Interfaces.RealInput u
    "Input signal connector"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.RealOutput y
    "Output signal connector"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

equation
  y=k*u;
  annotation (
    defaultComponentName="gai",
    Documentation(
      info="<html>
<p>
Block that outputs <code>y = k * u</code>,
where
<code>k</code> is a parameter and
<code>u</code> is an input.
</p>
</html>",
      revisions="<html>
<ul>
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
        Polygon(
          points={{-100,-100},{-100,100},{100,0},{-100,-100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,-140},{150,-100}},
          lineColor={0,0,0},
          textString="k=%k"),
        Text(
          extent={{-150,144},{150,104}},
          textString="%name",
          lineColor={0,0,255}),
        Text(
          extent={{226,60},{106,10}},
          lineColor={0,0,0},
          textString=DynamicSelect("",String(y,
            leftjustified=false,
            significantDigits=3)))}));
end Gain;

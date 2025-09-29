within Buildings.Controls.OBC.CDL.Reals;
block MultiplyByParameter
  "Output the product of a gain value with the input signal"
  parameter Real k
    "Factor to be multiplied with input signal";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u
    "Input to be multiplied with gain"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Product of the parameter times the input"
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
January 27, 2022, by Jianjun Hu:<br/>
Renamed the block name from Gain to MultiplyByParameter.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2865\">Buildings, issue 2865</a>.
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
        Polygon(
          points={{-100,-100},{-100,100},{100,0},{-100,-100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,-140},{150,-100}},
          textColor={0,0,0},
          textString="k=%k"),
        Text(
          extent={{-150,144},{150,104}},
          textString="%name",
          textColor={0,0,255}),
        Text(
          extent={{226,60},{106,10}},
          textColor={0,0,0},
          textString=DynamicSelect("",String(y,
            leftJustified=false,
            significantDigits=3)))}));
end MultiplyByParameter;

within Buildings.Controls.OBC.CDL.Integers;
block Min
  "Pass through the smallest signal"
  Interfaces.IntegerInput u1
    "Connector of Integer input signal 1"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Interfaces.IntegerInput u2
    "Connector of Integer input signal 2"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Interfaces.IntegerOutput y
    "Connector of Integer output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

equation
  y=min(
    u1,
    u2);
  annotation (
    defaultComponentName="minInt",
    Documentation(
      info="<html>
<p>
Block that outputs <code>y = min(u1, u2)</code>,
where
<code>u1</code> and <code>u2</code> are inputs.
</p>
</html>",
      revisions="<html>
<ul>
<li>
January 9, 2017, by Milica Grahovac:<br/>
First integer implementation, based on the implementation of the
Modelica Standard Library.
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
          lineColor={255,127,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255}),
        Text(
          extent={{-90,36},{90,-36}},
          textColor={160,160,164},
          textString="min()")}));
end Min;

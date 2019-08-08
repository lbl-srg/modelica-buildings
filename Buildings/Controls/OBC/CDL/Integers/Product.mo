within Buildings.Controls.OBC.CDL.Integers;
block Product "Output product of the two inputs"

  Interfaces.IntegerInput u1 "Connector of Integer input signal 1"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));

  Interfaces.IntegerInput u2 "Connector of Integer input signal 2"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));

  Interfaces.IntegerOutput y "Connector of Integer output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

equation
  y = u1 * u2;

annotation (
defaultComponentName="proInt",
Documentation(info="<html>
<p>
Block that outputs <code>y = u1 * u2</code>,
where
<code>u1</code> and <code>u2</code> are Integer inputs.
</p>
</html>", revisions="<html>
<ul>
<li>
January 3, 2017, by Michael Wetter:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
                                           Rectangle(
            extent={{-100,-100},{100,100}},
            lineColor={255,127,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
        Line(points={{-100,60},{-40,60},{-30,40}}, color={255,127,0}),
        Line(points={{-100,-60},{-40,-60},{-30,-40}}, color={255,127,0}),
        Line(points={{50,0},{100,0}}, color={255,127,0}),
        Line(points={{-30,0},{30,0}}),
        Line(points={{-15,25.99},{15,-25.99}}),
        Line(points={{-15,-25.99},{15,25.99}}),
        Ellipse(lineColor={255,127,0}, extent={{-50,-50},{50,50}}),
                                        Text(
        extent={{-150,150},{150,110}},
        textString="%name",
        lineColor={0,0,255})}));
end Product;

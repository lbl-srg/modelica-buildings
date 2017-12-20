within Buildings.Controls.OBC.CDL.Continuous;
block Division "Output first input divided by second input"

  Interfaces.RealInput u1 "Connector of Real input signal 1"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));

  Interfaces.RealInput u2 "Connector of Real input signal 2"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));

  Interfaces.RealOutput y "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  y * u2 = u1;

annotation (
  defaultComponentName="div",
  Documentation(info="<html>
<p>
Block that outputs <code>y = u1 / u2</code>,
where
<code>u1</code> and <code>u2</code> are inputs.
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
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Ellipse(lineColor={0,0,127}, extent={{-50,-50},{50,50}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
        extent={{-150,150},{150,110}},
        textString="%name",
        lineColor={0,0,255}),
        Line(points={{50,0},{100,0}}, color={0,0,127}),
        Line(points={{-30,0},{30,0}}),
        Ellipse(fillPattern=FillPattern.Solid, extent={{-5,20},{5,30}}),
        Ellipse(fillPattern=FillPattern.Solid, extent={{-5,-30},{5,-20}}),
        Text(
          lineColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name"),
        Line(points={{-100,60},{-66,60},{-40,30}}, color={0,0,127}),
        Line(points={{-100,-60},{0,-60},{0,-50}}, color={0,0,127})}));
end Division;

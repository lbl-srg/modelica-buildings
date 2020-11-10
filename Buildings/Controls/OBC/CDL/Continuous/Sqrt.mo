within Buildings.Controls.OBC.CDL.Continuous;
block Sqrt
  "Output the square root of the input (input >= 0 required)"

  Interfaces.RealInput u "Connector of Real input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Interfaces.RealOutput y "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

equation
  y = sqrt(u);
  annotation (
    defaultComponentName="sqr",
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={  Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Line(points={{-90,-80},{68,-80}}, color={192,192,192}),
        Polygon(
          points={{90,-80},{68,-72},{68,-88},{90,-80}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,-80},{-79.2,-68.7},{-78.4,-64},{-76.8,-57.3},{-73.6,-47.9},
              {-67.9,-36.1},{-59.1,-22.2},{-46.2,-6.49},{-28.5,10.7},{-4.42,
              30},{27.7,51.3},{69.5,74.7},{80,80}},
          smooth=Smooth.Bezier),
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,-88},{-80,68}}, color={192,192,192}),
        Text(
          extent={{-8,-4},{64,-52}},
          lineColor={192,192,192},
          textString="sqrt"),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          lineColor={0,0,255}),
        Text(
          extent={{226,60},{106,10}},
          lineColor={0,0,0},
          textString=DynamicSelect("", String(y, leftjustified=false, significantDigits=3)))}),
    Documentation(info="<html>
<p>
Block that outputs square root of the input <code>y = sqrt(u)</code>,
where <code>u</code> is an input. All elements of the input vector shall be non-negative.
</p>
</html>", revisions="<html>
<ul>
<li>
March 2, 2020, by Michael Wetter:<br/>
Changed icon to display dynamically the output value.
</li>
<li>
March 15, 2017, by Jianjun Hu:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end Sqrt;

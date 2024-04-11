within Buildings.Controls.OBC.CDL.Reals;
block Asin "Output the arc sine of the input"
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u
    "Connector of Real input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(unit="rad")
    "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
equation
  y = Modelica.Math.asin(u);

annotation (defaultComponentName="arcSin",
 Icon(coordinateSystem(preserveAspectRatio=false),
   graphics={Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
        extent={{-100,140},{100,100}},
        textString="%name",
        textColor={0,0,255}),
        Polygon(
          points={{0,90},{-8,68},{8,68},{0,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{0,-80},{0,68}}, color={192,192,192}),
        Line(points={{-80,-80},{-79.2,-72.8},{-77.6,-67.5},{-73.6,-59.4},{-66.3,-49.8},
              {-53.5,-37.3},{-30.2,-19.7},{37.4,24.8},{57.5,40.8},{68.7,52.7},{75.2,
              62.2},{77.6,67.5},{80,80}},
          smooth=Smooth.Bezier),
        Line(points={{-90,0},{68,0}}, color={192,192,192}),
        Polygon(
          points={{90,0},{68,8},{68,-8},{90,0}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-88,78},{-16,30}},
          textColor={192,192,192},
          textString="asin"),
        Text(
          extent={{226,60},{106,10}},
          textColor={0,0,0},
          textString=DynamicSelect("",String(y,
            leftJustified=false,
            significantDigits=3)))}),
  Diagram(coordinateSystem(preserveAspectRatio=false)),
Documentation(info="<html>
<p>
Block that outputs <code>y = asin(u)</code>, where <code>u</code> is an input.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Controls/OBC/CDL/Reals/Asin.png\"
     alt=\"asin.png\" />
</p>
</html>",
revisions="<html>
<ul>
<li>
March 7, 2023, by Jianjun Hu:<br/>
Added unit <code>rad</code> to the output.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3277\">issue 3277</a>.
</li>
<li>
January 28, 2022, by Jianjun Hu:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end Asin;

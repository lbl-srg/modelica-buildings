within Buildings.Utilities.IO.Strings;
model Constant "Constant String value source"
  parameter String k "Constant String value";
  StringOutput y "Output of constant value"
    annotation (Placement(transformation(extent={{100,-10},
            {120,10}}), iconTransformation(extent={{100,-10},{120,10}})));
equation
  y = k;

annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                            Rectangle(
    extent={{-100,-100},{100,100}},
    lineColor={0,100,0},
    fillColor={255,255,255},
    fillPattern=FillPattern.Solid), Text(
    extent={{-148,146},{152,106}},
    textString="%name",
    textColor={0,0,255}),
    Polygon(
      points={{-80,90},{-88,68},{-72,68},{-80,90}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid),
    Line(points={{-80,68},{-80,-80}}, color={192,192,192}),
    Line(points={{-80,0},{80,0}}, color={0,100,0}),
    Line(points={{-90,-70},{82,-70}}, color={192,192,192}),
    Polygon(
      points={{90,-70},{68,-62},{68,-78},{90,-70}},
      lineColor={192,192,192},
      fillColor={192,192,192},
      fillPattern=FillPattern.Solid)}),                    Diagram(
    coordinateSystem(preserveAspectRatio=false)),
Documentation(info="<html>
<p>
  Constant String value source. 
</p>
</html>", revisions="<html><ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
</ul>
</html>"));
end Constant;

within Buildings.Utilities.IO.Strings;
model StringPassThrough
  StringInput u "String input = u" annotation (Placement(transformation(extent={{-120,-10},
            {-100,10}}), iconTransformation(extent={{-120,-10},{-100,10}})));
  StringOutput y "String output = u" annotation (Placement(transformation(extent={{100,-10},
            {120,10}}), iconTransformation(extent={{100,-10},{120,10}})));
equation
  connect(u, y);
  annotation (Documentation(info="<html>
<p>
  Model to pass trough the input String as an output. 
</p>
</html>", revisions="<html><ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
</ul>
</html>"), Icon(graphics={      Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,100,0},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),  Line(points={{-100,0},{100,0}},
            color={0,100,0}),           Text(
        extent={{-152,144},{148,104}},
        textString="%name",
        textColor={0,0,255})}));
end StringPassThrough;

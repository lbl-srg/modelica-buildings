within Buildings.Controls.OBC.CDL.Conversions;
block BooleanToReal "Convert Boolean to Real signal"

  parameter Real realTrue=1 "Output signal for true Boolean input";

  parameter Real realFalse=0 "Output signal for false Boolean input";

  Interfaces.BooleanInput u "Connector of Boolean input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Interfaces.RealOutput y
    "Connector of Integer output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  y = if u then realTrue else realFalse;

annotation (
defaultComponentName="booToRea",
Documentation(info="<html>
<p>
Block that outputs the <code>Boolean</code>
equivalent of the <code>Integer</code> input.
</p>
<pre>
  y = if u then integerTrue else integerFalse;
</pre>
<p>
where <code>u</code> is of <code>Boolean</code> and <code>y</code>
of <code>Integer</code> type,
and <code>integerTrue</code> and <code>integerFalse</code> are parameters.
</p>
</html>", revisions="<html>
<ul>
<li>
April 10, 2017, by Jianjun Hu:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"),
         Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics={
        Text(
          extent={{-86,92},{-6,10}},
          lineColor={255,0,255},
          textString="B"),
        Polygon(
          points={{-12,-46},{-32,-26},{-32,-36},{-64,-36},{-64,-56},{-32,-56},
              {-32,-66},{-12,-46}},
          lineColor={255,170,85},
          fillColor={255,170,85},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{8,-4},{92,-94}},
          lineColor={255,170,85},
          textString="I"),               Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          lineThickness=5.0,
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
                                   Ellipse(
          extent={{-71,7},{-85,-7}},
          lineColor=DynamicSelect({235,235,235}, if u then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if u then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid),      Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          lineColor={0,0,255})}));
end BooleanToReal;

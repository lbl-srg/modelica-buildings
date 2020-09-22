within Buildings.Controls.OBC.CDL.Conversions;
block BooleanToReal "Convert Boolean to Real signal"

  parameter Real realTrue=1 "Output signal for true Boolean input";

  parameter Real realFalse=0 "Output signal for false Boolean input";

  Interfaces.BooleanInput u "Connector of Boolean input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Interfaces.RealOutput y
    "Connector of Integer output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

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
            {100,100}}), graphics={      Rectangle(
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
          lineColor={0,0,255}),
    Text(
      extent={{-68,-86},{70,-38}},
      lineColor={0,0,0},
          textString="%realFalse"),
    Text(
      extent={{-68,-26},{70,22}},
      lineColor={0,0,0},
          textString="%realTrue"),
        Text(
          extent={{-86,78},{-34,26}},
          lineColor={255,0,255},
          textString="B"),
        Polygon(
          points={{26,48},{6,68},{6,58},{-26,58},{-26,38},{6,38},{6,28},{26,48}},
          lineColor={0,0,127},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{34,82},{86,24}},
          lineColor={0,0,127},
          textString="R")}));
end BooleanToReal;

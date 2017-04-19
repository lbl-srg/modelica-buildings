within Buildings.Experimental.OpenBuildingControl.CDL.Conversions;
block IntegerToBoolean "Convert Integer to Boolean signal"

  parameter Integer threshold=1
    "Output signal y is true, if input u >= threshold";

  Interfaces.IntegerInput u "Connector of Integer input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Interfaces.BooleanOutput y
    "Connector of Boolean output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  y = u >= threshold;

  annotation (
defaultComponentName="intToBoo",
Documentation(info="<html>
<p>
This block computes the <code>Boolean</code> output <code>y</code>
from the <code>Integer</code> input <code>u</code> using
</p>
<pre>
  y = u &ge; threshold;
</pre>
<p>
where <code>threshold</code> is a parameter.
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
         Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics={
         Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          lineThickness=5.0,
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Text(
          extent={{-86,92},{-6,10}},
          lineColor={255,128,0},
          textString="I"),
        Polygon(
          points={{-12,-46},{-32,-26},{-32,-36},{-64,-36},{-64,-56},{-32,-56},
              {-32,-66},{-12,-46}},
          lineColor={255,0,255},
          fillColor={255,0,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{8,-4},{92,-94}},
          lineColor={255,0,255},
          textString="B"),                     Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          lineColor={0,0,255}),    Ellipse(
          extent={{71,7},{85,-7}},
          lineColor=DynamicSelect({235,235,235}, if y > 0.5 then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if y > 0.5 then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid)}));
end IntegerToBoolean;

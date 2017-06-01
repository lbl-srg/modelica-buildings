within Buildings.Experimental.OpenBuildingControl.CDL.Conversions;
block RealToBoolean "Convert Real to Boolean signal"

  Interfaces.RealInput u "Connector of Real input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.BooleanOutput y "Connector of Boolean output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  parameter Real threshold=0.5
    "Output signal y is true, if input u >= threshold";

equation
  y = u >= threshold;
  annotation (defaultComponentName="reaToBoo",
        Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
        {100,100}}), graphics={Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-86,92},{-6,10}},
          lineColor={0,0,127},
          textString="R"),
        Polygon(
          points={{-12,-46},{-32,-26},{-32,-36},{-64,-36},{-64,-56},{-32,-56},
              {-32,-66},{-12,-46}},
          lineColor={255,0,255},
          fillColor={255,0,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{8,-4},{92,-94}},
          lineColor={255,0,255},
          textString="B")}),
Documentation(info="<html>
<p>
This block computes the Boolean output <b>y</b>
from the Real input <b>u</b> by the equation:
</p>

<pre>    y = u &ge; threshold;
</pre>

<p>
where <b>threshold</b> is a parameter.
</p>
</html>", revisions="<html>
<ul>
<li>
June 1, 2017, by Milica Grahovac:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end RealToBoolean;

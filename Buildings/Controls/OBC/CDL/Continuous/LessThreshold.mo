within Buildings.Controls.OBC.CDL.Continuous;
block LessThreshold "Output y is true, if input u is less than threshold"

  parameter Real threshold=0 "Comparison with respect to threshold";

  Interfaces.RealInput u "Connector of Real input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Interfaces.BooleanOutput y "Connector of Boolean output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  y = u < threshold;
  annotation (
        defaultComponentName="lesThr",
        Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          lineThickness=5.0,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Ellipse(
          extent={{71,7},{85,-7}},
          lineColor=DynamicSelect({235,235,235}, if y then {0,255,0}
               else {235,235,235}),
          fillColor=DynamicSelect({235,235,235}, if y then {0,255,0}
               else {235,235,235}),
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,-140},{150,-110}},
          lineColor={0,0,0},
          textString="%threshold"),
        Text(
          extent={{-150,150},{150,110}},
          lineColor={0,0,255},
          textString="%name"),
        Line(
          points={{-10,20},{-54,0},{-10,-18}},
          thickness=0.5)}),
Documentation(info="<html>
<p>
Block that outputs <code>true</code> if the Real input is less than
the parameter <code>threshold</code>.
Otherwise the output is <code>false</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 3, 2017, by Michael Wetter:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end LessThreshold;

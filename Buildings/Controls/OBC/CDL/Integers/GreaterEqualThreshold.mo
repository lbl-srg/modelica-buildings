within Buildings.Controls.OBC.CDL.Integers;
block GreaterEqualThreshold
  "Output y is true, if input u is greater or equal than threshold"
  parameter Integer t=0
    "Comparison with respect to a threshold";
  Interfaces.IntegerInput u
    "Connector of Integer input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.BooleanOutput y
    "Connector of Boolean output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

equation
  y=u >= t;
  annotation (
    defaultComponentName="intGreEquThr",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Text(
          extent={{-150,-140},{150,-110}},
          textColor={0,0,0},
          textString="%t"),
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          lineThickness=5.0,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Ellipse(
          extent={{71,7},{85,-7}},
          lineColor=DynamicSelect({235,235,235},
            if y then
              {0,255,0}
            else
              {235,235,235}),
          fillColor=DynamicSelect({235,235,235},
            if y then
              {0,255,0}
            else
              {235,235,235}),
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255}),
        Line(
          points={{-54,22},{-8,2},{-54,-18}},
          thickness=0.5,
          color={255,127,0}),
        Line(
          points={{-52,-36},{-6,-14}},
          thickness=0.5,
          color={255,127,0})}),
    Documentation(
      info="<html>
<p>
Block that outputs <code>true</code> if the Integer input is greater than or equal to
the parameter <code>t</code>.
Otherwise the output is <code>false</code>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
August 6, 2020, by Michael Wetter:<br/>
Renamed <code>threshold</code> to <code>t</code>.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2076\">issue 2076</a>.
</li>
<li>
August 30, 2017, by Jianjun Hu:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end GreaterEqualThreshold;

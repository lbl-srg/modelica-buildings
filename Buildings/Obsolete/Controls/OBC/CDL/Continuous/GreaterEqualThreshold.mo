within Buildings.Obsolete.Controls.OBC.CDL.Continuous;
block GreaterEqualThreshold
  "Output y is true, if input u is greater or equal than threshold"
  extends Modelica.Icons.ObsoleteModel;

  parameter Real threshold=0 "Threshold for comparison";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput u "Connector of Real input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y "Connector of Boolean output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

equation
  y = u >= threshold;

annotation (
  defaultComponentName="greEquThr",
  obsolete = "Obsolete model, use Buildings.Controls.OBC.CDL.Reals.GreaterThreshold instead",
  Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics={
        Text(
          extent={{-150,-140},{150,-110}},
          textColor={0,0,0},
          textString="%threshold"),
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
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255}),
        Line(
          points={{-54,22},{-8,2},{-54,-18}},
          thickness=0.5),
        Line(
          points={{-52,-36},{-6,-14}},
          thickness=0.5)}),
  Documentation(info="<html>
<p>
Block that outputs <code>true</code> if the Real input is greater than or equal to
the parameter <code>threshold</code>.
Otherwise the output is <code>false</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 6, 2020, by Michael Wetter:<br/>
Moved block to obsolete package.
</li>
<li>
January 3, 2017, by Michael Wetter:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end GreaterEqualThreshold;

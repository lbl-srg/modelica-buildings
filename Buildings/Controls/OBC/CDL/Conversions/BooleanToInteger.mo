within Buildings.Controls.OBC.CDL.Conversions;
block BooleanToInteger
  "Convert Boolean to Integer signal"
  parameter Integer integerTrue=1
    "Output signal for true Boolean input";
  parameter Integer integerFalse=0
    "Output signal for false Boolean input";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u
    "Boolean signal to be converted to an Integer signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput y
    "Converted input signal as an Integer"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

equation
  y=if u then
      integerTrue
    else
      integerFalse;
  annotation (
    defaultComponentName="booToInt",
    Documentation(
      info="<html>
<p>
Block that outputs the <code>Integer</code>
equivalent of the <code>Boolean</code> input.
</p>
<pre>
  y = if u then integerTrue else integerFalse;
</pre>
<p>
where <code>u</code> is of <code>Boolean</code> and <code>y</code>
of <code>Integer</code> type,
and <code>integerTrue</code> and <code>integerFalse</code> are parameters.
</p>
</html>",
      revisions="<html>
<ul>
<li>
May 17, 2022, by Hongxiang Fu:<br/>
Corrected documentation texts where the variables were described with wrong types.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3016\">Buildings, issue 3016</a>.
</li>
<li>
January 3, 2017, by Michael Wetter:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"),
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          lineThickness=5.0,
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Text(
          extent={{-86,78},{-34,26}},
          textColor={255,0,255},
          textString="B"),
        Polygon(
          points={{28,48},{8,68},{8,58},{-24,58},{-24,38},{8,38},{8,28},{28,48}},
          lineColor={255,170,85},
          fillColor={255,170,85},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{34,82},{86,24}},
          textColor={255,170,85},
          textString="I"),
        Ellipse(
          extent={{-71,7},{-85,-7}},
          lineColor=DynamicSelect({235,235,235},
            if u then
              {0,255,0}
            else
              {235,235,235}),
          fillColor=DynamicSelect({235,235,235},
            if u then
              {0,255,0}
            else
              {235,235,235}),
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255}),
        Text(
          extent={{-74,-28},{64,20}},
          textColor={0,0,0},
          textString="%integerTrue"),
        Text(
          extent={{-74,-90},{64,-42}},
          textColor={0,0,0},
          textString="%integerFalse")}));
end BooleanToInteger;

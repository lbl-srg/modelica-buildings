within Buildings.Controls.OBC.CDL.Integers;
block AddParameter "Output the sum of an input plus a parameter"
  parameter Integer p
    "Value to be added";
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput u "Connector of Integer input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput y "Connector of Integer output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

equation
  y=u+p;
  annotation (
    defaultComponentName="addPar",
    Documentation(
      info="<html>
<p>
Block that outputs <code>y = u + p</code>,
where <code>p</code> is parameter and <code>u</code> is an input.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 3 2022, by Jianjun Hu:<br/>
First implementation.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2876\">issue 2876</a>.
</li>
</ul>
</html>"),
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={255,127,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          textColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name"),
        Line(points={{-54,66},{-28,30},{2,30}}, color={255,127,0}),
        Line(points={{-100,0},{100,0}}, color={255,127,0}),
        Text(
          extent={{-122,58},{-17,98}},
          textColor={255,127,0},
          textString="%p"),
        Ellipse(
          lineColor={255,127,0},
          extent={{-12,-52},{88,48}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{0,-26},{76,42}},
          textString="+",
          textColor={255,127,0}),
        Text(
          extent={{226,60},{106,10}},
          textColor={0,0,0},
          textString=DynamicSelect("",String(y,
            leftJustified=false,
            significantDigits=3)))}));
end AddParameter;

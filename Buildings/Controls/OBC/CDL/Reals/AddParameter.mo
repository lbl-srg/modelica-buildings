within Buildings.Controls.OBC.CDL.Reals;
block AddParameter "Output the sum of an input plus a parameter"
  parameter Real p
    "Parameter to be added to the input";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u
    "Input to be added to the parameter"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Sum of the parameter and the input"
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
February 3, 2022, by Jianjun Hu:<br/>
Removed input gain factor.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2876\">issue 2876</a>.
</li>
<li>
March 2, 2020, by Michael Wetter:<br/>
Changed icon to display dynamically the output value.
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
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          textColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name"),
        Line(
          points={{-54,66},{-28,30},{2,30}},
          color={0,0,127}),
        Line(
          points={{-100,0},{100,0}},
          color={0,0,127}),
        Text(
          extent={{-122,58},{-17,98}},
          textString="%p",
          textColor={0,0,0}),
        Ellipse(
          lineColor={0,0,127},
          extent={{-12,-52},{88,48}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{0,-26},{76,42}},
          textString="+"),
        Text(
          extent={{226,60},{106,10}},
          textColor={0,0,0},
          textString=DynamicSelect("",String(y,
            leftJustified=false,
            significantDigits=3)))}));
end AddParameter;

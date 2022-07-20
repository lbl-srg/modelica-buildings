within Buildings.Controls.OBC.CDL.Continuous;
block Divide "Output first input divided by second input"
  Interfaces.RealInput u1
    "Connector for dividend"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Interfaces.RealInput u2
    "Connector for divisor"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Interfaces.RealOutput y
    "Connector for quotient"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

equation
  y=u1/u2;
  annotation (
    defaultComponentName="div",
    Documentation(
      info="<html>
<p>
Block that outputs <code>y = u1 / u2</code>,
where
<code>u1</code> and <code>u2</code> are inputs.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 27, 2022, by Jianjun Hu:<br/>
Renamed the block name from Division to Divide.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2865\">issue 2865</a>.
</li>
<li>
March 9, 2020, by Michael Wetter:<br/>
Reformulated model to avoid stack overflow in OpenModelica.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1819\">issue 1819</a>.
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
        Ellipse(
          lineColor={0,0,127},
          extent={{-50,-50},{50,50}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255}),
        Line(
          points={{50,0},{100,0}},
          color={0,0,127}),
        Line(
          points={{-30,0},{30,0}}),
        Ellipse(
          fillPattern=FillPattern.Solid,
          extent={{-5,20},{5,30}}),
        Ellipse(
          fillPattern=FillPattern.Solid,
          extent={{-5,-30},{5,-20}}),
        Line(
          points={{-100,60},{-66,60},{-40,30}},
          color={0,0,127}),
        Line(
          points={{-100,-60},{0,-60},{0,-50}},
          color={0,0,127}),
        Text(
          extent={{226,60},{106,10}},
          textColor={0,0,0},
          textString=DynamicSelect("",String(y,
            leftJustified=false,
            significantDigits=3)))}));
end Divide;

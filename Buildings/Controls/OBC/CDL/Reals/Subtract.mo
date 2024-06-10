within Buildings.Controls.OBC.CDL.Reals;
block Subtract "Output the difference of the two inputs"
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u1
    "Connector of Real input signal 1"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u2
    "Connector of Real input signal 2"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

equation
  y=u1-u2;
  annotation (
    defaultComponentName="sub",
    Documentation(
      info="<html>
<p>
Block that outputs <code>y</code> as the difference of the
two input signals <code>u1</code> and <code>u2</code>,
</p>
<pre>
    y = u1 - u2
</pre>
</html>",
revisions="<html>
<ul>
<li>
January 28, 2022, by Jianjun Hu:<br/>
First implementation.
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
          points={{-100,60},{-74,24},{-44,24}},
          color={0,0,127}),
        Line(
          points={{-100,-60},{-74,-28},{-42,-28}},
          color={0,0,127}),
        Line(
          points={{50,0},{100,0}},
          color={0,0,127}),
        Text(
          extent={{-38,-28},{38,40}},
          textString="-",
          textColor={0,0,0}),
        Text(
          extent={{226,60},{106,10}},
          textColor={0,0,0},
          textString=DynamicSelect("",String(y,
            leftJustified=false,
            significantDigits=3)))}));
end Subtract;

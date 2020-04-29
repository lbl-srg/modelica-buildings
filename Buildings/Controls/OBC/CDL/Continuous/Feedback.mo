within Buildings.Controls.OBC.CDL.Continuous;
block Feedback "Output difference between commanded and feedback input"

  Interfaces.RealInput u1 "Connector of Real input signal 1"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Interfaces.RealInput u2 "Connector of Real input signal 2"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-120})));

  Interfaces.RealOutput y "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

equation
  y = u1 - u2;

annotation (
  defaultComponentName="feedback",
  Documentation(info="<html>
<p>
Block that outputs <code>y = u1 - u2</code>,
where
<code>u1</code> and <code>u2</code> are inputs.
</p>
</html>", revisions="<html>
<ul>
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
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Ellipse(
          lineColor={0,0,127},
          fillColor={235,235,235},
          fillPattern=FillPattern.Solid,
          extent={{-20,-20},{20,20}}),
        Line(points={{-100,0},{-20,0}},color={0,0,127}),
        Line(points={{20,0},{100,0}},color={0,0,127}),
        Line(points={{0,-20},{0,-100}},color={0,0,127}),
        Text(extent={{-14,-112},{74,-38}},
                                        textString="-"),
        Text(
          lineColor={0,0,255},
          extent={{-150,48},{150,98}},
          textString="%name"),
        Text(extent={{-100,-4},{-40,56}},
          textString="+",
          lineColor={0,0,0}),
        Text(
          extent={{226,60},{106,10}},
          lineColor={0,0,0},
          textString=DynamicSelect("", String(y, leftjustified=false, significantDigits=3)))}));
end Feedback;

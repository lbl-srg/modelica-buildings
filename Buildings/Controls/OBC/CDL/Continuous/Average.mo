within Buildings.Controls.OBC.CDL.Continuous;
block Average
  "Output the average of its two inputs"
  Interfaces.RealInput u1
    "Connector of Real input signal 1"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),iconTransformation(extent={{-140,40},{-100,80}})));
  Interfaces.RealInput u2
    "Connector of Real input signal 2"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),iconTransformation(extent={{-140,-80},{-100,-40}})));
  Interfaces.RealOutput y
    "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

equation
  y=0.5*(u1+u2);
  annotation (
    defaultComponentName="ave",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Text(
          textColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name"),
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-50,34},{52,-26}},
          textColor={192,192,192},
          textString="avg()"),
        Line(
          points={{-8,16}},
          color={0,0,0}),
        Line(
          points={{-100,60}},
          color={0,0,0},
          thickness=1),
        Text(
          extent={{226,60},{106,10}},
          textColor={0,0,0},
          textString=DynamicSelect("",String(y,
            leftJustified=false,
            significantDigits=3)))}),
    Documentation(
      info="<html>
<p>
Block that outputs <code>y = (u1 + u2) / 2</code>,
where
<code>u1</code> and <code>u2</code> are inputs.
</p>
</html>",
      revisions="<html>
<ul>
<li>
March 2, 2020, by Michael Wetter:<br/>
Changed icon to display dynamically the output value.
</li>
<li>
March 15, 2017, by Jianjun Hu:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end Average;

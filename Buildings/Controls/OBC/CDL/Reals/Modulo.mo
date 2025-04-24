within Buildings.Controls.OBC.CDL.Reals;
block Modulo
  "Output the remainder of first input divided by second input (~=0)"
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u1
    "Dividend of the modulus function"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u2
    "Divisor of the modulus function"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Modulus u1 mod u2"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

equation
  y=mod(u1, u2);
  annotation (
    defaultComponentName="mod",
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
          extent={{-50,-48},{50,52}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          textColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name"),
        Text(
          extent={{-32,-52},{40,-100}},
          textColor={192,192,192},
          textString="mod"),
        Line(
          points={{-8,16}},
          color={0,0,0}),
        Line(
          points={{-100,60}},
          color={0,0,0},
          thickness=1),
        Line(
          points={{-100,60},{-28,60},{-12,50}},
          color={0,0,127}),
        Line(
          points={{-100,-60},{-26,-60},{-2,-48}},
          color={0,0,127}),
        Line(
          points={{50,2},{102,2},{100,2}},
          color={0,0,127}),
        Ellipse(
          fillPattern=FillPattern.Solid,
          extent={{11,-18},{21,-8}}),
        Line(
          points={{-24,-20},{26,24}}),
        Ellipse(
          fillPattern=FillPattern.Solid,
          extent={{-21,12},{-11,22}}),
        Text(
          extent={{226,60},{106,10}},
          textColor={0,0,0},
          textString=DynamicSelect("",String(y,
            leftJustified=false,
            significantDigits=3)))}),
    Documentation(
      info="<html>
<p>
Block that outputs <code>y = mod(u1/u2)</code>,
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
end Modulo;

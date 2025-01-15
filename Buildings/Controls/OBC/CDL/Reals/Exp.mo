within Buildings.Controls.OBC.CDL.Reals;
block Exp "Output the exponential (base e) of the input"
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u
    "Input for the base e exponential function"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Base e exponential value of the input"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

equation
  y=Modelica.Math.exp(u);
  annotation (
    defaultComponentName="exp",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),
      graphics={
        Line(
          points={{-90,-80.3976},{68,-80.3976}},
          color={192,192,192}),
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,-80},{-31,-77.9},{-6.03,-74},{10.9,-68.4},{23.7,-61},{34.2,-51.6},{43,-40.3},{50.3,-27.8},{56.7,-13.5},{62.3,2.23},{67.1,18.6},{72,38.2},{76,57.6},{80,80}}),
        Line(
          points={{0,-80},{0,68}},
          color={192,192,192}),
        Text(
          extent={{-86,50},{-14,2}},
          textColor={192,192,192},
          textString="exp"),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255}),
        Text(
          extent={{226,60},{106,10}},
          textColor={0,0,0},
          textString=DynamicSelect("",String(y,
            leftJustified=false,
            significantDigits=3)))}),
    Documentation(
      info="<html>
<p>
Block that outputs <code>y = exp(u)</code>,
where
<code>u</code> is an input and <code>exp()</code> is the
base-e exponential function.
</p>

<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Controls/OBC/CDL/Reals/Exp.png\"
     alt=\"exp.png\" />
</p>

</html>",
      revisions="<html>
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
</html>"));
end Exp;

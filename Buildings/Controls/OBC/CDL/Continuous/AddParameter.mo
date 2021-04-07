within Buildings.Controls.OBC.CDL.Continuous;
block AddParameter
  "Output the sum of an input plus a parameter"
  parameter Real p
    "Value to be added";
  parameter Real k
    "Gain of input";
  Interfaces.RealInput u
    "Connector of Real input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.RealOutput y
    "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

equation
  y=k*u+p;
  annotation (
    defaultComponentName="addPar",
    Documentation(
      info="<html>
<p>
Block that outputs <code>y = k u + p</code>,
where <code>k</code> and <code>p</code> are
parameters and <code>u</code> is an input.
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
          lineColor={0,0,255},
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
          lineColor={0,0,0}),
        Polygon(
          points={{-86,-36},{-86,36},{-34,0},{-86,-36}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-196,-84},{104,-44}},
          lineColor={0,0,0},
          textString="k=%k"),
        Ellipse(
          lineColor={0,0,127},
          extent={{-12,-52},{88,48}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-2,-22},{74,46}},
          textString="+"),
        Text(
          extent={{226,60},{106,10}},
          lineColor={0,0,0},
          textString=DynamicSelect("",String(y,
            leftjustified=false,
            significantDigits=3)))}));
end AddParameter;

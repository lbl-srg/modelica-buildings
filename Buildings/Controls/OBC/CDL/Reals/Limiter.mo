within Buildings.Controls.OBC.CDL.Reals;
block Limiter
  "Limit the range of a signal"
  parameter Real uMax
    "Upper limit of input signal";
  parameter Real uMin
    "Lower limit of input signal";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u
    "Connector of Real input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

initial equation
  assert(
    uMin < uMax,
    "uMin must be smaller than uMax. Check parameters.");

equation
  y=homotopy(
    actual=smooth(0,noEvent(
      if u > uMax then
        uMax
      else
        if u < uMin then
          uMin
        else
          u)),
    simplified=u);
  annotation (
    defaultComponentName="lim",
    Documentation(
      info="<html>
<p>
Block that outputs <code>y = min(uMax, max(uMin, u))</code>,
where
<code>u</code> is an input
and
<code>uMax</code> and <code>uMin</code> are parameters.
</p>
<p>
If <code>uMax &lt; uMin</code>, an error occurs.
</p>
</html>",
      revisions="<html>
<ul>
<li>
February 15, 2024, by Michael Wetter:<br/>
Updated documentation.
</li>
<li>
March 2, 2020, by Michael Wetter:<br/>
Changed icon to display dynamically the output value.
</li>
<li>
July 17, 2017, by Michael Wetter:<br/>
Removed cyclical definition.
</li>
<li>
January 3, 2017, by Michael Wetter:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"),
    Icon(
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
        Line(
          points={{0,-90},{0,68}},
          color={192,192,192}),
        Polygon(
          points={{0,90},{-8,68},{8,68},{0,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-90,0},{68,0}},
          color={192,192,192}),
        Polygon(
          points={{90,0},{68,-8},{68,8},{90,0}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,-70},{-50,-70},{50,70},{80,70}}),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255}),
        Line(
          points={{50,70},{80,70}}),
        Line(
          points={{-80,-70},{-50,-70}}),
        Text(
          extent={{12,72},{94,98}},
          textColor={0,0,0},
          textString="%uMax"),
        Text(
          extent={{-100,-98},{-18,-72}},
          textColor={0,0,0},
          textString="%uMin"),
        Text(
          extent={{226,60},{106,10}},
          textColor={0,0,0},
          textString=DynamicSelect("",String(y,
            leftJustified=false,
            significantDigits=3)))}));
end Limiter;

within Buildings.Controls.OBC.CDL.Continuous;
block Round
  "Round real number to given digits"
  parameter Integer n
    "Number of digits being round to";
  Interfaces.RealInput u
    "Connector of Real input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Interfaces.RealOutput y
    "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

protected
  parameter Real fac=10^n
    "Factor used for rounding";

equation
  y=
    if(u > 0) then
      floor(
        u*fac+0.5)/fac
    else
      ceil(
        u*fac-0.5)/fac;
  annotation (
    defaultComponentName="rou",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100.0,-100.0},{100.0,100.0}}),
      graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          lineColor={0,0,127},
          extent={{-56,4},{72,106}},
          textString="round( )"),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          lineColor={0,0,255}),
        Text(
          lineColor={0,0,127},
          extent={{-60,-88},{54,-34}},
          textString="%n"),
        Text(
          extent={{226,60},{106,10}},
          lineColor={0,0,0},
          textString=DynamicSelect("",String(y,
            leftjustified=false,
            significantDigits=3)))}),
    Documentation(
      info="<html>
<p>
Block that outputs the input after rounding it to <code>n</code> digits.
</p>
<p>
For example,
</p>
<ul>
<li>
set <code>n = 0</code> to round to the nearest integer,
</li>
<li>
set <code>n = 1</code> to round to the next decimal point, and
</li>
<li>
set <code>n = -1</code> to round to the next multiple of ten.
</li>
</ul>
<p>
Hence, the block outputs
</p>
<pre>
    y = floor(u*(10^n) + 0.5)/(10^n)  for  u &gt; 0,
    y = ceil(u*(10^n) - 0.5)/(10^n)   for  u &lt; 0.
</pre>
</html>",
      revisions="<html>
<ul>
<li>
March 2, 2020, by Michael Wetter:<br/>
Changed icon to display dynamically the output value.
</li>
<li>
September 14, 2017, by Jianjun Hu:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end Round;

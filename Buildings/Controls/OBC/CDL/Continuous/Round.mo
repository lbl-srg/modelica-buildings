within Buildings.Controls.OBC.CDL.Continuous;
block Round "Round real number to given digits"

  parameter Integer n "Number of digits being round to";

  Interfaces.RealInput u "Connector of Real input signal"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Interfaces.RealOutput y
    "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  y = if (u>0) then floor(u*(10^n) + 0.5)/(10^n) else ceil(u*(10^n) - 0.5)/(10^n);

annotation (
defaultComponentName="round",
Icon(coordinateSystem(
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
          extent={{-62,-50},{66,52}},
          textString="Round( )"),           Text(
            extent={{-150,150},{150,110}},
            textString="%name",
            lineColor={0,0,255})}),
Documentation(info="<html>
<p>
Block that outputs <code>y</code>
as the round value of the input <code>u</code> with given number of 
digits <code>n</code>.
</p>
<p>
The block outputs
</p>
<pre>
    y = floor(u*(10^n) + 0.5)/(10^n)  for  u &gt; 0,
    y = ceil(u*(10^n) - 0.5)/(10^n)  for  u &lt; 0.
</pre>
</html>", revisions="<html>
<ul>
<li>
September 14, 2017, by Jianjun Hu:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
end Round;

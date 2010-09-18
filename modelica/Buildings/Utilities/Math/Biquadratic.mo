within Buildings.Utilities.Math;
block Biquadratic "Biquadratic function"
  extends Modelica.Blocks.Interfaces.SI2SO;
  parameter Real a[6] "Coefficients";
equation
  y =  Buildings.Utilities.Math.Functions.biquadratic(a=a, x1=u1, x2=u2);
  annotation (Icon(graphics={Text(
          extent={{-88,40},{92,-32}},
          lineColor={160,160,164},
          textString="biquadratic()")}),      Diagram(graphics),
Documentation(info="<html>
<p>
This block computes
<pre>
  y =   a1 + a2 * x1 + a3 * x1^2 
           + a4 * x2 + a5 * x2^2 + a6 * x1 * x2
</pre>
</p>
</html>",
revisions="<html>
<ul>
<li>
Sep. 8, 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end Biquadratic;

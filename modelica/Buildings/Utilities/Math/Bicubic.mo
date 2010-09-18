within Buildings.Utilities.Math;
block Bicubic "Bicubic function"
  extends Modelica.Blocks.Interfaces.SI2SO;
 input Real a[10] "Coefficients";
equation
  y =  Buildings.Utilities.Math.Functions.bicubic(a=a, x1=u1, x2=u2);
  annotation (Icon(graphics={Text(
          extent={{-88,40},{92,-32}},
          lineColor={160,160,164},
          textString="bicubic()")}),      Diagram(graphics),
Documentation(info="<html>
<p>
This block computes
<pre>
 y = a1 + a2 * x1 + a3 * x1^2 
        + a4 * x2 + a5 * x2^2 
        + a6 * x1 * x2 
        + a7 * x1^3
        + a8 * x2^3 
        + a9 * x1^2 * x2 + a10 * x1 * x2^2
</pre>
</html>", revisions="<html>
<ul>
<li>
Sep 17, 2010 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end Bicubic;

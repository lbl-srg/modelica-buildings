within Districts.Utilities.Math;
block SmoothMax
  "Once continuously differentiable approximation to the maximum function"
  extends Modelica.Blocks.Interfaces.SI2SO;
 parameter Real deltaX "Width of transition interval";
equation
  y =  Districts.Utilities.Math.Functions.smoothMax(x1=u1, x2=u2, deltaX=deltaX);
  annotation (Icon(graphics={Text(
          extent={{-88,40},{92,-32}},
          lineColor={160,160,164},
          textString="smoothMax()"), Text(
          extent={{-74,-44},{68,-114}},
          lineColor={0,0,255},
          textString="dX=%deltaX%")}),        Diagram(graphics),
Documentation(info="<html>
<p>
Once continuously differentiable approximation to the <i>max(.,.)</i> function.
</p>
</html>",
revisions="<html>
<ul>
<li>
August 15, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end SmoothMax;

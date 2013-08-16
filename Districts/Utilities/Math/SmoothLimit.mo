within Districts.Utilities.Math;
block SmoothLimit
  "Once continuously differentiable approximation to the limit function"
 extends Modelica.Blocks.Interfaces.SISO;
 parameter Real deltaX "Width of transition interval";
 parameter Real upper "Upper limit";
 parameter Real lower "Lower limit";
equation
  y = Districts.Utilities.Math.Functions.smoothLimit(u, lower, upper, deltaX);
  annotation (Icon(graphics={Text(
          extent={{-88,40},{92,-32}},
          lineColor={160,160,164},
          textString="smoothLimit()")}),        Diagram(graphics),
Documentation(info="<html>
<p>
Once continuously differentiable approximation to the <i>limit(.,.)</i> function.
The output is bounded to be in <i>[lower, upper]</i>.
</p>
</html>",
revisions="<html>
<ul>
July 14, 2010, by Wangda Zuo, Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end SmoothLimit;

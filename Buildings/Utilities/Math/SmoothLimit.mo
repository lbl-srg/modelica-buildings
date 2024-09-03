within Buildings.Utilities.Math;
block SmoothLimit
  "Once continuously differentiable approximation to the limit function"
 extends Modelica.Blocks.Interfaces.SISO;
 parameter Real deltaX "Width of transition interval";
 parameter Real upper "Upper limit";
 parameter Real lower "Lower limit";
equation
  y = Buildings.Utilities.Math.Functions.smoothLimit(u, lower, upper, deltaX);
  annotation (Icon(graphics={Text(
          extent={{-88,40},{92,-32}},
          textColor={160,160,164},
          textString="smoothLimit()")}),
Documentation(info="<html>
<p>
Once continuously differentiable approximation to the <i>limit(.,.)</i> function.
The output is bounded to be in <i>[lower, upper]</i>.
</p>
<p>
Note that the limit need not be respected, such as illustrated in
<a href=\"modelica://Buildings.Utilities.Math.Examples.SmoothMin\">
Buildings.Utilities.Math.Examples.SmoothMin</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 12, 2015, by Filip Jorissen:<br/>
Added documentation reference demonstrating overshoot.
</li>
<li>
July 14, 2010, by Wangda Zuo, Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end SmoothLimit;

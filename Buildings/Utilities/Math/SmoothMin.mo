within Buildings.Utilities.Math;
block SmoothMin
  "Once continuously differentiable approximation to the minimum function"
  extends Modelica.Blocks.Interfaces.SI2SO;
  parameter Real deltaX "Width of transition interval";
equation
  y = Buildings.Utilities.Math.Functions.smoothMin(x1=u1, x2=u2, deltaX=deltaX);
  annotation (Icon(graphics={Text(
          extent={{-88,40},{92,-32}},
          textColor={160,160,164},
          textString="smoothMin()"), Text(
          extent={{-66,-50},{76,-120}},
          textColor={0,0,255},
          textString="dX=%deltaX%")}),
Documentation(info="<html>
<p>
Once continuously differentiable approximation to the <i>min(.,.)</i> function.
</p>
<p>
Note that the minimum need not be respected, such as illustrated in
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
August 15, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end SmoothMin;

within Buildings.Utilities.Math;
block SmoothExponential
  "Once continuously differentiable approximation to exp(-|x|) in interval |x| < delta"
  extends Modelica.Blocks.Interfaces.SISO;
  parameter Real delta "Transition point where approximation occurs";
equation
  y = Buildings.Utilities.Math.Functions.smoothExponential(x=u, delta=delta);
  annotation (Documentation(info="<html>
<p>Function to provide a once continuously differentiable approximation to <i>exp(- |x| )</i> in the interval <i>|x| for some positive &delta; </i></p>
</html>", revisions="<html>
<ul>
<li>
November 29, 2013 by Marcus Fuchs:<br/>
Implementation based on Functions.smoothExponential.
</li>
</ul>
</html>"), Icon(graphics={   Text(
          extent={{-88,38},{92,-34}},
          textColor={160,160,164},
          textString="smoothExponential()")}));
end SmoothExponential;

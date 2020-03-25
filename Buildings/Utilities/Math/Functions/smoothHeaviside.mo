within Buildings.Utilities.Math.Functions;
function smoothHeaviside
  "Twice continuously differentiable approximation to the Heaviside function"
  extends Modelica.Icons.Function;
  input Real x "Argument";
  input Real delta(min=Modelica.Constants.eps) "Parameter used for scaling";
  output Real y "Result";
protected
  Real dx=0.5*x/delta "Scaled input argument";
  Real xpow2=dx*dx "=dx*dx";
algorithm
  y := smooth(2, max(0, min(1, 0.5+dx*(1.875+xpow2*(-5+6*xpow2)))));

 annotation (smoothOrder = 2,
 Documentation(info="<html>
<p>
Twice Lipschitz continuously differentiable approximation to the
<code>Heaviside(.,.)</code> function.<br/>
Function is derived from a quintic polynomial going through <i>(0,0)</i> and <i>(1,1)</i>,
with zero first and second order derivatives at those points.<br/>
See Example <a href=\"modelica://Buildings.Utilities.Math.Examples.SmoothHeaviside\">
Buildings.Utilities.Math.Examples.SmoothHeaviside</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 21, 2019:<br/>
Added <code>delta.min</code> attribute to guard against division by zero.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1202\">issue 1202</a>.
</li>
<li>
September 13, 2019, by Kristoff Six and Filip Jorissen:<br/>
Once continuously differentiable replaced by twice continuously differentiable implementation. This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1202\">issue 1202</a>.
</li>
<li>
March 15, 2016, by Michael Wetter:<br/>
Replaced <code>spliceFunction</code> with <code>regStep</code>.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/300\">issue 300</a>.
</li>
<li>
July 17, 2015, by Marcus Fuchs:<br/>
Add link to example.
</li>
<li>
February 5, 2015, by Filip Jorissen:<br/>
Added <code>smoothOrder = 1</code>.
</li>
<li>
July 14, 2010, by Wangda Zuo, Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end smoothHeaviside;

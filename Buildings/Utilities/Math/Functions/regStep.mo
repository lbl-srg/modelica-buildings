within Buildings.Utilities.Math.Functions;
function regStep
  "Approximation of a general step, such that the approximation is continuous and differentiable"
  extends Modelica.Icons.Function;
  input Real x "Abscissa value";
  input Real y1 "Ordinate value for x > 0";
  input Real y2 "Ordinate value for x < 0";
  input Real x_small(min=0) = 1e-5
    "Approximation of step for -x_small <= x <= x_small; x_small >= 0 required";
  output Real y "Ordinate value to approximate y = if x > 0 then y1 else y2";
algorithm
  y := smooth(1, if x >  x_small then y1 else
                 if x < -x_small then y2 else
                 if x_small > 0 then (x/x_small)*((x/x_small)^2 - 3)*(y2-y1)/4 + (y1+y2)/2 else (y1+y2)/2);

  annotation(Inline=true,
  Documentation(revisions="<html>
<ul>
<li><i>February 18, 2016</i>
    by Marcus Fuchs:<br/>
    Add function with <code>Inline = true</code> in annotations to package for better performance,
    as suggested in <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/300\">#300</a> .</li>
<li><i>August 12, 2008</i>
    by <a href=\"mailto:Michael.Sielemann@dlr.de\">Michael Sielemann</a>:<br/>
    Minor modification to cover the limit case <code>x_small -> 0</code> without division by zero.</li>
<li><i>April 29, 2008</i>
    by <a href=\"mailto:Martin.Otter@DLR.de\">Martin Otter</a>:<br/>
    Designed and implemented.</li>
</ul>
</html>", info="<html>
<p>
This function is used to approximate the equation
</p>
<pre>
    y = <b>if</b> x &gt; 0 <b>then</b> y1 <b>else</b> y2;
</pre>

<p>
by a smooth characteristic, so that the expression is continuous and differentiable:
</p>

<pre>
   y = <b>smooth</b>(1, <b>if</b> x &gt;  x_small <b>then</b> y1 <b>else</b>
                 <b>if</b> x &lt; -x_small <b>then</b> y2 <b>else</b> f(y1, y2));
</pre>

<p>
In the region <code>-x_small &lt; x &lt; x_small</code> a 2nd order polynomial is used
for a smooth transition from <code>y1</code> to <code>y2</code>.
</p>
</html>"));
end regStep;

within Buildings.Utilities.Math;
block RegNonZeroPower
  "Power function, regularized near zero, but nonzero value for x=0"
  extends Modelica.Blocks.Interfaces.SISO;
  parameter Real n "Exponent";
  parameter Real delta = 0.01 "Abscissa value where transition occurs";
equation
  y = Buildings.Utilities.Math.Functions.regNonZeroPower(x=u, n=n, delta=delta);
  annotation (Documentation(info="<html>

Function that approximates <i>y=|x|<sup>n</sup></i> where <i>n &gt; 0</i>
so that
<ul>
<li><i>y(0)</i> is not equal to zero.</li>
<li><i>dy/dx</i> is bounded and continuous everywhere.</li>
</ul>

<p>
This function replaces <i>y=|x|<sup>n</sup></i> in the interval
<i>-&delta;...+&delta;</i> by a 4-th order polynomial that has the same
function value and the first and second derivative at <i>x=&plusmn; &delta;</i>.
</p>
<p>
A typical use of this function is to replace the
function for the convective heat transfer
coefficient for forced or free convection that is of the form
<i>h=c |dT|<sup>n</sup></i> for some constant <i>c</i> and exponent
<i>0 &le; n &le; 1</i>.
By using this function, the original function
that has an infinite derivative near zero and that takes on zero
at the origin is replaced by a function with a bounded derivative and
a non-zero value at the origin. Physically,
the region <i>-&delta;...+&delta;</i> may be interpreted as the region
where heat conduction dominates convection in the boundary layer.
</p>
See the package <code>Examples</code> for the graph.
</html>", revisions="<html>
<ul>
<li>
November 29, 2013 by Marcus Fuchs:<br/>
Implementation based on Functions.regNonZeroPower.
</li>
</ul>
</html>"), Icon(graphics={   Text(
          extent={{-88,38},{92,-34}},
          textColor={160,160,164},
          textString="regNonZeroPower()")}));
end RegNonZeroPower;

within Buildings.Utilities.Math;
block RegNonZeroPower
  "Power function, regularized near zero, but nonzero value for x=0"
  extends Modelica.Blocks.Interfaces.SISO;
  parameter Real n "Exponent";
  parameter Real delta = 0.01 "Abscissa value where transition occurs";
equation
  y = Buildings.Utilities.Math.Functions.regNonZeroPower(x=u, n=n, delta=delta);
  annotation (Documentation(info="<html>
<p>
Block that approximates <i>y=|x|<sup>n</sup></i> where <i>0 &lt; n &lt; 2</i>
so that
</p>
<ul>
<li><i>y(0)</i> is not equal to zero.</li>
<li><i>dy/dx</i> is bounded and continuous everywhere.</li>
</ul>
<p>
This block replaces <i>y=|x|<sup>n</sup></i> in the interval
<i>-&delta;...+&delta;</i> by a 4-th order polynomial that has the same
function value and the first and second derivative at <i>x=&plusmn; &delta;</i>.
</p>
<p>
A typical use of this block is to replace the
function for the convective heat transfer
coefficient for forced or free convection that is of the form
<i>h=c |dT|<sup>n</sup></i> for some constant <i>c</i> and exponent
<i>0 &lt; n &le; 1</i>.
By using this block, the original function
that has an infinite derivative near zero and that takes on zero
at the origin is replaced by a function with a bounded derivative and
a non-zero value at the origin. Physically,
the region <i>-&delta;...+&delta;</i> may be interpreted as the region
where heat conduction dominates convection in the boundary layer.
</p>
<p>
See the package <code>Examples</code> for the graph.
</p>
</html>", revisions="<html>
<ul>
<li>
November 2, 2022, by Michael Wetter:<br/>
Set minimum and maximum attribute on <code>n</code>, improved assertion and documentation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3135\">Buildings, #3135</a>.
</li>
<li>
November 29, 2013 by Marcus Fuchs:<br/>
Implementation based on
<a href=\"modelica://Buildings.Utilities.Math.Functions.regNonZeroPower\">
Buildings.Utilities.Math.Functions.regNonZeroPower</a>.
</li>
</ul>
</html>"), Icon(graphics={   Text(
          extent={{-88,38},{92,-34}},
          textColor={160,160,164},
          textString="regNonZeroPower()")}));
end RegNonZeroPower;

within Buildings.Utilities.Math;
block PowerLinearized
  "Power function that is linearized below a user-defined threshold"
  extends Modelica.Blocks.Interfaces.SISO;
  parameter Real n "Exponent";
  parameter Real x0 "Abscissa value below which linearization occurs";

equation
  y = Buildings.Utilities.Math.Functions.powerLinearized(x=u, n=n, x0=x0);

  annotation (Icon(graphics={Text(
          extent={{-90,36},{90,-36}},
          textColor={160,160,164},
          textString="powerLinearized()")}), Documentation(info="<html>
Function that approximates <i>y=x<sup>n</sup></i>
where <i>0 &lt; n</i> so that
<ul>
<li>the function is defined and monotonically increasing for all <i>x</i>.</li>
<li><i>dy/dx</i> is bounded and continuous everywhere (for <i>n &lt; 1</i>).</li>
</ul>
<p>
For <i>x &lt; x<sub>0</sub></i>, this function replaces
<i>y=x<sup>n</sup></i> by
a linear function that is continuously differentiable everywhere.
</p>
<p>
A typical use of this function is to replace
<i>T = T4<sup>(1/4)</sup></i> in a radiation balance to ensure that the
function is defined everywhere. This can help solving the initialization problem
when a solver may be far from a solution and hence <i>T4 &lt; 0</i>.
</p>
<p>
See the package <code>Examples</code> for the graph.
</p>
</html>", revisions="<html>
<ul>
<li>
November 29, 2013, by Marcus Fuchs:<br/>
Implementation based on Functions.powerLinearized.
</li>
</ul>
</html>"));
end PowerLinearized;

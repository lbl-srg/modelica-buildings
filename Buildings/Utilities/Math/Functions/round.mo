within Buildings.Utilities.Math.Functions;
function round "Round real number to specified digits"
  extends Modelica.Icons.Function;

  input Real x "Argument to be rounded";
  input Integer n "Number of digits being round to";
  output Real y "Connector of Real output signal";

protected
  parameter Real fac = 10^n "Factor used for rounding";

algorithm
  y := if (x>0) then floor(x*fac + 0.5)/fac else ceil(x*fac - 0.5)/fac;

annotation (
Documentation(info="<html>
<p>
Function that outputs the input after rounding it to <code>n</code> digits.
</p>
<p>
For example,
</p>
<ul>
<li>
set <code>n = 0</code> to round to the nearest integer,
</li>
<li>
set <code>n = 1</code> to round to the next decimal point, and
</li>
<li>
set <code>n = -1</code> to round to the next multiple of ten.
</li>
</ul>
<p>
Hence, the function outputs
</p>
<pre>
    y = floor(x*(10^n) + 0.5)/(10^n)  for  x &gt; 0,
    y = ceil( x*(10^n) - 0.5)/(10^n)  for  x &lt; 0.
</pre>
<p>
To use this function as a block, use
<a href=\"modelica://Buildings.Controls.OBC.CDL.Reals.Round\">
Buildings.Controls.OBC.CDL.Reals.Round</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 2, 2020, by Michael Wetter:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2170\">#2170</a>.
</li>
</ul>
</html>"));
end round;

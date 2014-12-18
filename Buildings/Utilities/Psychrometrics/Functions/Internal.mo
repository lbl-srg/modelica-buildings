within Buildings.Utilities.Psychrometrics.Functions;
package Internal "Solve f(x, data) for x with given f"
  extends Modelica.Media.Common.OneNonLinearEquation;

  redeclare function extends f_nonlinear
  algorithm
     y := pW_TDewPoi(x);
  end f_nonlinear;

annotation (
Documentation(
info="<html>
<p>
Function to compute the dew point temperature based on the
partial water vapor concentration.
</p>
</html>",
revisions="<html>
<ul>
<li>
August 10, 2011, by Michael Wetter:<br/>
Changed function to extend from
<code>Modelica.Media.Common.OneNonLinearEquation</code>
instead of
<code>Buildings.Utilities.Math.BaseClasses.OneNonLinearEquation</code>.
</li>
<li>
February 17, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Internal;

within Buildings.Utilities.Psychrometrics.Functions;
package Internal "Solve f(x, data) for x with given f"
  extends Buildings.Utilities.Math.BaseClasses.OneNonLinearEquation;

  redeclare function extends f_nonlinear
  algorithm
     y := pW_TDewPoi(x);
  end f_nonlinear;

  // Dummy definition has to be added for current Dymola
  redeclare function extends solve
  end solve;
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
February 17, 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"
));
end Internal;

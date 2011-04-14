within Buildings.Fluid.HeatExchangers.BaseClasses;
package Internal "Solve f(x, data) for x with given f"
  extends Buildings.Utilities.Math.BaseClasses.OneNonLinearEquation;

  redeclare function extends f_nonlinear
  algorithm
    y := epsilon_ntuZ(x, f_nonlinear_data[1],
         Buildings.Fluid.Types.HeatExchangerFlowRegime.CrossFlowUnmixed);
  end f_nonlinear;

  // Dummy definition has to be added for current Dymola
  redeclare function extends solve
  end solve;
annotation (
Documentation(
info="<html>
<p>
Function that internally solves a scalar equation.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 16, 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"
));

end Internal;

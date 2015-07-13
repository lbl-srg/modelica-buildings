within Buildings.Fluid.HeatExchangers.BaseClasses;
package Internal "Solve f(x, data) for x with given f"
  extends Modelica.Media.Common.OneNonLinearEquation;

  redeclare function extends f_nonlinear
  algorithm
  assert(x>0, "NTU needs to be strictly positive.
Received NTU = " + String(x) + "
         Z   = " + String(p));
    y := epsilon_ntuZ(NTU=x, Z=p,
         flowRegime=Integer(Buildings.Fluid.Types.HeatExchangerFlowRegime.CrossFlowUnmixed));
  end f_nonlinear;

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
July 7, 2014, by Michael Wetter:<br/>
Changed the type of the input <code>flowRegime</code> from
<code>Buildings.Fluid.Types.HeatExchangerFlowRegime</code>
to <code>Integer</code>.
</li>
<li>
August 10, 2011, by Michael Wetter:
<ul>
<li>
Changed implementation to use
<code>Modelica.Media.Common.OneNonLinearEquation</code> instead of
<code>Buildings.Utilities.Math.BaseClasses.OneNonLinearEquation</code>.
</li>
<li>
Added assert statement as <code>epsilon_ntuZ</code> computes <code>NTU^(-0.22)</code>.
</li>
</ul>
</li>
<li>
February 16, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));

end Internal;

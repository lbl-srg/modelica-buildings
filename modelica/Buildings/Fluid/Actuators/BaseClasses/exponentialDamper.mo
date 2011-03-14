within Buildings.Fluid.Actuators.BaseClasses;
function exponentialDamper
  "Damper opening characteristics for an exponential damper"

  input Real y(min=0, max=1, unit="")
    "Control signal, y=0 is closed, y=1 is open";
  input Real a(unit="") "Coefficient a for damper characteristics";
  input Real b(unit="") "Coefficient b for damper characteristics";
  input Real[3] cL "Polynomial coefficients for curve fit for y < yl";
  input Real[3] cU "Polynomial coefficients for curve fit for y > yu";
  input Real yL "Lower value for damper curve";
  input Real yU "Upper value for damper curve";

  output Real kThetaSqRt(min=0)
    "Flow coefficient, kThetaSqRT = =sqrt(kTheta) = sqrt(pressure drop/dynamic pressure)";
algorithm
  if y < yL then
    kThetaSqRt := sqrt(Modelica.Math.exp(cL[3] + y * (cL[2] + y * cL[1])));
  else
    if (y > yU) then
      kThetaSqRt := sqrt(Modelica.Math.exp(cU[3] + y * (cU[2] + y * cU[1])));
    else
      kThetaSqRt := sqrt(Modelica.Math.exp(a+b*(1-y))) "y=0 is closed";
    end if;
  end if;
annotation (
Documentation(info="<html>
<p>
This function computes the opening characteristics of an exponential damper.
</p><p>
The function is used by the model 
<a href=\"modelica://Buildings.Fluid.Actuators.Dampers.Exponential\">
Dampers.Exponential</a>.
</p><p>
For <code>yL &lt; y &lt; yU</code>, the damper characteristics is 
</p>
<p align=\"center\" style=\"font-style:italic;\">
  k = exp(a+b (1-y)).
</p>
<p>
Outside this range, the damper characteristic is defined by a quadratic polynomial.
</p>
<p>
Note that this implementation returns <code>sqrt(k)</code> instead of <code>k</code>.
This is done for numerical reason since otherwise <code>k</code> may be an iteration
variable, which may cause a lot of warnings and slower convergence if the solver
attempts <code>k &lt; 0</code> during the iterative solution procedure.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 4, 2010 by Michael Wetter:<br>
Reformulated implementation. The new implementation computes
<code>sqrt(kTheta)</code>. This avoid having <code>kTheta</code> in
the iteration variables, which caused warnings when the solver attempted
<code>kTheta &lt; 0</code>.
<li>
June 22, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),   smoothOrder=1);
end exponentialDamper;

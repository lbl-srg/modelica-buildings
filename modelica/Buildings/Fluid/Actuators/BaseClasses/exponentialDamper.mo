within Buildings.Fluid.Actuators.BaseClasses;
function exponentialDamper
  "Damper opening characteristics for an exponential damper"

annotation (
Documentation(info="<html>
<p>
This function computes the opening characteristics of an exponential damper.
</p><p>
The function is used by the model 
<a href=\"Modelica:Buildings.Fluid.Actuators.Dampers.Exponential\">
Dampers.Exponential</a>.
</p><p>
For <tt>yL &lt; y &lt; yU</tt>, the damper characteristics is <pre>
  k = exp(a+b*(1-y)).
</pre>
Outside this range, the damper characteristic is defined by a quadratic polynomial.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 24, 2010 by Michael Wetter:</br>
Added assert to check for valid input. This helps detecting wrong controls, which
can lead to non-convergence (or non-physical results) if <code>y &lt; 0</code>.
</li>
<li>
June 22, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  input Real y(min=0, max=1, unit="")
    "Control signal, y=0 is closed, y=1 is open";
  input Real a(unit="") "Coefficient a for damper characteristics";
  input Real b(unit="") "Coefficient b for damper characteristics";
  input Real[3] cL "Polynomial coefficients for curve fit for y < yl";
  input Real[3] cU "Polynomial coefficients for curve fit for y > yu";
  input Real yL "Lower value for damper curve";
  input Real yU "Upper value for damper curve";

  output Real kTheta(min=0)
    "Flow coefficient, kTheta = pressure drop divided by dynamic pressure";
  annotation(smoothOrder=1, derivative=der_exponentialDamper);
algorithm
  assert(y >-0.00000001,
     "Control input y for exponentialDamper must be non-negative. Received y = " + realString(y));
  assert(y < 1.00000001,
     "Control input y for exponentialDamper must not be bigger than one. Received y = " + realString(y));
  if y < yL then
    kTheta := Modelica.Math.exp(cL[3] + y * (cL[2] + y * cL[1]));
  else
    if (y > yU) then
      kTheta := Modelica.Math.exp(cU[3] + y * (cU[2] + y * cU[1]));
    else
      kTheta := Modelica.Math.exp(a+b*(1-y)) "y=0 is closed";
    end if;
  end if;
end exponentialDamper;

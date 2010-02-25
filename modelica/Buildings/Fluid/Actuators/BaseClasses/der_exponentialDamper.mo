within Buildings.Fluid.Actuators.BaseClasses;
function der_exponentialDamper
  "Derivative of damper opening characteristics for an exponential damper"

annotation (
Documentation(info="<html>
<p>
This function computes the derivative of the opening characteristics of an exponential damper.
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
February 4, 2010 by Michael Wetter:<br>
Fixed implementation of derivative function.
</li>
<li>
June 22, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  input Real y "Control signal, y=0 is closed, y=1 is open";
  input Real a "Coefficient a for damper characteristics";
  input Real b "Coefficient b for damper characteristics";
  input Real[3] cL "Polynomial coefficients for curve fit for y < yl";
  input Real[3] cU "Polynomial coefficients for curve fit for y > yu";
  input Real yL "Lower value for damper curve";
  input Real yU "Upper value for damper curve";
  input Real der_y "Derivative of control signal";
  input Real der_a;
  input Real der_b;
  input Real[3] der_cL;
  input Real[3] der_cU;
  input Real der_yL;
  input Real der_yU;

  output Real der_kTheta(min=0)
    "Derivative of flow coefficient, der_kTheta=dkTheta/dy";
algorithm
  if y < yL then
    der_kTheta := Modelica.Math.exp(cL[3] + y * (cL[2] + y * cL[1]))*(2 * cL[1] * y + cL[2]) * der_y;
  else
    if (y > yU) then
      der_kTheta := Modelica.Math.exp(cU[3] + y * (cU[2] + y * cU[1]))*(2 * cU[1] * y + cU[2]) * der_y;
    else
      der_kTheta := -b*Modelica.Math.exp(a+b*(1-y)) * der_y
        "y=0 is closed, but theta=1 is closed in ASHRAE-825";
    end if;
  end if;
end der_exponentialDamper;

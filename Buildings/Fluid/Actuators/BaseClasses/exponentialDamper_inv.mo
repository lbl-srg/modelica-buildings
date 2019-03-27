within Buildings.Fluid.Actuators.BaseClasses;
function exponentialDamper_inv
  "Inverse function of damper opening characteristics for an exponential damper"
  import Modelica.Math.Matrices;
  extends Modelica.Icons.Function;
  input Real kThetaSqRt(min=0);
  input Real a "Coefficient a for damper characteristics";
  input Real b "Coefficient b for damper characteristics";
  input Real[3] cL "Polynomial coefficients for curve fit for y < yl";
  input Real[3] cU "Polynomial coefficients for curve fit for y > yu";
  input Real yL "Lower value for damper curve";
  input Real yU "Upper value for damper curve";
  output Real y(min=0, max=1);
protected
  parameter Real kL = Buildings.Fluid.Actuators.BaseClasses.exponentialDamper(
       y=yL, a=a, b=b, cL=cL, cU=cU, yL=yL, yU=yU);
  parameter Real kU = Buildings.Fluid.Actuators.BaseClasses.exponentialDamper(
       y=yU, a=a, b=b, cL=cL, cU=cU, yL=yL, yU=yU);
  parameter Integer sizeSupSpl = 3;
  parameter Real[sizeSupSpl] ySupSpl = {1, yU*1.1, yU};
  parameter Real[sizeSupSpl] kSupSpl = Buildings.Fluid.Actuators.BaseClasses.exponentialDamper(
      y=ySupSpl, a=a, b=b, cL=cL, cU=cU, yL=yL, yU=yU)
      "Strict monotone increasing";
  parameter Real[sizeSupSpl] invSplDer = Buildings.Utilities.Math.Functions.splineDerivatives(
    x=kSupSpl, y=ySupSpl, ensureMonotonicity=true);
  Real kBnd "Bounded flow resistance sqrt value";
  Integer i "Integer to select data interval";
  Real delta "Discriminant";
  Real y1 "First root";
  Real y2 "Second root";
algorithm
  kBnd := if kThetaSqRt < kSupSpl[1] then kSupSpl[1] elseif
    kThetaSqRt > kSupSpl[sizeSupSpl] then kSupSpl[sizeSupSpl] else kThetaSqRt;

  if kThetaSqRt > kL then
    // kThetaSqRt := sqrt(Modelica.Math.exp(cL[3] + yC * (cL[2] + yC * cL[1])));
    delta := cL[2]^2 - 4 * cL[1] * (-2 * Modelica.Math.log(kThetaSqRt) + cL[3]);
    y1 := (-cL[2] - sqrt(delta)) / (2 * cL[1]);
    y2 := (-cL[2] + sqrt(delta)) / (2 * cL[1]);
    y := if cL[2] + 2 * cL[1] * y1 <= 0 then max(0, y1) else max(0, y2);
  elseif kThetaSqRt < kU then
    // kThetaSqRt := sqrt(Modelica.Math.exp(cU[3] + yC * (cU[2] + yC * cU[1])));
    i := 1;
    for j in 2:sizeSupSpl loop
      if kBnd <= kSupSpl[j] then
        i := j;
        break;
      end if;
    end for;
    y := min(1, Buildings.Utilities.Math.Functions.cubicHermiteLinearExtrapolation(
      x=kBnd,
      x1=kSupSpl[i - 1],
      x2=kSupSpl[i],
      y1=ySupSpl[i - 1],
      y2=ySupSpl[i],
      y1d=invSplDer[i - 1],
      y2d=invSplDer[i]
    ));
  else
    y := 1 -(2 * Modelica.Math.log(kThetaSqRt) - a) / b;
    y1 := 0;
    y2 := 0;
    //kThetaSqRt := sqrt(Modelica.Math.exp(a+b*(1-y))) "y=0 is closed";
  end if;
annotation (
Documentation(info="<html>
<p>
This function computes the opening characteristics of an exponential damper.
</p><p>
The function is used by the model
<a href=\"modelica://Buildings.Fluid.Actuators.Dampers.Exponential\">
Buildings.Fluid.Actuators.Dampers.Exponential</a>.
</p><p>
For <code>yL &lt; y &lt; yU</code>, the damper characteristics is
</p>
<p align=\"center\" style=\"font-style:italic;\">
  k<sub>d</sub>(y) = exp(a+b (1-y)).
</p>
<p>
Outside this range, the damper characteristic is defined by a quadratic polynomial.
</p>
<p>
Note that this implementation returns <i>sqrt(k<sub>d</sub>(y))</i> instead of <i>k<sub>d</sub>(y)</i>.
This is done for numerical reason since otherwise <i>k<sub>d</sub>(y)</i> may be an iteration
variable, which may cause a lot of warnings and slower convergence if the solver
attempts <i>k<sub>d</sub>(y) &lt; 0</i> during the iterative solution procedure.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 14, 2014 by Michael Wetter:<br/>
Improved documentation.
</li>
<li>
July 1, 2011 by Michael Wetter:<br/>
Added constraint to control input to avoid using a number outside
<code>0</code> and <code>1</code> in case that the control input
has a numerical integration error.
</li>
<li>
April 4, 2010 by Michael Wetter:<br/>
Reformulated implementation. The new implementation computes
<code>sqrt(kTheta)</code>. This avoid having <code>kTheta</code> in
the iteration variables, which caused warnings when the solver attempted
<code>kTheta &lt; 0</code>.
</li>
<li>
June 22, 2008 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),   smoothOrder=1);
end exponentialDamper_inv;

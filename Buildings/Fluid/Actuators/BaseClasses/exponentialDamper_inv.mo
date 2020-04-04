within Buildings.Fluid.Actuators.BaseClasses;
function exponentialDamper_inv
  "Inverse function of the exponential damper characteristics"
  extends Modelica.Icons.Function;
  input Real kThetaSqRt(min=0, unit="1") "Square root of loss coefficient";
  input Real[:] kSupSpl "k values of support points";
  input Real[:] ySupSpl "y values of support points";
  input Real[:] invSplDer "Derivatives at support points";
  output Real y(unit="1") "Fractional opening";
protected
  parameter Integer sizeSupSpl = size(kSupSpl, 1) "Number of spline support points";
  Integer i "Integer to select data interval";
  Real kBnd "Bounded flow resistance sqrt value";
algorithm
  kBnd := if kThetaSqRt < kSupSpl[1] then kSupSpl[1] elseif
    kThetaSqRt > kSupSpl[sizeSupSpl] then kSupSpl[sizeSupSpl] else kThetaSqRt;
  i := 1;
  for j in 2:sizeSupSpl loop
    if kBnd <= kSupSpl[j] then
      i := j;
      break;
    end if;
  end for;
  y := Buildings.Utilities.Math.Functions.smoothLimit(
    Buildings.Utilities.Math.Functions.cubicHermiteLinearExtrapolation(
      x=kBnd,
      x1=kSupSpl[i - 1],
      x2=kSupSpl[i],
      y1=ySupSpl[i - 1],
      y2=ySupSpl[i],
      y1d=invSplDer[i - 1],
      y2d=invSplDer[i]),
    0,
    1,
    1E-3);
annotation (
Documentation(info="<html>
<p>
This function provides an approximate inverse of the exponential damper characteristics.
</p><p>
The function is used by the model
<a href=\"modelica://Buildings.Fluid.Actuators.Dampers.PressureIndependent\">
Buildings.Fluid.Actuators.Dampers.PressureIndependent</a>.
</p><p>
The quadratic interpolation used outside the exponential domain in the function
<a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.exponentialDamper\">
Buildings.Fluid.Actuators.BaseClasses.exponentialDamper</a>
yields a local extremum.
Therefore, the formal inversion of the function is not possible.
A cubic spline is used instead to fit the inverse of the characteristics.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 19, 2019, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"), smoothOrder=1);
end exponentialDamper_inv;

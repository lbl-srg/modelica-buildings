within Buildings.Utilities.Math.Functions;
function quinticHermite
  "Quintic Hermite spline function for interpolation between two functions with a continuous second derivative"
  extends Modelica.Icons.Function;
  input Real x "Abscissa value";
  input Real x1 "Lower abscissa value";
  input Real x2 "Upper abscissa value";
  input Real y1 "Lower ordinate value";
  input Real y2 "Upper ordinate value";
  input Real y1d "Lower derivative";
  input Real y2d "Upper derivative";
  input Real y1dd "Lower second derivative";
  input Real y2dd "Upper second derivative";
  output Real y "Interpolated ordinate value";
protected
  Real h = x2 - x1;
  Real hpow2 = h*h;
  Real t = (x - x1)/h;
  Real tpow2 = t*t;
  Real tpow3 = tpow2*t;
  Real tpow4 = tpow3*t;
  Real tpow5 = tpow4*t;
  Real H0 = 1 - 10*tpow3 + 15*tpow4 - 6*tpow5;
  Real H1 = t -  6*tpow3 +  8*tpow4 - 3*tpow5;
  Real H2 = 0.5*(tpow2 - 3*tpow3 + 3 *tpow4 - tpow5);
  Real H3 = 0.5*tpow3 - tpow4 + 0.5*tpow5;
  Real H4 = -4*tpow3 +7*tpow4 -3*tpow5;
  Real H5 = 1-H0;
algorithm
  y :=H0*y1 + H1*y1d*h  + H2*y1dd*hpow2 + H3*y2dd*hpow2 + H4*y2d*h + H5*y2;

annotation (smoothOrder=99,
Documentation(revisions="<html>
<ul>
<li>
April 19, 2017, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Returns the result y of a quintic Hermite spline,
which is a C<sup>2</sup> continuous interpolation between two functions.
The abscissa value <code>x</code> has to be between <code>x1</code> and <code>x2</code>.
Variables <code>y1</code>, <code>y1d</code>, <code>y1dd</code> are the ordinate,
ordinate derivative and ordinate second derivative of the function at <code>x1</code>.
Variables <code>y2</code>, <code>y2d</code>, <code>y2dd</code> are respectively the ordinate,
ordinate derivative and ordinate second derivative of the function at <code>x2</code>.
</p>
</html>"));
end quinticHermite;

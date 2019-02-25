within Buildings.Utilities.Math.Functions;
function besselJ1 "Bessel function of the first kind of order 1, J1"
  extends Modelica.Icons.Function;

  input Real x "Independent variable";
  output Real J1 "Bessel function J1(x)";

protected
  constant Real P[5] = {1.0,
            0.183105e-2,
            -0.3516396496e-4,
            0.2457520174e-5,
            -0.240337019e-6};
  constant Real Q[5] = {0.04687499995,
            -0.2002690873e-3,
            0.8449199096e-5,
            -0.88228987e-6,
            0.105787412e-6};
  constant Real R[6] = {72362614232.0,
            -7895059235.0,
            242396853.1,
            -2972611.439,
            15704.48260,
            -30.16036606};
  constant Real S[6] = {144725228442.0,
            2300535178.0,
            18583304.74,
            99447.43394,
            376.9991397,
            1.0};
  Real ax = abs(x);
  Real xx;
  Real y;
  Real z;
  Real coeff1;
  Real coeff2;

algorithm
  if ax < 8.0 then
    y := x^2;
    coeff1 := R[6];
    coeff2 := S[6];
    for i in 1:5 loop
      coeff1 := R[6-i] + y*coeff1;
      coeff2 := S[6-i] + y*coeff2;
    end for;
    J1 := x*coeff1/coeff2;
  else
    z := 8/ax;
    y := z^2;
    xx := ax - 2.356194491;
    coeff1 := P[5];
    coeff2 := Q[5];
    for i in 1:4 loop
      coeff1 := P[5-i] + y*coeff1;
      coeff2 := Q[5-i] + y*coeff2;
    end for;
    J1 := sqrt(0.636619772/ax)*(cos(xx)*coeff1 - z*sin(xx)*coeff2)*sign(x);
  end if;

annotation (
Documentation(info="<html>
<p>
Evaluates the Bessel function of the first kind of order 1 (<i>J<sub>1</sub></i>), based
on the implementations of Press et al. (1986).
</p>
<h4>References</h4>
<p>
Press, William H., Brian P. Flannery, Saul A. Teukolsky, and William T.
Vetterling. Numerical Recipes - The Art of Scientific Computing. Cambridge
University Press (1986): 988 p.
</p>
</html>", revisions="<html>
<ul>
<li>
March 21, 2018 by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end besselJ1;

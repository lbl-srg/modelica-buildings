within Buildings.Utilities.Math.Functions;
function besselJ0 "Bessel function of the first kind of order 0, J0"
  extends Modelica.Icons.Function;

  input Real x "Independent variable";
  output Real J0 "Bessel function J0(x)";

protected
  constant Real P[5] = {1.0,
            -0.1098628627e-2,
            0.2734510407e-4,
            -0.2073370639e-5,
            0.2093887211e-6};
  constant Real Q[5] = {-0.1562499995e-1,
            0.1430488765e-3,
            -0.6911147651e-5,
            0.7621095161e-6,
            -0.934945152e-7};
  constant Real R[6] = {57568490574.0,
            -13362590354.0,
            651619640.7,
            -11214424.18,
            77392.33017,
            -184.9052456};
  constant Real S[6] = {57568490411.0,
            1029532985.0,
            9494680.718,
            59272.64853,
            267.8532712,
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
    J0 := coeff1/coeff2;
  else
    z := 8/ax;
    y := z^2;
    xx := ax - 0.785398164;
    coeff1 := P[5];
    coeff2 := Q[5];
    for i in 1:4 loop
      coeff1 := P[5-i] + y*coeff1;
      coeff2 := Q[5-i] + y*coeff2;
    end for;
    J0 := sqrt(0.636619772/ax)*(cos(xx)*coeff1 - z*sin(xx)*coeff2);
  end if;

annotation (
Documentation(info="<html>
<p>
Evaluates the Bessel function of the first kind of order 0 (<i>J<sub>0</sub></i>), based
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
end besselJ0;

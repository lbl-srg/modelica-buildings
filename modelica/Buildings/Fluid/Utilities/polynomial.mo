within Buildings.Fluid.Utilities;
function polynomial
  "Polynomial, used because OpenModelica 1.4.3 does not expand the sum() into a scalar"
  extends Modelica.Icons.Function;
  annotation(smoothOrder=5);
  input Real[:] c "Coefficients";
  input Real x "Independent variable";
  output Real y "Dependent variable";
algorithm
 y := c[1];
 for i in 2 : size(c,1) loop
   y := y + x^(i-1) * c[i];
 end for;
end polynomial;

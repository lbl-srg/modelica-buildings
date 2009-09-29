within Buildings.Fluid.Utilities.BaseClasses;
function der_extendedPolynomial
  "Polynomial that is linearly extended at user specified values"
  extends Modelica.Icons.Function;
  annotation (Documentation(info="<html>
<p>
This function is the derivative of  
<a href=\"Modelica:Buildings.Fluid.Utilities.extendedPolynomial\">
extendedPolynomial</a> with respect to <tt>x</tt>.
</p>
</html>", revisions="<html>
<ul>
<li>
June 16, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  input Real[:] c "Polynomial coefficients";
  input Real x "x value";
  input Real xMin "Minimum x value for polynomial";
  input Real xMax "Maximum x value for polynomial";
  input Real der_x;
  output Real der_y "Derivative dy/dx";
protected
 Integer N = size(c,1) "Number of coefficients";
algorithm
if x < xMin then
   der_y := 0;
   for i in 2:N loop
     der_y := der_y + (i - 1)*xMin^(i - 2)*c[i];
   end for;
  elseif x < xMax then
   der_y := 0;
   for i in 2:N loop
     der_y := der_y + (i - 1)*x^(i - 2)*c[i];
  end for;
  else
     der_y := 0;
     for i in 2:N loop
       der_y := der_y + (i - 1)*xMax^(i - 2)*c[i];
    end for;
  end if;
end der_extendedPolynomial;

within Buildings.Fluid.Utilities.BaseClasses;
function der_extendedPolynomial
  "Polynomial that is linearly extended at user specified values"
  extends Modelica.Icons.Function;
  input Real x "x value";
  input Real[:] c "Polynomial coefficients";
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
  annotation (Documentation(info="<html>
<p>
This function is the derivative of
<a href=\"modelica://Buildings.Fluid.Utilities.extendedPolynomial\">
extendedPolynomial</a> with respect to <code>x</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 23, 2011 by Michael Wetter:<br/>
Changed order of argument list to make <code>x</code> the first argument.
</li>
<li>
June 16, 2008 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end der_extendedPolynomial;

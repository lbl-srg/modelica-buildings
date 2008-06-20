function extendedPolynomial 
  "Polynomial that is linearly extended at user specified values" 
  extends Modelica.Icons.Function;
  annotation (Documentation(info="<html>
For <tt>x</tt> between the bounds <tt>xMin &lt; x &lt; xMax</tt>,
this function defines a polynomial 
<pre>
   y = c1 + c2 * x + ... + cN * x^(N-1)
</pre>
where <tt>N &gt; 1</tt> and <tt>xMin, xMax</tt> are parameters.
For <tt>x &lt; xMin</tt> and <tt>x &gt; xMax</tt>,
the polynomial is replaced with a linear function
in such a way that the first derivative is continuous everywhere. 
</html>", revisions="<html>
<ul>
<li>
September 11, 2007 by Michael Wetter:<br>
Fixed error in computing the polynomial outside of <code>xMin</code> and <code>xMax</code>.
<li>
July 19, 2007 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  input Real[:] c "Polynomial coefficients";
  input Real x "x value";
  input Real xMin "Minimum x value for polynomial";
  input Real xMax "Maximum x value for polynomial";
  output Real y "y value";
     annotation(smoothOrder=1, derivative=BaseClasses.der_extendedPolynomial);
protected 
 Integer N = size(c,1) "Number of coefficients";
algorithm 
if x < xMin then
   y := c[1];
   for i in 2:N loop
     y := y + xMin^(i - 1)*c[i] + (x - xMin)*(i - 1)*xMin^(i - 2)*c[i];
   end for;
  elseif x < xMax then
   y := c[1];
   for i in 2:N loop
     y := y + x^(i - 1)*c[i];
  end for;
  else
     y := c[1];
     for i in 2:N loop
       y := y + xMax^(i - 1)*c[i] + (x - xMax)*(i - 1)*xMax^(i - 2)*c[i];
    end for;
  end if;
end extendedPolynomial;

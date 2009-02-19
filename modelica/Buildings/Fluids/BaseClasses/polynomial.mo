within Buildings.Fluids.BaseClasses;
function polynomial "Polynomial function"
 input Real a[:] "Coefficients";
 input Real x "Independent variable";
 output Real y "Result";
protected
 parameter Integer n = size(a, 1)-1;
 Real xp[n+1] "Powers of x";
algorithm
  xp[1] :=1;
  for i in 1:n loop
     xp[i+1] :=xp[i]*x;
  end for;
  y :=a*xp;
  annotation (Documentation(revisions="<html>
<ul>
<li>
February 29, 2009 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>", info="<html>
This function computes a polynomial of arbitrary order.
</html>"));
end polynomial;

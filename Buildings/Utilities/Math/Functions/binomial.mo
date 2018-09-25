within Buildings.Utilities.Math.Functions;
function binomial "Returns the binomial coefficient"
  extends Modelica.Icons.Function;

  input Integer n "Size of set";
  input Integer k(min=0) "Size of subsets";
  output Integer binom "Binomial coefficient";

algorithm
  assert(n >= k, "n must be k or greater.");
  assert(k >= 0, "k must be 0 or greater.");
  if k <= 0.5*n then
    binom := integer(Buildings.Utilities.Math.Functions.fallingFactorial(n,k)/Buildings.Utilities.Math.Functions.factorial(k));
  else
    binom := integer(Buildings.Utilities.Math.Functions.fallingFactorial(n,n-k)/Buildings.Utilities.Math.Functions.factorial(n-k));
  end if;

annotation (Documentation(info="<html>
<p>
Function that evaluates the binomial coefficient \"n choose k\".
</p>
</html>", revisions="<html>
<ul>
<li>
February 9, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end binomial;

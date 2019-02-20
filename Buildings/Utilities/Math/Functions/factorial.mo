within Buildings.Utilities.Math.Functions;
function factorial "Returns the value n! as an integer"
  extends Modelica.Icons.Function;

  input Integer n(min=0, max=12) "Integer number";
  output Integer f "Factorial of n";

algorithm
  assert(n >= 0, "n must be 0 or greater.");
  assert(n <= 12, "n must be 12 or less.");
  f := 1;
  for k in 1:n loop
    f := k*f;
  end for;

annotation (Documentation(info="<html>
<p>
Function that returns the factorial <i>n!</i> for <i>0 &le; n &le; 12</i>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 9, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end factorial;

within Buildings.Utilities.Math.Functions;
function fallingFactorial "Returns the k-th falling factorial of n"
  extends Modelica.Icons.Function;

  input Integer n "Integer number";
  input Integer k "Falling factorial power";
  output Integer f "k-th falling factorial of n";

protected
  Integer maxInt = 2147483647 "Max 32-bit integer";

algorithm
  if k > n then
    f := 0;
  else
    f := 1;
    for i in 0:(k-1) loop
      assert(f <= maxInt/(n-i), "Integer overflow");
      f := f*(n-i);
    end for;
  end if;

annotation (Documentation(info="<html>
<p>
Function that evaluates the falling factorial \"k-permutations of n\".
</p>
</html>", revisions="<html>
<ul>
<li>
February 9, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end fallingFactorial;

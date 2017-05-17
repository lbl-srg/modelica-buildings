within Buildings.Utilities.Math.Functions;
function isMonotonic "Returns true if the argument is a monotonic sequence"
  extends Modelica.Icons.Function;
  input Real x[:] "Sequence to be tested";
  input Boolean strict=false "Set to true to test for strict monotonicity";
  output Boolean monotonic "True if x is monotonic increasing or decreasing";
protected
  Integer n=size(x, 1) "Number of data points";

algorithm
  if n == 1 then
    monotonic := true;
  else
    monotonic := true;
    if strict then
      if (x[1] >= x[n]) then
        for i in 1:n - 1 loop
          if (not x[i] > x[i + 1]) then
            monotonic := false;
          end if;
        end for;
      else
        for i in 1:n - 1 loop
          if (not x[i] < x[i + 1]) then
            monotonic := false;
          end if;
        end for;
      end if;
    else
      // not strict
      if (x[1] >= x[n]) then
        for i in 1:n - 1 loop
          if (not x[i] >= x[i + 1]) then
            monotonic := false;
          end if;
        end for;
      else
        for i in 1:n - 1 loop
          if (not x[i] <= x[i + 1]) then
            monotonic := false;
          end if;
        end for;
      end if;
    end if;
    // strict
  end if;

  annotation (Documentation(info="<html>
<p>
This function returns <code>true</code> if its argument is
monotonic increasing or decreasing, and <code>false</code> otherwise.
If <code>strict=true</code>, then strict monotonicity is tested,
otherwise weak monotonicity is tested.
</p>
</html>", revisions="<html>
<ul>
<li>
September 28, 2011 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end isMonotonic;

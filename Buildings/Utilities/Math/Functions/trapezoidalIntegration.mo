within Buildings.Utilities.Math.Functions;
function trapezoidalIntegration "Integration using the trapezoidal rule"
  extends Modelica.Icons.Function;
  input Integer N "Number of integrand points";
  input Real[:] f "Integrands";
  input Real deltaX "Width of interval for Trapezoidal integration";
  output Real result "Result";
algorithm
  assert(N >= 2, "N must be no less than 2.");
  result := 0;
  for i in 1:N loop
    result := result + f[i];
  end for;

  result := 2*result;
  result := result - f[1] - f[N];
  result := result*deltaX/2;
  annotation (Documentation(info="<html>
<p>
This function computes a definite integral using the trapezoidal rule.
</p>
</html>", revisions="<html>
<ul>
<li>
August 23, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end trapezoidalIntegration;

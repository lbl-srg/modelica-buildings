within Buildings.Occupants.BaseClasses;
function linear1D "Mapping a continuous input to a binary output through a linear relation"
  extends Modelica.Icons.Function;

  input Real x "Continuous variable";
  input Real A=1 "Slope of the linear function";
  input Real B=0 "Intercept of the linear function";
  input Integer globalSeed "Seed for the random number generator";
  output Boolean y "Binary variable";

algorithm
  y := Buildings.Occupants.BaseClasses.binaryVariableGeneration(max(0, min(1, A*x+B)), globalSeed);
annotation (
Documentation(info="<html>
<p>
This function generates a random binary variable with the input of a continuous variable <code>x</code> from a
linear relation.
</p>
<p>
The probability of being 1 is calculated from the input <code>x</code> with the
slope <code>A</code> and the intercept <code>B</code>.
Then a random generator generates the output, which should be a binary variable.
</p>
</html>", revisions="<html>
<ul>
<li>
July 20, 2018, by Zhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"));
end linear1D;

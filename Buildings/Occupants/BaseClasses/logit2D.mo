within Buildings.Occupants.BaseClasses;
function logit2D "Mapping two continuous inputs to a binary output through a 2-dimension logistic relation"
  input Real x1 "The first input variable";
  input Real x2 "The second input variable";
  input Real A=1.0 "Parameter defining the 2D logistic relation: mutiplier for the first input";
  input Real B=1.0 "Parameter defining the 2D logistic relation: mutiplier for the second input";
  input Real C=1.0 "Parameter defining the 2D logistic relation: intercept";
  input Integer globalSeed "Seed for the random number generator";
  output Boolean y "Binary variable";

algorithm
  y := Buildings.Occupants.BaseClasses.binaryVariableGeneration(
    Modelica.Math.exp(A*x1+B*x2+C)/(Modelica.Math.exp(A*x1+B*x2+C)+1),
    globalSeed);
annotation (
Documentation(info="<html>
<p>
This function generates a random binary variable with two inputs <code>x1</code>
and <code>x2</code> from a 2-dimension logistic relation.
</p>
<p>
The probability of being 1 is calculated from the inputs <code>x1</code> and
<code>x2</code> from a 2D logistic relation with three predefined parameters
<code>A</code> (mutiplier for <code>x1</code>), <code>B</code> (mutiplier for
<code>x2</code>) and <code>C</code> (intercept). Then a random generator
generates the output, which should be a binary variable.
</p>
</html>", revisions="<html>
<ul>
<li>
July 20, 2018, by Zhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"));
end logit2D;

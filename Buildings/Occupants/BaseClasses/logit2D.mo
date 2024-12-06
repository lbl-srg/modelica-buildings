within Buildings.Occupants.BaseClasses;
function logit2D "Mapping two continuous inputs to a binary output through a 2-dimension logistic relation"
  extends Modelica.Icons.Function;

  input Real x1 "The first input variable";
  input Real x2 "The second input variable";
  input Real A=1.0 "Parameter defining the 2D logistic relation: mutiplier for the first input";
  input Real B=1.0 "Parameter defining the 2D logistic relation: mutiplier for the second input";
  input Real C=1.0 "Parameter defining the 2D logistic relation: intercept";
  input Integer stateIn[Modelica.Math.Random.Generators.Xorshift1024star.nState]
    "State of the random number generator";
  output Boolean y "Binary variable";
  output Integer stateOut[Modelica.Math.Random.Generators.Xorshift1024star.nState]
    "New state of the random number generator";

algorithm
  (y, stateOut) := Buildings.Occupants.BaseClasses.binaryVariableGeneration(
    Modelica.Math.exp(A*x1+B*x2+C)/(Modelica.Math.exp(A*x1+B*x2+C)+1),
    stateIn);
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
December 6, 2024, by Michael Wetter:<br/>
Refactored implementation of random number calculations, transfering the local state of
the random number generator from one call to the next.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4069\">#4069</a>.
</li>
<li>
July 20, 2018, by Zhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"));
end logit2D;

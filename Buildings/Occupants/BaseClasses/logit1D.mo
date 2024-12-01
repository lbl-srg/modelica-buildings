within Buildings.Occupants.BaseClasses;
function logit1D "Mapping a continuous input to a binary output through a logistic relation"
  extends Modelica.Icons.Function;

  input Real x "Continuous variable";
  input Real A=1.0 "Logistic relation: Slope";
  input Real B=1.0 "Logistic relation: Intercept";
  input Integer stateIn[Modelica.Math.Random.Generators.Xorshift1024star.nState]
    "State of the random number generator";
  output Boolean y "Binary variable";
  output Integer stateOut[Modelica.Math.Random.Generators.Xorshift1024star.nState]
    "New state of the random number generator";

algorithm
  (y, stateOut) := Buildings.Occupants.BaseClasses.binaryVariableGeneration(
    Modelica.Math.exp(A*x+B)/(Modelica.Math.exp(A*x+B)+1),
    stateIn);
annotation (
Documentation(info="<html>
<p>
This function generates a random binary variable with the input of a continuous variable <code>x</code> from a
logistic relation.
</p>
<p>
The probability of being 1 is calculated from the input <code>x</code> from a logistic relation with the
slope <code>A</code> and the intercept <code>B</code>. Then a random generator
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
end logit1D;

within Buildings.Occupants.BaseClasses;
function linear1D "Mapping a continuous input to a binary output through a linear relation"
  extends Modelica.Icons.Function;

  input Real x "Continuous variable";
  input Real A=1 "Slope of the linear function";
  input Real B=0 "Intercept of the linear function";
  input Integer stateIn[Modelica.Math.Random.Generators.Xorshift1024star.nState]
    "State of the random number generator";
  output Boolean y "Binary variable";
  output Integer stateOut[Modelica.Math.Random.Generators.Xorshift1024star.nState]
    "New state of the random number generator";
algorithm
  (y, stateOut) := Buildings.Occupants.BaseClasses.binaryVariableGeneration(
    max(0, min(1, A*x+B)), stateIn);
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
end linear1D;

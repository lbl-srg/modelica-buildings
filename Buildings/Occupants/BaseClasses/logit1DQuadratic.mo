within Buildings.Occupants.BaseClasses;
function logit1DQuadratic "Mapping a continuous input to a binary output through a quadratic logistic relation"
  input Real x "Continous variable";
  input Real A=1.0 "Parameter defining the quadratic logistic relation";
  input Real B=1.0 "Parameter defining the quadratic logistic relation";
  input Real C=1.0 "Parameter defining the quadratic logistic relation";
  input Real D=1.0 "Parameter defining the quadratic logistic relation";
  input Integer globalSeed "Seed for the random number generator";
  output Boolean y "Binary variable";

algorithm
  y := Buildings.Occupants.BaseClasses.binaryVariableGeneration(
   A + C/(1+ Modelica.Math.exp(-B*(Modelica.Math.log10(x)-D))),
   globalSeed);
annotation (
Documentation(info="<html>
<p>
This function generates a random binary variable with the input of a continuous
variable <code>x</code> from a quadratic logistic relation.
</p>
<p>
The probability of being 1 is calculated from the input <code>x</code> from a
quadratic logistic relation with four predefined parameters <code>A</code>,
<code>B</code>, <code>C</code> and <code>D</code>. Then a random generator
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
end logit1DQuadratic;

within Buildings.Occupants.BaseClasses;
function weibull1DOFF "Mapping a continuous input to a binary output through a Weibull Distribution Relation"
    input Real x "Continous variable";
    input Real u=1.0 "Parameter defining the Weibull distribution threshold";
    input Real L=1.0 "Parameter defining the Weibull distribution normalization factor";
    input Real k=1.0 "Parameter defining the Weibull distribution shape factor";
    input Real dt=60 "Time step length";
    input Integer globalSeed "Seed for the random number generator";
    output Boolean y "Binary variable 0/1";

algorithm
    y := Buildings.Occupants.BaseClasses.binaryVariableGeneration(
     p = if x <= u then 1 - Modelica.Math.exp(-((u-x)/L)^k*dt) else 0,
     globalSeed = globalSeed);
annotation (
Documentation(info="<html>
<p>
This function generates a random binary variable with a continuous inputs
<code>x</code> from a Weibull Distribution relation.
</p>
<p>
The probability of being 1 is calculated from the input <code>x</code> from a
Weibull Distribution relation with three predefined parameters <code>u</code>
(threshold, the output would be 0 if <code>x</code> is bigger than <code>u</code>),
<code>L</code> (normalization faction) and <code>k</code> (shape factor).
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
end weibull1DOFF;

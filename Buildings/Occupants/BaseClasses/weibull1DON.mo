within Buildings.Occupants.BaseClasses;
function weibull1DON "Mapping a continuous input to a binary output through a Weibull distribution relation"
  extends Modelica.Icons.Function;

  input Real x "Continous variable";
  input Real u=1.0 "Parameter defining the Weibull distribution threshold";
  input Real L=1.0 "Parameter defining the Weibull distribution normalization factor";
  input Real k=1.0 "Parameter defining the Weibull distribution shape factor";
  input Real dt=60 "Time step length";
  input Integer stateIn[Modelica.Math.Random.Generators.Xorshift1024star.nState]
    "State of the random number generator";
  output Boolean y "Binary variable 0/1";
  output Integer stateOut[Modelica.Math.Random.Generators.Xorshift1024star.nState]
    "New state of the random number generator";

algorithm
  (y, stateOut) := Buildings.Occupants.BaseClasses.weibull1DOFF(
    x = u,
    u = x,
    L = L,
    k = k,
    dt = dt,
    stateIn = stateIn);
annotation (
Documentation(info="<html>
<p>
This function generates a random binary variable with a continuous inputs
<code>x</code> from a Weibull distribution relation.
</p>
<p>
The probability of being 1 is calculated from the input <code>x</code> from a
Weibull distribution relation with three predefined parameters <code>u</code>
(threshold, the output would be 0 if <code>x</code> is less than <code>u</code>),
<code>L</code> (normalization faction) and <code>k</code> (shape factor). Then
a random generator generates the output, which should be a binary variable.
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
end weibull1DON;

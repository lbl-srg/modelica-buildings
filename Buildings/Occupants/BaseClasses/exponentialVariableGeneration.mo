within Buildings.Occupants.BaseClasses;
function exponentialVariableGeneration "Random variable generator from the exponential distribution"
  extends Modelica.Icons.Function;
    input Real mu  "Mean exponential distribution";
    input Integer stateIn[Modelica.Math.Random.Generators.Xorshift1024star.nState]
      "State of the random number generator";
    output Real y "Random number";
    output Integer stateOut[Modelica.Math.Random.Generators.Xorshift1024star.nState]
      "New state of the random number generator";
protected
    Real r "Generated random numberin the range 0 < random ≤ 1";
algorithm
    (r, stateOut) := Modelica.Math.Random.Generators.Xorshift1024star.random(stateIn);
    y := -mu * Modelica.Math.log(1 - r);
  annotation (Documentation(info="<html>
<p>
This function generates a random variable, from a exponentuial distribution with the input of mean
<code>mu</code>. The random variable might be the duration of a specific event, for instance the time to keep
the HVAC on.
</p>
<p>
The input <code>mu</code> denotes the mean value of the exponential distribution. Higher <code>mu</code> indicates a higher
chance to generate a larger output <code>y</code>.
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
October 3, 2023, by Michael Wetter:<br/>
Initialized <code>localSeed</code>.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3549\">#3549</a>.
</li>
<li>
July 20, 2018, by Zhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"));
end exponentialVariableGeneration;

within Buildings.Occupants.BaseClasses;
function exponentialVariableGeneration "Random variable generator from the exponential distribution"
  extends Modelica.Icons.Function;
    input Real mu  "Mean exponential distribution";
    input Integer globalSeed "Seed for the random number generator";
    output Real y "duration of event";
protected
    Integer localSeed = 0 "Local seed";
    Integer state[Modelica.Math.Random.Generators.Xorshift1024star.nState];
    Real r "Generated random numberin the range 0 < random ≤ 1";
algorithm
    state := Modelica.Math.Random.Generators.Xorshift1024star.initialState(localSeed, globalSeed);
    (r, state) := Modelica.Math.Random.Generators.Xorshift1024star.random(state);
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

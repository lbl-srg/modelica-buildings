within Buildings.Occupants.BaseClasses;
function weibullVariableGeneration "Random variable generator from the Weibull distribution"
  extends Modelica.Icons.Function;

    input Real lambda "Parameter defining the Weibull distribution scale factor";
    input Real k "Parameter defining the Weibull distribution shape factor";
    input Integer stateIn[Modelica.Math.Random.Generators.Xorshift1024star.nState]
      "State of the random number generator";
    output Real y "Random variable generated from Weibull Distribution";
    output Integer stateOut[Modelica.Math.Random.Generators.Xorshift1024star.nState]
      "New state of the random number generator";
protected
    Real r "Generated random number in the range 0 < r ≤ 1";
algorithm
    (r, stateOut) := Modelica.Math.Random.Generators.Xorshift1024star.random(stateIn);
    y := lambda*(Modelica.Math.log((1 - r)^(-1)))^(1/k);
  annotation (Documentation(info="<html>
<p>
This function generates a random variable, from a Weibull distribution with the
inputs of <code>lambda</code> and <code>k</code>. The random variable might be
the duration of a specific event, for instance the time to keep the HVAC on.
</p>
<p>
The inputs <code>lambda</code> and <code>k</code> defines the probability density
function. <code>lambda</code> is similar to the mean value of exponential
distribution, and <code>k</code> defines the shape. A value of <code>k</code> = 1
means the Weibull distribution reduces to an exponential distribution. Genrally
speaking, higher <code>lambda</code> and higher <code>k</code> indicate a higher
chance to generate a higher output.
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
end weibullVariableGeneration;

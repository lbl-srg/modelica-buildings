within Buildings.Occupants.BaseClasses;
function weibullVariableGeneration "Random variable generator from the Weibull distribution"
    input Real lambda "Parameter defining the Weibull distribution scale factor";
    input Real k "Parameter defining the Weibull distribution shape factor";
    input Integer globalSeed "Seed for the random number generator";
    output Real y "Random variable generated from Weibull Distribution";
protected
    Integer localSeed;
    Integer state[Modelica.Math.Random.Generators.Xorshift1024star.nState];
    Real r "Generated random numberin the range 0 < random ≤ 1";
algorithm
    state := Modelica.Math.Random.Generators.Xorshift1024star.initialState(localSeed, globalSeed);
    (r, state) := Modelica.Math.Random.Generators.Xorshift1024star.random(state);
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
July 20, 2018, by Zhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"));
end weibullVariableGeneration;

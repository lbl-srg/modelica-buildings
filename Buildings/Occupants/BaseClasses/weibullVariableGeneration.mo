within Buildings.Occupants.BaseClasses;
function weibullVariableGeneration "Random variable generator from the Weibull distribution"
    input Real lambda;
    input Real k;
    output Real y;
protected
    Integer globalSeed = Modelica.Math.Random.Utilities.automaticGlobalSeed();
    Integer localSeed;
    Integer state[Modelica.Math.Random.Generators.Xorshift1024star.nState];
    Real r "Generated random numberin the range 0 < random ≤ 1";
algorithm
    state := Modelica.Math.Random.Generators.Xorshift1024star.initialState(localSeed, globalSeed);
    (r, state) := Modelica.Math.Random.Generators.Xorshift1024star.random(state);
    y := lambda*(Modelica.Math.log((1 - r)^(-1)))^(1/k);
  annotation (Documentation(info="<html>
<p>
This function generates a random variable, from a Weibull distribution with the inputs of lambda 
and k. The random variable might be the duration of a specific event, for instance the time to 
keep the HVAC on.
</p>
<p>
The inputs lambda and k defines the probability density function. Lambda is similar to the mean 
value of exponential distribution, and k defines the shape. A value of k = 1 means the Weibull 
distribution reduces to an exponential distribution. Genrally speaking, higher lambda 
and higher k indicate a higher chance to generate a higher output.
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

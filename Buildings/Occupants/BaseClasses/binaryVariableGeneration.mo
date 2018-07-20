within Buildings.Occupants.BaseClasses;
function binaryVariableGeneration "Binary variables (0/1) random generator"
    input Real p "probaility of 1, in the range 0~1";
    input Integer globalSeed "seed for the random generator";
    output Boolean y "integer, 0 or 1";
protected
    Integer localSeed;
    Integer state[Modelica.Math.Random.Generators.Xorshift1024star.nState];
    Real r "random generated number in the range 0 < random ≤ 1";
  algorithm
    state := Modelica.Math.Random.Generators.Xorshift1024star.initialState(localSeed, globalSeed);
    (r, state) := Modelica.Math.Random.Generators.Xorshift1024star.random(state);
    y := if r < p then true else false;
    Modelica.Utilities.Streams.print(String(r));
  annotation (preferredView="info", Documentation(info="<html>
<p>
This function generates a random binary variable with the input of prabobility p.
</p>
<p>
The input p denotes the probability of being 1. Higher p indicates a higher chance of generating 1. 
</p>
</html>"));
end binaryVariableGeneration;

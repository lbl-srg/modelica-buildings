within Buildings.Occupants.BaseClasses;
function bVGRealRandom

  input Real p(min=0, max=1) "Probaility of 1";
  output Boolean y "Random number";

protected
  Integer globalSeed = Modelica.Math.Random.Utilities.automaticGlobalSeed();
  Integer localSeed "Local seed";
  Integer state[Modelica.Math.Random.Generators.Xorshift1024star.nState];
  Real r(min=0, max=1) "Generated random number";
algorithm
  state := Modelica.Math.Random.Generators.Xorshift1024star.initialState(localSeed, globalSeed);
  (r, state) := Modelica.Math.Random.Generators.Xorshift1024star.random(state);
  y := r < p;

end bVGRealRandom;

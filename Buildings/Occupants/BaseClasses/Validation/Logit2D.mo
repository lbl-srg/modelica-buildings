within Buildings.Occupants.BaseClasses.Validation;
model Logit2D "Test model for 2D binary variable generation function"
    extends Modelica.Icons.Example;

    parameter Integer localSeed = 10
    "Local seed to be used to generate the initial state of the random number generator";
  parameter Integer globalSeed = 30129
    "Global seed to be combined with the local seed";
    parameter Real A = 0.9 "Parameter A";
    parameter Real B = 1.3 "Parameter B";
    parameter Real C = 0 "Parameter C";
    Real x1 "Time-varying real number as input";
    Real x2 "Time-varying real number as input";
    output Real y "Output";
protected
  parameter Modelica.Units.SI.Time t0(final fixed=false)
    "First sample time instant";
    Integer state[Modelica.Math.Random.Generators.Xorshift1024star.nState]
    "State of the random number generator";
  Boolean r "Return value of random number generator";

initial equation
    y = 0;
    t0 = time;
    state = Modelica.Math.Random.Generators.Xorshift1024star.initialState(
      localSeed = localSeed,
      globalSeed = globalSeed);
    r = false;


equation
    x1 = time;
    x2 = 0.7*time;
    when sample(0, 0.1) then
      (r, state) = Buildings.Occupants.BaseClasses.logit2D(x1, x2, A, B, C, pre(state));
      if r then
        y = 1;
      else
       y = 0;
      end if;
    end when;

    annotation ( experiment(Tolerance=1e-6, StopTime=1.0),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Occupants/BaseClasses/Validation/Logit2D.mos"
          "Simulate and plot"), Documentation(info="<html>
<p>
This model tests the implementation of
<a href=\"modelica://Buildings.Occupants.BaseClasses.logit2D\">
Buildings.Occupants.BaseClasses.logit2D</a>.
</p>
</html>",   revisions="<html>
<ul>
<li>
December 6, 2024, by Michael Wetter:<br/>
Refactored implementation of random number calculations, transfering the local state of
the random number generator from one call to the next.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4069\">#4069</a>.
</li>
<li>
September 5, 2018 by Zhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"));
end Logit2D;

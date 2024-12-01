within Buildings.Occupants.BaseClasses.Validation;
model Logit1D "Test model for 1D binary variable generation function"
 extends Modelica.Icons.Example;

  parameter Integer localSeed = 10
    "Local seed to be used to generate the initial state of the random number generator";
  parameter Integer globalSeed = 30129
    "Global seed to be combined with the local seed";
  parameter Real A = 0.9 "Parameter A";
  parameter Real B = 0 "Parameter B";
  Real x "Time-varying real number as input";
  output Real y "Output";
protected
  parameter Modelica.Units.SI.Time t0(final fixed=false)
    "First sample time instant";
  Integer state[Modelica.Math.Random.Generators.Xorshift1024star.nState]
    "State of the random number generator";

initial equation
  y = 0;
  t0 = time;
  state = Modelica.Math.Random.Generators.Xorshift1024star.initialState(
    localSeed = localSeed, 
    globalSeed = globalSeed);


equation
  x = time;
  when sample(0, 0.1) then
    curSeed = seed*1E6*time;
    if Buildings.Occupants.BaseClasses.logit1D(x,A,B,globalSeed=integer(curSeed)) then
      y = 1;
    else
      y = 0;
    end if;
  end when;

  annotation ( experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Occupants/BaseClasses/Validation/Logit1D.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model tests the implementation of
<a href=\"modelica://Buildings.Occupants.BaseClasses.logit1D\">
Buildings.Occupants.BaseClasses.logit1D</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 5, 2018 by Zhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"));
end Logit1D;

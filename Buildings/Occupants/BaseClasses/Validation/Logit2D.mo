within Buildings.Occupants.BaseClasses.Validation;
model Logit2D "Test model for 2D binary variable generation function"
    extends Modelica.Icons.Example;

    parameter Integer seed = 5 "Seed for the random number generator";
    parameter Real A = 0.9 "Parameter A";
    parameter Real B = 1.3 "Parameter B";
    parameter Real C = 0 "Parameter C";
    Real x1 "Time-varying real number as input";
    Real x2 "Time-varying real number as input";
    output Real y "Output";
protected
  parameter Modelica.Units.SI.Time t0(final fixed=false)
    "First sample time instant";
    Real curSeed "Current value for seed as a real-valued variable";

initial equation
    y = 0;
    t0 = time;
    curSeed = t0*seed;

equation
    x1 = time;
    x2 = 0.7*time;
    when sample(0, 0.1) then
      curSeed = seed*1E6*time;
      if Buildings.Occupants.BaseClasses.logit2D(x1,x2,A,B,C,globalSeed=integer(curSeed)) then
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
September 5, 2018 by Zhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"));
end Logit2D;

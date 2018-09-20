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
  initial equation
    y = 0;
  equation
    x1 = time;
    x2 = 0.7*time;
    when sample(0, 0.1) then
    if Buildings.Occupants.BaseClasses.logit2D(x1,x2,A,B,C,globalSeed=integer(seed*1E6*time)) then
      y = 1;
    else
      y = 0;
    end if;
    end when;

    annotation ( experiment(Tolerance=1e-6, StopTime=1.0),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Occupants/BaseClasses/Validation/TestLogit2D.mos"
          "Simulate and plot"), Documentation(info="<html>
<p>
This model tests the implementation of
<a href=\"modelica://Buildings.Occupants.Baseclasses.logit2D\">
Buildings.Occupants.Baseclasses.logit2D</a>.
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

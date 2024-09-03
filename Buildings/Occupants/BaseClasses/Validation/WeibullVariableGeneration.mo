within Buildings.Occupants.BaseClasses.Validation;
model WeibullVariableGeneration "Test model for real variable generation function"
  extends Modelica.Icons.Example;

  parameter Integer seed = 5 "Seed for the random number generator";
  parameter Real lambda=10 "Time step length";

  Real k "Time-varying real number as input";

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
  k = (time+1);
  when sample(0, 0.1) then
    curSeed = seed*1E6*time;
    y = Buildings.Occupants.BaseClasses.weibullVariableGeneration(lambda,k,globalSeed=integer(curSeed));
  end when;

  annotation ( experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Occupants/BaseClasses/Validation/WeibullVariableGeneration.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model tests the implementation of
<a href=\"modelica://Buildings.Occupants.BaseClasses.weibullVariableGeneration\">
Buildings.Occupants.BaseClasses.weibullVariableGeneration</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 5, 2018 by Zhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"));
end WeibullVariableGeneration;

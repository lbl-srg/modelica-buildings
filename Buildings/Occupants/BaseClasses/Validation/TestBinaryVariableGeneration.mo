within Buildings.Occupants.BaseClasses.Validation;
model TestBinaryVariableGeneration "Test model for binary variable generation function"
  extends Modelica.Icons.Example;

  parameter Integer seed = 5 "Seed for the random number generator";
  Real p "Time-varying real number as input";
  output Real y "Output";
initial equation
  y = 0;
equation
  p = time;
  when sample(0, 0.1) then
  if Buildings.Occupants.BaseClasses.binaryVariableGeneration(p, globalSeed=integer(seed*1E6*time)) then
    y = 1;
  else
    y = 0;
  end if;
  end when;

  annotation ( experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Occupants/BaseClasses/Validation/TestBinaryVariableGeneration.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model tests the implementation of
<a href=\"modelica://Buildings.Utilities.Math.Average\">
Buildings.Utilities.Math.Average</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
November 28, 2013 by Marcus Fuchs:<br/>
First implementation.
</li>
</ul>
</html>"));
end TestBinaryVariableGeneration;

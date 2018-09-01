within Buildings.Occupants.BaseClasses.Validation;
model TestBinaryVariableGeneration "Test model for binary variable generation function"
  extends Modelica.Icons.Example;

  parameter Integer seed = 10 "Seed for the random number generator";
  output Boolean y "Output";

equation
  y = Buildings.Occupants.BaseClasses.binaryVariableGeneration(time, globalSeed=seed);

  annotation ( experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Math/Examples/Average.mos"
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

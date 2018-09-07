within Buildings.Occupants.BaseClasses.Validation;
model TestLinear1D "Test model for 1D binary variable generation function"
  extends Modelica.Icons.Example;

  parameter Integer seed = 5 "Seed for the random number generator";
  parameter Real A = 0.9 "Parameter A";
  parameter Real B = 0 "Parameter B";
  Real x "Time-varying real number as input";
  output Real y "Output";
initial equation
  y = 0;
equation
  x = time;
  when sample(0, 0.1) then
  if Buildings.Occupants.BaseClasses.linear1D(x,A,B,globalSeed=integer(seed*1E6*time)) then
    y = 1;
  else
    y = 0;
  end if;
  end when;

  annotation ( experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Occupants/BaseClasses/Validation/TestLinear1D.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model tests the implementation of
<a href=\"modelica://Buildings.Occupants.Baseclasses.linear1D\">
Buildings.Occupants.Baseclasses.linear1D</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 5, 2018 by Zhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"));
end TestLinear1D;

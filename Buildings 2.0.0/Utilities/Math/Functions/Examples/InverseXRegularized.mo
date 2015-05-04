within Buildings.Utilities.Math.Functions.Examples;
model InverseXRegularized
  "Test problem for function that replaces 1/x around the origin by a twice continuously differentiable function"
  extends Modelica.Icons.Example;
  Real x "Independent variable";
  parameter Real delta = 0.5 "Small value for approximation";
  Real y "Function value";
  Real xInv "Function value";
equation
  x=2*time-1;
  xInv = if ( abs(x) > 0.1)   then 1 / x else 0;
  y = Buildings.Utilities.Math.Functions.inverseXRegularized(x=x, delta=delta);
  annotation(experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Math/Functions/Examples/InverseXRegularized.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example tests the implementation of
<a href=\"modelica://Buildings.Utilities.Math.Functions.inverseXRegularized\">
Buildings.Utilities.Math.Functions.inverseXRegularized</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 8, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end InverseXRegularized;

within Districts.Utilities.Math.Functions.Examples;
model InverseXRegularized
  "Test problem for function that replaces 1/x around the origin by a twice continuously differentiable function"
  extends Modelica.Icons.Example;
  Real x "Indepedent variable";
  parameter Real delta = 0.5 "Small value for approximation";
  Real y "Function value";
  Real xInv "Function value";
equation
  x=2*time-1;
  xInv = if ( abs(x) > 0.1)   then 1 / x else 0;
  y = Districts.Utilities.Math.Functions.inverseXRegularized(x=x, delta=delta);
  annotation(Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                     graphics),
                      __Dymola_Commands(file="modelica://Districts/Resources/Scripts/Dymola/Utilities/Math/Functions/Examples/InverseXRegularized.mos"
        "Simulate and plot"));
end InverseXRegularized;

within Buildings.Utilities.Math.Functions.Examples;
model RegNonZeroPower
  extends Modelica.Icons.Example;
  Real y "Function value";
equation
  y=Buildings.Utilities.Math.Functions.regNonZeroPower(
                                             time, 0.3, 0.5);
  annotation(Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                     graphics),
                      
experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Math/Functions/Examples/RegNonZeroPower.mos" "Simulate and plot"));
end RegNonZeroPower;

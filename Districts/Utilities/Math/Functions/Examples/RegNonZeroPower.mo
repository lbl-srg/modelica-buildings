within Districts.Utilities.Math.Functions.Examples;
model RegNonZeroPower
  extends Modelica.Icons.Example;
  Real y "Function value";
equation
  y=Districts.Utilities.Math.Functions.regNonZeroPower(
                                             time, 0.3, 0.5);
  annotation(Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                     graphics),
                      __Dymola_Commands(file="modelica://Districts/Resources/Scripts/Dymola/Utilities/Math/Functions/Examples/RegNonZeroPower.mos"
        "Simulate and plot"));
end RegNonZeroPower;

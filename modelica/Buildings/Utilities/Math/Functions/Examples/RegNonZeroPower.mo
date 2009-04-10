within Buildings.Utilities.Math.Functions.Examples;
model RegNonZeroPower
  annotation(Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                     graphics),
                      Commands(file="RegNonZeroPower.mos" "run"));
  Real y "Function value";
equation
  y=Buildings.Utilities.Math.Functions.regNonZeroPower(
                                             time, 0.3, 0.5);
end RegNonZeroPower;

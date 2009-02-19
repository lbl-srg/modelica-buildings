within Buildings.Utilities.Math.Examples;
model RegNonZeroPower
  annotation(Diagram(graphics),
                      Commands(file="RegNonZeroPower.mos" "run"));
  Real y "Function value";
equation
  y=Buildings.Utilities.Math.regNonZeroPower(time, 0.3, 0.5);
end RegNonZeroPower;

within Buildings.Utilities.Math.Functions.Examples;
model SpliceFunction
  annotation(Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                     graphics),
                      Commands(file="SpliceFunction.mos" "run"));
  Real y "Function value";
equation
  y=Buildings.Utilities.Math.Functions.spliceFunction(
                                            10, -10, time+0.1, 0.2);
end SpliceFunction;

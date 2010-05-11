within Buildings.Utilities.Math.Functions.Examples;
model SpliceFunction

  Real y "Function value";
equation
  y=Buildings.Utilities.Math.Functions.spliceFunction(
                                            10, -10, time-0.5, 0.2);
  annotation(Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                     graphics),
                      Commands(file="SpliceFunction.mos" "run"));
end SpliceFunction;

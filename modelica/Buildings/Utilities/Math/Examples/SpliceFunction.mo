model SpliceFunction 
  annotation(Diagram, Commands(file="SpliceFunction.mos" "run"));
  Real y "Function value";
equation 
  y=Buildings.Utilities.Math.spliceFunction(10, -10, time+0.1, 0.2);
end SpliceFunction;

within Buildings.Utilities.Math.Functions.Examples;
model SpliceFunction
  extends Modelica.Icons.Example;

  Real y "Function value";
equation
  y=Buildings.Utilities.Math.Functions.spliceFunction(
                                            pos=10, neg=-10, x=time-0.4, deltax=0.2);
  annotation(Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                     graphics),
                      Commands(file="SpliceFunction.mos" "run"));
end SpliceFunction;

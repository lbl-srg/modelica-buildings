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
experiment(StartTime=-1, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Math/Functions/Examples/SpliceFunction.mos" "Simulate and plot"));
end SpliceFunction;

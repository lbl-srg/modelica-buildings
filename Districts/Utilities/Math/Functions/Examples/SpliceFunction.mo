within Districts.Utilities.Math.Functions.Examples;
model SpliceFunction
  extends Modelica.Icons.Example;

  Real y "Function value";
equation
  y=Districts.Utilities.Math.Functions.spliceFunction(
                                            pos=10, neg=-10, x=time-0.4, deltax=0.2);
  annotation(Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                     graphics),
                      __Dymola_Commands(file="modelica://Districts/Resources/Scripts/Dymola/Utilities/Math/Functions/Examples/SpliceFunction.mos"
        "Simulate and plot"));
end SpliceFunction;

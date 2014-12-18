within Buildings.Utilities.Math.Functions.Examples;
model SpliceFunctionDerivativeCheck
  extends Modelica.Icons.Example;

  Real x;
  Real y;
initial equation
   y=x;
equation
  x=Buildings.Utilities.Math.Functions.spliceFunction(
                                            10, -10, time+0.1, 0.2);
  der(y)=der(x);
  assert(abs(x-y) < 1E-2, "Model has an error");

 annotation(experiment(StartTime=-1, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Math/Functions/Examples/SpliceFunctionDerivativeCheck.mos" "Simulate and plot"),
    Documentation(info="<html>
<p>
This example checks whether the function derivative
is implemented correctly. If the derivative implementation
is not correct, the model will stop with an assert statement.
</p>
</html>", revisions="<html>
<ul>
<li>
May 20, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end SpliceFunctionDerivativeCheck;

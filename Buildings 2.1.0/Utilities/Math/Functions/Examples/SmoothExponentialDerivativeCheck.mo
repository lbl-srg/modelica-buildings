within Buildings.Utilities.Math.Functions.Examples;
model SmoothExponentialDerivativeCheck
  extends Modelica.Icons.Example;

  Real x;
  Real y;
  Real ex "exact function value";
initial equation
   y=x;
equation
  x=Buildings.Utilities.Math.Functions.smoothExponential(
                                               x=time-2, delta=0.5);
  der(y)=der(x);
  assert(abs(x-y) < 1E-2, "Model has an error");
  ex=exp(-abs(time-2));
 annotation(experiment(StopTime=4),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Math/Functions/Examples/SmoothExponentialDerivativeCheck.mos" "Simulate and plot"),
    Documentation(info="<html>
<p>
This example checks whether the function derivative
is implemented correctly. If the derivative implementation
is not correct, the model will stop with an assert statement.
</p>
</html>", revisions="<html>
<ul>
<li>
October 29, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end SmoothExponentialDerivativeCheck;

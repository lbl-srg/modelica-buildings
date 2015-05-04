within Buildings.Utilities.Math.Functions.Examples;
model PolynomialDerivativeCheck
  extends Modelica.Icons.Example;
  Real x;
  Real y;
initial equation
   y=x;
equation
  x=Buildings.Utilities.Math.Functions.polynomial(x=time-2, a={2, 4, -4, 5});
  der(y)=der(x);
  // Trigger an error if the derivative implementation is incorrect.
  assert(abs(x-y) < 1E-2, "Model has an error.");

 annotation(experiment(StopTime=4),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Math/Functions/Examples/PolynomialDerivativeCheck.mos" "Simulate and plot"),
    Documentation(info="<html>
<p>
This example checks whether the function derivative
is implemented correctly. If the derivative implementation
is incorrect, the model will stop with an assert statement.
</p>
</html>", revisions="<html>
<ul>
<li>
October 29, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PolynomialDerivativeCheck;

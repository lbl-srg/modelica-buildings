within Buildings.Utilities.Math.Functions.Examples;
model SpliceFunctionDerivativeCheck
 annotation(Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                    graphics),
                     Commands(file="SpliceFunctionDerivativeCheck.mos" "run"));
  annotation (
    Documentation(info="<html>
<p>
This example checks whether the function derivative
is implemented correctly. If the derivative implementation
is not correct, the model will stop with an assert statement.
</p>
</html>", revisions="<html>
<ul>
<li>
May 20, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));

  Real x;
  Real y;
initial equation
   y=x;
equation
  x=Buildings.Utilities.Math.Functions.spliceFunction(
                                            10, -10, time+0.1, 0.2);
  der(y)=der(x);
  assert(abs(x-y) < 1E-2, "Model has an error");

end SpliceFunctionDerivativeCheck;

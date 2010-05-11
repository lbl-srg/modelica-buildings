within Buildings.Utilities.Math.Functions.Examples;
model PolynomialDerivativeCheck

  Real x;
  Real y;
initial equation
   y=x;
equation
  x=Buildings.Utilities.Math.Functions.polynomial(
                                        x=time-2, a={2, 4, -4, 5});
  der(y)=der(x);
  assert(abs(x-y) < 1E-2, "Model has an error");
 annotation(Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                    graphics),
                     Commands(file="PolynomialDerivativeCheck.mos" "run"),
    Documentation(info="<html>
<p>
This example checks whether the function derivative
is implemented correctly. If the derivative implementation
is not correct, the model will stop with an assert statement.
</p>
</html>", revisions="<html>
<ul>
<li>
October 29, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end PolynomialDerivativeCheck;

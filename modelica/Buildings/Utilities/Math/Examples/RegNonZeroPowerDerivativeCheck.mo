within Buildings.Utilities.Math.Examples;
model RegNonZeroPowerDerivativeCheck
 annotation(Diagram(graphics),
                     Commands(file="RegNonZeroPowerDerivativeCheck.mos" "run"));
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
April 14, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));

 parameter Real n=0.33 "Exponent";
 parameter Real delta = 0.1 "Abscissa value where transition occurs";

  Real x;
  Real y;
initial equation
   y=x;
equation
  x=Buildings.Utilities.Math.regNonZeroPower(time,n, delta);
  der(y)=der(x);
  assert(abs(x-y) < 1E-2, "Model has an error");

end RegNonZeroPowerDerivativeCheck;

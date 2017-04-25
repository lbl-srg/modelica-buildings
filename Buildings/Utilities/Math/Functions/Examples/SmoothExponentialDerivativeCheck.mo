within Buildings.Utilities.Math.Functions.Examples;
model SmoothExponentialDerivativeCheck
  extends Modelica.Icons.Example;

  parameter Real delta = 0.5 "Smoothing area";
  Real x "Independent variable";
  Real y "Approximate function value";
  Real y_comp "Approximate function value";

  Real ex "Exact function value";
  Real err "Error";
initial equation
   y=y_comp;
equation
  x = time^3;
  y_comp=Buildings.Utilities.Math.Functions.smoothExponential(
                                               x=x, delta=delta);
  der(y)=der(y_comp);
  err = y_comp-y;
  assert(abs(err) < 1E-2, "Model has an error");
  ex=exp(-abs(x));
 annotation(experiment(StartTime=-1, StopTime=1, Tolerance=1E-8),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Math/Functions/Examples/SmoothExponentialDerivativeCheck.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example checks whether the function derivative
is implemented correctly. If the derivative implementation
is not correct, the model will stop with an assert statement.
</p>
</html>", revisions="<html>
<ul>
<li>
August 17, 2015 by Michael Wetter:<br/>
Updated regression test to have slope that is different from one.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/303\">issue 303</a>.
</li>
<li>
October 29, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end SmoothExponentialDerivativeCheck;

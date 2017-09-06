within Buildings.Utilities.Math.Functions.Examples;
model SpliceFunctionDerivativeCheck
  extends Modelica.Icons.Example;

  parameter Real delta = 0.2 "Smoothing area";
  Real deltax "Smoothing area as a function of x";

  Real x "Independent variable";
  Real y "Approximate function value";
  Real y_comp "Approximate function value";

  Real err "Error";

initial equation
   y=y_comp;
equation
  x = time^3;
  deltax=delta*10*time^8+0.1;

  // Because the derivative is implemented for all arguments,
  // we make pos, neg and deltax also functions of time
  y=Buildings.Utilities.Math.Functions.spliceFunction(
      pos=10*x^3,
      neg=-10*x^2,
      x=x,
      deltax=deltax);
  der(y)=der(y_comp);
  err = y-y_comp;
  assert(abs(err) < 1E-2, "Model has an error");

 annotation(experiment(StartTime=-1, Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Math/Functions/Examples/SpliceFunctionDerivativeCheck.mos"
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
May 20, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end SpliceFunctionDerivativeCheck;

within Buildings.Utilities.Math.Functions.Examples;
model RegNonZeroPowerDerivative_2_Check
  extends Modelica.Icons.Example;

  parameter Real n=0.33 "Exponent";

  constant Real gain = 4 "Gain for computing the mass flow rate";

  parameter Real delta = 0.7 "Smoothing coefficient";

  Real x "Independent variable";
  Real y_comp "Comparison value";
  Real y "Dependent variable";
  Real der_y_comp "1st order derivative of comparison value";
  Real der_y "1st order derivative of dependent variable";

  Real err "Integration error";
  Real der_err "Integration error";
initial equation
 y = y_comp;
 der_y = der_y_comp;
equation
  x = time^3*gain;
  y = Buildings.Utilities.Math.Functions.regNonZeroPower(
       x=      x,
       n=      n,
       delta=  delta);

  der_y = der(y);
  der_y_comp = der(y_comp);
  der(der_y) = der(der_y_comp);
  err     = y-y_comp;
  der_err = der_y-der_y_comp;

  assert(abs(err) < 1E-3, "Error in implementation.");
  assert(abs(der_err) < 1E-3, "Error in implementation.");

 annotation(experiment(StartTime=-1, StopTime=1.0, Tolerance=1E-8),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Math/Functions/Examples/RegNonZeroPowerDerivative_2_Check.mos"
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
April 14, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end RegNonZeroPowerDerivative_2_Check;

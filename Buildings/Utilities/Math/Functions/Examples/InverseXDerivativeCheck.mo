within Buildings.Utilities.Math.Functions.Examples;
model InverseXDerivativeCheck
  "Model that checks the correct implementation of the 1st order derivative of InverseXRegularized"
  extends Modelica.Icons.Example;

  constant Real gain = 4 "Gain for computing the mass flow rate";

  parameter Real delta = 0.7 "Smoothing coefficient";

  Real x "Independent variable";
  Real y_comp "Comparison value";
  Real y "Dependent variable";

  Real err "Integration error";
initial equation
 y = y_comp;
equation
  x = time^3*gain;
  y = Buildings.Utilities.Math.Functions.inverseXRegularized(
    x = x,
    delta = delta);
  der(y_comp) = Buildings.Utilities.Math.Functions.BaseClasses.der_inverseXRegularized(x=x,delta=delta,x_der=der(x));
  err = y-y_comp;
  assert(abs(err) < 1E-3, "Error in implementation.");
annotation (
experiment(
      StartTime=-1,
      StopTime=1.0,
      Tolerance=1e-08),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Math/Functions/Examples/InverseXDerivativeCheck.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This model validates the implementation of
<a href=\"modelica://Buildings.Utilities.Math.Functions.inverseXRegularized\">
Buildings.Utilities.Math.Functions.inverseXRegularized</a>
and its first order derivative
<a href=\"modelica://Buildings.Utilities.Math.Functions.BaseClasses.der_smoothTransition\">
Buildings.Utilities.Math.Functions.BaseClasses.der_smoothTransition</a>.
If the derivative implementation is wrong, the simulation will stop with an error.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 22, 2016, by Filip Jorissen:<br/>
Changed example such that it explicitly uses
<a href=\"modelica://Buildings.Utilities.Math.Functions.BaseClasses.der_inverseXRegularized\">
Buildings.Utilities.Math.Functions.BaseClasses.der_inverseXRegularized</a>.
</li>
<li>
August 11, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end InverseXDerivativeCheck;

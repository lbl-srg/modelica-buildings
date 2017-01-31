within Buildings.Utilities.Math.Functions.Examples;
model InverseXDerivative_2_Check
  "Model that checks the correct implementation of the 2nd order derivative of InverseXRegularized"
  extends Modelica.Icons.Example;
  Buildings.Utilities.Diagnostics.CheckEquality cheEqu1(
    threShold=1e-3)
    "Block for checking integration error";
  Buildings.Utilities.Diagnostics.CheckEquality cheEqu2(
    threShold=1e-3)
    "Block for checking integration error";
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
  y = Buildings.Utilities.Math.Functions.inverseXRegularized(
    x = x,
    delta = delta);

  der_y = der(y);
  der_y_comp = der(y_comp);
  der(der_y) = der(der_y_comp);
  cheEqu1.u1 = y;
  cheEqu1.u2 = y_comp;
  err = cheEqu1.y;
  cheEqu2.u1 = der_y;
  cheEqu2.u2 = der_y_comp;
  der_err = cheEqu2.y;

  assert(abs(err) < 1E-3, "Error in implementation.");
  assert(abs(der_err) < 1E-3, "Error in implementation.");
annotation (
experiment(
      StartTime=-1.5,
      StopTime=1.5,
      Tolerance=1e-08),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Math/Functions/Examples/InverseXDerivative_2_Check.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This model validates the implementation of
<a href=\"modelica://Buildings.Utilities.Math.Functions.inverseXRegularized\">
Buildings.Utilities.Math.Functions.inverseXRegularized</a>
and its second order derivative
<a href=\"modelica://Buildings.Utilities.Math.Functions.BaseClasses.der_2_smoothTransition\">
Buildings.Utilities.Math.Functions.BaseClasses.der_2_smoothTransition</a>.
If the derivative implementation is wrong, the simulation will stop with an error.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 12, 2017, by Thierry S. Nouidui:<br/>
Added blocks for checking integration errors.
This is needed for the JModelica verification tests.
</li>
<li>
August 11, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end InverseXDerivative_2_Check;

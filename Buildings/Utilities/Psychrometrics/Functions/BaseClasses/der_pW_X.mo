within Buildings.Utilities.Psychrometrics.Functions.BaseClasses;
function der_pW_X "Derivative of function pW_X"
  extends Modelica.Icons.Function;

  input Modelica.Units.SI.MassFraction X_w(
    min=0,
    max=1,
    nominal=0.01) "Species concentration at dry bulb temperature";
  input Modelica.Units.SI.Pressure p=101325 "Total pressure";

  input Real dX_w
    "Differential of species concentration at dry bulb temperature";
  input Real dp "Differential of total pressure";

  output Real dp_w "Differential of water vapor pressure";

protected
  Modelica.Units.SI.MassFraction x_w(nominal=0.01)
    "Water mass fraction per mass of dry air";
  Real dX_w_dX "Differential d (x_w) / d X_w";
algorithm
  x_w := X_w/(1 - X_w);
  dX_w_dX := 1/(1-X_w)^2;
  dp_w := p * 0.62198 / (0.62198 + x_w)^2 * dX_w_dX * dX_w + x_w/(0.62198 + x_w) * dp;

  annotation (
    Documentation(info="<html>
<p>
Derivative of function
<a href=\"modelica://Buildings.Utilities.Psychrometrics.Functions.pW_X\">
Buildings.Utilities.Psychrometrics.Functions.pW_X</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
May 21, 2010 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end der_pW_X;

within Buildings.Utilities.Psychrometrics.Functions;
function density_pTX
  "Density of air as a function of pressure, temperature and species concentration"
  extends Modelica.Icons.Function;
  input Modelica.Units.SI.Pressure p "Absolute pressure of the medium";
  input Modelica.Units.SI.Temperature T "Dry bulb temperature";
  input Modelica.Units.SI.MassFraction X_w
    "Water vapor mass fraction per unit mass total air";
  output Modelica.Units.SI.Density d "Mass density";
protected
  Modelica.Units.SI.SpecificHeatCapacity R
    "Gas constant (of mixture if applicable)";
algorithm
  R :=Modelica.Media.IdealGases.Common.SingleGasesData.Air.R_s*(1 - X_w) +
    Modelica.Media.IdealGases.Common.SingleGasesData.H2O.R_s*X_w;
  d := p/(R*T);

  annotation (smoothOrder=99,
  Documentation(info="<html>
<p>
Function to compute the density of moist air for given
pressure, temperature and water vapor mass fraction.
</p>
<p>
Note that the water vapor mass fraction is in <i>kg/kg</i>
total air.
</p>
</html>", revisions="<html>
<ul>
<li>
November 23, 2015 by Filip Jorissen:<br/>
Added derivative information for avoiding numerical Jacobians.
</li>
<li>
February 24, 2015 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end density_pTX;

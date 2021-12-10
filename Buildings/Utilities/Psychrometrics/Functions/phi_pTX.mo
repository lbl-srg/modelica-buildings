within Buildings.Utilities.Psychrometrics.Functions;
function phi_pTX
  "Relative humidity for given pressure, dry bulb temperature and moisture mass fraction"
  extends Modelica.Icons.Function;
  input Modelica.Units.SI.Pressure p "Absolute pressure of the medium";
  input Modelica.Units.SI.Temperature T "Dry bulb temperature";
  input Modelica.Units.SI.MassFraction X_w
    "Water vapor mass fraction per unit mass total air";
  output Real phi(unit="1") "Relative humidity";
algorithm
  phi :=p/saturationPressure(T)*X_w/(X_w +
    Buildings.Utilities.Psychrometrics.Constants.k_mair*(1-X_w));
  annotation (
    inverse(X_w=X_pTphi(p,T,phi)),
    smoothOrder=1,
    Documentation(info="<html>
<p>
Relative humidity of air for given
pressure, temperature and water vapor mass fraction.
</p>
<p>
Note that the water vapor mass fraction must be in <i>kg/kg</i>
total air, and not dry air.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 4, 2019 by Filip Jorissen:<br/>
Added inverse annotation
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1110\">#1110</a>.
</li>
<li>
November 17, 2014 by Michael Wetter:<br/>
Removed test that constrains the saturation pressure to be
lower than <code>p</code>.
I do not see any numerical problems without this test.
</li>
<li>
November 13, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end phi_pTX;

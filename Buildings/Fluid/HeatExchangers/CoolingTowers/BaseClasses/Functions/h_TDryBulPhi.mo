within Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Functions;
function h_TDryBulPhi
  "Computes saturated enthalpy based on drybulb temperature and relative humidity"
  extends Modelica.Icons.Function;

  // coefficients

  input Modelica.SIunits.Temperature  TDryBul(
    final min=100) "Dry bulb temperature";
  input Modelica.SIunits.MassFraction phi(final min=0, final max=1)
    "Relative air humidity";
  input Modelica.SIunits.Pressure p(
    final min = 0) "Pressure";

  output Modelica.SIunits.SpecificEnthalpy h "Specific enthalpy";

protected
  Modelica.SIunits.Conversions.NonSIunits.Temperature_degC TDryBul_degC
    "Dry bulb temperature in degree Celsius";
  Modelica.SIunits.Pressure p_w(displayUnit="Pa") "Water vapor pressure";
  Modelica.SIunits.MassFraction XiDryBul(nominal=0.01)
    "Water vapor mass fraction at dry bulb state";

algorithm
  TDryBul_degC := TDryBul - 273.15;
  p_w := phi * Buildings.Utilities.Psychrometrics.Functions.saturationPressure(TDryBul);
  XiDryBul := 0.6219647130774989*p_w/(p-p_w);
  h := 1006*TDryBul_degC + XiDryBul*(2501014.5+1860*TDryBul_degC);

  annotation (Documentation(revisions="<html>
<ul>
<li>
October 22, 2019, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This function computes enthalpy from the dry bulb temperature and relative humidity. 
</p>
</html>"));
end h_TDryBulPhi;

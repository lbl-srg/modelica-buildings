within Buildings.Applications.DataCenters.LiquidCooled.CDUs.Data.BaseClasses;
function thermalConductivity_TX_a "Return thermal conductivity"
  extends Modelica.Icons.Function;
  input Buildings.Applications.DataCenters.LiquidCooled.Types.Media medium
    "Medium type";
  input Modelica.Units.SI.MassFraction X_a "Glycol mass fraction";
  input Modelica.Units.SI.Temperature T "Temperature at which properties are evaluated";
  output Modelica.Units.SI.ThermalConductivity k_default
    "Thermal conductivity";

algorithm
  k_default :=
  if medium == Buildings.Applications.DataCenters.LiquidCooled.Types.Media.EthyleneGlycol
  then
    Buildings.Media.Antifreeze.Functions.EthyleneGlycolWater.thermalConductivity_TX_a(X_a=X_a, T=T)
  else
    Buildings.Media.Antifreeze.Functions.PropyleneGlycolWater.thermalConductivity_TX_a(X_a=X_a, T=T);

  annotation (Documentation(info="<html>
<p>
Function to return thermal conductivity for specified glycol mass fraction and temperature.
</p>
<p>
This function returns the thermal conductivity by calling the functions in
<a href=\\\"modelica://Buildings.Media.Antifreeze.Functions\">
Buildings.Media.Antifreeze.Functions</a>.
For water, the input argument <code>X_a</code> is not used.
For glycol, set it to the mass fraction of glycol.
</p>
</html>", revisions="<html>
<li>
April 21, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</html>"));
end thermalConductivity_TX_a;

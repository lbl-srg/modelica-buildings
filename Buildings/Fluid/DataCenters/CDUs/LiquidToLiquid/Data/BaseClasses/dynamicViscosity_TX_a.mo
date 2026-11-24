within Buildings.Fluid.DataCenters.CDUs.LiquidToLiquid.Data.BaseClasses;
function dynamicViscosity_TX_a "Return dynamic viscosity"
  extends Modelica.Icons.Function;
  input Buildings.Fluid.DataCenters.CDUs.Types.Media medium
    "Medium type";
  input Modelica.Units.SI.MassFraction X_a "Glycol mass fraction";
  input Modelica.Units.SI.Temperature T "Temperature at which properties are evaluated";
  output Modelica.Units.SI.DynamicViscosity eta_default
    "Dynamic viscosity";

algorithm
  eta_default :=
    if medium == Buildings.Fluid.DataCenters.CDUs.Types.Media.Water
    then
      Buildings.Media.Antifreeze.Functions.PropyleneGlycolWater.dynamicViscosity_TX_a(X_a=0, T=T)
    elseif medium == Buildings.Fluid.DataCenters.CDUs.Types.Media.EthyleneGlycol
    then
      Buildings.Media.Antifreeze.Functions.EthyleneGlycolWater.dynamicViscosity_TX_a(X_a=X_a, T=T)
    else
      Buildings.Media.Antifreeze.Functions.PropyleneGlycolWater.dynamicViscosity_TX_a(X_a=X_a, T=T);

  annotation (Documentation(info="<html>
<p>
Function to return dynamic viscosity for specified glycol mass fraction and temperature.
</p>
<p>
This function returns the dynamic viscosity by calling the functions in
<a href=\"modelica://Buildings.Media.Antifreeze.Functions\">
Buildings.Media.Antifreeze.Functions</a>.
For water, the input argument <code>X_a</code> is not used.
For glycol, set it to the mass fraction of glycol.
</p>
</html>", revisions="<html>
<ul>
<li>
November 13, 2026, by Michael Wetter:<br/>
Handled <code>medium == Buildings.Fluid.DataCenters.CDUs.Types.Media.Water</code>
explicitly so that <code>X_a</code> is ignored for water.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4926\">Buildings, #4926</a>.
</li>
<li>
April 21, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end dynamicViscosity_TX_a;

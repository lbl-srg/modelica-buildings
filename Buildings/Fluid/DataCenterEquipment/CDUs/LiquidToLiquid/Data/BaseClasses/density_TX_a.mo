within Buildings.Fluid.DataCenterEquipment.CDUs.LiquidToLiquid.Data.BaseClasses;
function density_TX_a "Return density"
  extends Modelica.Icons.Function;
  input Buildings.Fluid.DataCenterEquipment.CDUs.Types.Media medium
    "Medium type";
  input Modelica.Units.SI.MassFraction X_a "Glycol mass fraction";
  input Modelica.Units.SI.Temperature T "Temperature at which properties are evaluated";
  output Modelica.Units.SI.Density d
    "Prandtl number";

algorithm
  d :=
    if medium == Buildings.Fluid.DataCenterEquipment.CDUs.Types.Media.EthyleneGlycol
    then
      Buildings.Media.Antifreeze.Functions.EthyleneGlycolWater.density_TX_a(X_a=X_a, T=T)
    else
      Buildings.Media.Antifreeze.Functions.PropyleneGlycolWater.density_TX_a(X_a=X_a, T=T);

  annotation (Documentation(info="<html>
<p>
Function to return the mass density for specified glycol mass fraction and temperature.
</p>
<p>
This function returns the mass density by calling the functions in
<a href=\"modelica://Buildings.Media.Antifreeze.Functions\">
Buildings.Media.Antifreeze.Functions</a>.
For water, the input argument <code>X_a</code> is not used.
For glycol, set it to the mass fraction of glycol.
</p>
</html>", revisions="<html>
<li>
July 8, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</html>"));
end density_TX_a;

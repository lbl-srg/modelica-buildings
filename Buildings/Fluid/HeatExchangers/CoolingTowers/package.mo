within Buildings.Fluid.HeatExchangers;
package CoolingTowers "Package with cooling tower models"
  extends Modelica.Icons.VariantsPackage;

annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains components models for cooling towers.
</p>
<p>
The model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers.DryCooler\">
Buildings.Fluid.HeatExchangers.CoolingTowers.DryCooler</a>
computes the performance of a dry cooler using the epsilon-NTU approach,
with flow and temperature dependent convective heat transfer coefficients.
It uses the dry bulb air temperature as an input.
</p>
<p>
The model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers.FixedApproach\">
Buildings.Fluid.HeatExchangers.CoolingTowers.FixedApproach</a>
computes a fixed approach temperature.
It can be used with either the dry bulb or the wet bulb temperature as an input,
as it simply sets the coolant leaving temperature to be equal to the air temperature
plus a constant offset.
Note that this model does not compute fan energy consumption.
</p>
<p>
The model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers.YorkCalc\">
Buildings.Fluid.HeatExchangers.CoolingTowers.YorkCalc</a>
computes the performance of a wet, open cooling tower based the York formula.
It uses the wet bulb temperature as an input.
</p>
<p>
The model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers.Merkel\">
Buildings.Fluid.HeatExchangers.CoolingTowers.Merkel</a>
computes the performance of a wet, open cooling tower using the Merkel formula.
It uses the wet bulb temperature as an input.
</p>
</html>"));
end CoolingTowers;

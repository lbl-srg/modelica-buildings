within Buildings.Fluid.HeatExchangers.CoolingTowers.Data;
record UAMerkel "UA correction factors for Merkel cooling towers"
  extends Modelica.Icons.Record;

  parameter Real cDifWB[3]={1,0.0081,0}
    "Polynomial coefficients for correction of design wet bulb minus actual wet bulb temperature"
    annotation (Dialog(group="Performance curves"));
  parameter Real cAirFra[3]={0,1.3,-0.3}
    "Polynomial coefficients for correction for fractional air flow rate"
    annotation (Dialog(group="Performance curves"));
  parameter Real cWatFra[3]={0.1082,1.667,-0.7713}
    "Polynomial coefficients for correction for fractional water flow rate"
    annotation (Dialog(group="Performance curves"));

  parameter Real FRAirMin(min=0) = 0.2 "Minimum value for air flow fraction"
    annotation (Dialog(group="Performance curves"));
  parameter Real FRAirMax(min=0)= 1.0 "Maximum value for air flow fraction"
    annotation (Dialog(group="Performance curves"));
  parameter Real FRWatMin(min=0) = 0.3 "Minimum value for water flow fraction"
    annotation (Dialog(group="Performance curves"));
  parameter Real FRWatMax(min=0) = 1.0 "Maximum value for water flow fraction"
    annotation (Dialog(group="Performance curves"));

  // Range for the curves
  parameter Modelica.Units.SI.TemperatureDifference TDiffWBMin(
    max=0,
    displayUnit="K") = -10
    "Minimum value for leaving evaporator temperature difference"
    annotation (Dialog(group="Performance curves"));
  parameter Modelica.Units.SI.TemperatureDifference TDiffWBMax(
    min=0,
    displayUnit="K") = 25
    "Maximum value for leaving evaporator temperature difference"
    annotation (Dialog(group="Performance curves"));

  annotation (
defaultComponentName="UACor",
    Documentation(info="<html>
<p>
This data record contains the cooling tower performance data for
<a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers.Merkel\">
Buildings.Fluid.HeatExchangers.CoolingTowers.Merkel</a>.
Similar to the <code>CoolingTower:VariableSpeed:Merkel</code> model in EnergyPlus,
Merkel's theory is modified to include Scheier's adjustment factors that
adjust <i>UA</i> values at off-design conditions. The three factors are:
</p>
<ul>
<li>
<code>cDifWB</code>- Corrected UA based on the difference between the
current wetbulb temperature and the design wetbulb temperature.
</li>
<li>
<code>cAirFra</code>- Corrected UA based on the ratio of the current air
flow rate and the design air flow rate.
</li>
<li>
<code>cWatFra</code>- Corrected UA based on the ratio of the current water
flow rate and the design water flow rate.
</li>
</ul>
<p>
The user can update the values in this record based on the performance
characteristics of their cooling tower.
</p>
<p>
These three adjustment factors are used to calculate the
<i>UA</i> value as
</p>
<p align=\"center\" style=\"font-style:italic;\">
UA<sub>e</sub> = UA<sub>0</sub> &#183; f<sub>UA,wetbulb</sub> &#183; f<sub>UA,airflow</sub> &#183; f<sub>UA,waterflow</sub>,
</p>
<p>
where
<i>UA<sub>e</sub></i> and <i>UA<sub>0</sub></i> are the equivalent and design
overall heat transfer coefficent-area products, respectively.
</p>
<p>
The factors <i>f<sub>UA,wetbulb</sub></i>, <i>f<sub>UA,airflow</sub></i>, and <i>f<sub>UA,waterflow</sub></i>
adjust the current <i>UA</i> value for the current wetbulb temperature, air flow rate, and water
flow rate, respectively. These adjustment factors are third-order polynomial functions defined as
</p>
<p align=\"center\" style=\"font-style:italic;\">
f<sub>UA,x</sub> =
    c<sub>x,0</sub>&nbsp;
  + c<sub>x,1</sub> x
  + c<sub>x,2</sub> x<sup>2</sup>
  + c<sub>x,3</sub> x<sup>3</sup>,
</p>
<p>
where <i>x = {(T<sub>0,wetbulb</sub> - T<sub>wetbulb</sub>), &nbsp;
m&#775;<sub>air</sub> &frasl; m&#775;<sub>0,air</sub>, &nbsp;
m&#775;<sub>wat</sub> &frasl; m&#775;<sub>0,wat</sub>}
</i>
for the respective adjustment factor, and the
coefficients  <i>c<sub>x,0</sub></i>, <i>c<sub>x,1</sub></i>, <i>c<sub>x,2</sub></i>, and <i>c<sub>x,3</sub></i>
are the user-defined
values for the respective adjustment factor functions obtained from
<a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers.Data.UAMerkel\">
Buildings.Fluid.HeatExchangers.CoolingTowers.Data.UAMerkel</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 22, 2019, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end UAMerkel;

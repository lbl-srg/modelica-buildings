within Buildings.Fluid.HeatExchangers.CoolingTowers.Data;
record UAMerkel "UA correction factors for Merkel cooling towers"
  extends Modelica.Icons.Record;

  constant Integer nUAFunDifWB=3 "Number of coefficients for UAFunDifWB"
    annotation (Dialog(group="Performance curves"));
  constant Integer nUAFunAirFra=3 "Number of coefficients for UAFunAirFra"
    annotation (Dialog(group="Performance curves"));
  constant Integer nUAFunWatFra=3 "Number of coefficients for UAFunWatFra"
    annotation (Dialog(group="Performance curves"));
  parameter Real UAFunDifWB[nUAFunDifWB]={1,0.0081,0}
    "Polynomial coefficients for UAFunDifWB"
    annotation (Dialog(group="Performance curves"));
  parameter Real UAFunAirFra[nUAFunAirFra]={0,1.3,-0.3}
    "Polynomial coefficients for UAFunAirFra"
    annotation (Dialog(group="Performance curves"));
  parameter Real UAFunWatFra[nUAFunWatFra]={0.1082,1.667,-0.7713}
    "Polynomial coefficients for UAFunWatFra"
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
  parameter Modelica.SIunits.TemperatureDifference TDiffWBMin(
    max=0,
    displayUnit="K")= -10
    "Minimum value for leaving evaporator temperature difference"
    annotation (Dialog(group="Performance curves"));
  parameter Modelica.SIunits.TemperatureDifference TDiffWBMax(
    min=0,
    displayUnit="K")= 25
    "Maximum value for leaving evaporator temperature difference"
    annotation (Dialog(group="Performance curves"));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>This data record contains the cooling tower performance data for 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers.Merkel\">
Buildings.Fluid.HeatExchangers.CoolingTowers.Merkel</a>. 
Similar to the EnergyPlus <code>CoolingTower:VariableSpeed:Merkel</code> model, 
Merkel's theory is modified to include Scheier's modifications that 
adjust UA values at off-design conditions. The three adjustment factors are:</p>
<ul>
<li>
<code>UAFunDifWB </code>- Corrected UA based on the difference between the 
current wetbulb temperature and the design wetbulb temperature. 
</li>
<li>
<code>UAFunAirFra </code>- Corrected UA based on the ratio of the current air 
flow rate and the design air flow rate. 
</li>
<li>
<code>UAFunWatFra </code>- Corrected UA based on the ratio of the current water 
flow rate and the design water flow rate. 
</li>
</ul>
<p>
The user can update the values in this record based on the performance
characteristics of their cooling tower. 
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

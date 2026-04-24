within Buildings.Fluid.HeatExchangers.CoolingTowers.Data;
record YorkCalc "Performance data record for a dry cooler"
  extends Buildings.Fluid.HeatExchangers.CoolingTowers.Data.BaseClasses.BaseCoolingTower(
    TCooIn_nominal = 273.15 + 35,
    TCooOut_nominal = 273.15 + 29.44,
    ratCooAir_nominal =
      Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Functions.equivalentHeatCapacity(
      TIn=TAirInWB_nominal, TOut=TAirInWB_nominal+5) /
      Buildings.Utilities.Psychrometrics.Constants.cpWatLiq);

  parameter Modelica.Units.SI.Temperature TAirInWB_nominal=273.15 + 25.55
    "Nominal outdoor (air inlet) wetbulb temperature"
    annotation (Dialog(group="Nominal thermal performance"));

  annotation (
    defaultComponentName="dat",
    defaultComponentPrefixes="parameter",
    Documentation(info="<html>
<p>
Performance data record for a wet cooling cooler using the York calculation methods.
</p>
<p>
The default settings are for a cooler with a design approach temperature
(cooling out - air wet bulb in) of <i>3.89</i> K and
a design range temperature (cooling in - cooling out) of <i>5.56</i> K.
This corresponds to a nominal water inlet temperature of <i>35</i> &deg;C and
a nominal water outlet temperature of <i>29.44</i> &deg;C.
</p>
</html>", revisions="<html>
<ul>
<li>
April 23, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end YorkCalc;

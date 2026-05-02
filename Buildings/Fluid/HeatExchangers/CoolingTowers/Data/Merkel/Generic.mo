within Buildings.Fluid.HeatExchangers.CoolingTowers.Data.Merkel;
record Generic
  "Performance data record for a wet cooling tower that uses Merkel's model"
  extends Buildings.Fluid.HeatExchangers.CoolingTowers.Data.BaseClasses.BaseCoolingTower(
    TCooIn_nominal = 308.15,
    TCooOut_nominal = 302.59,
    ratCooAir_nominal =
      Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Functions.equivalentHeatCapacity(
      TIn=TAirInWB_nominal, TOut=TAirInWB_nominal+5) /
      Buildings.Utilities.Psychrometrics.Constants.cpWatLiq);

  parameter Modelica.Units.SI.Temperature TAirInWB_nominal=298.7
    "Nominal outdoor (air inlet) wetbulb temperature"
    annotation (Dialog(group="Nominal thermal performance"));

  parameter BaseClasses.UACorrection UACor "UA correction factors"
    annotation (
      Dialog(tab="Advanced"),
      Placement(transformation(extent={{60,60},{80,80}})));
  annotation (
    defaultComponentName="datCooTow",
    defaultComponentPrefixes="parameter",
    Documentation(info="<html>
<p>
Performance data record for a wet cooling tower that uses Merkel's method.
</p>
</html>", revisions="<html>
<ul>
<li>
April 22, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Generic;

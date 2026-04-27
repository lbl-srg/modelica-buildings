within Buildings.Fluid.HeatExchangers.CoolingTowers.Data.DryCooler;
record Generic "Performance data record for a dry cooler"
  extends Buildings.Fluid.HeatExchangers.CoolingTowers.Data.BaseClasses.BaseCoolingTower(
    ratCooAir_nominal =
      Buildings.Utilities.Psychrometrics.Constants.cpAir /
      Buildings.Utilities.Psychrometrics.Constants.cpWatLiq);

  parameter Modelica.Units.SI.Temperature TAirIn_nominal=308.15
    "Nominal outdoor (air inlet) drybulb temperature"
    annotation (Dialog(group="Nominal thermal performance"));


  BaseClasses.UACorrection UACor
    "Correction factor for UA value due to change in mass flow rate and temperature"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  annotation (
    defaultComponentName="datCooTow",
    defaultComponentPrefixes="parameter",
    Documentation(info="<html>
<p>
Performance data record for a dry cooler.
</p>
</html>", revisions="<html>
<ul>
<li>
April 21, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Generic;

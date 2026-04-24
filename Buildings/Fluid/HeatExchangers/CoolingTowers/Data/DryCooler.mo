within Buildings.Fluid.HeatExchangers.CoolingTowers.Data;
record DryCooler "Performance data record for a dry cooler"
  extends Buildings.Fluid.HeatExchangers.CoolingTowers.Data.BaseClasses.BaseCoolingTower(
    ratCooAir_nominal =
      Buildings.Utilities.Psychrometrics.Constants.cpAir /
      Buildings.Utilities.Psychrometrics.Constants.cpWatLiq);

  parameter Modelica.Units.SI.Temperature TAirIn_nominal=273.15 + 35
    "Nominal outdoor (air inlet) drybulb temperature"
    annotation (Dialog(group="Nominal thermal performance"));

  annotation (
    defaultComponentName="datDryCoo",
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
end DryCooler;

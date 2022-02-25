within Buildings.Examples.ScalableBenchmarks.BuildingVAV.ThermalZones.Validation;
model ThermalZone "Validation of the single zone model"
  extends Modelica.Icons.Example;
  package MediumA = Buildings.Media.Air "Medium model";

  Buildings.Examples.ScalableBenchmarks.BuildingVAV.ThermalZones.ThermalZone thermalZone(
    redeclare package MediumA = MediumA,
    gainFactor=1) "Thermal zone model"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
    Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));

equation
  connect(weaDat.weaBus, thermalZone.weaBus)
    annotation (Line(points={{-60,-30},{-38,-30},{-14.8,-30},{-14.8,-16}},
      color={255,204,51},  thickness=0.5));

annotation (
  experiment(StopTime=604800, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Examples/ScalableBenchmarks/BuildingVAV/ThermalZones/Validation/ThermalZone.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This model validates <a href=\"modelica://Buildings.Examples.ScalableBenchmarks.BuildingVAV.ThermalZones.ThermalZone\">
Buildings.Examples.ScalableBenchmarks.BuildingVAV.ThermalZones.ThermalZone</a>.
The number of floor and zones are default value (<code>nFlo=1, nZon=1</code>) and the
internal heat gain fluctuating amplitude factor is set to be <code>gainFactor=1</code>.
</p>

</html>", revisions="<html>
<ul>
<li>
September 16, 2021, by Michael Wetter:<br/>
Removed assignment of parameter <code>lat</code> as this is now obtained from the weather data reader.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1477\">IBPSA, #1477</a>.
</li>
<li>
June 16, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ThermalZone;

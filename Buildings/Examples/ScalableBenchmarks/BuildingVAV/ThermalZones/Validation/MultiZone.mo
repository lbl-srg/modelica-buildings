within Buildings.Examples.ScalableBenchmarks.BuildingVAV.ThermalZones.Validation;
model MultiZone "Validated the MultiZone model"
  extends Modelica.Icons.Example;

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
    "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Examples.ScalableBenchmarks.BuildingVAV.ThermalZones.MultiZone
    multiZone(nZon=6, nFlo=2)
    annotation (Placement(transformation(extent={{-20,-20},{20,20}})));
equation
  connect(weaDat.weaBus, multiZone.weaBus) annotation (Line(
      points={{-60,-30},{-40,-30},{-40,0},{-16.4,0}},
      color={255,204,51},
      thickness=0.5));
  annotation (
  experiment(StopTime=604800, Tolerance=1e-06, __Dymola_Algorithm="Radau"),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Examples/ScalableBenchmarks/BuildingVAV/ThermalZones/Validation/MultiZone.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This model validates <a href=\"modelica://Buildings.Examples.ScalableBenchmarks.BuildingVAV.ThermalZones.MultiZone\">
Buildings.Examples.ScalableBenchmarks.BuildingVAV.ThermalZones.MultiZone</a> by setting
number of floors and zones to <code>nFlo=2, nZon=6</code> respectively.  
</p>

</html>", revisions="<html>
<ul>
<li>
June 16, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end MultiZone;

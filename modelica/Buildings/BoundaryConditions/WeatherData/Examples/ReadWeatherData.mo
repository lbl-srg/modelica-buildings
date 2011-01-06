within Buildings.BoundaryConditions.WeatherData.Examples;
model ReadWeatherData "Test model for read requested weather data"
  import Buildings;

  Buildings.BoundaryConditions.WeatherData.ReadWeatherData weaDat(filNam=
        "Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  annotation (Diagram(graphics), Commands(file="ReadWeatherData.mos" "run"));
end ReadWeatherData;

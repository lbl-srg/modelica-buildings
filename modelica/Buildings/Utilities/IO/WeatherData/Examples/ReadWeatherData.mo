within Buildings.Utilities.IO.WeatherData.Examples;
model ReadWeatherData "Test model for read requested weather data"
  import Buildings;

  Buildings.Utilities.IO.WeatherData.ReadWeatherData weaDat(filNam=
        "/home/mwetter/proj/ldrd/bie/modeling/bie/branches/wzuo/work/bie/modelica/Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Buildings.Utilities.SimulationTime simTim
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
equation
  connect(simTim.y, weaDat.cloTim) annotation (Line(
      points={{-39,10},{-22,10}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(graphics), Commands(file="ReadWeatherData.mos" "run"));
end ReadWeatherData;

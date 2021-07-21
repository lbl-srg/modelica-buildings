within Buildings.Utilities.IO.SignalExchange.Examples;
model WeatherStation "Example use of WeatherStation"
  extends Modelica.Icons.Example;
  Buildings.Utilities.IO.SignalExchange.WeatherStation weaSta "Weather station"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data reader"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
equation

  connect(weaDat.weaBus, weaSta.weaBus) annotation (Line(
      points={{-40,0},{-24,0},{-24,-0.1},{-9.9,-0.1}},
      color={255,204,51},
      thickness=0.5));
  annotation (experiment(StopTime=864000,Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/IO/SignalExchange/Examples/WeatherStation.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
This example uses the weather station signal exchange block,
<a href=\"modelica://Buildings.Utilities.IO.SignalExchange.WeatherStation\">
Buildings.Utilities.IO.SignalExchange.WeatherStation</a>
along with a TMY weather data reader.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 29, 2020, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"));
end WeatherStation;

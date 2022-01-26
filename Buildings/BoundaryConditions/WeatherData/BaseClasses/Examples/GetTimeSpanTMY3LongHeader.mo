within Buildings.BoundaryConditions.WeatherData.BaseClasses.Examples;
model GetTimeSpanTMY3LongHeader
  "Test model to get the time span of a weather file with a long header line"
  extends Modelica.Icons.Example;

  parameter String filNam=Modelica.Utilities.Files.loadResource(
  "modelica://Buildings/Resources/Data/BoundaryConditions/WeatherData/BaseClasses/Examples/weatherWithLongHeader.mos")
   "Name of weather data file";

  final parameter Modelica.Units.SI.Time[2] timeSpan=
      Buildings.BoundaryConditions.WeatherData.BaseClasses.getTimeSpanTMY3(filNam,
      "tab1") "Start time, end time of weather data";

initial equation
  assert(abs(timeSpan[2]-14400) < 0.1, "Error in getting time span.");
  annotation (
    Documentation(info="<html>
<p>
This example tests getting the time span of a TMY3 weather data file with a long line in the
header of the weather file.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 27, 2021, by Michael Wetter:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1432\">#1432</a>.
</li>
</ul>
</html>"),
experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/WeatherData/BaseClasses/Examples/GetTimeSpanTMY3LongHeader.mos"
        "Simulate and plot"));
end GetTimeSpanTMY3LongHeader;

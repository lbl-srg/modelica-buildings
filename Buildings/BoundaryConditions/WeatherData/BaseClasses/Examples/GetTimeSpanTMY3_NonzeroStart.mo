within Buildings.BoundaryConditions.WeatherData.BaseClasses.Examples;
model GetTimeSpanTMY3_NonzeroStart
  "Test model to get time span of a weather file, start time is non zero"
  extends Modelica.Icons.Example;

  parameter String filNam = Modelica.Utilities.Files.loadResource(
  "modelica://Buildings/Resources/Data/BoundaryConditions/WeatherData/Validation/DecemberToJanuary.mos")
    "Name of weather data file";
  parameter String tabNam = "tab1" "Name of table on weather file";

  parameter Modelica.SIunits.Time[2] timeSpan(each fixed=false)
    "Start time, end time of weather data";

initial equation
  timeSpan = Buildings.BoundaryConditions.WeatherData.BaseClasses.getTimeSpanTMY3(
  filNam, tabNam);

  assert(abs(timeSpan[2]-31863600) < 1E-5  and abs(timeSpan[1]-30992400) < 1E-5,
      "Error in weather file, start time " + String(timeSpan[1]) +
      " and end time " + String(timeSpan[2]) + ", but expected 30992400 and 31863600.");

  annotation (
    Documentation(info="<html>
<p>
This example tests getting time span of a TMY3 weather data file that
starts at a non-zero time.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 17, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/WeatherData/BaseClasses/Examples/GetTimeSpanTMY3_NonzeroStart.mos"
        "Simulate and plot"));
end GetTimeSpanTMY3_NonzeroStart;

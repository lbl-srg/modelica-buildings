within Buildings.BoundaryConditions.WeatherData.BaseClasses;
function getTimeSpanTMY3
    "Get the time span of the weather data from the file"
  extends Modelica.Icons.Function;

  input String filNam "Name of weather data file";
  input String tabNam "Name of table on weather file";
  output Modelica.SIunits.Time[2] timeSpan "Start time, end time of weather data";

external "C" getTimeSpan(filNam, tabNam, timeSpan)
  annotation (
  Include="#include <getTimeSpan.c>",
  IncludeDirectory="modelica://Buildings/Resources/C-Sources");

  annotation (Documentation(info="<html>
<p>
This function returns the start time (first time stamp) and end time
(last time stamp plus average increment) of the TMY3 weather data file.
</p>
</html>", revisions="<html>
<ul>
<li>
April 16, 2019, by Jianjun Hu:<br/>
Reimplemented to use a C function, this is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1108\">#1108</a>.
</li>
<li>
November 15, 2017, by Ana Constantin:<br/>
First implementation, as part of solution to <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/842\">#842</a>.
</li>
</ul>
</html>"));
end getTimeSpanTMY3;

within Buildings.BoundaryConditions.WeatherData;
package UsersGuide "User's Guide"

annotation (DocumentationClass=true, Documentation(info="<html>
This package contains models to read weather data.
The weather data format is the Typical Meteorological Year (TMY3)
as obtained from the EnergyPlus web site at
<a href=\"http://apps1.eere.energy.gov/buildings/energyplus/cfm/weather_data.cfm\">
http://apps1.eere.energy.gov/buildings/energyplus/cfm/weather_data.cfm</a>.
</p>
<p>
To add new weather data, proceed as follows:
<ol>
<li>
Download the weather data file with the <code>epw</code> extension from
<a href=\"http://apps1.eere.energy.gov/buildings/energyplus/cfm/weather_data.cfm\">
http://apps1.eere.energy.gov/buildings/energyplus/cfm/weather_data.cfm</a>.
</li>
<li>
Add the file to <code>Buildings/Resources/weatherdata</code> (or to any directory
for which you have write permission).
</li>
<li>
On a console window, type<pre>
  cd Buildings/Resources/weatherdata
  java -jar ../bin/ConvertWeatherData.jar inputFile.epw
</pre>
This will generate the weather data file <code>inputFile.mos</code>, which can be read
by the model
<a href=\"modelica:Buildings.BoundaryConditions.WeatherData.ReadWeatherData\">
Buildings.BoundaryConditions.WeatherData.ReadWeatherData</a>.
</li>
</ol>
</p>
</html>"));
end UsersGuide;

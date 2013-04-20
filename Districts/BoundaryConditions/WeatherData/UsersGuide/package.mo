within Districts.BoundaryConditions.WeatherData;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Info;


annotation (DocumentationClass=true, Documentation(info="<html>
This package contains models to read weather data.
The weather data format is the Typical Meteorological Year (TMY3)
as obtained from the EnergyPlus web site at
<a href=\"http://apps1.eere.energy.gov/buildings/energyplus/cfm/weather_data.cfm\">
http://apps1.eere.energy.gov/buildings/energyplus/cfm/weather_data.cfm</a>.
</p>
<h4>Adding new weather data</h4>
<p>
To add new weather data, proceed as follows:
<ol>
<li>
Download the weather data file with the <code>epw</code> extension from
<a href=\"http://apps1.eere.energy.gov/buildings/energyplus/cfm/weather_data.cfm\">
http://apps1.eere.energy.gov/buildings/energyplus/cfm/weather_data.cfm</a>.
</li>
<li>
Add the file to <code>Districts/Resources/weatherdata</code> (or to any directory
for which you have write permission).
</li>
<li>
On a console window, type<pre>
  cd Districts/Resources/weatherdata
  java -jar ../bin/ConvertWeatherData.jar inputFile.epw
</pre>
This will generate the weather data file <code>inputFile.mos</code>, which can be read
by the model
<a href=\"modelica:Districts.BoundaryConditions.WeatherData.ReaderTMY3\">
Districts.BoundaryConditions.WeatherData.ReaderTMY3</a>.
</li>
</ol>
</p>
<h4>Implementation</h4>
<p>
The TMY3 weather data, as well as the EnergyPlus weather data, start at 1:00 AM
on January 1, and provide hourly data until midnight on December 31.
Thus, the first entry for temperatures, humidity, wind speed etc. are values
at 1:00 AM and not at midnight. Furthermore, the TMY3 weather data files can have
values at midnight of December 31 that may be significantly different from the values
at 1:00 AM on January 1.
Since annual simulations require weather data that start at 0:00 on January 1, 
data need to be provided for this hour. Due to the possibly large change in
weatherdata between 1:00 AM on January 1 and midnight at December 31, 
the weather data files in the Buildings library do not use the data entry from 
midnight at December 31 as the value for <i>t=0</i>. Rather, the
value from 1:00 AM on January 1 is duplicated and used for 0:00 on January 1.
To maintain a data record with <i>8760</i> hours, the weather data record from
midnight at December 31 is deleted.
These changes in the weather data file are done in the Java program that converts
EnergyPlus weather data file to Modelica weather data files, and which is described
below.
</p>
</html>"));
end UsersGuide;

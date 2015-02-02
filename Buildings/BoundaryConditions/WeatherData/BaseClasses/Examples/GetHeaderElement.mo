within Buildings.BoundaryConditions.WeatherData.BaseClasses.Examples;
model GetHeaderElement "Test model to get header element"
  extends Modelica.Icons.Example;
  parameter Modelica.SIunits.Angle longitude(fixed=false, displayUnit="deg")
    "Longitude";
  parameter Modelica.SIunits.Angle latitude(fixed=false, displayUnit="deg")
    "Latitude";
  parameter Modelica.SIunits.Time timeZone(fixed=false, displayUnit="h")
    "Time zone";

initial equation
  longitude = Buildings.BoundaryConditions.WeatherData.BaseClasses.getLongitudeTMY3(
    filNam="modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos");
  latitude = Buildings.BoundaryConditions.WeatherData.BaseClasses.getLatitudeTMY3(
    filNam="modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos");
  timeZone = Buildings.BoundaryConditions.WeatherData.BaseClasses.getTimeZoneTMY3(
    filNam="modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos");
  assert(abs(longitude*180/Modelica.Constants.pi+87.92) < 1,
      "Error when parsing longitude, longitude = " + String(longitude));
  assert(abs(latitude*180/Modelica.Constants.pi-41.98) < 1,
      "Error when parsing latitude, latitude = " + String(latitude));
  assert(abs(timeZone+6*3600) < 1, "Error when parsing time zone, timeZone = "
    + String(timeZone));

  annotation (
    Documentation(info="<html>
<p>
This example tests getting the header of the TMY3 weather data file.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 14, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/WeatherData/BaseClasses/Examples/GetHeaderElement.mos"
        "Simulate and plot"));
end GetHeaderElement;

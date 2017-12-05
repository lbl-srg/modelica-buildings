within Buildings.BoundaryConditions.WeatherData.BaseClasses.Examples;
model GetHeaderElement "Test model to get header element"
  extends Modelica.Icons.Example;
  parameter Modelica.SIunits.Angle longitude(fixed=false, displayUnit="deg")
    "Longitude";
  parameter Modelica.SIunits.Angle latitude(fixed=false, displayUnit="deg")
    "Latitude";
  parameter Modelica.SIunits.Time timeZone(fixed=false, displayUnit="h")
    "Time zone";

  parameter String filNam = Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    "Name of weather data file";

  final parameter String absFilNam = Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath(filNam)
    "Absolute path of the file";
initial equation
  longitude = Buildings.BoundaryConditions.WeatherData.BaseClasses.getLongitudeTMY3(
    filNam=absFilNam);
  latitude = Buildings.BoundaryConditions.WeatherData.BaseClasses.getLatitudeTMY3(
    filNam=absFilNam);
  timeZone = Buildings.BoundaryConditions.WeatherData.BaseClasses.getTimeZoneTMY3(
    filNam=absFilNam);
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
April 21, 2016, by Michael Wetter:<br/>
Added call to
<a href=\"modelica://Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath\">
Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath</a>
as this call has been removed from the function
<a href=\"modelica://Buildings.BoundaryConditions.WeatherData.BaseClasses.getHeaderElementTMY3\">
Buildings.BoundaryConditions.WeatherData.BaseClasses.getHeaderElementTMY3</a>.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/506\">Buildings, #506</a>.
</li>
<li>
July 14, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/WeatherData/BaseClasses/Examples/GetHeaderElement.mos"
        "Simulate and plot"));
end GetHeaderElement;

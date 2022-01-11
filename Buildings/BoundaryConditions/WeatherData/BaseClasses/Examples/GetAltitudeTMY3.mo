within Buildings.BoundaryConditions.WeatherData.BaseClasses.Examples;
model GetAltitudeTMY3 "Test model to get Altitude of TMY3"
  extends Modelica.Icons.Example;
  parameter String filNam = Modelica.Utilities.Files.loadResource(
  "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    "Name of weather data file";
  parameter Modelica.Units.SI.Length alt = Buildings.BoundaryConditions.WeatherData.BaseClasses.getAltitudeLocationTMY3(
  filNam) "Altitude of TMY3 location";

  annotation (
    Documentation(info="<html>
<p>
This example tests getting the location altitude of a TMY3 weather data file.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 11, 2021, by Michael Wetter:<br/>
Changed <code>alt</code> from variable to parameter as it is evaluated using an impure function call.
</li>
<li>
September 16, 2021, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/WeatherData/BaseClasses/Examples/GetAltitudeTMY3.mos"
        "Simulate and plot"));
end GetAltitudeTMY3;

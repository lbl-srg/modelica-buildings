within Buildings.BoundaryConditions.WeatherData.BaseClasses.Examples;
model GetAltitudeTMY3 "Test model to get Altitude of TMY3"
  extends Modelica.Icons.Example;
  parameter String filNam = Modelica.Utilities.Files.loadResource(
  "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    "Name of weather data file";
  Modelica.SIunits.Length alt
    "Altitude of TMY3 location";
equation
  alt = Buildings.BoundaryConditions.WeatherData.BaseClasses.getAltitudeLocationTMY3(
  filNam);
  annotation (
    Documentation(info="<html>
<p>
This example tests getting the location altitude of a TMY3 weather data file.
</p>
</html>",
revisions="<html>
<ul>
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

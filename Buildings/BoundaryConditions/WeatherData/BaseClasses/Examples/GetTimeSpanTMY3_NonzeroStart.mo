within Buildings.BoundaryConditions.WeatherData.BaseClasses.Examples;
model GetTimeSpanTMY3_NonzeroStart
  "Test model to get time span of a weather file, start time is non zero"
  extends Modelica.Icons.Example;
  extends Buildings.BoundaryConditions.WeatherData.BaseClasses.Examples.GetTimeSpanTMY3(
    filNam = Modelica.Utilities.Files.loadResource(
 "modelica://Buildings/Resources/Data/BoundaryConditions/WeatherData/Validation/DecemberToJanuary.mos"),
    staTim = 30992400,
    endTim = 31863600);

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

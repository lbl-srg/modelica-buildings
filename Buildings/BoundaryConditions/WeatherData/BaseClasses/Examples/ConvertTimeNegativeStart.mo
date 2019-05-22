within Buildings.BoundaryConditions.WeatherData.BaseClasses.Examples;
model ConvertTimeNegativeStart
  "Validation of time conversion for negative start time"
  extends Buildings.BoundaryConditions.WeatherData.BaseClasses.Examples.ConvertTime;
  annotation (
  Documentation(info="<html>
<p>
This example tests the model that converts time for negative start time.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 4, 2019, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
  experiment(Tolerance=1e-6, StartTime=-31536000, StopTime=31536000),
__Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/WeatherData/BaseClasses/Examples/ConvertTimeNegativeStart.mos"
        "Simulate and plot"));
end ConvertTimeNegativeStart;

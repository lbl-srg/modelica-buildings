within Buildings.BoundaryConditions.WeatherData.BaseClasses.Examples;
model GetAbsolutePath "Test model to get the absolute path of a URI"
  extends Modelica.Icons.Example;
  parameter String f[:] = {"file://legal.html",
                           "modelica://Buildings/legal.html",
                           "legal.html"} "Name of a file that exists";
  parameter String fAbs[:]=
    Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath(uri=f)
    "Absolute path of f";
  final parameter Integer dummy = size(f, 1)
    "Dummy variable, used have a result needed for the unit tests";
initial algorithm
  for i in 1:size(f, 1) loop
    Modelica.Utilities.Streams.print("Absolute path = " + fAbs[i]);
  end for;

  annotation (
experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/WeatherData/BaseClasses/Examples/GetAbsolutePath.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model tests the function that gets the absolute path of a URI.
</p>
</html>", revisions="<html>
<ul>
<li>
October 9, 2013, by Michael Wetter:<br/>
Removed incorrect call to <code>Modelica.Utilities.Files.exist</code>.
</li>
<li>
May 9, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end GetAbsolutePath;

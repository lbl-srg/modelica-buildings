within Buildings.BoundaryConditions.WeatherData.BaseClasses.Examples;
model GetAbsolutePath "Test model to get the absolute path of a URI"
  extends Modelica.Icons.Example;
  parameter String f = "modelica://Buildings/package.mo"
   "Name of a file that exists";
  parameter String fAbs=
    Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath(uri=f)
    "Absolute path of f";
  final parameter Integer dummy = 1
    "Dummy variable, used to have a result as needed for the unit tests";
initial algorithm
  Modelica.Utilities.Streams.print("Absolute path = " + fAbs);

  annotation (
experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/WeatherData/BaseClasses/Examples/GetAbsolutePath.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model tests the function that gets the absolute path of a URI.
</p>
</html>", revisions="<html>
<ul>
<li>
November 18, 2016, by Michael Wetter:<br/>
Removed tests that assumed that the regression test is run
from the library root directory.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/596\">#596</a>.
</li>
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

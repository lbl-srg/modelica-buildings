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
  for i in 1:size(f, 1) loop
    assert(Modelica.Utilities.Files.exist(fAbs[i]), "File " + fAbs[i] + " does not exist.");
  end for;
  annotation (
experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/WeatherData/BaseClasses/Examples/GetAbsolutePath.mos"
        "Simulate and plot"));
end GetAbsolutePath;

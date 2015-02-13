within Buildings.Media.Specialized.Air.Examples;
model PerfectGasTemperatureEnthalpyInversion
  "Model to check computation of h(T) and its inverse"
  extends Modelica.Icons.Example;
  extends Buildings.Media.Examples.BaseClasses.TestTemperatureEnthalpyInversion(
    redeclare package Medium =
        Buildings.Media.Specialized.Air.PerfectGas);
      annotation (
experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Media/Specialized/Air/Examples/PerfectGasTemperatureEnthalpyInversion.mos"
        "Simulate and plot"));
end PerfectGasTemperatureEnthalpyInversion;

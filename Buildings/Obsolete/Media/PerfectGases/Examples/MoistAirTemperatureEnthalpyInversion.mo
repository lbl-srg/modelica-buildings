within Buildings.Obsolete.Media.PerfectGases.Examples;
model MoistAirTemperatureEnthalpyInversion
  "Model to check computation of h(T) and its inverse"
  extends Modelica.Icons.Example;
  extends Buildings.Media.Examples.BaseClasses.TestTemperatureEnthalpyInversion(
    redeclare package Medium = Buildings.Obsolete.Media.PerfectGases.MoistAir);
  annotation (
experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Obsolete/Media/PerfectGases/Examples/MoistAirTemperatureEnthalpyInversion.mos"
        "Simulate and plot"));
end MoistAirTemperatureEnthalpyInversion;

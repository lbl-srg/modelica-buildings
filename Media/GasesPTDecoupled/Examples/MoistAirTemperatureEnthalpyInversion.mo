within Buildings.Media.GasesPTDecoupled.Examples;
model MoistAirTemperatureEnthalpyInversion
  "Model to check computation of h(T) and its inverse"
  extends Modelica.Icons.Example;
  extends Buildings.Media.BaseClasses.TestTemperatureEnthalpyInversion(
    redeclare package Medium = Buildings.Media.GasesPTDecoupled.MoistAir);
  annotation (
experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Media/GasesPTDecoupled/Examples/MoistAirTemperatureEnthalpyInversion.mos"
        "Simulate and plot"));
end MoistAirTemperatureEnthalpyInversion;

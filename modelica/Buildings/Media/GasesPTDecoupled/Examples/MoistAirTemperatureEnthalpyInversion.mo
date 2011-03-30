within Buildings.Media.GasesPTDecoupled.Examples;
model MoistAirTemperatureEnthalpyInversion
  "Model to check computation of h(T) and its inverse"
  extends Modelica.Icons.Example;
  extends Buildings.Media.BaseClasses.TestTemperatureEnthalpyInversion(
    redeclare package Medium = Buildings.Media.GasesPTDecoupled.MoistAir);
  annotation (Commands(file="MoistAirTemperatureEnthalpyInversion.mos" "run"));
end MoistAirTemperatureEnthalpyInversion;

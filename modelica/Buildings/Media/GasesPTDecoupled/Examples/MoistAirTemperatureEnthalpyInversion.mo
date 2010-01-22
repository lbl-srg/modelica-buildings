within Buildings.Media.GasesPTDecoupled.Examples;
model MoistAirTemperatureEnthalpyInversion
  "Model to check computation of h(T) and its inverse"
  extends Buildings.Media.BaseClasses.TestTemperatureEnthalpyInversion(
    redeclare package Medium =Buildings.Media.GasesPTDecoupled.MoistAir);
end MoistAirTemperatureEnthalpyInversion;

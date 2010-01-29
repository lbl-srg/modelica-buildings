within Buildings.Media.PerfectGases.Examples;
model MoistAirTemperatureEnthalpyInversion
  "Model to check computation of h(T) and its inverse"
  extends Buildings.Media.BaseClasses.TestTemperatureEnthalpyInversion(
    redeclare package Medium = Buildings.Media.PerfectGases.MoistAir);
  annotation (Commands(file="MoistAirTemperatureEnthalpyInversion.mos" "run"));
end MoistAirTemperatureEnthalpyInversion;

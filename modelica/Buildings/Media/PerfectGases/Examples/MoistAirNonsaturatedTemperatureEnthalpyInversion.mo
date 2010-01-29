within Buildings.Media.PerfectGases.Examples;
model MoistAirNonsaturatedTemperatureEnthalpyInversion
  "Model to check computation of h(T) and its inverse"
  extends Buildings.Media.BaseClasses.TestTemperatureEnthalpyInversion(
    redeclare package Medium = 
        Buildings.Media.PerfectGases.MoistAirNonsaturated);
      annotation (Commands(file="MoistAirNonsaturatedTemperatureEnthalpyInversion.mos" "run"));
end MoistAirNonsaturatedTemperatureEnthalpyInversion;

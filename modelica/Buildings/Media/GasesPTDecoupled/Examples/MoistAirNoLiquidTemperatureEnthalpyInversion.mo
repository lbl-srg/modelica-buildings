within Buildings.Media.GasesPTDecoupled.Examples;
model MoistAirNoLiquidTemperatureEnthalpyInversion
  "Model to check computation of h(T) and its inverse"
  extends Buildings.Media.BaseClasses.TestTemperatureEnthalpyInversion(
    redeclare package Medium = 
        Buildings.Media.GasesPTDecoupled.MoistAirNoLiquid);
  annotation (Commands(file="MoistAirNoLiquidTemperatureEnthalpyInversion.mos" "run"));
end MoistAirNoLiquidTemperatureEnthalpyInversion;

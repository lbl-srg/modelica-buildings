within Buildings.Media.GasesConstantDensity.Examples;
model MoistAirUnsaturatedTemperatureEnthalpyInversion
  "Model to check computation of h(T) and its inverse"
  extends Buildings.Media.BaseClasses.TestTemperatureEnthalpyInversion(
    redeclare package Medium =
        Buildings.Media.GasesConstantDensity.MoistAirUnsaturated);
  annotation (Commands(file="MoistAirUnsaturatedTemperatureEnthalpyInversion.mos" "run"));
end MoistAirUnsaturatedTemperatureEnthalpyInversion;

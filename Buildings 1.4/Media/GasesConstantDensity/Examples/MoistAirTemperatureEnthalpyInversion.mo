within Buildings.Media.GasesConstantDensity.Examples;
model MoistAirTemperatureEnthalpyInversion
  "Model to check computation of h(T) and its inverse"
  extends Modelica.Icons.Example;
  extends Buildings.Media.BaseClasses.TestTemperatureEnthalpyInversion(
    redeclare package Medium = Buildings.Media.GasesConstantDensity.MoistAir);
  annotation (__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Media/GasesConstantDensity/Examples/MoistAirTemperatureEnthalpyInversion.mos" "Simulate and plot"));
end MoistAirTemperatureEnthalpyInversion;

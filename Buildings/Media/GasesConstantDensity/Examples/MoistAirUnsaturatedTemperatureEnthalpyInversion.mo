within Buildings.Media.GasesConstantDensity.Examples;
model MoistAirUnsaturatedTemperatureEnthalpyInversion
  "Model to check computation of h(T) and its inverse"
  extends Modelica.Icons.Example;
  extends Buildings.Media.BaseClasses.TestTemperatureEnthalpyInversion(
    redeclare package Medium =
        Buildings.Media.GasesConstantDensity.MoistAirUnsaturated);
  annotation (
experiment(StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Media/GasesConstantDensity/Examples/MoistAirUnsaturatedTemperatureEnthalpyInversion.mos"
        "Simulate and plot"));
end MoistAirUnsaturatedTemperatureEnthalpyInversion;

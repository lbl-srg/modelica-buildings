within Buildings.Media.PerfectGases.Examples;
model MoistAirUnsaturatedTemperatureEnthalpyInversion
  "Model to check computation of h(T) and its inverse"
  extends Modelica.Icons.Example;
  extends Buildings.Media.BaseClasses.TestTemperatureEnthalpyInversion(
    redeclare package Medium =
        Buildings.Media.PerfectGases.MoistAirUnsaturated);
      annotation (__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Media/PerfectGases/Examples/MoistAirUnsaturatedTemperatureEnthalpyInversion.mos" "Simulate and plot"));
end MoistAirUnsaturatedTemperatureEnthalpyInversion;

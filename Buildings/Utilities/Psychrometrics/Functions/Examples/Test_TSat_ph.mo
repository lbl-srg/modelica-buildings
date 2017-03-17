within Buildings.Utilities.Psychrometrics.Functions.Examples;
model Test_TSat_ph
  "Test function to derive saturation temperature from pressure and enthalpy"
  extends Modelica.Icons.Example;

  parameter Modelica.SIunits.SpecificEnthalpy hRef = 42.02e3
    "A reference value of h";
  parameter Modelica.SIunits.Pressure p = 101325
    "Constant pressure for the simulation";

  Modelica.SIunits.Temperature TSat;
  Real h;

equation
  h = max(0.1, time) * hRef;
  TSat = Buildings.Utilities.Psychrometrics.Functions.TSat_ph(
    p = p,
    h = h);
  annotation (
    experiment(StopTime=1.0),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Psychrometrics/Functions/Examples/Test_TSat_ph.mos"
      "Simulate and plot"),
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)));
end Test_TSat_ph;

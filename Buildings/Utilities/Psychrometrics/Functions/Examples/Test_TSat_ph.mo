within Buildings.Utilities.Psychrometrics.Functions.Examples;
model Test_TSat_ph
  "Test function to derive saturation temperature from pressure and enthalpy"
  extends Modelica.Icons.Example;

  parameter Modelica.SIunits.SpecificEnthalpy h = 42.02e3;
  parameter Modelica.SIunits.Pressure p = 101325;

  Modelica.SIunits.Temperature TSat;

equation
  TSat = Buildings.Utilities.Psychrometrics.Functions.TSat_ph(p=p,h=h);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Test_TSat_ph;

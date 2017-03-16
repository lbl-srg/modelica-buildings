within Buildings.Utilities.Psychrometrics.Functions;
function TSat_ph
  "Find saturation temperature given total pressure and enthalpy"
  input Modelica.SIunits.Pressure p
    "The total pressure of the fluid";
  input Modelica.SIunits.SpecificEnthalpy h
    "The specific enthalpy of the fluid";
  output Modelica.SIunits.Temperature T
    "Temperature of the fluid at saturation conditions";

protected
  Buildings.Utilities.Psychrometrics.Functions.Solver_TSat_ph.f_nonlinear_Data
    data(p=p);
  Modelica.SIunits.Temperature x_min;
  Modelica.SIunits.Temperature x_max;

algorithm
  x_min := Modelica.SIunits.Conversions.from_degF(-40);
  x_max := Modelica.SIunits.Conversions.from_degF(180);
  T :=Buildings.Utilities.Psychrometrics.Functions.Solver_TSat_ph.solve(
    h,
    x_min,
    x_max,
    f_nonlinear_data=data);
end TSat_ph;

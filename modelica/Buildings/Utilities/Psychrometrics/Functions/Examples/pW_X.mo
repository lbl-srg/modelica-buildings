within Buildings.Utilities.Psychrometrics.Functions.Examples;
model pW_X "Model to test pW_X and its inverse function"

  Modelica.SIunits.MassFraction X "Mass fraction";
  Modelica.SIunits.MassFraction XInv "Mass fraction";
  Modelica.SIunits.MassFraction dX "Difference between mass fraction";
  Modelica.SIunits.Pressure p_w "Water vapor partial pressure";
  constant Real conv(unit="1/s") = 0.999 "Conversion factor";
equation
  X = conv*time;
  p_w = Buildings.Utilities.Psychrometrics.Functions.pW_X(X);
  XInv = Buildings.Utilities.Psychrometrics.Functions.X_pW(p_w);
  dX = X - XInv;
  assert(abs(dX) < 10E-12, "Error in function implementation.");
  annotation (Commands(file="pW_X.mos" "run"));
end pW_X;

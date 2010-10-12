within Buildings.Utilities.Psychrometrics.Functions.Examples;
model pW_TDewPoi_comparison
  "Model to test the approximation for pW_TDewPoi and its inverse function"

  Modelica.SIunits.Temperature T "Dew point temperature";
  Modelica.SIunits.Temperature TInv "Dew point temperature";
  Modelica.SIunits.TemperatureDifference dT "Difference between temperatures";
  Modelica.SIunits.Pressure p_w_ashrae
    "Water vapor partial pressure according to the ASHRAE handbook";
  Modelica.SIunits.Pressure p_w "Water vapor partial pressure";

  constant Real conv(unit="K/s") = 30 "Conversion factor";
  Real r_p "Ratio of the two approximations";
equation
  T = conv*time + 273.15;
  p_w_ashrae = Buildings.Utilities.Psychrometrics.Functions.pW_TDewPoi(T);
  p_w = Buildings.Utilities.Psychrometrics.Functions.pW_TDewPoi_amb(T);
  r_p = p_w_ashrae/p_w;
  p_w = Buildings.Utilities.Psychrometrics.Functions.pW_TDewPoi_amb(TInv);
  dT = T - TInv;
  assert(abs(dT) < 10E-12, "Error in function implementation.");
  annotation (Commands(file="pW_TDewPoi_comparison.mos" "run"));
end pW_TDewPoi_comparison;

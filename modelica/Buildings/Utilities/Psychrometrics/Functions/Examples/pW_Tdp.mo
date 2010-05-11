within Buildings.Utilities.Psychrometrics.Functions.Examples;
model pW_Tdp "Model to test pW_Tdp and its inverse function"

  Modelica.SIunits.Temperature T "Dew point temperature";
  Modelica.SIunits.Temperature TInv "Dew point temperature";
  Modelica.SIunits.TemperatureDifference dT "Difference between temperatures";
  Modelica.SIunits.Pressure p_w "Water vapor partial pressure";
  constant Real conv(unit="K/s") = 100 "Conversion factor";
equation
  T = conv * time + 273.15;
  p_w = Buildings.Utilities.Psychrometrics.Functions.pW_Tdp(T);
  TInv = Buildings.Utilities.Psychrometrics.Functions.Tdp_pW(p_w);
  dT=T-TInv;
  assert(abs(dT) < 10E-12, "Error in function implementation.");
  annotation(Commands(file="pW_Tdp.mos" "run"));
end pW_Tdp;

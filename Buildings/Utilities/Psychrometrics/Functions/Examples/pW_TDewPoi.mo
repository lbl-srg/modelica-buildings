within Buildings.Utilities.Psychrometrics.Functions.Examples;
model pW_TDewPoi "Model to test pW_TDewPoi and its inverse function"
  extends Modelica.Icons.Example;

  Modelica.Units.SI.Temperature T "Dew point temperature";
  Modelica.Units.SI.Temperature TInv "Dew point temperature";
  Modelica.Units.SI.TemperatureDifference dT "Difference between temperatures";
  Modelica.Units.SI.Pressure p_w "Water vapor partial pressure";
  constant Real conv(unit="K/s") = 100 "Conversion factor";
equation
  T = conv*time + 273.15;
  p_w = Buildings.Utilities.Psychrometrics.Functions.pW_TDewPoi(T);
  TInv = Buildings.Utilities.Psychrometrics.Functions.TDewPoi_pW(p_w);
  dT = T - TInv;
  assert(abs(dT) < 10E-12, "Error in function implementation.");
  annotation (
experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Psychrometrics/Functions/Examples/pW_TDewPoi.mos"
        "Simulate and plot"));
end pW_TDewPoi;

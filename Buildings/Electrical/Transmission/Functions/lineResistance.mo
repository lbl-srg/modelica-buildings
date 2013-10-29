within Buildings.Electrical.Transmission.Functions;
function lineResistance
  input Modelica.SIunits.Length Length "Length of the cable";
  input Buildings.Electrical.Types.VoltageLevel level;
  input Buildings.Electrical.Transmission.LowVoltageCables.Cable cable_low;
  input Buildings.Electrical.Transmission.MediumVoltageCables.Cable cable_med;
  output Modelica.SIunits.Resistance R;
algorithm
  R := cable_low.RCha*Length;
end lineResistance;

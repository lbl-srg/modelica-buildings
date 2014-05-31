within Buildings.Electrical.Transmission.Functions;
function lineResistance
  input Modelica.SIunits.Length Length "Length of the cable";
  input Buildings.Electrical.Types.VoltageLevel level;
  input Buildings.Electrical.Transmission.LowVoltageCables.Cable cable_low;
  input Buildings.Electrical.Transmission.MediumVoltageCables.Cable cable_med;
  output Modelica.SIunits.Resistance R;
algorithm

  if level == Buildings.Electrical.Types.VoltageLevel.Low then
    R := Length*cable_low.RCha;
  elseif level == Buildings.Electrical.Types.VoltageLevel.Medium then
    R := Length*cable_med.Rdc*R_AC_correction(cable_med.size, cable_med.material);
  elseif level == Buildings.Electrical.Types.VoltageLevel.High then
    R := Length*cable_med.Rdc*R_AC_correction(cable_med.size, cable_med.material);
  else
    Modelica.Utilities.Streams.print("Warning: the voltage level does not match one of the three available: Low, Medium or High " +
        String(level) + ". A Low level has been choose as default.");
    R := cable_low.RCha*Length;
  end if;

annotation(Inline = true);
end lineResistance;

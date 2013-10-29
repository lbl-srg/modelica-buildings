within Buildings.Electrical.Transmission.Functions;
function selectVoltageLevel
  "given the nominal voltage of the line defined the voltage level: low, medium or high"
  input Modelica.SIunits.Voltage V;
  output Buildings.Electrical.Types.VoltageLevel level;
algorithm
  if V<=0 then
    Modelica.Utilities.Streams.print("Error: the nominal voltage should be positive " +
        String(V) + " A. The voltage level cannot be choose, selected Low as default.");
    level := Buildings.Electrical.Types.VoltageLevel.Low;
  elseif V <= 1000 then
    level := Buildings.Electrical.Types.VoltageLevel.Low;
  elseif V > 1000 and V <= 50000 then
    level := Buildings.Electrical.Types.VoltageLevel.Medium;
  else
    level := Buildings.Electrical.Types.VoltageLevel.High;
  end if;
end selectVoltageLevel;

within Buildings.Electrical.Transmission.Functions;
function lineCapacitance
  input Modelica.SIunits.Length Length "Length of the cable";
  input Buildings.Electrical.Types.VoltageLevel level;
  input Buildings.Electrical.Transmission.LowVoltageCables.Cable cable_low;
  input Buildings.Electrical.Transmission.MediumVoltageCables.Cable cable_med;
  output Modelica.SIunits.Capacitance C;
protected
  parameter Modelica.SIunits.Frequency f = 50
    "Frequency considered in the definition of cables properties";
  parameter Modelica.SIunits.AngularVelocity omega = 2*Modelica.Constants.pi*f;
  Modelica.SIunits.Length GMD,r;
algorithm

  GMD := cable_med.GMD;
  r   := cable_med.d/2.0;

  if level == Buildings.Electrical.Types.VoltageLevel.Low then
    C := 0;//(1/omega)*Length;
  elseif level == Buildings.Electrical.Types.VoltageLevel.Medium then
    C := Length*2*Modelica.Constants.pi*Modelica.Constants.epsilon_0/log(GMD/r);
  elseif level == Buildings.Electrical.Types.VoltageLevel.High then
    C := Length*2*Modelica.Constants.pi*Modelica.Constants.epsilon_0/log(GMD/r);
  else
    Modelica.Utilities.Streams.print("Warning: the voltage level does not match one of the three available: Low, Medium or High " +
        String(level) + ". A Low level has been choose as default.");
  end if;

end lineCapacitance;

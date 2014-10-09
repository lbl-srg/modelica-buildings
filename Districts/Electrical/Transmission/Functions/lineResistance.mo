within Districts.Electrical.Transmission.Functions;
function lineResistance
  input Modelica.SIunits.Length Length "Length of the cable";
  input Districts.Electrical.Transmission.CommercialCables.Cable commercialCable;
  output Modelica.SIunits.Resistance R;
algorithm
  R := commercialCable.RCha*Length;
end lineResistance;

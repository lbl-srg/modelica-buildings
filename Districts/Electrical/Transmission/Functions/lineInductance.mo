within Districts.Electrical.Transmission.Functions;
function lineInductance
  input Modelica.SIunits.Length Length "Length of the cable";
  input Districts.Electrical.Transmission.CommercialCables.Cable commercialCable;
  output Modelica.SIunits.Inductance L;
protected
  parameter Modelica.SIunits.Frequency f = 50
    "Frequency considered in the definition of cables properties";
  parameter Modelica.SIunits.AngularVelocity omega = 2*Modelica.Constants.pi*f;
algorithm
  L := (commercialCable.XCha/omega)*Length;
end lineInductance;

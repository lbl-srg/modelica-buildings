within Districts.Electrical.Transmission.Functions;
function lineInductance
  input Modelica.SIunits.Length Length "Length of the cable";
  input Districts.Electrical.Transmission.Cables.Cable cable;
  input Districts.Electrical.Transmission.CommercialCables.Cable commercialCable;
  input Districts.Electrical.Types.CableMode mode;
  output Modelica.SIunits.Inductance L;
protected
  parameter Modelica.SIunits.Frequency f = 50;
  parameter Modelica.SIunits.AngularVelocity omega = 2*Modelica.Constants.pi*f;
algorithm
  if mode == Districts.Electrical.Types.CableMode.commercial then
    L := (commercialCable.XCha/omega)*Length;
  else
    L := Length*(0.055 + 0.4606*log(4*cable.i/cable.d))*1e-3/1e3;
  end if;
end lineInductance;

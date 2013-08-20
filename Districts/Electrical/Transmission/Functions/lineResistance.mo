within Districts.Electrical.Transmission.Functions;
function lineResistance
  input Modelica.SIunits.Length Length "Length of the cable";
  input Districts.Electrical.Transmission.Cables.Cable cable;
  input Districts.Electrical.Transmission.Materials.Material material;
  input Districts.Electrical.Transmission.CommercialCables.Cable commercialCable;
  input Districts.Electrical.Types.CableMode mode;
  output Modelica.SIunits.Resistance R;
algorithm
  if mode == Districts.Electrical.Types.CableMode.commercial then
    R := commercialCable.RCha*Length;
  else
    R := material.r0*Length/(cable.S);
  end if;
end lineResistance;

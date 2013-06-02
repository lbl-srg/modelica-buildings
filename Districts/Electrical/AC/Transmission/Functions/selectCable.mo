within Districts.Electrical.AC.Transmission.Functions;
function selectCable
  input Modelica.SIunits.Power P;
  input Modelica.SIunits.Voltage V;
  output Districts.Electrical.AC.Transmission.Cables.Cable cable;
protected
  Real i;
  Districts.Electrical.AC.Transmission.Cables.mmq_1_0 mmq_1_0;
  Districts.Electrical.AC.Transmission.Cables.mmq_1_5 mmq_1_5;
  Districts.Electrical.AC.Transmission.Cables.mmq_2_5 mmq_2_5;
  Districts.Electrical.AC.Transmission.Cables.mmq_4_0 mmq_4_0;
algorithm

  i := P/V;

  // Chose the material
  if i >= 0 and i < 1 then
    cable := mmq_1_0;
  elseif i >= 1 and i < 2 then
    cable := mmq_1_5;
  elseif i >= 2 and i < 3 then
    cable := mmq_2_5;
  else
    cable := mmq_4_0;
  end if;

end selectCable;

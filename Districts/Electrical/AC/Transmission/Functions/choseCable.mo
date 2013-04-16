within Districts.Electrical.AC.Transmission.Functions;
function choseCable
  input Modelica.SIunits.Power P;
  input Modelica.SIunits.Voltage V;
  output Districts.Electrical.AC.Transmission.Cables.Cable cable;
protected
  Real x;
  Districts.Electrical.AC.Transmission.Cables.mmq_1_0 mmq_1_0;
  Districts.Electrical.AC.Transmission.Cables.mmq_1_5 mmq_1_5;
  Districts.Electrical.AC.Transmission.Cables.mmq_2_5 mmq_2_5;
  Districts.Electrical.AC.Transmission.Cables.mmq_4_0 mmq_4_0;
algorithm

  x := P/V;

  // Chose the material
  if x >= 0 and x < 1 then
    cable := mmq_1_0;
  elseif x >= 1 and x < 2 then
    cable := mmq_1_5;
  elseif x >= 2 and x < 3 then
    cable := mmq_2_5;
  else
    cable := mmq_4_0;
  end if;

end choseCable;

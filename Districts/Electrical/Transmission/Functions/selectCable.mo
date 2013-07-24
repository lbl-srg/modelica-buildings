within Districts.Electrical.Transmission.Functions;
function selectCable
  input Modelica.SIunits.Power P;
  input Modelica.SIunits.Voltage V;
  input Boolean continuous;
  output Districts.Electrical.Transmission.Cables.Cable cable;
protected
  Real i;
  Districts.Electrical.Transmission.Cables.mmq_1_0 mmq_1_0;
  Districts.Electrical.Transmission.Cables.mmq_1_5 mmq_1_5;
  Districts.Electrical.Transmission.Cables.mmq_2_5 mmq_2_5;
  Districts.Electrical.Transmission.Cables.mmq_4_0 mmq_4_0;
  Real A;
  Real diameter;
algorithm
  i := P/V;

  if continuous then
    // Self defined cable
    // The density of current is 5A/mm2
    A := (i/5)*(1e-6);
    diameter := 2*sqrt(A/Modelica.Constants.pi);
    cable := Districts.Electrical.Transmission.Cables.Cable(S=A, d=diameter,  i=diameter*0.5);
  else

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

  end if;

end selectCable;

within Districts.Electrical.Transmission.Functions;
function selectCable
  input Modelica.SIunits.Power P "Rated transmitted power";
  input Modelica.SIunits.Voltage V "Nominal voltage";
  input Districts.Electrical.Types.CableMode mode "Mode of cable selection";
  output Districts.Electrical.Transmission.Cables.Cable cable;
protected
  Modelica.SIunits.Current i "Current";
  Districts.Electrical.Transmission.Cables.mmq_1_0 mmq_1_0;
  Districts.Electrical.Transmission.Cables.mmq_1_5 mmq_1_5;
  Districts.Electrical.Transmission.Cables.mmq_2_5 mmq_2_5;
  Districts.Electrical.Transmission.Cables.mmq_4_0 mmq_4_0;
  Modelica.SIunits.Area A "Cable cross sectional area";
  Modelica.SIunits.Length d "Cable diameter";
algorithm
  i := P/V;

  if mode == Districts.Electrical.Types.CableMode.automatic then
    // Self defined cable
    // The density of current is 5A/mm2
    A := (i/5)*(1e-6);
    d := 2*sqrt(A/Modelica.Constants.pi);
    cable := Districts.Electrical.Transmission.Cables.Cable(S=A, d=d,  i=d*0.5);
  else
    assert(false, "fixme: This feature is not yet implemented.");
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

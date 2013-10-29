within Buildings.Electrical.Transmission.Functions;
function selectCable_low
  input Modelica.SIunits.Power P_nominal "Rated power";
  input Modelica.SIunits.Voltage V_nominal "Rated voltage";
  output Buildings.Electrical.Transmission.LowVoltageCables.Cable cable "Cable";
protected
  Modelica.SIunits.Current I_nominal = P_nominal/V_nominal
    "Nominal current flowing through the line";
  parameter Real I_mm2 = 4 "Current density A/mm2";
  // List of commercial cables available in the library
  Buildings.Electrical.Transmission.LowVoltageCables.Cu10 cu10;
  Buildings.Electrical.Transmission.LowVoltageCables.Cu10 cu20;
  Buildings.Electrical.Transmission.LowVoltageCables.Cu10 cu25;
  Buildings.Electrical.Transmission.LowVoltageCables.Cu10 cu35;
  Buildings.Electrical.Transmission.LowVoltageCables.Cu10 cu50;
  Buildings.Electrical.Transmission.LowVoltageCables.Cu10 cu95;
  Buildings.Electrical.Transmission.LowVoltageCables.Cu10 cu100;
algorithm

  // Assumed the material is Copper
  if I_nominal*I_mm2 < 10 then
        cable := cu10;
  elseif I_nominal*I_mm2>=10 and I_nominal*I_mm2 <20 then
        cable := cu20;
  elseif I_nominal*I_mm2>=20 and I_nominal*I_mm2 <25 then
        cable := cu25;
  elseif I_nominal*I_mm2>=25 and I_nominal*I_mm2 <35 then
        cable := cu35;
  elseif I_nominal*I_mm2>=35 and I_nominal*I_mm2 <50 then
        cable := cu50;
  elseif I_nominal*I_mm2>=50 and I_nominal*I_mm2 <95 then
        cable := cu95;
  elseif I_nominal*I_mm2>=95 and I_nominal*I_mm2 <100 then
        cable := cu100;
  else  Modelica.Utilities.Streams.print("Warning: Cable autosizing does not support a current of " +
        String(I_nominal) + " A.
  The selected cable will be undersized.");
        cable := cu100;
  end if;

end selectCable_low;

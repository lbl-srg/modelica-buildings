within Buildings.Electrical.Transmission.Functions;
function selectCable_low
  input Modelica.SIunits.Power P_nominal "Rated power";
  input Modelica.SIunits.Voltage V_nominal "Rated voltage";
  output Buildings.Electrical.Transmission.LowVoltageCables.Cable cable "Cable";
protected
  parameter Real safety_factor = 1.2;
  Modelica.SIunits.Current I_nominal = safety_factor*P_nominal/V_nominal
    "Nominal current flowing through the line";
  Buildings.Electrical.Transmission.LowVoltageCables.Cu10 cu10;
  Buildings.Electrical.Transmission.LowVoltageCables.Cu20 cu20;
  Buildings.Electrical.Transmission.LowVoltageCables.Cu25 cu25;
  Buildings.Electrical.Transmission.LowVoltageCables.Cu35 cu35;
  Buildings.Electrical.Transmission.LowVoltageCables.Cu50 cu50;
  Buildings.Electrical.Transmission.LowVoltageCables.Cu95 cu95;
  Buildings.Electrical.Transmission.LowVoltageCables.Cu100 cu100;
algorithm
  // Assumed the material is Copper
  if I_nominal < cu10.Amp then
        cable := cu10;
  elseif I_nominal >= cu10.Amp and I_nominal < cu20.Amp then
        cable := cu20;
  elseif I_nominal >= cu20.Amp and I_nominal < cu25.Amp then
        cable := cu25;
  elseif I_nominal >= cu25.Amp and I_nominal < cu35.Amp then
        cable := cu35;
  elseif I_nominal >= cu35.Amp and I_nominal < cu50.Amp then
        cable := cu50;
  elseif I_nominal >= cu50.Amp and I_nominal < cu95.Amp then
        cable := cu95;
  elseif I_nominal >= cu95.Amp and I_nominal < cu100.Amp then
        cable := cu100;
  else
        Modelica.Utilities.Streams.print("Warning: Cable autosizing does not support a current of " +
        String(I_nominal) + " [A]. The selected cable will be undersized.");
        cable := cu100;
  end if;

end selectCable_low;

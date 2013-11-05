within Buildings.Electrical.Transmission.Functions;
function selectCable_med
  input Modelica.SIunits.Power P_nominal "Rated power";
  input Modelica.SIunits.Voltage V_nominal "Rated voltage";
  output Buildings.Electrical.Transmission.MediumVoltageCables.Cable cable "Cable";
protected
  parameter Real safety_factor = 1.2;
  Modelica.SIunits.Current I_nominal = safety_factor*P_nominal/V_nominal
    "Nominal current flowing through the line";
  Buildings.Electrical.Transmission.MediumVoltageCables.Annealed_Al_10 Al10;
  Buildings.Electrical.Transmission.MediumVoltageCables.Annealed_Al_30 Al30;
  Buildings.Electrical.Transmission.MediumVoltageCables.Annealed_Al_40 Al40;
  Buildings.Electrical.Transmission.MediumVoltageCables.Annealed_Al_350 Al350;
  Buildings.Electrical.Transmission.MediumVoltageCables.Annealed_Al_500 Al500;
  Buildings.Electrical.Transmission.MediumVoltageCables.Annealed_Al_1000 Al1000;
  Buildings.Electrical.Transmission.MediumVoltageCables.Annealed_Al_1500 Al1500;
algorithm

  // Assumed the material is Copper
  if I_nominal < Al10.Amp then
        cable := Al10;
  elseif I_nominal >= Al10.Amp and I_nominal < Al30.Amp then
        cable := Al30;
  elseif I_nominal >= Al30.Amp and I_nominal < Al40.Amp then
        cable := Al40;
  elseif I_nominal >= Al40.Amp and I_nominal < Al350.Amp then
        cable := Al350;
  elseif I_nominal >= Al350.Amp and I_nominal < Al500.Amp then
        cable := Al500;
  elseif I_nominal >= Al500.Amp and I_nominal < Al1000.Amp then
        cable := Al1000;
  elseif I_nominal >= Al1000.Amp and I_nominal < Al1500.Amp then
        cable := Al1500;
  else
        Modelica.Utilities.Streams.print("Warning: Function <selectCable_med>\nCable autosizing does not support a current of " +
        String(I_nominal) + " A.
  The selected cable will be undersized.");
        cable := Al10;
  end if;

end selectCable_med;

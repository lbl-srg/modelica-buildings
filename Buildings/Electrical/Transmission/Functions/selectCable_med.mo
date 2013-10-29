within Buildings.Electrical.Transmission.Functions;
function selectCable_med
  input Modelica.SIunits.Power P_nominal "Rated power";
  input Modelica.SIunits.Voltage V_nominal "Rated voltage";
  output Buildings.Electrical.Transmission.MediumVoltageCables.Cable cable "Cable";
protected
  Modelica.SIunits.Current I_nominal = P_nominal/V_nominal
    "Nominal current flowing through the line";
  Buildings.Electrical.Transmission.MediumVoltageCables.Annealed_Al_350 Al350;
algorithm

  cable := Al350;

end selectCable_med;

within Buildings.Electrical.Transmission.Functions;
function selectCable_med "This function is used to automatically select the
    type of cable for medium voltages"
  input Modelica.Units.SI.Power P_nominal=0 "Rated power";
  input Modelica.Units.SI.Voltage V_nominal=0 "Rated voltage";
  output Buildings.Electrical.Transmission.MediumVoltageCables.Generic cable "Cable";
protected
  parameter Real safety_factor = 1.2;
  Modelica.Units.SI.Current I_nominal
    "Nominal current flowing through the line";
  Buildings.Electrical.Transmission.MediumVoltageCables.Annealed_Al_10 Al10;
  Buildings.Electrical.Transmission.MediumVoltageCables.Annealed_Al_30 Al30;
  Buildings.Electrical.Transmission.MediumVoltageCables.Annealed_Al_40 Al40;
  Buildings.Electrical.Transmission.MediumVoltageCables.Annealed_Al_350 Al350;
  Buildings.Electrical.Transmission.MediumVoltageCables.Annealed_Al_500 Al500;
  Buildings.Electrical.Transmission.MediumVoltageCables.Annealed_Al_1000 Al1000;
  Buildings.Electrical.Transmission.MediumVoltageCables.Annealed_Al_1500 Al1500;
algorithm

  assert(Transmission.Functions.selectVoltageLevel(V_nominal) == Buildings.Electrical.Types.VoltageLevel.Medium,
  "In function Buildings.Electrical.Transmission.Functions.selectCable_med,
  cable autosizing has a nominal Voltage " + String(V_nominal) + " [V].
  The medium voltage cables do not support such a voltage level.",
  level=AssertionLevel.error);

  // Check if it's possible to compute the current
  if V_nominal > 0 then
    I_nominal :=safety_factor*P_nominal/V_nominal;
  else
    I_nominal :=0;
  end if;

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
    assert(I_nominal < Al1500.Amp,
"Warning: In function Buildings.Electrical.Transmission.Functions.selectCable_med,
  cable autosizing does not support a current of " + String(I_nominal) + " [A].
  The selected cable will be undersized.",
  level=AssertionLevel.warning);

        cable := Al10;
  end if;
annotation(Inline = true, Documentation(revisions="<html>
<ul>
<li>
Sept 19, 2014, by Marco Bonvini:<br/>
Added warning instead of print.
</li>
<li>
June 3, 2014, by Marco Bonvini:<br/>
Added User's guide.
</li>
</ul>
</html>", info="<html>
<p>
This function selects the default cable for a medium voltage
transmission line.
</p>
<p>
The function takes as inputs the nominal voltage <i>V<sub>nominal</sub></i> and the
nominal power <i>P<sub>nominal</sub></i>. It computes the maximum current current that
can flow through the cable as
</p>
<p align=\"center\" style=\"font-style:italic;\">
I<sub>MAX</sub> = S<sub>F</sub> P<sub>nominal</sub> / V<sub>nominal</sub>,
</p>
<p>
where <i>S<sub>F</sub></i> is the safety factor. By default the safety factor is equal to <i>1.2</i>.
</p>
<p>
Using <i>I<sub>MAX</sub></i>, the function selects the smallest cable that has an ampacity
higher than I<sub>MAX</sub>. The cables are selected from
<a href=\"modelica://Buildings.Electrical.Transmission.MediumVoltageCables\">
Buildings.Electrical.Transmission.MediumVoltageCables</a>.
</p>
</html>"));
end selectCable_med;

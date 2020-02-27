within Buildings.Electrical.Transmission.Functions;
function selectCable_low "This function is used to automatically select the
    type of cable for low voltages"
  input Modelica.Units.SI.Power P_nominal=0 "Rated power";
  input Modelica.Units.SI.Voltage V_nominal=0 "Rated voltage";
  output Buildings.Electrical.Transmission.LowVoltageCables.Generic cable "Cable";
protected
  parameter Real safety_factor = 1.2;
  Modelica.Units.SI.Current I_nominal
    "Nominal current flowing through the line";
  Buildings.Electrical.Transmission.LowVoltageCables.Cu10 cu10;
  Buildings.Electrical.Transmission.LowVoltageCables.Cu20 cu20;
  Buildings.Electrical.Transmission.LowVoltageCables.Cu25 cu25;
  Buildings.Electrical.Transmission.LowVoltageCables.Cu35 cu35;
  Buildings.Electrical.Transmission.LowVoltageCables.Cu50 cu50;
  Buildings.Electrical.Transmission.LowVoltageCables.Cu95 cu95;
  Buildings.Electrical.Transmission.LowVoltageCables.Cu100 cu100;
algorithm

  assert(Transmission.Functions.selectVoltageLevel(V_nominal) == Buildings.Electrical.Types.VoltageLevel.Low,
  "In function Buildings.Electrical.Transmission.Functions.selectCable_low,
  cable autosizing has a nominal Voltage " + String(V_nominal) + " [V].
  The low voltage cables do not support such a voltage level.",
  level=AssertionLevel.error);

  // Check if it's possible to compute the current
  if V_nominal > 0 then
    I_nominal :=safety_factor*P_nominal/V_nominal;
  else
    I_nominal :=0;
  end if;

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
    assert(I_nominal < cu100.Amp,
"In function Buildings.Electrical.Transmission.Functions.selectCable_low,
  cable autosizing does not support a current of " + String(I_nominal) + " [A].
  The selected cable will be undersized.",
  level=AssertionLevel.warning);
        cable := cu100;
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
This function selects the default cable for a low voltage
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
<a href=\"modelica://Buildings.Electrical.Transmission.LowVoltageCables\">
Buildings.Electrical.Transmission.LowVoltageCables</a>.
</p>
</html>"));
end selectCable_low;

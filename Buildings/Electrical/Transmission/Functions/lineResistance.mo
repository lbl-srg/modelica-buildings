within Buildings.Electrical.Transmission.Functions;
function lineResistance "This function computes the resistance of the cable"
  input Modelica.SIunits.Length Length "Length of the cable";
  input Buildings.Electrical.Types.VoltageLevel level "Voltage level";
  input Buildings.Electrical.Transmission.LowVoltageCables.Generic cable_low
    "Type of cable (if low voltage)";
  input Buildings.Electrical.Transmission.MediumVoltageCables.Generic cable_med
    "Type of cable (if medium voltage)";
  output Modelica.SIunits.Resistance R "Resistance of the cable";
algorithm

  if level == Buildings.Electrical.Types.VoltageLevel.Low then
    R := Length*cable_low.RCha;
  elseif level == Buildings.Electrical.Types.VoltageLevel.Medium then
    R := Length*cable_med.Rdc*R_AC_correction(cable_med.size, cable_med.material);
  elseif level == Buildings.Electrical.Types.VoltageLevel.High then
    R := Length*cable_med.Rdc*R_AC_correction(cable_med.size, cable_med.material);
  else
    Modelica.Utilities.Streams.print("Warning: the voltage level does not match one of the three available: Low, Medium or High " +
        String(level) + ". A Low level has been choose as default.");
    R := cable_low.RCha*Length;
  end if;

annotation(Inline = true, Documentation(revisions="<html>
<ul>
<li>
June 3, 2014, by Marco Bonvini:<br/>
Added User's guide.
</li>
</ul>
</html>", info="<html>
<p>
This function computes the overall resistance of a cable.
There are two different ways to compute the overall resistance of the cable
 depending on the voltage level.
</p>

<h4>Low voltage level</h4>
<p>
When the voltage level is low the cables have a characteristic resistance per unit 
length. The overall resistance is computed as
</p>
<p align=\"center\" style=\"font-style:italic;\">
R = R<sub>CHA</sub> L<sub>CABLE</sub>
</p>
<p>
where <i>R<sub>CHA</sub></i> is the characteristic resistance per unit lenght, and
<i>L<sub>CABLE</sub></i> is the length of the cable.
</p>

<h4>Medium and High voltage level</h4>
<p>
When the voltage level is medium or high the cables have a DC resistance that needs
to be corrected to account for the effects cause by the AC voltage
</p>
<p align=\"center\" style=\"font-style:italic;\">
R = L<sub>CABLE</sub> R<sub>DC</sub> f<sub>CORR</sub>(s, m)
</p>
<p>
where <i>R<sub>DC</sub> </i> is the characteristic DC resistance per unit lenght, 
<i>L<sub>CABLE</sub></i> is the length of the cable, and
<i>f<sub>CORR</sub>(s, m)</i> is a function that corrects the DC value and depends on the
size of the cable <i>s</i> and its material <i>m</i>. See 
<a href=\"modelica://Buildings.Electrical.Transmission.Functions.R_AC_correction\">
Buildings.Electrical.Transmission.Functions.R_AC_correction</a> for moer details on
the correction function.
</p>
</html>"));
end lineResistance;

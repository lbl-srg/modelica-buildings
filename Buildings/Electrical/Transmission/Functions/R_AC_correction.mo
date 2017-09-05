within Buildings.Electrical.Transmission.Functions;
function R_AC_correction
  "This function computes the correction factor of the DC resistance for AC systems at 60 Hz"
  input String size "Size of the commercial cable (AWG or kcmil)";
  input Buildings.Electrical.Transmission.Types.Material material
    "Material of the cable";
  output Real correction "Correction factor";
algorithm
  if material == Buildings.Electrical.Transmission.Types.Material.Al then
    if size == "1/0" then
      correction := 1.0;
    elseif size == "2/0" then
      correction := 1.001;
    elseif size == "3/0" then
      correction := 1.001;
    elseif size == "4/0" then
      correction := 1.001;
    elseif size == "250" then
      correction := 1.002;
    elseif size == "300" then
      correction := 1.003;
    elseif size == "350" then
      correction := 1.004;
    elseif size == "400" then
      correction := 1.005;
    elseif size == "500" then
      correction := 1.007;
    elseif size == "600" then
      correction := 1.01;
    elseif size == "700" then
      correction := 1.013;
    elseif size == "750" then
      correction := 1.015;
    elseif size == "800" then
      correction := 1.017;
    elseif size == "1000" then
      correction := 1.026;
    elseif size == "1250" then
      correction := 1.04;
    elseif size == "1500" then
      correction := 1.058;
    elseif size == "1750" then
      correction := 1.079;
    elseif size == "2000" then
      correction := 1.1;
    elseif size == "2500" then
      correction := 1.142;
    else
      correction := 1.0;
    end if;

  elseif material == Buildings.Electrical.Transmission.Types.Material.Cu then
    if size == "1/0" then
      correction := 1.0;
    elseif size == "2/0" then
      correction := 1.001;
    elseif size == "3/0" then
      correction := 1.002;
    elseif size == "4/0" then
      correction := 1.004;
    elseif size == "250" then
      correction := 1.005;
    elseif size == "300" then
      correction := 1.006;
    elseif size == "350" then
      correction := 1.009;
    elseif size == "400" then
      correction := 1.011;
    elseif size == "500" then
      correction := 1.018;
    elseif size == "600" then
      correction := 1.025;
    elseif size == "700" then
      correction := 1.034;
    elseif size == "750" then
      correction := 1.039;
    elseif size == "800" then
      correction := 1.044;
    elseif size == "1000" then
      correction := 1.067;
    elseif size == "1250" then
      correction := 1.102;
    elseif size == "1500" then
      correction := 1.142;
    elseif size == "1750" then
      correction := 1.185;
    elseif size == "2000" then
      correction := 1.233;
    elseif size == "2500" then
      correction := 1.326;
    else
      correction := 1.0;
    end if;
  else
    assert(material <> Buildings.Electrical.Transmission.Types.Material.Al and
           material <> Buildings.Electrical.Transmission.Types.Material.Cu,
    "In function Buildings.Electrical.Transmission.Functions.R_AC_Correction,
    does not support material " + String(material) + ".
    The selected cable has the R_AC_Correction of the Copper.",
    level = AssertionLevel.warning);

    correction := 1.0;
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
This function computes a correction factor for adapting the DC resistance
when working with AC voltages. The correction factor assumes <i>f = 60 Hz</i>.
</p>
<p>
The correction is based on the type of cabel (AWG or kcmil) and the material.
</p>

<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr>
<th>Type (AWG or kcmil)</th>
<th>Material</th>
<th>Correction factor</th>
</tr>
<!-- ************ -->
<tr>
<td>1/0</td><td>Aluminium</td><td>1.0</td>
</tr>
<!-- ************ -->
<tr>
<td>2/0</td><td>Aluminium</td><td>1.001</td>
</tr>
<!-- ************ -->
<tr>
<td>3/0</td><td>Aluminium</td><td>1.001</td>
</tr>
<!-- ************ -->
<tr>
<td>4/0</td><td>Aluminium</td><td>1.001</td>
</tr>
<!-- ************ -->
<tr>
<td>250</td><td>Aluminium</td><td>1.002</td>
</tr>
<!-- ************ -->
<tr>
<td>300</td><td>Aluminium</td><td>1.003</td>
</tr>
<!-- ************ -->
<tr>
<td>350</td><td>Aluminium</td><td>1.004</td>
</tr>
<!-- ************ -->
<tr>
<td>400</td><td>Aluminium</td><td>1.005</td>
</tr>
<!-- ************ -->
<tr>
<td>500</td><td>Aluminium</td><td>1.007</td>
</tr>
<!-- ************ -->
<tr>
<td>600</td><td>Aluminium</td><td>1.010</td>
</tr>
<!-- ************ -->
<tr>
<td>700</td><td>Aluminium</td><td>1.013</td>
</tr>
<!-- ************ -->
<tr>
<td>750</td><td>Aluminium</td><td>1.015</td>
</tr>
<!-- ************ -->
<tr>
<td>800</td><td>Aluminium</td><td>1.017</td>
</tr>
<!-- ************ -->
<tr>
<td>1000</td><td>Aluminium</td><td>1.026</td>
</tr>
<!-- ************ -->
<tr>
<td>1250</td><td>Aluminium</td><td>1.040</td>
</tr>
<!-- ************ -->
<tr>
<td>1500</td><td>Aluminium</td><td>1.058</td>
</tr>
<!-- ************ -->
<tr>
<td>1750</td><td>Aluminium</td><td>1.079</td>
</tr>
<!-- ************ -->
<tr>
<td>2000</td><td>Aluminium</td><td>1.100</td>
</tr>
<!-- ************ -->
<tr>
<td>2500</td><td>Aluminium</td><td>1.142</td>
</tr>
</table>

<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr>
<th>Type (AWG or kcmil)</th>
<th>Material</th>
<th>Correction factor</th>
</tr>
<!-- ************ -->
<tr>
<td>1/0</td><td>Copper</td><td>1.0</td>
</tr>
<!-- ************ -->
<tr>
<td>2/0</td><td>Copper</td><td>1.001</td>
</tr>
<!-- ************ -->
<tr>
<td>3/0</td><td>Copper</td><td>1.002</td>
</tr>
<!-- ************ -->
<tr>
<td>4/0</td><td>Copper</td><td>1.004</td>
</tr>
<!-- ************ -->
<tr>
<td>250</td><td>Copper</td><td>1.005</td>
</tr>
<!-- ************ -->
<tr>
<td>300</td><td>Copper</td><td>1.006</td>
</tr>
<!-- ************ -->
<tr>
<td>350</td><td>Copper</td><td>1.009</td>
</tr>
<!-- ************ -->
<tr>
<td>400</td><td>Copper</td><td>1.011</td>
</tr>
<!-- ************ -->
<tr>
<td>500</td><td>Copper</td><td>1.018</td>
</tr>
<!-- ************ -->
<tr>
<td>600</td><td>Copper</td><td>1.025</td>
</tr>
<!-- ************ -->
<tr>
<td>700</td><td>Copper</td><td>1.034</td>
</tr>
<!-- ************ -->
<tr>
<td>750</td><td>Copper</td><td>1.039</td>
</tr>
<!-- ************ -->
<tr>
<td>800</td><td>Copper</td><td>1.044</td>
</tr>
<!-- ************ -->
<tr>
<td>1000</td><td>Copper</td><td>1.067</td>
</tr>
<!-- ************ -->
<tr>
<td>1250</td><td>Copper</td><td>1.102</td>
</tr>
<!-- ************ -->
<tr>
<td>1500</td><td>Copper</td><td>1.142</td>
</tr>
<!-- ************ -->
<tr>
<td>1750</td><td>Copper</td><td>1.185</td>
</tr>
<!-- ************ -->
<tr>
<td>2000</td><td>Copper</td><td>1.233</td>
</tr>
<!-- ************ -->
<tr>
<td>2500</td><td>Copper</td><td>1.326</td>
</tr>
</table>

</html>"));
end R_AC_correction;

within Buildings.Electrical.Transmission.Functions;
function R_AC_correction
  "Function that corrects the value of the DC resistance for AC systems at 60 Hz"
  input String size;
  input Buildings.Electrical.Transmission.Materials.Material material;
  output Real correction;
algorithm
  if material == Buildings.Electrical.Transmission.Materials.Material.Al then
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

  elseif material == Buildings.Electrical.Transmission.Materials.Material.Cu then
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
    Modelica.Utilities.Streams.print("Warning: the material is not available " +
        String(material) + ". No correction applied.");
    correction := 1.0;
  end if;
annotation(Inline = true, Documentation(revisions="<html>
<ul>
<li>
June 3, 2014, by Marco Bonvini:<br/>
Added User's guide.
</li>
</ul>
</html>"));
end R_AC_correction;

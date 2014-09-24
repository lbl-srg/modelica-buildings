within Buildings.Electrical.Transmission.Functions;
function temperatureConstant
  "This function returns the temperature constant of the material (used to determine the temperature dependence of the resistivity)"
  input Buildings.Electrical.Types.VoltageLevel voltageLevel "Voltage level";
  input Buildings.Electrical.Transmission.LowVoltageCables.Generic cable_low
    "Type of cable (if low voltage)";
  input Buildings.Electrical.Transmission.MediumVoltageCables.Generic cable_med
    "Type of cable (if medium voltage)";
  output Modelica.SIunits.Temperature M "Temperature constant of the material";
protected
  Buildings.Electrical.Transmission.Types.Material material "Cable material";
algorithm

  // Select the cable depending on the voltage level of the line
  if voltageLevel == Buildings.Electrical.Types.VoltageLevel.Low then
    material := cable_low.material;
  elseif voltageLevel == Buildings.Electrical.Types.VoltageLevel.Medium then
    material := cable_med.material;
  else
    Modelica.Utilities.Streams.print("Warning: the voltage level should be Low or Medium " +
        String(voltageLevel) + " A. The material cannot be choose, selected Copper as default.");
    material := Buildings.Electrical.Transmission.Types.Material.Cu;
  end if;

  // Depending on the material define the constant
  if material == Buildings.Electrical.Transmission.Types.Material.Al then
    M := 228.1 + 273.15;
  elseif material == Buildings.Electrical.Transmission.Types.Material.Cu then
    M := 234.5 + 273.15;
  else
    assert(material <> Buildings.Electrical.Transmission.Types.Material.Al and
           material <> Buildings.Electrical.Transmission.Types.Material.Cu,
    "In function Buildings.Electrical.Transmission.Functions.temperatureConstant,
    does not support material " + String(material) + ".
    The selected cable has the temperature constant of Copper.",
    level=  AssertionLevel.warning);

    M := 234.5 + 273.15;
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
This function computes the temperature coefficient of a cable.
</p>
<p>
The temperature coefficient of a cable <i>M</i> is used to
compute how the resistance of a cable <i>R(T)</i> varies with the temperature <i>T</i>.
The variation is defined as
</p>
<p align=\"center\" style=\"font-style:italic;\">
R(T) = R<sub>ref</sub> (M + T)/(M + T<sub>ref</sub>),
</p>
<p>
where the resistance <i>R<sub>ref</sub></i> is the reference value of the resistance, <i>M</i> is the
 temperature coefficient of the cable material, and <i>T<sub>ref</sub></i> is the reference temperature.
</p>
<p>
The temperature coefficient depends on the material of the cable.
</p>
<h4>Copper</h4>
<p align=\"center\" style=\"font-style:italic;\">
M = 234.5 + 273.15 K
</p>
<h4>Aluminium</h4>
<p align=\"center\" style=\"font-style:italic;\">
M = 228.1 + 273.15 K
</p>
</html>"));
end temperatureConstant;

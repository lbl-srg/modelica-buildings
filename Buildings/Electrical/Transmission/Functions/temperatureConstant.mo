within Buildings.Electrical.Transmission.Functions;
function temperatureConstant
  "Function that returns the temperature constant of the material (used to determine the temperature dependence of the resistivity)"
  input Buildings.Electrical.Types.VoltageLevel voltageLevel;
  input Buildings.Electrical.Transmission.LowVoltageCables.Cable cable_low;
  input Buildings.Electrical.Transmission.MediumVoltageCables.Cable cable_med;
  output Modelica.SIunits.Temperature M;
protected
  Buildings.Electrical.Transmission.Materials.Material material;
algorithm

  // Select the cable depending on the voltage level of the line
  if voltageLevel == Buildings.Electrical.Types.VoltageLevel.Low then
    material := cable_low.material;
  elseif voltageLevel == Buildings.Electrical.Types.VoltageLevel.Medium then
    material := cable_med.material;
  else
    Modelica.Utilities.Streams.print("Warning: the voltage level should be Low or Medium " +
        String(voltageLevel) + " A. The material cannot be choose, selected Copper as default.");
    material := Buildings.Electrical.Transmission.Materials.Material.Cu;
  end if;

  // Depending on the material define the constant
  if material == Buildings.Electrical.Transmission.Materials.Material.Al then
    M := 228.1 + 273.15;
  elseif material == Buildings.Electrical.Transmission.Materials.Material.Cu then
    M := 234.5 + 273.15;
  else
    Modelica.Utilities.Streams.print("Warning: the material is not known, missing the temperature constant " +
        String(material) + " A. The material cannot be choose, selected Copper as default.");
    M := 234.5 + 273.15;
  end if;

annotation(Inline = true);
end temperatureConstant;

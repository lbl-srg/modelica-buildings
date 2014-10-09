within Districts.Electrical.Transmission.CommercialCables;
record Cable "Low Voltage Cable Type"
  extends Modelica.Icons.MaterialProperty;
  parameter Districts.Electrical.Types.CharacteristicResistance RCha(start=0)
    "Characteristic resistance of the cable";
  parameter Districts.Electrical.Types.CharacteristicReactance XCha(start=0)
    "Characteristic reactance of the cable";
  parameter Modelica.SIunits.ElectricCurrent In(start=0)
    "Nominal electrical current fused";
  parameter Modelica.SIunits.Temperature T0 = 273.15 + 25
    "Reference cable temperature";
  parameter Modelica.SIunits.LinearTemperatureCoefficient alphaT0 = 0.0
    "Linear temperature coefficient of the material";
end Cable;

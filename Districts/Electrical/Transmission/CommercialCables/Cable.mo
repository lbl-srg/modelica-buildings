within Districts.Electrical.Transmission.CommercialCables;
record Cable "Low Voltage Cable Type"
  extends Modelica.Icons.MaterialProperty;
  parameter Districts.Electrical.Types.CharacteristicResistance RCha(start=0)
    "Characteristic Resistance of the Cable";
  parameter Districts.Electrical.Types.CharacteristicReactance XCha(start=0)
    "Characteristic Reactance of the Cable";
  parameter Modelica.SIunits.ElectricCurrent In(start=0)
    "Nominal Electrical Current Fused";
end Cable;

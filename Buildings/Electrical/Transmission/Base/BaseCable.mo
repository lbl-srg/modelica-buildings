within Buildings.Electrical.Transmission.Base;
record BaseCable
  parameter Buildings.Electrical.Transmission.Materials.Material material
    "Material of the cable";
  parameter Modelica.SIunits.Current Amp(start=0.0)=0.0
    "Ampacitance of the cable";
  parameter Modelica.SIunits.Temperature Tref = 298.15
    "Reference cable temperature";
  parameter Buildings.Electrical.Types.CharacteristicResistance RCha(start=0)
    "Characteristic resistance of the cable";
  parameter Buildings.Electrical.Types.CharacteristicReactance XCha(start=0)
    "Characteristic reactance of the cable";
  parameter String size(start="")
    "AWG or kcmil code representing the conductor size";
  parameter Buildings.Electrical.Types.CharacteristicResistance Rdc(start=0)
    "Characteristic DC resistance of the cable @ Tref";
  parameter Modelica.SIunits.Length d(start=0.0) "Inner diameter";
  parameter Modelica.SIunits.Length D(start=0.0) "Outer diameter";
  parameter Modelica.SIunits.Length GMR(start=0.0)
    "Geometrical Mean Radius of the cable";
  parameter Modelica.SIunits.Length GMD(start=0.0)
    "Geometrical Mean Diameter of the cable";
end BaseCable;

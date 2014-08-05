within Buildings.Electrical.Transmission.BaseClasses;
record BaseCable "Record that contains the properties of a generic cable"
  parameter Buildings.Electrical.Transmission.Types.Material material
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
  parameter Modelica.SIunits.Length d "Inner diameter";
  parameter Modelica.SIunits.Length D "Outer diameter";
  parameter Modelica.SIunits.Length GMR "Geometrical Mean Radius of the cable";
  parameter Modelica.SIunits.Length GMD
    "Geometrical mean diameter of the cable";
  annotation (Documentation(revisions="<html>
<ul>
<li>
June 3, 2014, by Marco Bonvini:<br/>
Added User's guide.
</li>
</ul>
</html>", info="<html>
<p>
This record contains all the properties that are specified for a commercial
cable.
</p>
</html>"));
end BaseCable;

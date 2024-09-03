within Buildings.Electrical.Transmission.BaseClasses;
record BaseCable "Record that contains the properties of a generic cable"
  parameter Buildings.Electrical.Transmission.Types.Material material = Buildings.Electrical.Transmission.Types.Material.Al
    "Material of the cable";
  parameter Modelica.Units.SI.Current Amp(start=0.0) = 0.0
    "Ampacitance of the cable";
  parameter Modelica.Units.SI.Temperature T_ref=298.15
    "Reference cable temperature";
  parameter Modelica.Units.SI.Temperature M=228.1 + 273.15
    "Temperature constant of the material";

  replaceable partial function lineResistance
    "Function that computes the resistance of a cable"
    extends Modelica.Icons.Function;
    input Modelica.Units.SI.Length l "Length of the cable";
    input Modelica.Units.SI.Frequency f=50
      "Frequency considered in the definition of cables properties";
    output Modelica.Units.SI.Resistance R "Resistance of the cable";
  protected
    Modelica.Units.SI.AngularVelocity omega=2*Modelica.Constants.pi*f;
    annotation (Documentation(revisions="<html>
<ul>
<li>
August 30, 2024, by Michael Wetter:<br/>
Removed wrong parameter keyword on protected variable, which is needed for Dymola 2025x.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1930\">IBPSA, #1930</a>.
</li>
<li>
September 23, 2014, by Marco Bonvini:<br/>
Added function and documentation
</li>
</ul>
</html>"));
  end lineResistance;

  replaceable partial function lineInductance
    "Function that computes the inductance of a cable"
    extends Modelica.Icons.Function;
    input Modelica.Units.SI.Length l "Length of the cable";
    input Modelica.Units.SI.Frequency f=50
      "Frequency considered in the definition of cables properties";
    output Modelica.Units.SI.Inductance L "Inductance of the cable";
  protected
    Modelica.Units.SI.AngularVelocity omega=2*Modelica.Constants.pi*f;
    annotation (Documentation(revisions="<html>
<ul>
<li>
August 30, 2024, by Michael Wetter:<br/>
Removed wrong parameter keyword on protected variable, which is needed for Dymola 2025x.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1930\">IBPSA, #1930</a>.
</li>
<li>
September 23, 2014, by Marco Bonvini:<br/>
Added function and documentation
</li>
</ul>
</html>"));
  end lineInductance;

  replaceable partial function lineCapacitance
    "Function that computes the capacitance of a cable"
    extends Modelica.Icons.Function;
    input Modelica.Units.SI.Length l "Length of the cable";
    input Modelica.Units.SI.Frequency f=50
      "Frequency considered in the definition of cables properties";
    output Modelica.Units.SI.Capacitance C "Capacitance of the cable";
  protected
    Modelica.Units.SI.AngularVelocity omega=2*Modelica.Constants.pi*f;
    annotation (Documentation(revisions="<html>
<ul>
<li>
August 30, 2024, by Michael Wetter:<br/>
Removed wrong parameter keyword on protected variable, which is needed for Dymola 2025x.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1930\">IBPSA, #1930</a>.
</li>
<li>
September 23, 2014, by Marco Bonvini:<br/>
Added function and documentation
</li>
</ul>
</html>"));
  end lineCapacitance;

  annotation (Documentation(revisions="<html>
<ul>
<li>
August 30, 2024, by Michael Wetter:<br/>
Removed wrong parameter keyword on protected variable, which is needed for Dymola 2025x.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1930\">IBPSA, #1930</a>.
</li>
<li>
September 24, 2014, by Marco Bonvini:<br/>
Revised structure of the record, now the temperature constant <code>M</code>
is directly specified in the record.
</li>
<li>
September 23, 2014, by Marco Bonvini:<br/>
Revised structure of the record, not it contains just the minimum amount of
information needed to describe a cable.<br/>
It also contains partial function that compute the properties of the cable.
</li>
<li>
June 3, 2014, by Marco Bonvini:<br/>
Added User's guide.
</li>
</ul>
</html>", info="<html>
<p>
This record contains the basic properties to describe a commercial
cable.
</p>
<p>
The low voltage and medium voltage cables extends this base records and add
other specific parameters like the geometrical properties.
</p>
<p>
The record contains four partial replaceable functions used to compute
the properties of the cable such its resistance, inductance or capacitance.
</p>
</html>"));
end BaseCable;

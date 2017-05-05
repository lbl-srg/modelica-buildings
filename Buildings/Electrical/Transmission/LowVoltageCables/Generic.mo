within Buildings.Electrical.Transmission.LowVoltageCables;
record Generic "Data record for a generic low voltage cable"
  extends Modelica.Icons.MaterialProperty;
  extends Buildings.Electrical.Transmission.BaseClasses.BaseCable;
  parameter Buildings.Electrical.Types.CharacteristicResistance RCha(start=0)
    "Characteristic resistance of the cable";
  parameter Buildings.Electrical.Types.CharacteristicReactance XCha(start=0)
    "Characteristic reactance of the cable";

  redeclare function extends lineResistance
    "Function that computes the resistance of a cable"
   input Buildings.Electrical.Transmission.LowVoltageCables.Generic cable
      "Record that contains cable properties";
  algorithm
      R :=cable.RCha*l;
      annotation(Inline=true, Documentation(revisions="<html>
<ul>
<li>
September 23, 2014, by Marco Bonvini:<br/>
Added function and documentation
</li>
</ul>
</html>", info="<html>
<p>
This function computes the overall resistance of a cable.
</p>

<p>
The low voltage cable is described by a characteristic resistance per unit
length, given this value the overall resistance is computed as
</p>
<p align=\"center\" style=\"font-style:italic;\">
R = R<sub>CHA</sub> l<sub>CABLE</sub>,
</p>
<p>
where <i>R<sub>CHA</sub></i> is the characteristic resistance per unit length, and
<i>l<sub>CABLE</sub></i> is the length of the cable.
</p>
</html>"));
  end lineResistance;

  redeclare function extends lineInductance
    "Function that computes the resistance of a cable"
   input Buildings.Electrical.Transmission.LowVoltageCables.Generic cable
      "Record that contains cable properties";
  algorithm
      L := l*(cable.XCha/omega);
      annotation(Inline=true, Documentation(revisions="<html>
<ul>
<li>
September 23, 2014, by Marco Bonvini:<br/>
Added function and documentation
</li>
</ul>
</html>", info="<html>
<p>
This function computes the overall inductance of a cable.
</p>
<p>
When the voltage level is low, the cables have a characteristic reactance per unit
length, which is specified at <i>f = 50 Hz</i>.
The overall inductance is computed as
</p>
<p align=\"center\" style=\"font-style:italic;\">
L = (X<sub>CHA</sub>/&omega;) l<sub>CABLE</sub>,
</p>
<p>
where <i>X<sub>CHA</sub></i> is the characteristic reactance per unit length,
<i>&omega; = 2 &pi; f</i> is the angular velocity, and <i>l<sub>CABLE</sub></i> is
the length of the cable.
</p>
</html>"));
  end lineInductance;

  redeclare function extends lineCapacitance
    "Function that computes the capacitance of a cable"
   input Buildings.Electrical.Transmission.LowVoltageCables.Generic cable
      "Record that contains cable properties";
  algorithm
      C := 0.0;
      annotation(Inline=true, Documentation(revisions="<html>
<ul>
<li>
September 23, 2014, by Marco Bonvini:<br/>
Added function and documentation
</li>
</ul>
</html>", info="<html>
<p>
This function computes the overall capacity of a cable.
</p>
<p>
When the voltage level is low, the cables do not consider the capacitive effect. Hence,
</p>
<p align=\"center\" style=\"font-style:italic;\">
C = 0.
</p>
</html>"));
  end lineCapacitance;

  annotation (Documentation(info="<html>
<p>
This is a base record for specifying physical properties for low
voltage commercial cables. New cables can be added by extending the
it.
</p>
<p>
For low voltage cables, only the characteristic resistance and reactance are
specified.
</p>
</html>", revisions="<html>
<ul>
<li>
September 23, 2014, by Marco Bonvini:<br/>
Revised structure of the record, not it extends the base records
and add details for the low voltage cables.
</li>
<li>
Sept 19, 2014, by Marco Bonvini:<br/>
Added User's guide.
</li>
</ul>
</html>"));
end Generic;

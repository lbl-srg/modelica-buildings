within Buildings.HeatTransfer.Data;
package OpaqueSurfaces
  "Package with thermophysical properties for opaque surfaces"
    extends Modelica.Icons.MaterialPropertiesPackage;

  record Generic "Thermal properties of opaque surfaces"
      extends Modelica.Icons.Record;
    parameter Modelica.Units.SI.Area A "Area";
    parameter Modelica.Units.SI.Angle til
      "Surface tilt (0: ceiling, pi/2: wall, pi: floor";
    parameter Modelica.Units.SI.Emissivity absIR=0.84 "Infrared absorptivity";
    parameter Modelica.Units.SI.Emissivity absSol=0.84 "Solar absorptivity";
   final parameter Boolean is_floor=til > 2.74889125 and til < 3.53428875
      "Flag, true if construction is a floor" annotation (Evaluate=true);

   annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="datOpaSur",
      Documentation(info="<html>
<p>
This record implements thermophysical properties for opaque surfaces.
</p>
<p>
The parameter <code>absIR</code>
is used to compute infrared heat radiation (in the infrared spectrum).
The parameter <code>absSol</code>
is used to compute solar heat radiation (in the solar spectrum).
</p>
</html>",
  revisions="<html>
<ul>
<li>
February 11, 2022, by Michael Wetter:<br/>
Change parameter <code>isFloor</code> to <code>is_floor</code>,
and <code>isCeiling</code> to <code>is_ceiling</code>,
for consistency with naming convention.
</li>
<li>
November 16, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
  end Generic;

  record Black=Buildings.HeatTransfer.Data.OpaqueSurfaces.Generic (absIR=1.0,
        absSol=1.0) "Black surface with absIR=1.0, absSol=1.0"
    annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="datOpaSur");

  record Gray=Buildings.HeatTransfer.Data.OpaqueSurfaces.Generic (absIR=0.5,
        absSol=0.5) "Gray surface with absIR=0.5, absSol=0.5"
    annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="datOpaSur");

  record White=Buildings.HeatTransfer.Data.OpaqueSurfaces.Generic (absIR=0.0,
        absSol=0.0) "White surface with absIR=0.0, absSol=0.0"
    annotation (
      defaultComponentPrefixes="parameter",
      defaultComponentName="datOpaSur");

  annotation (
preferredView="info",
Documentation(info="<html>
<p>
Package with records for opaque surfaces.
</p>
<p>
The parameter <code>absIR</code>
is used to compute infrared heat radiation (in the infrared spectrum).
The parameter <code>absSol</code>
is used to compute solar heat radiation (in the solar spectrum).
</p>
</html>",
  revisions="<html>
<ul>
<li>
November 16, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end OpaqueSurfaces;

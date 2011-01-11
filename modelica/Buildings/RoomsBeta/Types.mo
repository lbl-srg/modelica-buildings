within Buildings.RoomsBeta;
package Types "Package with type definitions"

  package Tilt "Enumeration for surface tilt"
     constant Modelica.SIunits.Angle ceiling = 0 "Tilt for ceiling";
     constant Modelica.SIunits.Angle wall =    Modelica.Constants.pi/2
      "Tilt for wall";
     constant Modelica.SIunits.Angle floor =   Modelica.Constants.pi
      "Tilt for floor";
    annotation(preferedView="info", Documentation(info="<html>
<p>
 Enumeration to define the tilt of a surface for the room model.
  For example, for a construction that is a floor, use
 <code>Buildings.RoomsBeta.Types.Tilt.floor</code>.
</p>
</html>",
  revisions="<html>
<ul>
<li>
November 30 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  end Tilt;

  package Azimuth "Enumeration for surface azimuth"
     constant Modelica.SIunits.Angle S = 0
      "Azimuth for an exterior wall whose outer surface faces south";
     constant Modelica.SIunits.Angle E = -Modelica.Constants.pi/2
      "Azimuth for an exterior wall whose outer surface faces east";
     constant Modelica.SIunits.Angle N = Modelica.Constants.pi
      "Azimuth for an exterior wall whose outer surface faces north";
     constant Modelica.SIunits.Angle W = +Modelica.Constants.pi/2
      "Azimuth for an exterior wall whose outer surface faces west";
    annotation(preferedView="info",
    Documentation(info="<html>
<p>
 Enumeration to define the azimuth of a surface for the room model.
 For example, if an exterior wall is south oriented, use 
 <code>Buildings.RoomsBeta.Types.Azimuth.S</code>.
</p>
</html>",
  revisions="<html>
<ul>
<li>
November 30 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  end Azimuth;
annotation (preferedView="info", Documentation(info="<html>
This package contains type definitions.
</html>"));
end Types;

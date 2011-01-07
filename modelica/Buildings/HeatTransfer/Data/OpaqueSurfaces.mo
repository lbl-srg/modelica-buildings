within Buildings.HeatTransfer.Data;
package OpaqueSurfaces
  "Package with thermophysical properties for opaque surfaces"

  record Generic "Thermal properties of opaque surfaces"
      extends Modelica.Icons.Record;
   parameter Modelica.SIunits.Area A "Area";
   parameter Modelica.SIunits.Angle til
      "Surface tilt (0: ceiling, pi/2: wall, pi: floor";
   parameter Modelica.SIunits.Emissivity epsLW=0.84 "Long wave emissivity";
   parameter Modelica.SIunits.Emissivity epsSW=0.84 "Short wave emissivity";
   final parameter Boolean isFloor=til > 2.74889125 and til < 3.53428875
      "Flag, true if construction is a floor" annotation (Evaluate=true);

    annotation (Documentation(info="<html>
This record implements thermophysical properties for opaque surfaces.
</html>",
  revisions="<html>
<ul>
<li>
Nove. 16 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  end Generic;

  record Black=Buildings.HeatTransfer.Data.OpaqueSurfaces.Generic (epsLW=1.0,
        epsSW=1.0) "Black surface with epsLW=1.0, epsSW=1.0";

  record Gray=Buildings.HeatTransfer.Data.OpaqueSurfaces.Generic (epsLW=0.5,
        epsSW=0.5) "Gray surface with epsLW=0.5, epsSW=0.5";

  record White=Buildings.HeatTransfer.Data.OpaqueSurfaces.Generic (epsLW=0.0,
        epsSW=0.0) "White surface with epsLW=0.0, epsSW=0.0";

  annotation(preferedView="info",
            Documentation(info="<html>
This package implements thermophysical properties for window shades.
</html>"));
end OpaqueSurfaces;

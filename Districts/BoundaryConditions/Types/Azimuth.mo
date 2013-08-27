within Districts.BoundaryConditions.Types;
package Azimuth "Enumeration for surface azimuth"
   constant Modelica.SIunits.Angle S = 0 "Azimuth for a south-facing collector";
   constant Modelica.SIunits.Angle E = -Modelica.Constants.pi/2
    "Azimuth for an east-facing collector";
   constant Modelica.SIunits.Angle N = Modelica.Constants.pi
    "Azimuth for a north-facing collector";
   constant Modelica.SIunits.Angle W = +Modelica.Constants.pi/2
    "Azimuth for a west-facing collector";
  annotation(preferedView="info",
  Documentation(info="<html>
<p>
 Enumeration to define the azimuth of collectors.
</p>
 <p>
  This enumaration is consistent with
  <a href=\"modelica://Buildings.HeatTransfer.Types.Azimuth\">
  Buildings.HeatTransfer.Types.Azimuth</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 14, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Azimuth;

within Buildings.Types;
package Azimuth "List of possible constant values for surface azimuth"
   extends Modelica.Icons.TypesPackage;

   constant Modelica.SIunits.Angle S = 0
  "Azimuth for an exterior wall whose outer surface faces south";
   constant Modelica.SIunits.Angle SW = +Modelica.Constants.pi/4
  "Azimuth for an exterior wall whose outer surface faces south-west";
   constant Modelica.SIunits.Angle W = +Modelica.Constants.pi/2
  "Azimuth for an exterior wall whose outer surface faces west";
   constant Modelica.SIunits.Angle NW = +Modelica.Constants.pi*3/4
  "Azimuth for an exterior wall whose outer surface faces north-west";
   constant Modelica.SIunits.Angle N = Modelica.Constants.pi
  "Azimuth for an exterior wall whose outer surface faces north";
   constant Modelica.SIunits.Angle NE = -Modelica.Constants.pi*3/4
  "Azimuth for an exterior wall whose outer surface faces north-east";
   constant Modelica.SIunits.Angle E = -Modelica.Constants.pi/2
  "Azimuth for an exterior wall whose outer surface faces east";
   constant Modelica.SIunits.Angle SE = -Modelica.Constants.pi/4
  "Azimuth for an exterior wall whose outer surface faces south-east";

annotation(preferredView="info",
Documentation(info="<html>
<p>
Collection of constant values to define the azimuth of a surface.
For example, if an exterior wall is South oriented, i.e., its outside-facing
surface is towards South, use
<code>Buildings.Types.Azimuth.S</code>.
</p>
<p>
See also
<a href=\"modelica://Buildings.BoundaryConditions.UsersGuide\">
Buildings.BoundaryConditions.UsersGuide</a>
for explanations of the azimuth.
</p>
</html>",
revisions="<html>
<ul>
<li>
November 30 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Azimuth;

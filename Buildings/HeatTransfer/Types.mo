within Buildings.HeatTransfer;
package Types "Package with type definitions"

  type SurfaceRoughness = enumeration(
      VeryRough "Very rough",
      Rough "Rough",
      Medium "Medium rough",
      MediumSmooth "Medium smooth",
      Smooth "Smooth",
      VerySmooth "Very smooth") "Enumeration defining the surface roughness"
  annotation (Documentation(info="<html>
<p>
This enumeration is used to define the surface roughness
which may be used to compute the convective heat transfer coefficients of 
building construction.
</p>
<p>
The surface roughness will be used to compute the
wind-driven convective heat transfer coefficient in 
<a href=\"modelica://Buildings.HeatTransfer.Convection.Exterior\">
Buildings.HeatTransfer.Convection.Exterior</a>.
The possible surface roughness are
</p>

<table summary=\"summary\" border=\"1\">
<tr>
<th>Roughness index</th>
<th>Example material</th>
</tr>
<tr><td>VeryRough</td>     <td>Stucco</td></tr>
<tr><td>Rough</td>         <td>Brick</td></tr>
<tr><td>MediumRough</td>   <td>Concrete</td></tr>
<tr><td>MediumSmooth</td>  <td>Clear pine</td></tr>
<tr><td>Smooth</td>        <td>Smooth plaster</td></tr>
<tr><td>VerySmooth</td>    <td>Glass</td></tr>
</table>
</html>"));

  type ExteriorConvection = enumeration(
      Fixed "Fixed coefficient (a user-specified parameter is used)",
      TemperatureWind "Wind speed and temperature dependent")
    "Enumeration defining the convective heat transfer model for exterior surfaces"
  annotation (Documentation(info="<html>
<p>
This enumeration is used to set the function
that is used to compute the convective
heat transfer coefficient for exterior (outside-side facing) surfaces.
</p>
</html>"));

  type InteriorConvection = enumeration(
      Fixed "Fixed coefficient (a user-specified parameter is used)",
      Temperature "Temperature dependent")
    "Enumeration defining the convective heat transfer model for interior surfaces"
  annotation (Documentation(info="<html>
<p>
This enumeration is used to set the function
that is used to compute the convective
heat transfer coefficient for interior (room-side facing) surfaces.
</p>
</html>"));

  package Tilt "Enumeration for surface tilt"
    constant Modelica.SIunits.Angle Ceiling=0 "Tilt for ceiling";
    constant Modelica.SIunits.Angle Wall =    Modelica.Constants.pi/2
      "Tilt for wall";
    constant Modelica.SIunits.Angle Floor =   Modelica.Constants.pi
      "Tilt for floor";
    annotation(preferredView="info", Documentation(info="<html>
<p>
 Enumeration to define the tilt of a surface for the room model.
  For example, for a construction that is a floor, use
 <code>Buildings.HeatTransfer.Types.Tilt.Floor</code>.
</p>
<p>
Note that a ceiling has a tilt of <i>0</i>, and also the solar collector models
in 
<a href=\"Buildings.Fluid.SolarCollectors\">Buildings.Fluid.SolarCollectors</a>
require a tilt of <i>0</i> if they are facing straight upwards.
This is correct because
the solar irradiation on a ceiling construction is on the other-side surface,
which faces upwards toward the sky. Hence, a construction is considered
a ceiling from the view point of a person standing inside a room. 
</p>
</html>",
  revisions="<html>
<ul>
<li>
November 30, 2010, by Michael Wetter:<br/>
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
    annotation(preferredView="info",
    Documentation(info="<html>
<p>
 Enumeration to define the azimuth of a surface for the room model.
 For example, if an exterior wall is South oriented, i.e., its outside-facing
surface is towards South, use 
 <code>Buildings.HeatTransfer.Types.Azimuth.S</code>.
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
annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains type definitions.
</p>
</html>"));
end Types;

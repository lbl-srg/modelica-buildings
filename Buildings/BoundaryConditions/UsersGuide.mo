within Buildings.BoundaryConditions;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;
annotation (preferredView="info",
Documentation(info="<html>
<p>This package contains models to read or compute boundary conditions, such as weather data, solar irradition and sky temperatures.
The calculations follow the description in Wetter (2004), Appendix A.4.2.</p>
<p>To compute the solar irradiation, parameters such as the surface azimuth and the surface tilt are defined as shown in the following three figures. </p>
<p align=\"center\"><img alt=\"image\" src=\"modelica://Buildings/Resources/Images/BoundaryConditions/ear_ray.png\"/> </p>
<p align=\"center\"><img alt=\"image\" src=\"modelica://Buildings/Resources/Images/BoundaryConditions/zen_sun.png\"/> </p>
<p align=\"center\"><img alt=\"image\" src=\"modelica://Buildings/Resources/Images/BoundaryConditions/zen_pla.png\"/> </p>
<p>
For the surface azimuth and tilt, the enumerations 
<a href=\"modelica://Buildings.HeatTransfer.Types.Azimuth\">
Buildings.HeatTransfer.Types.Azimuth</a>
and
<a href=\"modelica://Buildings.HeatTransfer.Types.Tilt\">
Buildings.HeatTransfer.Types.Tilt</a>
can be used.
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

<h4>References</h4>
<ul>
<li>
Michael Wetter.<br/>
<a href=\"http://simulationresearch.lbl.gov/wetter/download/mwdiss.pdf\">
Simulation-based Building Energy Optimization</a>.<br/>
Dissertation. University of California at Berkeley. 2004.
</li>
</ul>
</html>"));
end UsersGuide;

within Buildings.BoundaryConditions.SolarGeometry.BaseClasses;
block AltitudeAngle "Solar altitude angle"
  extends Modelica.Blocks.Icons.Block;
  Modelica.Blocks.Interfaces.RealInput zen(quantity="Angle", unit="rad")
    "Zenith angle"
annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput alt(
    final quantity="Angle",
    final unit="rad",
    displayUnit="deg") "Solar altitude angle"
annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  alt = (Modelica.Constants.pi/2) - zen;
  annotation (Icon(graphics={Bitmap(extent={{-90,-90},{90,90}}, fileName=
              "modelica://Buildings/Resources/Images/BoundaryConditions/SolarGeometry/BaseClasses/AltitudeAngle.png")}),
    defaultComponentName="altAng", Documentation(info="<html>
<p>
This block computes the altitude angle of the sun with respect to a horizontal surface.
The altitude angle is the angle between the sun ray and the projection of the ray
on a horizontal surface.
It is the complementory angle to the zenith angle.
</p>
</html>", revisions="<html>
<ul>
<li>
January 5, 2015, by Michael Wetter:<br/>
Updated comment of the output connector as this is used in the weather bus connector.
This is for
issue <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/376\">376</a>.
</li>
<li>
Feb 01, 2012, by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>
</html>"));
end AltitudeAngle;

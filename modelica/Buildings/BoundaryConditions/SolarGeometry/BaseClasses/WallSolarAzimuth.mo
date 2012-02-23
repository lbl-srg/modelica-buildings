within Buildings.BoundaryConditions.SolarGeometry.BaseClasses;
block WallSolarAzimuth
  "Angle measured in a horizontal plane between the projection of the sun's rays and the normal to a vertical surface"
  extends Modelica.Blocks.Interfaces.BlockIcon;
public
  Modelica.Blocks.Interfaces.RealInput incAng(quantity="Angle",
                                              unit="rad",
                                              displayUnit="rad")
    "Solar incidence angle"
    annotation (Placement(transformation(extent={{-140,-68},{-100,-28}})));
Modelica.Blocks.Interfaces.RealInput alt(quantity="Angle",
                                         unit="rad",
                                         displayUnit="rad")
    "Solar altitude angle (angle between sun ray and horizontal surface)"
    annotation (Placement(transformation(extent={{-140,28},{-100,68}})));
Modelica.Blocks.Interfaces.RealOutput verAzi(
    final quantity="Angle",
    final unit="rad",
    displayUnit="deg")
    "Angle between projection of sun's rays and normal to vertical surface"
annotation (Placement(transformation(extent={{100,-10},{120,10}})));
protected
  constant Modelica.SIunits.Angle delta = 1*Modelica.Constants.pi/180
    "Small angle";
  constant Modelica.SIunits.Angle ninety= Modelica.Constants.pi/2-delta
    "+89 degree";
  Real alt_c "Cosine of altitude, bounded away from zero";
equation
  alt_c=Modelica.Math.cos(Buildings.Utilities.Math.Functions.smoothLimit(
        x=alt, l=-ninety, u=ninety, deltaX=delta));
  verAzi=Modelica.Math.acos(Modelica.Math.cos(incAng)/alt_c);

  annotation (Icon(graphics={Bitmap(extent={{-92,92},{92,-92}}, fileName=
              "modelica://Buildings/Resources/Images/BoundaryConditions/SolarGeometry/BaseClasses/WallSolarAzimuth.png")}),
defaultComponentName="wallSolAzi",
Documentation(info="<html>
<p>
This block computes the wall solar azimuth angle. 
It is the angle between the projection of the sun ray on a horizontal surface 
and the line perpendicular to the wall. The value of this angle varies from <i>0</i> to <i>180</i> degrees. 
In the northern hemisphere at solar noon, the value of the wall solar azimuth angle is zero if the wall is facing south.
</p>
</html>
", revisions="<html>
<ul>
<li>
February 23, 2012, by Michael Wetter:<br>
Guarded against division by zero because the altitude angle can be <i>90</i> degree
in the tropics, and hence its cosine can take on zero.
</li>
<li>
Feb 01, 2012, by Kaustubh Phalak<br>
First implementation.
</li>
</ul>
</html>"));
end WallSolarAzimuth;

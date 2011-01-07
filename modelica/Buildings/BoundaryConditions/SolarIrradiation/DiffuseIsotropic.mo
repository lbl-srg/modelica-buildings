within Buildings.BoundaryConditions.SolarIrradiation;
block DiffuseIsotropic
  "Diffuse solar irradiation on a tilted surface with an isotropic sky model"
  extends
    Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.PartialSolarIrradiation;
public
  parameter Real rho=0.2 "Ground reflectance";
protected
  Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.DiffuseIsotropic
    HDifTilIso(til=til, rho=rho)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation
  connect(weaBus.HGloHor, HDifTilIso.HGloHor) annotation (Line(
      points={{-100,5.55112e-16},{-51.5,5.55112e-16},{-51.5,4},{-12,4}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.HDifHor, HDifTilIso.HDifHor) annotation (Line(
      points={{-100,5.55112e-16},{-51.5,5.55112e-16},{-51.5,-4},{-12,-4}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));

  connect(HDifTilIso.HDifTil, H) annotation (Line(
      points={{11,6.10623e-16},{56.5,6.10623e-16},{56.5,5.55112e-16},{110,
          5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    defaultComponentName="HDifTilIso",
    Documentation(info="<HTML>
<p>
This component computes the hemispherical diffuse irradiation on a tilted surface by using an isotropic model. It is the summation of diffuse solar irradiation and radiation reflected by the ground.
For a definition of the parameters, see the 
<a href=\"modelica://Buildings.BoundaryConditions.UsersGuide\">User's Guide</a>.
</p>
<h4>References</h4>
P. Ineichen, R. Perez and R. Seals (1987).
<i>The Importance of Correct Albedo Determination for Adequately Modeling Energy Received by Tilted Surface</i>,
Solar Energy, 39(4): 301-305.
</HTML>
", revisions="<html>
<ul>
<li>
May 24, 2010, by Wangda Zuo:<br>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true,extent={{-100,-100},{100,
            100}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          lineColor={0,0,255})}));
end DiffuseIsotropic;

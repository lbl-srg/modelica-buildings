within Buildings.BoundaryConditions.SolarIrradiation;
block DiffuseIsotropic
  "Diffuse solar irradiation on a tilted surface with an isotropic sky model"
  extends
    Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.PartialSolarIrradiation;
  parameter Real rho(min=0, max=1, final unit="1")=0.2 "Ground reflectance";
  parameter Boolean outSkyCon=false
    "Output contribution of diffuse irradiation from sky";
  parameter Boolean outGroCon=false
    "Output contribution of diffuse irradiation from ground";

  Modelica.Blocks.Math.Add add "Block to add radiation"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Modelica.Blocks.Interfaces.RealOutput HSkyDifTil if outSkyCon
    "Diffuse solar irradiation on a tilted surface from the sky"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput HGroDifTil if outGroCon
    "Diffuse solar irradiation on a tilted surface from the ground"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
protected
  Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.DiffuseIsotropic
    HDifTilIso(til=til, rho=rho) "Diffuse isotropic irradiation on tilted surface"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));

equation
  connect(weaBus.HGloHor, HDifTilIso.HGloHor) annotation (Line(
      points={{-100,5.55112e-16},{-51.5,5.55112e-16},{-51.5,4},{-22,4}},
      color={255,204,51},
      thickness=0.5), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.HDifHor, HDifTilIso.HDifHor) annotation (Line(
      points={{-100,5.55112e-16},{-51.5,5.55112e-16},{-51.5,-4},{-22,-4}},
      color={255,204,51},
      thickness=0.5), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));

  connect(HDifTilIso.HSkyDifTil, add.u1) annotation (Line(
      points={{1,4},{24,4},{24,6},{38,6}},
      color={0,0,127}));
  connect(HDifTilIso.HGroDifTil, add.u2) annotation (Line(
      points={{1,-4},{24,-4},{24,-6},{38,-6}},
      color={0,0,127}));
  connect(add.y, H) annotation (Line(
      points={{61,6.10623e-16},{81.5,6.10623e-16},{81.5,5.55112e-16},{110,
          5.55112e-16}},
      color={0,0,127}));

  connect(HDifTilIso.HSkyDifTil, HSkyDifTil) annotation (Line(
      points={{1,4},{14,4},{14,60},{110,60}},
      color={0,0,127}));
  connect(HDifTilIso.HGroDifTil, HGroDifTil) annotation (Line(
      points={{1,-4},{14,-4},{14,-60},{110,-60}},
      color={0,0,127}));
  annotation (
    defaultComponentName="HDifTilIso",
    Documentation(info="<html>
<p>
This component computes the hemispherical diffuse irradiation
on a tilted surface using an isotropic model.
The irradiation is a sum composed of diffuse solar irradiation and
radiation reflected by the ground.
For a definition of the parameters, see the
<a href=\"modelica://Buildings.BoundaryConditions.UsersGuide\">User's Guide</a>.
</p>
<h4>References</h4>
P. Ineichen, R. Perez and R. Seals (1987).
<i>The Importance of Correct Albedo Determination for Adequately Modeling
Energy Received by Tilted Surface</i>,
Solar Energy, 39(4): 301-305.
</html>", revisions="<html>
<ul>
<li>
November 14, 2015, by Michael Wetter:<br/>
Added <code>min</code>, <code>max</code> and <code>unit</code>
attributes for <code>rho</code>.
</li>
<li>
June 6, 2012, by Wangda Zuo:<br/>
Added contributions from sky and ground that were separated in base class.
</li>
<li>
May 24, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          textColor={0,0,255})}));
end DiffuseIsotropic;

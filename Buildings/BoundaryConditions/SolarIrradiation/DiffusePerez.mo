within Buildings.BoundaryConditions.SolarIrradiation;
block DiffusePerez
  "Hemispherical diffuse irradiation on a tilted surface using Perez's anisotropic sky model"
  extends
    Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.PartialSolarIrradiation;

  parameter Real rho(min=0, max=1, final unit="1")=0.2 "Ground reflectance";
  parameter Modelica.SIunits.Angle lat "Latitude";
  parameter Modelica.SIunits.Angle azi "Surface azimuth";
  parameter Boolean outSkyCon=false
    "Output contribution of diffuse irradiation from sky";
  parameter Boolean outGroCon=false
    "Output contribution of diffuse irradiation from ground";

  Modelica.Blocks.Math.Add add "Block to add radiations"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Modelica.Blocks.Interfaces.RealOutput HSkyDifTil if outSkyCon
    "Hemispherical diffuse solar irradiation on a tilted surface from the sky"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput HGroDifTil if outGroCon
    "Hemispherical diffuse solar irradiation on a tilted surface from the ground"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));

protected
  BaseClasses.DiffusePerez HDifTil(
    final til=til,
    final rho=rho) "Diffuse irradiation on tilted surface"
    annotation (Placement(transformation(extent={{0,-21},{42,21}})));
  BaseClasses.SkyClearness skyCle "Sky clearness"
    annotation (Placement(transformation(extent={{-62,16},{-54,24}})));
  BaseClasses.BrighteningCoefficient briCoe "Brightening coefficient"
    annotation (Placement(transformation(extent={{-40,-34},{-32,-26}})));
  BaseClasses.RelativeAirMass relAirMas "Relative air mass"
    annotation (Placement(transformation(extent={{-80,-44},{-72,-36}})));
  BaseClasses.SkyBrightness skyBri "Sky brightness"
    annotation (Placement(transformation(extent={{-60,-54},{-52,-46}})));
  SolarGeometry.IncidenceAngle incAng(
    final lat=lat,
    final azi=azi,
    final til=til) "Incidence angle"
    annotation (Placement(transformation(extent={{-86,-96},{-76,-86}})));

equation
  connect(relAirMas.relAirMas, skyBri.relAirMas) annotation (Line(
      points={{-71.6,-40},{-66,-40},{-66,-48.4},{-60.8,-48.4}},
      color={0,0,127}));
  connect(skyBri.skyBri, briCoe.skyBri) annotation (Line(
      points={{-51.6,-50},{-46,-50},{-46,-30},{-40.8,-30}},
      color={0,0,127}));
  connect(skyCle.skyCle, briCoe.skyCle) annotation (Line(
      points={{-53.6,20},{-46,20},{-46,-27.6},{-40.8,-27.6}},
      color={0,0,127}));
  connect(incAng.y, HDifTil.incAng) annotation (Line(
      points={{-75.5,-91},{-16,-91},{-16,-16},{-4.2,-16},{-4.2,-14.7}},
      color={0,0,127}));
  connect(weaBus.solZen, skyCle.zen) annotation (Line(
      points={{-100,5.55112e-16},{-86,5.55112e-16},{-86,17.6},{-62.8,17.6}},
      color={0,0,127}));
  connect(weaBus.solZen, relAirMas.zen) annotation (Line(
      points={{-100,5.55112e-16},{-86,5.55112e-16},{-86,-40},{-80.8,-40}},
      color={0,0,127}));
  connect(weaBus.solZen, briCoe.zen) annotation (Line(
      points={{-100,5.55112e-16},{-86,5.55112e-16},{-86,-20},{-66,-20},{-66,-32},
          {-40.8,-32},{-40.8,-32.4}},
      color={0,0,127}));
  connect(weaBus.HGloHor, skyCle.HGloHor) annotation (Line(
      points={{-100,5.55112e-16},{-92,5.55112e-16},{-92,22.4},{-62.8,22.4}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.HDifHor, skyCle.HDifHor) annotation (Line(
      points={{-100,5.55112e-16},{-92,5.55112e-16},{-92,20},{-62.8,20}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.HDifHor, skyBri.HDifHor) annotation (Line(
      points={{-100,5.55112e-16},{-92,5.55112e-16},{-92,-51.6},{-60.8,-51.6}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.HGloHor, HDifTil.HGloHor) annotation (Line(
      points={{-100,5.55112e-16},{-70,0},{-38,0},{-38,16.8},{-4.2,16.8}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.HDifHor, HDifTil.HDifHor) annotation (Line(
      points={{-100,5.55112e-16},{-38,5.55112e-16},{-38,10},{-4.2,10},{-4.2,
          10.5}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));

  connect(briCoe.F2, HDifTil.briCof2) annotation (Line(
      points={{-31.6,-31.6},{-24,-31.6},{-24,-2.1},{-4.2,-2.1}},
      color={0,0,127}));
  connect(briCoe.F1, HDifTil.briCof1) annotation (Line(
      points={{-31.6,-28.4},{-28,-28.4},{-28,4.2},{-4.2,4.2}},
      color={0,0,127}));
  connect(weaBus, incAng.weaBus) annotation (Line(
      points={{-100,5.55112e-16},{-92,5.55112e-16},{-92,-90.8},{-86,-90.8}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.solZen, HDifTil.zen) annotation (Line(
      points={{-100,5.55112e-16},{-86,5.55112e-16},{-86,-58},{-20,-58},{-20,
          -8.4},{-4.2,-8.4}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(HDifTil.HSkyDifTil, add.u1) annotation (Line(
      points={{44.1,8.4},{52,8.4},{52,6},{58,6}},
      color={0,0,127}));
  connect(HDifTil.HGroDifTil, add.u2) annotation (Line(
      points={{44.1,-8.4},{52,-8.4},{52,-6},{58,-6}},
      color={0,0,127}));
  connect(add.y, H) annotation (Line(
      points={{81,6.10623e-16},{90.5,6.10623e-16},{90.5,5.55112e-16},{110,
          5.55112e-16}},
      color={0,0,127}));

  connect(HDifTil.HSkyDifTil, HSkyDifTil) annotation (Line(
      points={{44.1,8.4},{52,8.4},{52,60},{110,60}},
      color={0,0,127}));
  connect(HDifTil.HGroDifTil, HGroDifTil) annotation (Line(
      points={{44.1,-8.4},{52,-8.4},{52,-60},{110,-60}},
      color={0,0,127}));
  annotation (
    defaultComponentName="HDifTil",
    Documentation(info="<html>
<p>
This component computes the hemispherical diffuse irradiation on a tilted surface using an anisotropic
sky model proposed by Perez.
For a definition of the parameters, see the
<a href=\"modelica://Buildings.BoundaryConditions.UsersGuide\">User's Guide</a>.
</p>
<h4>References</h4>
<ul>
<li>
P. Ineichen, R. Perez and R. Seals (1987).
<i>The Importance of Correct Albedo Determination for Adequately Modeling Energy Received by Tilted Surface</i>,
Solar Energy, 39(4): 301-305.
</li>
<li>
R. Perez, R. Seals, P. Ineichen, R. Stewart and D. Menicucci (1987).
<i>A New Simplified Version of the Perez Diffuse Irradiance Model for Tilted Surface</i>,
Solar Energy, 39(3): 221-231.
</li>
<li>
R. Perez, P. Ineichen, R. Seals, J. Michalsky and R. Stewart (1990).
<i>Modeling Dyalight Availability and Irradiance Componets From Direct and Global Irradiance</i>,
Solar Energy, 44(5):271-289.
</li>
</ul>
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
February 25, 2012, by Michael Wetter:<br/>
Changed component to get zenith angle from weather bus.
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
          lineColor={0,0,255})}));
end DiffusePerez;

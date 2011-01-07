within Buildings.BoundaryConditions.SolarIrradiation;
block DiffusePerez
  "Hemispherical diffuse irradiation on a tilted surface using Perez's anisotropic sky model"
  extends
    Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.PartialSolarIrradiation;

  parameter Real rho=0.2 "Ground reflectance";
  parameter Modelica.SIunits.Angle lat "Latitude";
  parameter Modelica.SIunits.Angle azi "Surface azimuth";

protected
  BaseClasses.DiffusePerez HDifTil(final til=til, final rho=
          rho) annotation (Placement(transformation(extent={{46,-21},{88,21}})));
  BaseClasses.SkyClearness skyCle
    annotation (Placement(transformation(extent={{-52,16},{-44,24}})));
  BaseClasses.BrighteningCoefficient briCoe
    annotation (Placement(transformation(extent={{2,-34},{10,-26}})));
  BaseClasses.RelativeAirMass relAirMas
    annotation (Placement(transformation(extent={{-52,-48},{-44,-40}})));
  BaseClasses.SkyBrightness skyBri
    annotation (Placement(transformation(extent={{-30,-56},{-22,-48}})));
  SolarGeometry.IncidenceAngle incAng(
    lat=lat,
    azi=azi,
    til=til)
    annotation (Placement(transformation(extent={{-90,-96},{-80,-86}})));
  SolarGeometry.ZenithAngle zen(lat=lat)
    annotation (Placement(transformation(extent={{-88,-48},{-80,-40}})));
equation
  connect(relAirMas.relAirMas, skyBri.relAirMas) annotation (Line(
      points={{-43.6,-44},{-34,-44},{-34,-50.4},{-30.8,-50.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(skyBri.skyBri, briCoe.skyBri) annotation (Line(
      points={{-21.6,-52},{-16,-52},{-16,-30},{1.2,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(skyCle.skyCle, briCoe.skyCle) annotation (Line(
      points={{-43.6,20},{-10,20},{-10,-27.6},{1.2,-27.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(incAng.y, HDifTil.incAng) annotation (Line(
      points={{-79.5,-91},{34,-91},{34,-14},{41.8,-14},{41.8,-14.7}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zen.y, skyCle.zen) annotation (Line(
      points={{-79.6,-44},{-70,-44},{-70,17.6},{-52.8,17.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zen.y, relAirMas.zen) annotation (Line(
      points={{-79.6,-44},{-52.8,-44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zen.y, briCoe.zen) annotation (Line(
      points={{-79.6,-44},{-70,-44},{-70,-64},{-10,-64},{-10,-34},{1.2,-34},{
          1.2,-32.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDifTil.zen, zen.y) annotation (Line(
      points={{41.8,-8.4},{26,-8.4},{26,-80},{-70,-80},{-70,-44},{-79.6,-44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaBus.HGloHor, skyCle.HGloHor) annotation (Line(
      points={{-100,5.55112e-16},{-70,5.55112e-16},{-70,22.4},{-52.8,22.4}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.HDifHor, skyCle.HDifHor) annotation (Line(
      points={{-100,5.55112e-16},{-82,5.55112e-16},{-82,20},{-52.8,20}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.HDifHor, skyBri.HDifHor) annotation (Line(
      points={{-100,5.55112e-16},{-36,5.55112e-16},{-36,-53.6},{-30.8,-53.6}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.HGloHor, HDifTil.HGloHor) annotation (Line(
      points={{-100,5.55112e-16},{20,5.55112e-16},{20,16.8},{41.8,16.8}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.HDifHor, HDifTil.HDifHor) annotation (Line(
      points={{-100,5.55112e-16},{2,5.55112e-16},{2,10.5},{41.8,10.5}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(briCoe.F2, HDifTil.briCof2) annotation (Line(
      points={{10.4,-31.6},{22,-31.6},{22,-2.1},{41.8,-2.1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(briCoe.F1, HDifTil.briCof1) annotation (Line(
      points={{10.4,-28.4},{16,-28.4},{16,4.2},{41.8,4.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaBus.cloTim, incAng.cloTim) annotation (Line(
      points={{-100,5.55112e-16},{-92,5.55112e-16},{-92,-91},{-90.9,-91}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.cloTim, zen.cloTim) annotation (Line(
      points={{-100,5.55112e-16},{-92,5.55112e-16},{-92,-44},{-88.8,-44}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(HDifTil.HDifTil, H) annotation (Line(
      points={{90.1,-6.60583e-16},{96.05,-6.60583e-16},{96.05,4.44089e-16},{110,
          4.44089e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    defaultComponentName="HDifTil",
    Documentation(info="<HTML>
<p>
This component computes the hemispherical diffuse irradiation on a tilted surface by using an anisotropic model proposed by Perez. 
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
          lineColor={0,0,255})}),
    DymolaStoredErrors);
end DiffusePerez;

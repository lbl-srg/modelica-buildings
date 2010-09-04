within Buildings.BoundaryConditions.SolarIrradiation;
block DirectSolarIrradiationTiltedSurface
  "Direct solar irradiation on a tilted surface"
  import Buildings;
  extends Modelica.Blocks.Interfaces.BlockIcon;
public
  parameter Modelica.SIunits.Angle lat "Latitude";
  parameter Modelica.SIunits.Angle aziAng "Surface azimuth";
  parameter Modelica.SIunits.Angle tilAng "Surface tilt";
  Modelica.Blocks.Interfaces.RealOutput y(final quantity=
        "RadiantEnergyFluenceRate", final unit="W/m2")
    "Direct solar irradiation on a tilted surfce"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.BoundaryConditions.WeatherData.WeatherBus weaBus annotation (Placement(
        transformation(extent={{-110,-10},{-90,10}})));

protected
  SolarGeometry.ZenithAngle zenAng(final lat=lat)
    annotation (Placement(transformation(extent={{-48,-60},{-28,-40}})));
  SolarGeometry.IncidenceAngle incAng(
    final aziAng=aziAng,
    final tilAng=tilAng,
    final lat=lat)
    annotation (Placement(transformation(extent={{-50,-30},{-30,-10}})));
  Buildings.BoundaryConditions.SolarIrradiation.BaseClasses.DirectSolarIrradiationTiltedSurface
    HDirTil annotation (Placement(transformation(extent={{0,-20},{40,20}})));

equation
  connect(HDirTil.HDirTil, y) annotation (Line(
      points={{42,1.22125e-15},{66,1.22125e-15},{66,5.55112e-16},{110,
          5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(y, y) annotation (Line(
      points={{110,5.55112e-16},{110,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(incAng.y, HDirTil.incAng) annotation (Line(
      points={{-29,-20},{-12,-20},{-12,-4},{-4,-4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zenAng.y, HDirTil.zenAng) annotation (Line(
      points={{-27,-50},{-10,-50},{-10,-12},{-4,-12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaBus.HDifHor, HDirTil.HDifHor) annotation (Line(
      points={{-100,5.55112e-16},{-54,5.55112e-16},{-54,4},{-4,4}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.HGloHor, HDirTil.HGloHor) annotation (Line(
      points={{-100,5.55112e-16},{-54,5.55112e-16},{-54,12},{-4,12}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));

  connect(weaBus.cloTim, incAng.cloTim) annotation (Line(
      points={{-100,5.55112e-16},{-80,5.55112e-16},{-80,-20},{-51.8,-20}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.cloTim, zenAng.cloTim) annotation (Line(
      points={{-100,5.55112e-16},{-80,5.55112e-16},{-80,-50},{-50,-50}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  annotation (
    defaultComponentName="HDirTil",
    Documentation(info="<HTML>
<p>
This component computes the direct solar irradiation on a tilted surface by using the weather data as input.
For a definition of the parameters, see the 
<a href=\"modelica://Buildings.BoundaryConditions.UsersGuide\">User's Guide</a>.
</p>
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
end DirectSolarIrradiationTiltedSurface;

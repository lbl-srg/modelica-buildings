within Buildings.BoundaryConditions.SolarGeometry;
block ZenithAngle "Zenith angle"
  extends Modelica.Blocks.Interfaces.BlockIcon;
public
  parameter Modelica.SIunits.Angle lat "Latitude";
  Modelica.Blocks.Interfaces.RealOutput y(
    final quantity="Angle",
    final unit="rad",
    displayUnit="deg") "Zenith angle"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
protected
   Buildings.BoundaryConditions.SolarGeometry.BaseClasses.ZenithAngle zen(final lat=lat)
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
   Buildings.BoundaryConditions.SolarGeometry.BaseClasses.Declination decAng
    "Declination angle"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));
   Buildings.BoundaryConditions.SolarGeometry.BaseClasses.SolarHourAngle
    solHouAng
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
public
  WeatherData.Bus weaBus
    annotation (Placement(transformation(extent={{-112,-10},{-92,10}})));
equation
  connect(decAng.decAng, zen.decAng) annotation (Line(
      points={{1,40},{50,40},{50,5.4},{58,5.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solHouAng.solHouAng, zen.solHouAng) annotation (Line(
      points={{1,-40},{50,-40},{50,-4.8},{58,-4.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zen.zen, y) annotation (Line(
      points={{81,6.10623e-16},{88.25,6.10623e-16},{88.25,1.16573e-15},{95.5,
          1.16573e-15},{95.5,5.55112e-16},{110,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    defaultComponentName="zen",
    Documentation(info="<HTML>
<p>
This component computes the zenith angle, which is the angle between the earth surface normal and the sun's beam.
For a definition of the parameters, see the 
<a href=\"modelica://Buildings.BoundaryConditions.UsersGuide\">User's Guide</a>.
</p>
</HTML>
", revisions="<html>
<ul>
<li>
May 17, 2010, by Wangda Zuo:<br>
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
  connect(weaBus.cloTim, decAng.nDay) annotation (Line(
      points={{-102,5.55112e-16},{-60,5.55112e-16},{-60,40},{-22,40}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.solTim, solHouAng.solTim) annotation (Line(
      points={{-102,5.55112e-16},{-60,5.55112e-16},{-60,-40},{-22,-40}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
end ZenithAngle;

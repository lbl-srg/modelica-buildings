within Buildings.BoundaryConditions.SolarGeometry;
block ZenithAngle "Zenith angle"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.SIunits.Angle lat "Latitude";
  Modelica.Blocks.Interfaces.RealOutput y(
    final quantity="Angle",
    final unit="rad",
    displayUnit="deg") "Zenith angle"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  WeatherData.Bus weaBus "Weather data"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
protected
   Buildings.BoundaryConditions.SolarGeometry.BaseClasses.ZenithAngle zen(final lat=lat)
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
equation
  connect(zen.zen, y) annotation (Line(
      points={{21,0},{88.25,0},{88.25,0},{95.5,
          0},{95.5,0},{110,0}},
      color={0,0,127}));
  connect(weaBus.solDec, zen.decAng) annotation (Line(
      points={{-100,0},{-40,0},{-40,5.4},{-2,5.4}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus.solHouAng, zen.solHouAng) annotation (Line(
      points={{-100,0},{-40,0},{-40,-4.8},{-2,-4.8}},
      color={255,204,51},
      thickness=0.5));
  annotation (
    defaultComponentName="zen",
    Documentation(info="<html>
<p>
This component computes the zenith angle,
which is the angle between the earth surface normal and the sun beam.
For a definition of the parameters, see the User's Guide
<a href=\"modelica://Buildings.BoundaryConditions.UsersGuide\">
Buildings.BoundaryConditions.UsersGuide</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 25, 2012, by Michael Wetter:<br/>
Changed model to get declination angle and
solar hour angle from weather bus.
</li>
<li>
May 17, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          lineColor={0,0,255}), Bitmap(extent={{-90,-90},{90,90}}, fileName=
              "modelica://Buildings/Resources/Images/BoundaryConditions/SolarGeometry/BaseClasses/ZenithAngle.png")}));
end ZenithAngle;

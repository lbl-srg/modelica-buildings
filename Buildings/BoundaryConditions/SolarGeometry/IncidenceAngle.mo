within Buildings.BoundaryConditions.SolarGeometry;
block IncidenceAngle "Solar incidence angle on a tilted surface"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.Units.SI.Angle azi "Surface azimuth";
  parameter Modelica.Units.SI.Angle til "Surface tilt";

  Modelica.Blocks.Interfaces.RealOutput y(
    final quantity="Angle",
    final unit="rad",
    displayUnit="deg") "Incidence angle" annotation (Placement(transformation(
          extent={{100,-10},{120,10}}), iconTransformation(extent={{100,-10},{
            120,10}})));
  WeatherData.Bus weaBus "Weather data"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
protected
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.Declination decAng
    "Declination angle"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.SolarHourAngle
    solHouAng "Solar hour angle"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.IncidenceAngle incAng(
    final azi=azi,
    final til=til) "Incidence angle"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
equation
  connect(incAng.incAng, y) annotation (Line(
      points={{61,0},{88.25,0},{88.25,1.16573e-015},{95.5,1.16573e-015},{95.5,0},
          {110,0}},
      color={0,0,127}));
  connect(decAng.decAng, incAng.decAng) annotation (Line(
      points={{-19,40},{20,40},{20,5.4},{37.8,5.4}},
      color={0,0,127}));
  connect(solHouAng.solHouAng, incAng.solHouAng) annotation (Line(
      points={{-19,-40},{20,-40},{20,-4.8},{38,-4.8}},
      color={0,0,127}));
  connect(weaBus.cloTim, decAng.nDay) annotation (Line(
      points={{-100,0},{-80,0},{-80,40},{-42,40}},
      color={255,204,51},
      thickness=0.5), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.solTim, solHouAng.solTim) annotation (Line(
      points={{-100,0},{-80,0},{-80,-40},{-42,-40}},
      color={255,204,51},
      thickness=0.5), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.lat, incAng.lat) annotation (Line(
      points={{-100,0},{38,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (
    defaultComponentName="incAng",
    Documentation(info="<html>
<p>
This component computes the solar incidence angle on a tilted surface.
For a definition of the parameters, see the User's Guide
<a href=\"modelica://Buildings.BoundaryConditions.UsersGuide\">Buildings.BoundaryConditions.UsersGuide</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 6, 2021, by Ettore Zanetti:<br/>
Changed <code>lat</code> from being a parameter to an input from weather bus.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1477\">IBPSA, #1477</a>.
</li>
<li>
November 30, 2011, by Michael Wetter:<br/>
Removed <code>connect(y, y)</code> statement.
</li>
<li>
February 28, 2011, by Wangda Zuo:<br/>
Use local civil time instead of clock time.
</li>
<li>
May 19, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          textColor={0,0,255}), Bitmap(extent={{-90,-90},{90,90}}, fileName=
              "modelica://Buildings/Resources/Images/BoundaryConditions/SolarGeometry/BaseClasses/IncidenceAngle.png")}));
end IncidenceAngle;

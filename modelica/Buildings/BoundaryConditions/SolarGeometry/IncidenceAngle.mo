within Buildings.BoundaryConditions.SolarGeometry;
block IncidenceAngle "Solar incidence angle on a tilted surface"
  extends Modelica.Blocks.Interfaces.BlockIcon;
public
  parameter Modelica.SIunits.Angle lat "Latitude";
  parameter Modelica.SIunits.Angle azi "Surface azimuth";
  parameter Modelica.SIunits.Angle til "Surface tilt";

  Modelica.Blocks.Interfaces.RealOutput y(
    final quantity="Angle",
    final unit="rad",
    displayUnit="deg") "Incidence angle" annotation (Placement(transformation(
          extent={{100,-10},{120,10}}), iconTransformation(extent={{100,-10},{
            120,10}})));
protected
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.Declination decAng
    "Declination angle"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.SolarHourAngle
    solHouAng "Solar hour angle"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.IncidenceAngle incAng(
    final lat=lat,
    final azi=azi,
    final til=til) "Incidence angle"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
public
  WeatherData.Bus weaBus
    annotation (Placement(transformation(extent={{-110,-6},{-90,14}})));
equation
  connect(incAng.incAng, y) annotation (Line(
      points={{61,6.10623e-16},{88.25,6.10623e-16},{88.25,1.16573e-15},{95.5,
          1.16573e-15},{95.5,5.55112e-16},{110,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(y, y) annotation (Line(
      points={{110,5.55112e-16},{110,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(decAng.decAng, incAng.decAng) annotation (Line(
      points={{-19,40},{20,40},{20,5.4},{37.8,5.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solHouAng.solHouAng, incAng.solHouAng) annotation (Line(
      points={{-19,-40},{20,-40},{20,-4.8},{38,-4.8}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    defaultComponentName="incAng",
    Documentation(info="<HTML>
<p>
This component computes the incidence angle of direct solar radiation on a tilted surface.
For a definition of the parameters, see the 
<a href=\"modelica://Buildings.BoundaryConditions.UsersGuide\">User's Guide</a>.
</p>
</HTML>
", revisions="<html>
<ul>
<li>
February 28, 2011, by Wangda Zuo:<br>
Use local civil time instead of clock time.
</li>
<li>
May 19, 2010, by Wangda Zuo:<br>
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
      points={{-100,4},{-80,4},{-80,40},{-42,40}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.solTim, solHouAng.solTim) annotation (Line(
      points={{-100,4},{-80,4},{-80,-40},{-42,-40}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
end IncidenceAngle;

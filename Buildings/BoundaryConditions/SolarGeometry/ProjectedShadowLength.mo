within Buildings.BoundaryConditions.SolarGeometry;
block ProjectedShadowLength "Length of shadow projected onto a direction"
  extends Modelica.Blocks.Icons.Block;

  parameter String filNam=""
    "Name of weather data file (used to read longitude, latitude and time zone)"
    annotation (Dialog(
        loadSelector(filter="Weather files (*.mos)",
        caption="Select weather file"),
        group="Location"));

  parameter Modelica.SIunits.Angle lon(displayUnit="deg")=
    Buildings.BoundaryConditions.WeatherData.BaseClasses.getLongitudeTMY3(
    absFilNam) "Longitude" annotation (Evaluate=true, Dialog(group="Location"));
  parameter Modelica.SIunits.Angle lat(displayUnit="deg")=
    Buildings.BoundaryConditions.WeatherData.BaseClasses.getLatitudeTMY3(
    absFilNam) "Latitude" annotation (Evaluate=true, Dialog(group="Location"));
  parameter Modelica.SIunits.Time timZon(displayUnit="h")=
    Buildings.BoundaryConditions.WeatherData.BaseClasses.getTimeZoneTMY3(absFilNam)
    "Time zone" annotation (Evaluate=true, Dialog(group="Location"));

  parameter Modelica.SIunits.Length h "Height of surface";
  parameter Modelica.SIunits.Angle azi "Surface azimuth";

  Modelica.Blocks.Interfaces.RealOutput y(
    final quantity="Length",
    final unit="m") "Projected shadow length"
    annotation (Placement(transformation(extent={{180,-10},{200,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));

protected
  final parameter String absFilNam = Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath(filNam)
    "Absolute path of the file";

  WeatherData.BaseClasses.LocalCivilTime locTim(
      final lon=lon, final timZon=timZon) "Local civil time"
    annotation (Placement(transformation(extent={{-20,90},{0,110}})));
  WeatherData.BaseClasses.EquationOfTime eqnTim "Equation of time"
    annotation (Placement(transformation(extent={{-20,130},{0,150}})));
  WeatherData.BaseClasses.SolarTime solTim "Solar time"
    annotation (Placement(transformation(extent={{20,110},{40,130}})));
  Utilities.Time.ModelTime modTim "Model time"
    annotation (Placement(transformation(extent={{-160,-10},{-140,10}})));
   BaseClasses.Declination decAng "Declination angle"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));

  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.ZenithAngle zen(
    final lat=lat) "Solar zenith angle"
    annotation (Placement(transformation(extent={{-70,-90},{-50,-70}})));
  Modelica.Blocks.Math.Tan tan "Tangent of solar zenith angle"
    annotation (Placement(transformation(extent={{-30,-90},{-10,-70}})));
  Modelica.Blocks.Math.Gain shaLen(k=-h) "Length of shadow"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  BaseClasses.SolarAzimuth solAzi(
    final lat=lat) "Solar azimuth"
    annotation (Placement(transformation(extent={{-30,-60},{-10,-40}})));
  Modelica.Blocks.Sources.Constant surAzi(final k=azi) "Surface azimuth"
    annotation (Placement(transformation(extent={{-30,-20},{-10,0}})));
  Modelica.Blocks.Math.Add add(
    final k1=1,
    final k2=-1) "Angle between surface azimuth and solar azimuth"
    annotation (Placement(transformation(extent={{10,-40},{30,-20}})));
  Modelica.Blocks.Math.Cos cos "Cosine"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Modelica.Blocks.Math.Product proShaLen "Projected shadow length"
    annotation (Placement(transformation(extent={{70,-90},{90,-70}})));

  BaseClasses.SolarHourAngle solHouAng "Solar hour angle"
    annotation (Placement(transformation(extent={{60,110},{80,130}})));

  Modelica.Blocks.Sources.RealExpression pShaLen(
    y=noEvent(if abs(zen.zen) < 0.5*Modelica.Constants.pi then proShaLen.y else 0.0))
    "Projected shadow length"
    annotation (Placement(transformation(extent={{102,-10},{122,10}})));
equation
  connect(tan.u, zen.zen)
    annotation (Line(points={{-32,-80},{-32,-80},{-49,-80}},
                     color={0,0,127}));
  connect(tan.y, shaLen.u)
    annotation (Line(points={{-9,-80},{-9,-80},{-2,-80}},
                     color={0,0,127}));
  connect(solAzi.zen, zen.zen) annotation (Line(points={{-32,-44},{-40,-44},{-40,
          -80},{-49,-80}},
                    color={0,0,127}));
  connect(add.u1, surAzi.y)
    annotation (Line(points={{8,-24},{0,-24},{0,-10},{-9,-10}},
                     color={0,0,127}));
  connect(solAzi.solAzi, add.u2)
    annotation (Line(points={{-9,-50},{0,-50},{0,-36},{8,-36}},
                     color={0,0,127}));
  connect(add.y, cos.u)
    annotation (Line(points={{31,-30},{38,-30}},
                     color={0,0,127}));
  connect(shaLen.y, proShaLen.u2)
    annotation (Line(points={{21,-80},{40,-80},{40,-86},{68,-86}},
                     color={0,0,127}));
  connect(proShaLen.u1, cos.y)
    annotation (Line(points={{68,-74},{64,-74},{64,-60},{64,-60},{64,-30},{61,-30}},
                     color={0,0,127}));
  connect(solHouAng.solHouAng, zen.solHouAng) annotation (Line(points={{81,120},
          {100,120},{100,80},{-80,80},{-80,-84},{-72,-84},{-72,-84.8}},
                     color={0,0,127}));
  connect(modTim.y,locTim. cloTim) annotation (Line(
      points={{-139,0},{-50,0},{-50,100},{-22,100}},
      color={0,0,127}));
  connect(modTim.y,eqnTim. nDay) annotation (Line(
      points={{-139,0},{-128,0},{-128,140},{-22,140}},
      color={0,0,127}));
  connect(eqnTim.eqnTim, solTim.equTim) annotation (Line(points={{1,140},{12,140},
          {12,126},{18,126}}, color={0,0,127}));
  connect(locTim.locTim, solTim.locTim) annotation (Line(points={{1,100},{12,100},
          {12,114.6},{18,114.6}}, color={0,0,127}));
  connect(solHouAng.solTim, solTim.solTim)
    annotation (Line(points={{58,120},{56,120},{41,120}}, color={0,0,127}));
  connect(decAng.nDay, modTim.y) annotation (Line(points={{-122,-50},{-128,-50},
          {-128,60},{-128,0},{-139,0}},
                                      color={0,0,127}));
  connect(zen.decAng, decAng.decAng) annotation (Line(points={{-72,-74.6},{-88,-74.6},
          {-88,-50},{-99,-50}},
                              color={0,0,127}));
  connect(solAzi.decAng, decAng.decAng) annotation (Line(points={{-32,-50},{-88,
          -50},{-99,-50}},         color={0,0,127}));
  connect(solAzi.solTim, solTim.solTim) annotation (Line(points={{-32,-56},{-42,
          -56},{-74,-56},{-74,72},{48,72},{48,120},{41,120}}, color={0,0,127}));
  connect(pShaLen.y, y)
    annotation (Line(points={{123,0},{190,0}}, color={0,0,127}));
  annotation (
    defaultComponentName="proShaLen",
    Documentation(info="<html>
<p>
This component computes the length of a shadow projected onto a horizontal plane
into the direction that is perpendicular to the surface azimuth <code>azi</code>.
</p>
<p>
The parameter <code>azi</code> is the azimuth of the surface that is perpendicular
to the direction of the view. For example, if
<code>azi=Buildings.Types.Azimuth.S</code>,
then one is looking towards South. Hence, in the Northern hemisphere, at
noon, the length of the shadow is <em>negative</em> as one is looking
towards South but the shadow is in ones back.
Similarly, for
<code>azi=Buildings.Types.Azimuth.E</code>, there is a shade of negative length
in the morning, and of positive length in the afternoon.
The example
<a href=\"modelica://Buildings.BoundaryConditions.SolarGeometry.Examples.ProjectedShadowLength\">
Buildings.BoundaryConditions.SolarGeometry.Examples.ProjectedShadowLength</a>
illustrates this.
</p>
<p>
For a definition of the parameters, see the User's Guide
<a href=\"modelica://Buildings.BoundaryConditions.UsersGuide\">
Buildings.BoundaryConditions.UsersGuide</a>.
The surface azimuth is defined in
<a href=\"modelica://Buildings.Types.Azimuth\">
Buildings.Types.Azimuth</a>.
</p>
<p>
The component requires as parameters the longitude, latitude and time zone.
These can automatically be assigned by setting the parameter <code>filNam</code>
to a weather data file, in which case these values are read from the weather data file.
</p>
</html>", revisions="<html>
<ul>
<li>
January 20, 2016, by Thierry S. Nouidui:<br/>
Refactored the model and added a <code>realExpression</code> with <code>noEvent()</code>
to avoid spikes in the trajectory.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/626\">Buildings, #626</a>.
</li>
<li>
April 21, 2016, by Michael Wetter:<br/>
Introduced <code>absFilNam</code> to avoid multiple calls to
<a href=\"modelica://Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath\">
Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath</a>.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/506\">Buildings, #506</a>.
</li>
<li>
March 19, 2016, by Michael Wetter:<br/>
Set <code>Evaluate=true</code> for parameters <code>lon</code>,
<code>lat</code> and <code>timZon</code>.
This is required for OpenModelica to avoid a compilation error in
<code>Buildings.BoundaryConditions.SolarGeometry.Examples.ProjectedShadowLength</code>.
</li>
<li>
November 14, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={240,240,240}),
                              Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          lineColor={0,0,255}),
        Polygon(
          points={{-50,-34},{38,6},{36,66},{-52,36},{-50,-34}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,0,0}),
        Polygon(
          points={{-50,-34},{38,6},{76,-4},{-4,-46},{-50,-34}},
          lineColor={175,175,175},
          fillPattern=FillPattern.Sphere,
          fillColor={175,175,175}),
        Line(points={{-90,100},{-4,-44}}, color={255,255,0}),
        Line(points={{-74,100},{8,-40}}, color={255,255,0}),
        Line(points={{-60,100},{20,-34}}, color={255,255,0}),
        Line(points={{-44,100},{32,-28}}, color={255,255,0}),
        Line(points={{-30,100},{44,-22}}, color={255,255,0}),
        Line(points={{-14,100},{54,-16}}, color={255,255,0}),
        Line(points={{2,100},{66,-10}}, color={255,255,0}),
        Line(points={{16,100},{76,-4}}, color={255,255,0})}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-180,-160},{180,
            160}})));
end ProjectedShadowLength;

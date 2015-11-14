within Buildings.BoundaryConditions.SolarGeometry;
block ProjectedShadowLength "Lenght of shadow projected onto a direction"
  // fixme: the icon needs to be updated
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.SIunits.Angle lat "Latitude";
  parameter Modelica.SIunits.Length h "Height of object";
  parameter Modelica.SIunits.Angle azi "Surface azimuth";

  Modelica.Blocks.Interfaces.RealInput decAng(quantity="Angle", unit="rad")
    "Declination angle"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput solTim(quantity="Time", unit="s")
    "Solar time" annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
                    iconTransformation(extent={{-140,-60},{-100,-20}})));

  Modelica.Blocks.Interfaces.RealOutput y(
    final quantity="Length",
    final unit="m") "Projected shadow length"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  Buildings.BoundaryConditions.SolarGeometry.BaseClasses.ZenithAngle zen(
    final lat=lat) "Solar zenith angle"
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  Modelica.Blocks.Math.Tan tan "Tangent of solar zenith angle"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Modelica.Blocks.Math.Gain shaLen(k=-h) "Length of shadow"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  BaseClasses.SolarAzimuth solAzi(
    final lat=lat) "Solar azimuth"
    annotation (Placement(transformation(extent={{-30,20},{-10,40}})));
  Modelica.Blocks.Sources.Constant surAzi(final k=azi) "Surface azimuth"
    annotation (Placement(transformation(extent={{-30,60},{-10,80}})));
  Modelica.Blocks.Math.Add add(
    final k1=1,
    final k2=-1) "Angle between surface azimuth and solar azimuth"
    annotation (Placement(transformation(extent={{10,40},{30,60}})));
  Modelica.Blocks.Math.Cos cos "Cosine"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Modelica.Blocks.Math.Product proShaLen "Projected shadow length"
    annotation (Placement(transformation(extent={{32,-10},{52,10}})));

  BaseClasses.SolarHourAngle solHouAng "Solar hour angle"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));

  Modelica.Blocks.Logical.LessThreshold lessThreshold(
    final threshold=0.5*Modelica.Constants.pi)
    "Output zero if sun is below horizon"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Modelica.Blocks.Logical.Switch switch1 "Switch to select the output signal"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
protected
  Modelica.Blocks.Sources.Constant zer(final k=0) "Zero output"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
equation
  connect(tan.u, zen.zen)
    annotation (Line(points={{-32,0},{-32,0},{-49,0}},
                                                    color={0,0,127}));
  connect(tan.y, shaLen.u)
    annotation (Line(points={{-9,0},{-9,0},{-2,0}},
                                                  color={0,0,127}));
  connect(solAzi.zen, zen.zen) annotation (Line(points={{-32,36},{-40,36},{-40,0},
          {-49,0}}, color={0,0,127}));
  connect(add.u1, surAzi.y)
    annotation (Line(points={{8,56},{0,56},{0,70},{-9,70}}, color={0,0,127}));
  connect(solAzi.solAzi, add.u2)
    annotation (Line(points={{-9,30},{0,30},{0,44},{8,44}}, color={0,0,127}));
  connect(add.y, cos.u)
    annotation (Line(points={{31,50},{38,50}}, color={0,0,127}));
  connect(shaLen.y, proShaLen.u2)
    annotation (Line(points={{21,0},{26,0},{26,-6},{30,-6}}, color={0,0,127}));
  connect(proShaLen.u1, cos.y)
    annotation (Line(points={{30,6},{24,6},{24,20},{64,20},{64,50},{61,50}},
                                                             color={0,0,127}));
  connect(solAzi.decAng, decAng) annotation (Line(points={{-32,30},{-68,30},{-68,
          40},{-120,40}}, color={0,0,127}));
  connect(solAzi.solTim, solTim) annotation (Line(points={{-32,24},{-60,24},{-90,
          24},{-90,-40},{-120,-40}}, color={0,0,127}));
  connect(zen.decAng, decAng) annotation (Line(points={{-72,5.4},{-84,5.4},{-84,
          40},{-120,40}}, color={0,0,127}));
  connect(solHouAng.solTim, solTim)
    annotation (Line(points={{-82,-40},{-120,-40}}, color={0,0,127}));
  connect(solHouAng.solHouAng, zen.solHouAng) annotation (Line(points={{-59,-40},
          {-50,-40},{-50,-20},{-80,-20},{-80,-4.8},{-72,-4.8}}, color={0,0,127}));
  connect(lessThreshold.u, zen.zen) annotation (Line(points={{-22,-30},{-40,-30},
          {-40,0},{-49,0}}, color={0,0,127}));
  connect(lessThreshold.y, switch1.u2)
    annotation (Line(points={{1,-30},{58,-30},{58,-30}}, color={255,0,255}));
  connect(switch1.u1, proShaLen.y) annotation (Line(points={{58,-22},{54,-22},{
          54,0},{53,0}}, color={0,0,127}));
  connect(zer.y, switch1.u3) annotation (Line(points={{41,-50},{48,-50},{48,-38},
          {58,-38}}, color={0,0,127}));
  connect(switch1.y, y) annotation (Line(points={{81,-30},{88,-30},{88,0},{110,
          0}}, color={0,0,127}));
  annotation (
    defaultComponentName="proShaLen",
    Documentation(info="<html>
<p>
This component computes the length of a shadow projected
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
The inputs declination angle and solar time can be obtained from the
weather data bus of the weather data reader
<a href=\"modelica://Buildings.BoundaryConditions.WeatherData.ReaderTMY3\">
Buildings.BoundaryConditions.WeatherData.ReaderTMY3</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
November 14, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          lineColor={0,0,255}), Bitmap(extent={{-90,90},{90,-92}}, fileName=
              "modelica://Buildings/Resources/Images/BoundaryConditions/SolarGeometry/BaseClasses/ZenithAngle.png")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})));
end ProjectedShadowLength;

within Buildings.HeatTransfer.Windows;
block BeamDepthInRoom "Depth of solar beam in the room"
  // fixme: the icon needs to be updated
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.SIunits.Angle lat "Latitude";
  parameter Modelica.SIunits.Angle azi "Surface azimuth";

  parameter Modelica.SIunits.Length hWorPla = 0.75
    "Height of workplane above ground";

  parameter Modelica.SIunits.Length hUppApe
    "Upper height of aperature above ground"
    annotation (Dialog(group="Aperture"));
  parameter Modelica.SIunits.Length depApe = 0.15
    "Depth of outer corner of aperture, measured from interior surface"
    annotation (Dialog(group="Aperture"));

  parameter Modelica.SIunits.Length depOve = 0
    "Depth of overhang, meausured from other exterior surface of aperature (set to 0 if no overhang)"
    annotation (Dialog(group="Overhang"));
  parameter Modelica.SIunits.Length gapOve = 0
    "Gap between upper height of aperature and lower height of overhang (set to 0 if no overhang)"
    annotation (Dialog(group="Overhang"));

  Modelica.Blocks.Interfaces.RealInput decAng(quantity="Angle", unit="rad")
    "Declination angle"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput solTim(quantity="Time", unit="s")
    "Solar time" annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
                    iconTransformation(extent={{-140,-60},{-100,-20}})));

  Modelica.Blocks.Interfaces.RealOutput y(
    final quantity="Length",
    final unit="m")
    "Beam depth in room, measured perpendicular to window surface, at workplane height"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  parameter Modelica.SIunits.Length dep = depApe + depOve
    "Depth of outer corner that throws the shade, measured from interior surface";
  parameter Modelica.SIunits.Length h = hUppApe - hWorPla + gapOve
    "Height of outer corner that throws the shade measure from the workplane height";

  BoundaryConditions.SolarGeometry.ProjectedShadowLength proShaLen(
    final lat=lat,
    final h=h,
    final azi=azi) "Projected length of shadow"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  Modelica.Blocks.Math.Add depInRoo(
    final k2=-1) "Depth of beam in room"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Sources.Constant depth(final k=-dep)
    "Distance outer corner that throws shade minus room-side surface"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));

  Modelica.Blocks.Math.Max max "Limiter to avoid negative distance"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
protected
  Modelica.Blocks.Sources.Constant zer(final k=0) "Outputs zero"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
initial equation
  assert(h > 0, "The aperature is below the workplane, hence the solar beam never hits the workplane.",
    AssertionLevel.warning);

equation
  connect(proShaLen.decAng, decAng) annotation (Line(points={{-42,4},{-70,4},{-70,
          40},{-120,40}}, color={0,0,127}));
  connect(proShaLen.solTim, solTim) annotation (Line(points={{-42,-4},{-56,-4},{
          -70,-4},{-70,-40},{-120,-40}}, color={0,0,127}));
  connect(proShaLen.y, depInRoo.u2) annotation (Line(points={{-19,0},{-8,0},{-8,
          -6},{-2,-6}}, color={0,0,127}));
  connect(depth.y, depInRoo.u1)
    annotation (Line(points={{-19,40},{-10,40},{-10,6},{-2,6}}, color={0,0,127}));
  connect(zer.y, max.u2) annotation (Line(points={{41,-30},{48,-30},{48,-6},{58,
          -6}}, color={0,0,127}));
  connect(max.u1, depInRoo.y)
    annotation (Line(points={{58,6},{40,6},{40,0},{21,0}}, color={0,0,127}));
  connect(max.y, y)
    annotation (Line(points={{81,0},{92,0},{110,0}}, color={0,0,127}));
  annotation (
    defaultComponentName="beaDep",
    Documentation(info="<html>
<p>
This component computes the maximum distance at which a solar beam that enters the window
hits the workplane. The distance is measured perpendicular to the wall.
</p>
<p>
The parameter <code>azi</code> is the azimuth of the window.
For example, if the window faces south, set
<code>azi=Buildings.Types.Azimuth.S</code>.
The figure below explains the parameters.
</p>
<p align=\"center\">
<img alt=\"Figure for beam depth parameters\" src=\"modelica://Buildings/Resources/Images/HeatTransfer/Windows/BeamDepthInRoom.png\" border=\"1\" />
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
<h4>Assumptions and approximations</h4>
<p>
The following assumptions and approximations are made:
</p>
<ol>
<li>
If an overhang is present, then the corner of the overhang is the
only object that casts a shade. In reality, for very shallow incidence angles,
the top of the window frame may be sun exposed, but this
model neglects any shade that is cast by the top of the window frame.
</li>
<li>
The overhang is assumed to have infinite length in the direction of the wall,
as this allows neglecting any effects that the corner may have at shallow incidence angles.
</li>
<li>
The wall is vertical.
</li>
</ol>
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
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end BeamDepthInRoom;

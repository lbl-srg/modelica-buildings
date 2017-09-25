within Buildings.HeatTransfer.Windows;
block BeamDepthInRoom "Depth of solar beam in the room"
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

  parameter Modelica.SIunits.Angle azi "Surface azimuth";

  parameter Modelica.SIunits.Length hWorPla = 0.75
    "Height of workplane above ground";

  parameter Modelica.SIunits.Length hApe
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

  Modelica.Blocks.Interfaces.RealOutput y(
    final quantity="Length",
    final unit="m")
    "Beam depth in room, measured perpendicular to window surface, at workplane height"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

protected
  final parameter String absFilNam = Buildings.BoundaryConditions.WeatherData.BaseClasses.getAbsolutePath(filNam)
    "Absolute name of the file";

  parameter Modelica.SIunits.Length dep = depApe + depOve
    "Depth of outer corner that throws the shade, measured from interior surface";
  parameter Modelica.SIunits.Length h = hApe - hWorPla + gapOve
    "Height of outer corner that throws the shade measure from the workplane height";

  BoundaryConditions.SolarGeometry.ProjectedShadowLength proShaLen(
    final h=h,
    final lat=lat,
    final azi=azi,
    final filNam=filNam,
    final lon=lon,
    final timZon=timZon) "Projected length of shadow"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));

  Modelica.Blocks.Math.Add depInRoo(
    final k2=-1) "Depth of beam in room"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Constant depth(final k=-dep)
    "Distance outer corner that throws shade minus room-side surface"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));

  Modelica.Blocks.Math.Max max "Limiter to avoid negative distance"
    annotation (Placement(transformation(extent={{72,-10},{92,10}})));
protected
  Modelica.Blocks.Sources.Constant zer(final k=0) "Outputs zero"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
initial equation
  assert(h > 0, "The aperature is below the workplane, hence the solar beam never hits the workplane.",
    AssertionLevel.warning);

equation
  connect(proShaLen.y, depInRoo.u2) annotation (Line(points={{-39,-20},{-20,-20},
          {-20,-6},{-12,-6}},
                        color={0,0,127}));
  connect(depth.y, depInRoo.u1)
    annotation (Line(points={{-39,20},{-20,20},{-20,6},{-12,6},{-12,6}},
                                                                color={0,0,127}));
  connect(zer.y, max.u2) annotation (Line(points={{41,-30},{48,-30},{48,-6},{70,
          -6}}, color={0,0,127}));
  connect(max.u1, depInRoo.y)
    annotation (Line(points={{70,6},{40,6},{40,0},{11,0}}, color={0,0,127}));
  connect(max.y, y)
    annotation (Line(points={{93,0},{93,0},{110,0}}, color={0,0,127}));
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
<img alt=\"Figure for beam depth parameters\"
     src=\"modelica://Buildings/Resources/Images/HeatTransfer/Windows/BeamDepthInRoom.png\"
     border=\"1\" />
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
August 23, 2016, by Thierry S. Nouidui:<br/>
Propagated <code>filNam</code>.
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
    Icon(graphics={Bitmap(extent={{-88,90},{96,-94}},
            fileName="modelica://Buildings/Resources/Images/HeatTransfer/Windows/BeamDepthInRoomIcon.png")}));
end BeamDepthInRoom;

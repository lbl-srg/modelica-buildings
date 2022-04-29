within Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources;
model PVsimpleOriented
  "Simple PV source with orientation and without neutral cable"
  extends
    Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.BaseClasses.UnbalancedPV(
    redeclare Buildings.Electrical.AC.OnePhase.Sources.PVSimple pv_phase1,
    redeclare Buildings.Electrical.AC.OnePhase.Sources.PVSimple pv_phase2,
    redeclare Buildings.Electrical.AC.OnePhase.Sources.PVSimple pv_phase3);
  parameter Modelica.Units.SI.Angle til "Surface tilt"
    annotation (Dialog(group="Orientation"));
  parameter Modelica.Units.SI.Angle azi "Surface Azimith"
    annotation (Dialog(group="Orientation"));
  BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil(
    final til=til,
    final azi=azi) "Diffuse irradiation on tilted surface"
    annotation (Placement(transformation(extent={{20,-80},{0,-60}})));
  BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil(
    final til=til,
    final azi=azi) "Direct irradiation on tilted surface"
    annotation (Placement(transformation(extent={{60,-99},{40,-79}})));
  Modelica.Blocks.Math.Add G "Total irradiation on tilted surface"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-76,-70})));
  BoundaryConditions.WeatherData.Bus weaBus "Bus with weather data" annotation (
     Placement(transformation(extent={{76,-62},{96,-42}}), iconTransformation(
          extent={{-10,80},{10,100}})));
equation
  connect(HDifTil.weaBus,weaBus)  annotation (Line(
      points={{20,-70},{72,-70},{72,-52},{86,-52}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus,HDirTil. weaBus) annotation (Line(
      points={{86,-52},{72,-52},{72,-89},{60,-89}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(HDifTil.H, G.u2) annotation (Line(
      points={{-1,-70},{-52,-70},{-52,-64},{-64,-64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(G.y, G_int) annotation (Line(
      points={{-87,-70},{-94,-70},{-94,20},{-80,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDirTil.H, G.u1) annotation (Line(
      points={{39,-89},{-60,-89},{-60,-76},{-64,-76}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
  defaultComponentName="pv",
    Documentation(revisions="<html>
<ul>
<li>
March 23, 2022, by Michael Wetter:<br/>
Corrected documentation string for parameter <code>A</code>.
</li>
<li>
September 16, 2021, by Michael Wetter:<br/>
Removed parameter <code>lat</code> as this is now obtained from the weather data reader.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1477\">IBPSA, #1477</a>.
</li>
<li>
October 7, 2019, by Michael Wetter:<br/>
Corrected model to include DC/AC conversion in output <code>P</code>.<br/>
This is for issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1577\">1577</a>.
</li>
<li>
August 27, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
</ul>
</html>", info="<html>
<p>
Simple PV model with orientation for three-phase unbalanced systems
without neutral cable connection.
</p>
<p>
For more information, see
<a href=\"modelica://Buildings.Electrical.AC.OnePhase.Sources.PVSimpleOriented\">
Buildings.Electrical.AC.OnePhase.Sources.PVSimpleOriented</a>.
</p>
</html>"));
end PVsimpleOriented;

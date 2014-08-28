within Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources;
model PVsimpleOriented "Simple PV source with orientation"
  extends
    Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.BaseClasses.UnbalancedPV(
    redeclare Buildings.Electrical.AC.OnePhase.Sources.PVSimple pv_phase1,
    redeclare Buildings.Electrical.AC.OnePhase.Sources.PVSimple pv_phase2,
    redeclare Buildings.Electrical.AC.OnePhase.Sources.PVSimple pv_phase3);
  parameter Modelica.SIunits.Angle til "Surface tilt" annotation(Dialog(group="Orientation"));
  parameter Modelica.SIunits.Angle lat "Latitude" annotation(Dialog(group="Orientation"));
  parameter Modelica.SIunits.Angle azi "Surface Azimith" annotation(Dialog(group="Orientation"));
  BoundaryConditions.SolarIrradiation.DiffusePerez           HDifTil(
    til=til,
    lat=lat,
    azi=azi) "Diffuse irradiation on tilted surface"
    annotation (Placement(transformation(extent={{10,74},{-10,94}})));
  BoundaryConditions.SolarIrradiation.DirectTiltedSurface           HDirTil(
    til=til,
    lat=lat,
    azi=azi) "Direct irradiation on tilted surface"
    annotation (Placement(transformation(extent={{28,47},{8,67}})));
  Modelica.Blocks.Math.Add G "Total irradiation on tilted surface"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-78,78})));
  BoundaryConditions.WeatherData.Bus weaBus "Bus with weather data" annotation (
     Placement(transformation(extent={{30,90},{50,110}}),  iconTransformation(
          extent={{-10,80},{10,100}})));
equation
  connect(HDifTil.weaBus,weaBus)  annotation (Line(
      points={{10,84},{40,84},{40,100}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus,HDirTil. weaBus) annotation (Line(
      points={{40,100},{40,84},{54,84},{54,62},{54,62},{54,57},{28,57}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(HDirTil.H, G.u1) annotation (Line(
      points={{7,57},{-14,57},{-14,76},{-58,76},{-58,72},{-66,72}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDifTil.H, G.u2) annotation (Line(
      points={{-11,84},{-66,84}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(G.y, G_int) annotation (Line(
      points={{-89,78},{-94,78},{-94,20},{-80,20}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics),
    Documentation(revisions="<html>
<ul>
<li>
August 27, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
</ul>
</html>", info="<html>
<p>
Simple PV model with orientation for three phases unbalanced systems.
</p>
<p>
For more information see 
<a href=\"modelica://Buildings.Electrical.AC.OnePhase.Sources.PVSimpleOriented\">
Buildings.Electrical.AC.OnePhase.Sources.PVSimpleOriented</a>, and
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.BaseClasses.UnbalancedPV\">
Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.BaseClasses.UnbalancedPV</a>.
</p>
</html>"));
end PVsimpleOriented;

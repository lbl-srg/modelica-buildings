within Buildings.ThermalZones.Detailed.BaseClasses;
model ExteriorBoundaryConditions
  "Model for convection and radiation bounary condition of exterior constructions"
  parameter Integer nCon(min=1) "Number of exterior constructions"
  annotation (Dialog(group="Exterior constructions"));

  parameter Boolean linearizeRadiation
    "Set to true to linearize emissive power";

  replaceable parameter ParameterConstruction conPar[nCon] constrainedby
    ParameterConstruction "Records for construction"
    annotation (Placement(transformation(extent={{174,-214},{194,-194}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a opa_a[nCon]
    "Heat port at surface a of opaque construction"
    annotation (Placement(transformation(extent={{-310,190},{-290,210}})));
  parameter Buildings.HeatTransfer.Types.ExteriorConvection conMod=
  Buildings.HeatTransfer.Types.ExteriorConvection.TemperatureWind
    "Convective heat transfer model for opaque part of the constructions"
    annotation (Dialog(group="Convective heat transfer"));
  parameter Modelica.Units.SI.CoefficientOfHeatTransfer hFixed=10.0
    "Constant convection coefficient for opaque part of the constructions"
    annotation (Dialog(group="Convective heat transfer", enable=(conMod ==
          Buildings.HeatTransfer.Types.ExteriorConvection.Fixed)));

  // The convection coefficients are not final to allow a user to individually
  // assign them.
  // We reassign the tilt since a roof has been declared in the room model as the
  // ceiling (of the room)
  HeatTransfer.Convection.Exterior conOpa[nCon](
    A=AOpa,
    final til=Modelica.Constants.pi*ones(nCon) .- conPar[:].til,
    final azi=conPar[:].azi,
    each conMod=conMod,
    each hFixed=hFixed) "Convection model for opaque part of the wall"
    annotation (Placement(transformation(extent={{-180,160},{-140,200}})));

  SkyRadiationExchange skyRadExc(
    final n=nCon,
    final A=AOpa,
    final absIR=conPar[:].layers.absIR_a,
    vieFacSky={(Modelica.Constants.pi - conPar[i].til)./Modelica.Constants.pi for i in 1:nCon})
    "Infrared radiative heat exchange with sky"
    annotation (Placement(transformation(extent={{-140,240},{-180,280}})));
  BoundaryConditions.WeatherData.Bus weaBus
    annotation (Placement(transformation(extent={{234,32},{254,52}}),
        iconTransformation(extent={{192,-10},{254,52}})));

  BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil[
            nCon](
    final til=conPar[:].til,
    final azi=conPar[:].azi) "Direct solar irradiation on the surface"
    annotation (Placement(transformation(extent={{220,120},{200,140}})));
  BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil[nCon](
    final til=conPar[:].til,
    final azi=conPar[:].azi) "Diffuse solar irradiation"
    annotation (Placement(transformation(extent={{220,80},{200,100}})));
  Modelica.Blocks.Math.Add HTotConExt[nCon](
    final k1=conPar[:].layers.absSol_a .* AOpa,
    final k2=conPar[:].layers.absSol_a .* AOpa) "Total solar irradiation"
    annotation (Placement(transformation(extent={{40,100},{20,120}})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow solHeaGaiConExt[nCon]
    "Total solar heat gain of the surface"
    annotation (Placement(transformation(extent={{0,100},{-20,120}})));

protected
  parameter Modelica.Units.SI.Area AOpa[nCon]=conPar[:].A
    "Area of opaque construction";

  Buildings.HeatTransfer.Sources.PrescribedTemperature TAirConExt[
    nCon] "Outside air temperature for exterior constructions"
    annotation (Placement(transformation(extent={{8,160},{-32,200}})));
  Modelica.Blocks.Routing.Replicator repConExt(nout=nCon) "Signal replicator"
    annotation (Placement(transformation(extent={{100,170},{80,190}})));

  Modelica.Blocks.Routing.Replicator repConExt1(
                                               nout=nCon) "Signal replicator"
    annotation (Placement(transformation(extent={{130,200},{110,220}})));
  Modelica.Blocks.Routing.Replicator repConExt2(
                                               nout=nCon) "Signal replicator"
    annotation (Placement(transformation(extent={{180,220},{160,240}})));

equation
  connect(conOpa.solid, opa_a) annotation (Line(
      points={{-180,180},{-240,180},{-240,200},{-300,200}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(skyRadExc.port, opa_a) annotation (Line(
      points={{-180,260},{-212,260},{-212,260},{-240,260},{-240,200},{-300,200}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(TAirConExt.port, conOpa.fluid) annotation (Line(
      points={{-32,180},{-140,180}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(repConExt.y, TAirConExt.T) annotation (Line(
      points={{79,180},{12,180}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(repConExt.u, weaBus.TDryBul) annotation (Line(
      points={{102,180},{244,180},{244,42}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(skyRadExc.TOut, weaBus.TDryBul) annotation (Line(
      points={{-136,252},{244,252},{244,42}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(skyRadExc.TBlaSky, weaBus.TBlaSky) annotation (Line(
      points={{-136,268},{244,268},{244,42}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  for i in 1:nCon loop
  connect(weaBus, HDirTil[i].weaBus) annotation (Line(
      points={{244,42},{244,130},{220,130}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(HDifTil[i].weaBus, weaBus) annotation (Line(
      points={{220,90},{244,90},{244,42}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
   end for;
  connect(HTotConExt.y, solHeaGaiConExt.Q_flow) annotation (Line(
      points={{19,110},{5.55112e-16,110}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solHeaGaiConExt.port, opa_a) annotation (Line(
      points={{-20,110},{-240,110},{-240,200},{-300,200}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(HDirTil.H, HTotConExt.u1) annotation (Line(
      points={{199,130},{60,130},{60,116},{42,116}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDifTil.H, HTotConExt.u2) annotation (Line(
      points={{199,90},{60,90},{60,104},{42,104}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(repConExt2.u, weaBus.winDir) annotation (Line(
      points={{182,230},{244,230},{244,42}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(repConExt1.u, weaBus.winSpe) annotation (Line(
      points={{132,210},{244,210},{244,42}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(repConExt1.y, conOpa.v) annotation (Line(
      points={{109,210},{-194,210},{-194,200},{-184,200}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(repConExt2.y, conOpa.dir) annotation (Line(
      points={{159,230},{-200,230},{-200,190},{-184,190}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-300,-300},
            {300,300}})), Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-300,-300},{300,300}}), graphics={
        Rectangle(
          extent={{-160,280},{280,-250}},
          fillColor={230,243,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
                               Ellipse(
          extent={{164,262},{270,162}},
          lineColor={255,255,0},
          fillColor={255,213,170},
          fillPattern=FillPattern.Sphere),
        Rectangle(
          extent={{-220,280},{-160,-280}},
          lineColor={0,0,0},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-160,-250},{280,-280}},
          lineColor={0,0,0},
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-168,346},{212,280}},
          textColor={0,0,255},
          textString="%name")}),
        Documentation(info="<html>
<p>
This model computes the boundary conditions for the outside-facing surface of
opaque constructions.
</p>
<p>
The model computes the infrared, solar, and convective heat exchange
between these surfaces and the exterior temperature and the sky temperature.
Input into this model are weather data that may be obtained from
<a href=\"modelica://Buildings.BoundaryConditions.WeatherData\">
Buildings.BoundaryConditions.WeatherData</a>.
</p>
<p>
In this model, the solar radiation data are converted from horizontal irradiation to
irradiation on tilted surfaces using models from the package
<a href=\"modelica://Buildings.BoundaryConditions.SolarIrradiation\">
Buildings.BoundaryConditions.SolarIrradiation</a>.
The convective heat transfer between the exterior surface of the opaque constructions
is computed using
<a href=\"modelica://Buildings.HeatTransfer.Convection\">
Buildings.HeatTransfer.Convection</a>.
</p>
<p>
The heat transfer of windows are not computed in this model. They are implemented in
<a href=\"modelica://Buildings.ThermalZones.Detailed.BaseClasses.ExteriorBoundaryConditionsWithWindow\">
Buildings.ThermalZones.Detailed.BaseClasses.ExteriorBoundaryConditionsWithWindow</a>.
</p>
</html>",
        revisions="<html>
<ul>
<li>
September 16, 2021, by Michael Wetter:<br/>
Removed parameter <code>lat</code> because the latitude is now obtained from the weather data bus.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1477\">IBPSA, #1477</a>.
</li>
<li>
August 9, 2011 by Michael Wetter:<br/>
Changed assignment of tilt in instance <code>conOpa</code>.
This fixes the bug in <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/35\">issue 35</a>
that led to the wrong solar radiation gain for roofs and floors.
(Since the tilt has been changed in the model
<a href=\"modelica://Buildings.ThermalZones.Detailed.MixedAir\">
Buildings.ThermalZones.Detailed.MixedAir</a> at the place where it makes an instance of this model,
the change in the tilt parameter of the convective heat transfer model was required.)
</li>
<li>
March 28, 2011, by Michael Wetter:<br/>
Propaged parameter <code>hFixed</code> to top-level of the model.
</li>
<li>
March 23, 2011, by Michael Wetter:<br/>
Removed default value for convection model.
</li>
<li>
November 23, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ExteriorBoundaryConditions;

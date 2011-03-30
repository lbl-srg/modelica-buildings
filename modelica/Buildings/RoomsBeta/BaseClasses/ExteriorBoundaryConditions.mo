within Buildings.RoomsBeta.BaseClasses;
model ExteriorBoundaryConditions
  "Model for convection and radiation bounary condition of exterior constructions"
  parameter Integer nCon(min=1) "Number of exterior constructions"
  annotation (Dialog(group="Exterior constructions"));
  parameter Modelica.SIunits.Angle lat "Latitude";
  parameter Modelica.SIunits.Angle til[nCon] "Surface tilt";
  parameter Modelica.SIunits.Angle azi[nCon] "Surface azimuth";

  parameter Modelica.SIunits.Area AOpa[nCon]
    "Areas of exterior constructions (excluding the window area)";
  parameter Boolean linearizeRadiation
    "Set to true to linearize emissive power";
  parameter Modelica.SIunits.Emissivity epsLW[nCon]
    "Long wave emissivity of building surface";
  parameter Modelica.SIunits.Emissivity epsSW[nCon]
    "Short wave emissivity of building surface";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a opa_a[nCon]
    "Heat port at surface a of opaque construction"
    annotation (Placement(transformation(extent={{-310,190},{-290,210}})));
  parameter Types.ConvectionModel[nCon] conMod
    "Convective heat transfer model for opaque part of the construction";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer[nCon] hFixed=3*ones(nCon)
    "Constant convection coefficient for opaque part of the wall"
    annotation (Dialog(enable=(conMod == Buildings.RoomsBeta.Types.ConvectionModel.fixed)));

  HeatTransfer.Convection conOpa[nCon](final A=AOpa,
    final conMod=conMod,
    final til=til,
    final hFixed=hFixed) "Convection model for opaque part of the wall"
    annotation (Placement(transformation(extent={{-180,180},{-140,220}})));

  SkyRadiationExchange skyRadExc(
    final n=nCon,
    each final A=AOpa,
    each final epsLW=epsLW,
    vieFacSky={(Modelica.Constants.pi - til[i])./Modelica.Constants.pi for i in 1:nCon})
    "Long-wave radiative heat exchange with sky"
    annotation (Placement(transformation(extent={{-140,240},{-180,280}})));
  BoundaryConditions.WeatherData.Bus weaBus
    annotation (Placement(transformation(extent={{234,32},{254,52}}),
        iconTransformation(extent={{192,-10},{254,52}})));
protected
  Buildings.HeatTransfer.Sources.PrescribedTemperature TAirConExt[
    nCon] "Outside air temperature for exterior constructions"
    annotation (Placement(transformation(extent={{8,180},{-32,220}})));
  Modelica.Blocks.Routing.Replicator repConExt(nout=nCon) "Signal replicator"
    annotation (Placement(transformation(extent={{100,190},{80,210}})));

public
  BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil[
            nCon](
    each final lat=lat,
    final til=til,
    final azi=azi) "Direct solar irradiation on the surface"
    annotation (Placement(transformation(extent={{100,120},{80,140}})));
  BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil[nCon](
    each final lat=lat,
    final til=til,
    final azi=azi) "Diffuse solar irradiation"
    annotation (Placement(transformation(extent={{100,80},{80,100}})));
  Modelica.Blocks.Math.Add HTotConExt[nCon](
    final k1=epsSW .* AOpa,
    final k2=epsSW .* AOpa) "Total solar irradiation"
    annotation (Placement(transformation(extent={{40,100},{20,120}})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow solHeaGaiConExt[nCon]
    "Total solar heat gain of the surface"
    annotation (Placement(transformation(extent={{0,100},{-20,120}})));

equation
  connect(conOpa.solid, opa_a) annotation (Line(
      points={{-180,200},{-300,200}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(skyRadExc.port, opa_a) annotation (Line(
      points={{-180,261.6},{-212,261.6},{-212,260},{-240,260},{-240,200},{-300,200}},
      color={191,0,0},
      smooth=Smooth.None));

  connect(TAirConExt.port, conOpa.fluid) annotation (Line(
      points={{-32,200},{-140,200}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(repConExt.y, TAirConExt.T) annotation (Line(
      points={{79,200},{12,200}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(repConExt.u, weaBus.TDryBul) annotation (Line(
      points={{102,200},{244,200},{244,42}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(skyRadExc.TOut, weaBus.TDryBul) annotation (Line(
      points={{-136,252},{244,252},{244,42}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(skyRadExc.TBlaSky, weaBus.TBlaSky) annotation (Line(
      points={{-136,268},{244,268},{244,42}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  for i in 1:nCon loop
  connect(weaBus, HDirTil[i].weaBus) annotation (Line(
      points={{244,42},{244,130},{100,130}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(HDifTil[i].weaBus, weaBus) annotation (Line(
      points={{100,90},{244,90},{244,42}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
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
      points={{79,130},{60,130},{60,116},{42,116}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDifTil.H, HTotConExt.u2) annotation (Line(
      points={{79,90},{60,90},{60,104},{42,104}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-300,
            -300},{300,300}},
        initialScale=0.1), graphics),
                          Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-300,-300},{300,300}},
        initialScale=0.1), graphics={
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
          lineColor={0,0,255},
          textString="%name")}),
        Documentation(info="<html>
This model computes the boundary conditions for the outside-facing surface of
opaque constructions.
</p>
<p>
The model computes the long-wave, short-wave, and convective heat exchange
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
<a href=\"modelica:Buildings.RoomsBeta.BaseClasses.ExteriorBoundaryConditionsWithWindow\">
Buildings.RoomsBeta.BaseClasses.ExteriorBoundaryConditionsWithWindow</a>.
</p>
</html>",
        revisions="<html>
<ul>
<li>
March 28, 2011, by Michael Wetter:<br>
Propaged parameter <code>hFixed</code> to top-level of the model.
</li>
<li>
March 23, 2011, by Michael Wetter:<br>
Removed default value for convection model.
</li>
<li>
November 23, 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end ExteriorBoundaryConditions;

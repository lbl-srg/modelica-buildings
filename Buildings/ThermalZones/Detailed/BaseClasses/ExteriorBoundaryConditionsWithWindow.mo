within Buildings.ThermalZones.Detailed.BaseClasses;
model ExteriorBoundaryConditionsWithWindow
  "Model for exterior boundary conditions for constructions with a window"
  extends Buildings.ThermalZones.Detailed.BaseClasses.ExteriorBoundaryConditions(
   final AOpa=conPar[:].AOpa,
   redeclare Buildings.ThermalZones.Detailed.BaseClasses.ParameterConstructionWithWindow conPar);

  final parameter Modelica.Units.SI.Area AWin[nCon]=conPar[:].hWin .* conPar[:].wWin
    "Window area" annotation (Dialog(group="Glazing system"));

  final parameter Boolean haveExteriorShade[nCon] = conPar[:].glaSys.haveExteriorShade
    "Set to true if window has exterior shade (at surface a)"
    annotation (Dialog(group="Shading"));
  final parameter Boolean haveInteriorShade[nCon] = conPar[:].glaSys.haveInteriorShade
    "Set to true if window has interior shade (at surface b)"
    annotation (Dialog(group="Shading"));

  final parameter Boolean haveShade=
    Modelica.Math.BooleanVectors.anyTrue(haveExteriorShade) or
    Modelica.Math.BooleanVectors.anyTrue(haveInteriorShade)
    "Set to true if window system has a shade"
    annotation (Dialog(group="Shading"), Evaluate=true);

  final parameter Boolean haveOverhangOrSideFins=
    Modelica.Math.BooleanVectors.anyTrue(conPar.haveOverhangOrSideFins)
    "Flag, true if the room has at least one window with either an overhang or side fins";

  Buildings.HeatTransfer.Windows.FixedShade sha[nCon](
    final conPar=conPar,
    azi=conPar.azi)
    if haveOverhangOrSideFins "Shade due to overhang or side fins"
    annotation (Placement(transformation(extent={{140,100},{120,120}})));

  Modelica.Blocks.Interfaces.RealInput uSha[nCon](
    each min=0,
    each max=1) if haveShade
    "Control signal for the shading device, 0: unshaded; 1: fully shaded"
    annotation (Placement(transformation(extent={{-340,80},{-300,120}}),
        iconTransformation(extent={{-340,80},{-300,120}})));

  Modelica.Blocks.Interfaces.RealInput QAbsSolSha_flow[nCon](
    each final unit="W",
    each quantity="Power") "Solar radiation absorbed by shade"
    annotation (Placement(transformation(extent={{-340,40},{-300,80}})));

  HeatTransfer.Windows.ExteriorHeatTransfer conExtWin[nCon](
    final A=conPar[:].AWin,
    final fFra=conPar[:].fFra,
    each final linearizeRadiation = linearizeRadiation,
    final vieFacSky={(Modelica.Constants.pi - conPar[i].til) ./ Modelica.Constants.pi for i in 1:nCon},
    final absIRSha_air=conPar[:].glaSys.shade.absIR_a,
    final absIRSha_glass=conPar[:].glaSys.shade.absIR_b,
    final tauIRSha_air=conPar[:].glaSys.shade.tauIR_a,
    final tauIRSha_glass=conPar[:].glaSys.shade.tauIR_b,
    final haveExteriorShade=haveExteriorShade,
    final haveInteriorShade=haveInteriorShade)
    "Exterior convection of the window"
    annotation (Placement(transformation(extent={{20,-120},{-40,-60}})));

  SkyRadiationExchange skyRadExcWin(
    final n=nCon,
    final absIR=conPar[:].glaSys.absIRFra,
    vieFacSky={(Modelica.Constants.pi - conPar[i].til) ./ Modelica.Constants.pi for i in
            1:nCon},
    final A=conPar[:].AWin .* conPar[:].fFra)
    "Infrared radiative heat exchange between window frame and sky"
    annotation (Placement(transformation(extent={{-140,-280},{-180,-240}})));
  HeatTransfer.Interfaces.RadiosityOutflow JOutUns[nCon]
    "Outgoing radiosity that connects to unshaded part of glass at exterior side"
    annotation (Placement(transformation(extent={{-300,-30},{-320,-10}}),
        iconTransformation(extent={{-300,-30},{-320,-10}})));
  HeatTransfer.Interfaces.RadiosityInflow JInUns[nCon]
    "Incoming radiosity that connects to unshaded part of glass at exterior side"
    annotation (Placement(transformation(extent={{-320,10},{-300,30}}),
        iconTransformation(extent={{-320,10},{-300,30}})));
  HeatTransfer.Interfaces.RadiosityOutflow JOutSha[nCon]
    if haveShade
    "Outgoing radiosity that connects to shaded part of glass at exterior side"
    annotation (Placement(transformation(extent={{-300,-210},{-320,-190}}),
        iconTransformation(extent={{-300,-210},{-320,-190}})));
  HeatTransfer.Interfaces.RadiosityInflow JInSha[nCon]
    if haveShade
    "Incoming radiosity that connects to shaded part of glass at exterior side"
    annotation (Placement(transformation(extent={{-320,-170},{-300,-150}}),
        iconTransformation(extent={{-320,-170},{-300,-150}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a glaUns[nCon]
    "Heat port at unshaded glass of exterior-facing surface"
                                                    annotation (Placement(transformation(extent={{-310,
            -90},{-290,-70}}), iconTransformation(extent={{-310,-90},{-290,
            -70}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a glaSha[nCon]
    if haveShade "Heat port at shaded glass of exterior-facing surface"
    annotation (Placement(transformation(extent={{-310,-130},{-290,-110}}),
        iconTransformation(extent={{-310,-130},{-290,-110}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a fra[nCon](
    each T(
      nominal=300,
      start=283.15))
    "Heat port at frame of exterior-facing surface"
    annotation (Placement(transformation(extent={{-310,
            -270},{-290,-250}}), iconTransformation(extent={{-310,-270},{-290,
            -250}})));
  Modelica.Blocks.Math.Add HTotConExtWinFra[nCon](
     final k1=conPar[:].fFra .* conPar[:].glaSys.absSolFra .* conPar[:].AWin,
     final k2=conPar[:].fFra .* conPar[:].glaSys.absSolFra .* conPar[:].AWin)
    "Total solar irradiation on window frame"
    annotation (Placement(transformation(extent={{40,60},{20,80}})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow solHeaGaiConWin[nCon]
    "Total solar heat gain of the window frame"
    annotation (Placement(transformation(extent={{0,60},{-20,80}})));
  Modelica.Blocks.Interfaces.RealOutput HDir[nCon](
     each final quantity="RadiantEnergyFluenceRate",
     each final unit="W/m2") "Direct solar irradition on tilted surface"
    annotation (Placement(transformation(extent={{300,110},{320,130}})));
  Modelica.Blocks.Interfaces.RealOutput HDif[nCon](
     each final quantity="RadiantEnergyFluenceRate",
     each final unit="W/m2") "Diffuse solar irradiation on tilted surface"
    annotation (Placement(transformation(extent={{300,50},{320,70}})));
  Modelica.Blocks.Interfaces.RealOutput inc[nCon](
    each final quantity="Angle",
    each final unit="rad",
    each displayUnit="deg") "Incidence angle"
    annotation (Placement(transformation(extent={{300,170},{320,190}})));

protected
  Buildings.HeatTransfer.Sources.PrescribedTemperature TAirConExtWin[
    nCon] "Outside air temperature for window constructions"
    annotation (Placement(transformation(extent={{160,-90},{120,-50}})));
  Modelica.Blocks.Routing.Replicator repConExtWin(final nout=nCon)
    "Signal replicator"
    annotation (Placement(transformation(extent={{220,-80},{200,-60}})));
  Modelica.Blocks.Routing.Replicator repConExtWinVWin(final nout=nCon)
    "Signal replicator"
    annotation (Placement(transformation(extent={{140,-22},{120,-2}})));
  Modelica.Blocks.Routing.Replicator repConExtWinTSkyBla(final nout=nCon)
    "Signal replicator"
    annotation (Placement(transformation(extent={{220,-112},{200,-92}})));
equation
  connect(uSha, conExtWin.uSha)
                          annotation (Line(
      points={{-320,100},{-140,100},{-140,-40},{40,-40},{40,-66},{22.4,-66}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(JInUns,conExtWin. JInUns) annotation (Line(
      points={{-310,20},{-200,20},{-200,-72},{-43,-72}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(conExtWin.JOutUns,JOutUns)  annotation (Line(
      points={{-43,-66},{-196.45,-66},{-196.45,-20},{-310,-20}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(conExtWin.glaUns,glaUns)  annotation (Line(
      points={{-40,-84},{-192,-84},{-192,-80},{-300,-80}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conExtWin.glaSha,glaSha)  annotation (Line(
      points={{-40,-96},{-190,-96},{-190,-120},{-300,-120}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conExtWin.JOutSha,JOutSha)  annotation (Line(
      points={{-43,-108},{-176,-108},{-176,-200},{-310,-200}},
      color={0,127,0},
      smooth=Smooth.None));
  connect(conExtWin.JInSha,JInSha)  annotation (Line(
      points={{-43,-114},{-184.45,-114},{-184.45,-160},{-310,-160}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(conExtWin.frame,fra)  annotation (Line(
      points={{-31,-120},{-31,-220},{-260,-220},{-260,-260},{-300,-260}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TAirConExtWin.port,conExtWin. air) annotation (Line(
      points={{120,-70},{90,-70},{90,-90},{20,-90}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TAirConExtWin.T,repConExtWin. y) annotation (Line(
      points={{164,-70},{199,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(repConExtWin.u, weaBus.TDryBul) annotation (Line(
      points={{222,-70},{244,-70},{244,42}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(repConExtWinVWin.y,conExtWin. vWin) annotation (Line(
      points={{119,-12},{50,-12},{50,-78},{22.4,-78}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(repConExtWinVWin.u, weaBus.winSpe) annotation (Line(
      points={{142,-12},{192,-12},{192,-14},{244,-14},{244,42}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(HTotConExtWinFra.y, solHeaGaiConWin.Q_flow) annotation (Line(
      points={{19,70},{0,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solHeaGaiConWin.port, fra) annotation (Line(
      points={{-20,70},{-60,70},{-60,-220},{-260,-220},{-260,-260},{-300,-260}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(HDifTil.H, HDif) annotation (Line(
      points={{199,90},{72,90},{72,60},{310,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDirTil.inc, inc) annotation (Line(
      points={{199,126},{180,126},{180,112},{260,112},{260,180},{310,180}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HTotConExtWinFra.u2, HDifTil.H) annotation (Line(
      points={{42,64},{72,64},{72,90},{199,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(skyRadExcWin.TOut, weaBus.TDryBul)
                                          annotation (Line(
      points={{-136,-268},{244,-268},{244,42}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(skyRadExcWin.TBlaSky, weaBus.TBlaSky)
                                             annotation (Line(
      points={{-136,-252},{244,-252},{244,42}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(skyRadExcWin.port, fra) annotation (Line(
      points={{-180,-260},{-242,-260},{-242,-260},{-300,-260}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(repConExtWin.y, conExtWin.TOut) annotation (Line(
      points={{199,-70},{180,-70},{180,-114.6},{23,-114.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(repConExtWinTSkyBla.y, conExtWin.TBlaSky) annotation (Line(
      points={{199,-102},{23,-102}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(repConExtWinTSkyBla.u, weaBus.TBlaSky) annotation (Line(
      points={{222,-102},{244,-102},{244,42}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  for i in 1:nCon loop
    connect(sha[i].weaBus, weaBus) annotation (Line(
      points={{140,110},{244,110},{244,42}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  end for;

  connect(HDirTil.inc, sha.incAng) annotation (Line(
      points={{199,126},{168,126},{168,104},{142,104}},
      color={0,0,127},
      smooth=Smooth.None));
  // OpenModelica does not remove the connect statement if conExtWin.QSolAbs_flow
  // is removed.
  if haveShade then
    connect(QAbsSolSha_flow, conExtWin.QSolAbs_flow) annotation (Line(
      points={{-320,60},{-160,60},{-160,-140},{-10,-140},{-10,-123}},
      color={0,0,127},
      smooth=Smooth.None));
  end if;

  connect(sha.HDirTilUns, HDirTil.H) annotation (Line(
      points={{142,116},{160,116},{160,130},{199,130}},
      color={0,0,127},
      smooth=Smooth.None));

  if haveOverhangOrSideFins then
    connect(sha.HDirTil, HTotConExtWinFra.u1) annotation (Line(
      points={{119,116},{100,116},{100,76},{42,76}},
      color={0,0,127},
      smooth=Smooth.None));
    connect(sha.HDirTil, HDir) annotation (Line(
      points={{119,116},{100,116},{100,70},{280,70},{280,120},{310,120}},
      color={0,0,127},
      smooth=Smooth.None));
  else
    connect(HDirTil.H, HTotConExtWinFra.u1) annotation (Line(
        points={{199,130},{100,130},{100,76},{42,76}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(HDirTil.H, HDir) annotation (Line(
      points={{199,130},{100,130},{100,70},{280,70},{280,120},{310,120}},
      color={0,0,127},
      smooth=Smooth.None));
  end if;

  annotation (Icon(graphics={
        Rectangle(
          extent={{-220,180},{-160,-102}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-212,180},{-202,-102}},
          lineColor={0,0,0},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.Dash),
        Rectangle(
          extent={{-180,180},{-170,-102}},
          lineColor={0,0,0},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.Dash)}),
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-300,-300},{300,
            300}}), graphics),
    Documentation(info="<html>
<p>
This model computes the boundary conditions for the outside-facing surface of
opaque constructions and of windows.
</p>
<p>
The model computes the infrared, solar, and convective heat exchange
between these surfaces and the exterior temperature and the sky temperature.
Input into this model are weather data that may be obtained from
<a href=\"modelica://Buildings.BoundaryConditions.WeatherData\">
Buildings.BoundaryConditions.WeatherData</a>.
</p>
<p>
This model extends
<a href=\"modelica://Buildings.ThermalZones.Detailed.BaseClasses.ExteriorBoundaryConditions\">
Buildings.ThermalZones.Detailed.BaseClasses.ExteriorBoundaryConditions</a>,
which models the boundary conditions for the opaque constructions,
and then implements the boundary condition for windows by using
the model
<a href=\"modelica://Buildings.HeatTransfer.Windows.ExteriorHeatTransfer\">
Buildings.HeatTransfer.Windows.ExteriorHeatTransfer</a>.
</html>", revisions="<html>
<ul>
<li>
November 9, 2021, by Michael Wetter:<br/>
Corrected use of <code>each</code> keyword.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2731\">issue 2731</a>.
</li>
<li>
September 16, 2021, by Michael Wetter:<br/>
Removed parameter <code>lat</code> because the latitude is now obtained from the weather data bus.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1477\">IBPSA, #1477</a>.
</li>
<li>
January 12, 2019, by Michael Wetter:<br/>
Added missing <code>each</code>.
</li>
<li>
March 13, 2015, by Michael Wetter:<br/>
Changed model to avoid a translation error
in OpenModelica if the connector is conditionally removed.
</li>
<li>
October 28, 2014, by Michael Wetter:<br/>
Replaced
<code>final parameter Boolean haveShade=haveExteriorShade[1] or haveInteriorShade[1]</code>
with a test for all elements of the vector.
This was not possible in earlier versions of Dymola, but now works.
</li>
<li>
October 20, 2014, by Michael Wetter:<br/>
Conditionally removed shade if not present. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/234\">
issue 234</a>.
</li>
<li>
February 8 2012, by Michael Wetter:<br/>
Changed model to use new implementation of
<a href=\"modelica://Buildings.HeatTransfer.Radiosity.OutdoorRadiosity\">
Buildings.HeatTransfer.Radiosity.OutdoorRadiosity</a>.
This change leads to the use of the same equations for the radiative
heat transfer between window and ambient as is used for
the opaque constructions.
</li>
<li>
August 9, 2011, by Michael Wetter:<br/>
Fixed bug that caused too high a surface temperature of the window frame.
The previous version did not compute the infrared radiation exchange between the
window frame and the sky. This has been corrected by adding the instance
<code>skyRadExcWin</code> and adding the parameter <code>absIRFra</code>.
This closes ticket <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/36\">issue 36</a>.
</li>
<li>
November 23, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ExteriorBoundaryConditionsWithWindow;

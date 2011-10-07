within Buildings.Rooms.BaseClasses;
model ExteriorBoundaryConditionsWithWindow
  "Model for exterior boundary conditions for constructions with a window"
  extends Buildings.Rooms.BaseClasses.ExteriorBoundaryConditions;
  parameter Modelica.SIunits.Area AWin[nCon] "Areas of window glass and frame";
  parameter Real fFra[nCon](each min=0, each max=1)
    "Fraction of window frame divided by total window area"
    annotation (Dialog(group="Frame"));

  parameter Modelica.SIunits.Emissivity absSolFra[nCon]
    "Solar absorptivity of window frame"
    annotation (Dialog(group="Frame"));
  parameter Modelica.SIunits.Emissivity absIRFra[nCon]
    "Infrared absorptivity of window frame"
    annotation (Dialog(group="Frame"));
  parameter Modelica.SIunits.Emissivity absIRSha_air[nCon]
    "Infrared absorptivity of shade surface that faces air"
        annotation (Dialog(group="Shading"));
  parameter Modelica.SIunits.Emissivity absIRSha_glass[nCon]
    "Infrared absorptivity of shade surface that faces glass"
    annotation (Dialog(group="Shading"));

  parameter Modelica.SIunits.TransmissionCoefficient tauIRSha_air[nCon]
    "Infrared transmissivity of shade for radiation coming from the exterior or the room"
    annotation (Dialog(group="Shading"));
  parameter Modelica.SIunits.TransmissionCoefficient tauIRSha_glass[nCon]
    "Infrared transmissivity of shade for radiation coming from the glass"
    annotation (Dialog(group="Shading"));

  parameter Boolean haveExteriorShade[nCon]
    "Set to true if window has exterior shade (at surface a)"
    annotation (Dialog(group="Shading"));
  parameter Boolean haveInteriorShade[nCon]
    "Set to true if window has interior shade (at surface b)"
    annotation (Dialog(group="Shading"));

  final parameter Boolean windowHasShade=
    haveExteriorShade[1] or haveInteriorShade[1]
    "Set to true if window system has a shade"
    annotation (Dialog(group="Shading"), Evaluate=true);

  Modelica.Blocks.Interfaces.RealInput uSha[nCon](min=0, max=1) if
       windowHasShade
    "Control signal for the shading device, 0: unshaded; 1: fully shaded"
    annotation (Placement(transformation(extent={{-340,80},{-300,120}}),
        iconTransformation(extent={{-340,80},{-300,120}})));

  Modelica.Blocks.Interfaces.RealInput QAbsSolSha_flow[nCon](
    final unit="W", quantity="Power") "Solar radiation absorbed by shade"
    annotation (Placement(transformation(extent={{-340,40},{-300,80}})));

  HeatTransfer.Windows.ExteriorHeatTransfer conExtWin[nCon](
    final A=AWin,
    final fFra=fFra,
    each final linearizeRadiation = linearizeRadiation,
    final F_sky={(Modelica.Constants.pi - til[i]) ./ Modelica.Constants.pi for i in 1:nCon},
    final absIRSha_air=absIRSha_air,
    final absIRSha_glass=absIRSha_glass,
    final tauIRSha_air=tauIRSha_air,
    final tauIRSha_glass=tauIRSha_glass,
    final haveExteriorShade=haveExteriorShade,
    final haveInteriorShade=haveInteriorShade)
    "Exterior convection of the window"
    annotation (Placement(transformation(extent={{20,-120},{-40,-60}})));

  SkyRadiationExchange skyRadExcWin(
    final n=nCon,
    each final absIR=absIRFra,
    vieFacSky={(Modelica.Constants.pi - til[i]) ./ Modelica.Constants.pi for i in
            1:nCon},
    each final A=AWin .* fFra)
    "Infrared radiative heat exchange between window frame and sky"
    annotation (Placement(transformation(extent={{-140,-282},{-180,-242}})));
  HeatTransfer.Interfaces.RadiosityOutflow JOutUns[nCon]
    "Outgoing radiosity that connects to unshaded part of glass at exterior side"
    annotation (Placement(transformation(extent={{-300,-30},{-320,-10}}),
        iconTransformation(extent={{-300,-30},{-320,-10}})));
  HeatTransfer.Interfaces.RadiosityInflow JInUns[nCon]
    "Incoming radiosity that connects to unshaded part of glass at exterior side"
    annotation (Placement(transformation(extent={{-320,10},{-300,30}}),
        iconTransformation(extent={{-320,10},{-300,30}})));
  HeatTransfer.Interfaces.RadiosityOutflow JOutSha[nCon] if
       windowHasShade
    "Outgoing radiosity that connects to shaded part of glass at exterior side"
    annotation (Placement(transformation(extent={{-300,-210},{-320,-190}}),
        iconTransformation(extent={{-300,-210},{-320,-190}})));
  HeatTransfer.Interfaces.RadiosityInflow JInSha[nCon] if
       windowHasShade
    "Incoming radiosity that connects to shaded part of glass at exterior side"
    annotation (Placement(transformation(extent={{-320,-170},{-300,-150}}),
        iconTransformation(extent={{-320,-170},{-300,-150}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a glaUns[nCon]
    "Heat port at unshaded glass of exterior-facing surface"
                                                    annotation (Placement(transformation(extent={{-310,
            -90},{-290,-70}},
                       rotation=0), iconTransformation(extent={{-310,-90},{-290,
            -70}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a glaSha[nCon] if
       windowHasShade "Heat port at shaded glass of exterior-facing surface"
    annotation (Placement(transformation(extent={{-310,-130},{-290,-110}}, rotation=0),
        iconTransformation(extent={{-310,-130},{-290,-110}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a fra[nCon](T(each nominal=
          300, each start=283.15))
    "Heat port at frame of exterior-facing surface"                                   annotation (Placement(transformation(extent={{-310,
            -270},{-290,-250}},
                       rotation=0), iconTransformation(extent={{-310,-270},{-290,
            -250}})));
  Modelica.Blocks.Math.Add HTotConExtWinFra[nCon](
     final k1=fFra .* absSolFra .* AWin,
     final k2=fFra .* absSolFra .* AWin)
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
    annotation (Placement(transformation(extent={{200,-80},{180,-60}})));
  Modelica.Blocks.Routing.Replicator repConExtWinF_clr(final nout=nCon)
    "Signal replicator"
    annotation (Placement(transformation(extent={{140,-140},{120,-120}})));
  Modelica.Blocks.Routing.Replicator repConExtWinVWin(final nout=nCon)
    "Signal replicator"
    annotation (Placement(transformation(extent={{140,-22},{120,-2}})));
equation
  connect(uSha, conExtWin.uSha)
                          annotation (Line(
      points={{-320,100},{-140,100},{-140,-40},{40,-40},{40,-66},{22.4,-66}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(JInUns,conExtWin. JInUns) annotation (Line(
      points={{-310,20},{-200,20},{-200,-72},{-43,-72}},
      color={0,0,0},
      pattern=LinePattern.None,
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
      pattern=LinePattern.None,
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
      points={{164,-70},{179,-70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(repConExtWin.u, weaBus.TDryBul) annotation (Line(
      points={{202,-70},{244,-70},{244,42}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(repConExtWinF_clr.y,conExtWin. f_clr) annotation (Line(
      points={{119,-130},{94.5,-130},{94.5,-114},{22.4,-114}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(repConExtWinVWin.y,conExtWin. vWin) annotation (Line(
      points={{119,-12},{108,-12},{108,-78},{22.4,-78}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(repConExtWinVWin.u, weaBus.winSpe) annotation (Line(
      points={{142,-12},{192,-12},{192,-14},{244,-14},{244,42}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(repConExtWinF_clr.u, weaBus.nTot) annotation (Line(
      points={{142,-130},{244,-130},{244,42}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(HTotConExtWinFra.y, solHeaGaiConWin.Q_flow) annotation (Line(
      points={{19,70},{5.55112e-16,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(solHeaGaiConWin.port, fra) annotation (Line(
      points={{-20,70},{-60,70},{-60,-220},{-260,-220},{-260,-260},{-300,-260}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(HDirTil.H, HDir) annotation (Line(
      points={{79,130},{72,130},{72,180},{280,180},{280,120},{310,120}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDifTil.H, HDif) annotation (Line(
      points={{79,90},{72,90},{72,60},{310,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HDirTil.inc, inc) annotation (Line(
      points={{79,126},{72,126},{72,180},{310,180}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HTotConExtWinFra.u2, HDifTil.H) annotation (Line(
      points={{42,64},{72,64},{72,90},{79,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(HTotConExtWinFra.u1, HDirTil.H) annotation (Line(
      points={{42,76},{66,76},{66,130},{79,130}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conExtWin.QAbs_flow, QAbsSolSha_flow) annotation (Line(
      points={{-10,-123},{-10,-140},{-160,-140},{-160,60},{-320,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(skyRadExcWin.TOut, weaBus.TDryBul)
                                          annotation (Line(
      points={{-136,-270},{244,-270},{244,42}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(skyRadExcWin.TBlaSky, weaBus.TBlaSky)
                                             annotation (Line(
      points={{-136,-254},{244,-254},{244,42}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(skyRadExcWin.port, fra) annotation (Line(
      points={{-180,-260.4},{-242,-260.4},{-242,-260},{-300,-260}},
      color={191,0,0},
      smooth=Smooth.None));
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
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-300,-300},{300,
            300}}), graphics),
    Documentation(info="<html>
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
<a href=\"modelica://Buildings.Rooms.BaseClasses.ExteriorBoundaryConditions\">
Buildings.Rooms.BaseClasses.ExteriorBoundaryConditions</a>,
which models the boundary conditions for the opaque constructions,
and then implements the boundary condition for windows by using
the model
<a href=\"modelica://Buildings.HeatTransfer.Windows.ExteriorHeatTransfer\">
Buildings.HeatTransfer.Windows.ExteriorHeatTransfer</a>.
</html>", revisions="<html>
<ul>
<li>
August 9, 2011, by Michael Wetter:<br>
Fixed bug that caused too high a surface temperature of the window frame.
The previous version did not compute the infrared radiation exchange between the
window frame and the sky. This has been corrected by adding the instance
<code>skyRadExcWin</code> and adding the parameter <code>absIRFra</code>.
This closes ticket <a href=\"https://corbu.lbl.gov/trac/bie/ticket/36\">ticket 36</a>.
</li>
<li>
November 23, 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end ExteriorBoundaryConditionsWithWindow;

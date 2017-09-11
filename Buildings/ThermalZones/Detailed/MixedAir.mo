within Buildings.ThermalZones.Detailed;
model MixedAir "Model of a room in which the air is completely mixed"
  extends Buildings.ThermalZones.Detailed.BaseClasses.RoomHeatMassBalance(
  redeclare Buildings.ThermalZones.Detailed.BaseClasses.MixedAirHeatMassBalance air(
    final energyDynamics=energyDynamics,
    final massDynamics = massDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final C_nominal=C_nominal,
    final m_flow_nominal=m_flow_nominal,
    final homotopyInitialization=homotopyInitialization,
    final conMod=intConMod,
    final hFixed=hIntFixed,
    final use_C_flow = use_C_flow),
    datConExt(
      each T_a_start = T_start,
      each T_b_start = T_start),
    datConExtWin(
      each T_a_start = T_start,
      each T_b_start = T_start),
    datConBou(
      each T_a_start = T_start,
      each T_b_start = T_start),
    datConPar(
      each T_a_start = T_start,
      each T_b_start = T_start));

  ////////////////////////////////////////////////////////////////////////////
  // Media declaration. This is identical to
  // Buildings.Fluid.Interfaces.LumpedVolumeDeclarations, except
  // that the comments have been changed to avoid a confusion about
  // what energyDynamics refers to.
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choicesAllMatching = true);

  // Ports
  parameter Boolean use_C_flow=false
    "Set to true to enable input connector for trace substance that is connected to room air"
    annotation (Dialog(group="Ports"));

  // Assumptions
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance for zone air: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Zone air"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
    "Type of mass balance for zone air: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Zone air"));
  final parameter Modelica.Fluid.Types.Dynamics substanceDynamics=energyDynamics
    "Type of independent mass fraction balance for zone air: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Zone air"));
  final parameter Modelica.Fluid.Types.Dynamics traceDynamics=energyDynamics
    "Type of trace substance balance for zone air: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Zone air"));

  parameter Real mSenFac(min=1)=1
    "Factor for scaling the sensible thermal mass of the zone air volume"
    annotation(Dialog(tab="Dynamics", group="Zone air"));

  // Initialization
  parameter Medium.AbsolutePressure p_start = Medium.p_default
    "Start value of zone air pressure"
    annotation(Dialog(tab = "Initialization"));
  parameter Medium.Temperature T_start=Medium.T_default
    "Start value of zone air temperature"
    annotation(Dialog(tab = "Initialization"));
  parameter Medium.MassFraction X_start[Medium.nX](
       quantity=Medium.substanceNames) = Medium.X_default
    "Start value of zone air mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", enable=Medium.nXi > 0));
  parameter Medium.ExtraProperty C_start[Medium.nC](
       quantity=Medium.extraPropertiesNames)=fill(0, Medium.nC)
    "Start value of zone air trace substances"
    annotation (Dialog(tab="Initialization", enable=Medium.nC > 0));
  parameter Medium.ExtraProperty C_nominal[Medium.nC](
       quantity=Medium.extraPropertiesNames) = fill(1E-2, Medium.nC)
    "Nominal value of zone air trace substances. (Set to typical order of magnitude.)"
   annotation (Dialog(tab="Initialization", enable=Medium.nC > 0));

  ////////////////////////////////////////////////////////////////////////////
  // Input connectors
  Modelica.Blocks.Interfaces.RealInput uSha[nConExtWin](each min=0, each max=1) if
       haveShade
    "Control signal for the shading device (removed if no shade is present)"
    annotation (Placement(transformation(extent={{-300,160},{-260,200}}),
        iconTransformation(extent={{-232,164},{-200,196}})));

  Modelica.Blocks.Interfaces.RealInput C_flow[Medium.nC] if use_C_flow
    "Trace substance mass flow rate added to the room air. Enable if use_C_flow = true"
    annotation (Placement(transformation(extent={{-300,-130},{-260,-90}}),
        iconTransformation(extent={{-232,12},{-200,44}})));

equation
  connect(uSha, conExtWin.uSha) annotation (Line(
      points={{-280,180},{308,180},{308,62},{281,62}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(uSha, bouConExtWin.uSha) annotation (Line(
      points={{-280,180},{308,180},{308,64},{351,64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(uSha, conExtWinRad.uSha) annotation (Line(
      points={{-280,180},{422,180},{422,-40},{310.2,-40},{310.2,-25.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(irRadGai.uSha,uSha)
    annotation (Line(
      points={{-100.833,-22.5},{-110,-22.5},{-110,180},{-280,180}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(uSha, radTem.uSha) annotation (Line(
      points={{-280,180},{-110,180},{-110,-62},{-100.833,-62},{-100.833,-62.5}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(uSha, shaSig.u) annotation (Line(
      points={{-280,180},{-248,180},{-248,160},{-222,160}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(air.uSha,uSha)  annotation (Line(
      points={{39.6,-120},{8,-120},{8,180},{-280,180}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(C_flow, air.C_flow) annotation (Line(points={{-280,-110},{-200,-110},{
          -200,-114},{-200,-114},{-200,-202},{-18,-202},{-18,-141},{39,-141}},
        color={0,0,127}));
  annotation (
    Documentation(info="<html>
<p>
Room model that assumes the air to be completely mixed.
</p>
<p>
See
<a href=\"modelica://Buildings.ThermalZones.Detailed.UsersGuide\">Buildings.ThermalZones.Detailed.UsersGuide</a>
for detailed explanations.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 8, 2017, by Michael Wetter:<br/>
Enabled input connector <code>C_flow</code> to allow adding trace substances.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/481\">issue 481</a>.
</li>
<li>
October 29, 2016, by Michael Wetter:<br/>
Removed inheritance from
<a href=\"modelica://Buildings.Fluid.Interfaces.LumpedVolumeDeclarations\">
Buildings.Fluid.Interfaces.LumpedVolumeDeclarations</a>
to provide better comments.
</li>
<li>
May 2, 2016, by Michael Wetter:<br/>
Refactored implementation of latent heat gain.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/515\">issue 515</a>.
</li>
<li>
February 12, 2015, by Michael Wetter:<br/>
Propagated initial states to the fluid volume.
</li>
<li>
August 1, 2013, by Michael Wetter:<br/>
Introduced base class
<a href=\"modelica://Buildings.ThermalZones.Detailed.BaseClasses.RoomHeatMassBalance\">
Buildings.ThermalZones.Detailed.BaseClasses.RoomHeatMassBalance</a>
as the latent heat gains are treated differently in the mixed air and in the CFD model.
</li>
<li>
July 16, 2013, by Michael Wetter:<br/>
Redesigned implementation to remove one level of model hierarchy on the room-side heat and mass balance.
This change was done to facilitate the implementation of non-uniform room air heat and mass balance,
which required separating the convection and long-wave radiation models.<br/>
Changed assignment
<code>solRadExc(tauGla={0.6 for i in 1:NConExtWin})</code> to
<code>solRadExc(tauGla={datConExtWin[i].glaSys.glass[datConExtWin[i].glaSys.nLay].tauSol for i in 1:NConExtWin})</code> to
better take into account the solar properties of the glass.
</li>
<li>
March 7 2012, by Michael Wetter:<br/>
Added optional parameters <code>ove</code> and <code>sidFin</code> to
the parameter <code>datConExtWin</code>.
This allows modeling windows with an overhang or with side fins.
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
December 12, 2011, by Wangda Zuo:<br/>
Add glass thickness as a parameter for conExtWinRad. It is needed by the claculation of property for uncoated glass.
</li>
<li>
December 6, 2011, by Michael Wetter:<br/>
Fixed bug that caused convective heat gains to be
removed from the room instead of added to the room.
This error was caused by a wrong sign in
<a href=\"modelica://Buildings.ThermalZones.Detailed.BaseClasses.HeatGain\">
Buildings.ThermalZones.Detailed.BaseClasses.HeatGain</a>.
This closes ticket <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/46\">issue 46</a>.
</li>
<li>
August 9, 2011, by Michael Wetter:<br/>
Fixed bug that caused too high a surface temperature of the window frame.
The previous version did not compute the infrared radiation exchange between the
window frame and the sky. This has been corrected by adding the instance
<code>skyRadExcWin</code> and the parameter <code>absIRFra</code> to the
model
<a href=\"modelica://Buildings.ThermalZones.Detailed.BaseClasses.ExteriorBoundaryConditionsWithWindow\">
Buildings.ThermalZones.Detailed.BaseClasses.ExteriorBoundaryConditionsWithWindow</a>.
This closes ticket <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/36\">issue 36</a>.
</li>
<li>
August 9, 2011 by Michael Wetter:<br/>
Changed assignment of tilt in instances <code>bouConExt</code> and <code>bouConExtWin</code>.
This fixes the bug in <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/35\">issue 35</a>
that led to the wrong solar radiation gain for roofs and floors.
</li>
<li>
March 23, 2011, by Michael Wetter:<br/>
Propagated convection model to exterior boundary condition models.
</li>
<li>
December 14, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,-200},
            {200,200}}), graphics={
        Text(
          extent={{-198,198},{-122,166}},
          lineColor={0,0,127},
          textString="uSha"),
        Text(
          extent={{-190,44},{-128,14}},
          lineColor={0,0,127},
          textString="C_flow",
          visible=use_C_flow)}));
end MixedAir;

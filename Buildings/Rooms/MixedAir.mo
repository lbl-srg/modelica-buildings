within Buildings.Rooms;
model MixedAir "Model of a room in which the air is completely mixed"
  extends Buildings.Rooms.BaseClasses.RoomHeatMassBalance(
  redeclare Buildings.Rooms.BaseClasses.MixedAirHeatMassBalance air(
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
    final hFixed=hIntFixed),
    datConExt(
    each T_a_start =         T_start,
    each T_b_start =         T_start),
    datConExtWin(
    each T_a_start =            T_start,
    each T_b_start =            T_start),
    datConBou(
    each T_a_start =         T_start,
    each T_b_start =         T_start),
    datConPar(
    each T_a_start =         T_start,
    each T_b_start =         T_start));
  extends Buildings.Fluid.Interfaces.LumpedVolumeDeclarations;

protected
  Buildings.Rooms.BaseClasses.MixedAirHeatGain heaGai(
    redeclare package Medium = Medium, final AFlo=AFlo)
    "Model to convert internal heat gains"
    annotation (Placement(transformation(extent={{-220,90},{-200,110}})));

public
  Modelica.Blocks.Interfaces.RealInput uSha[nConExtWin](each min=0, each max=1) if
       haveShade
    "Control signal for the shading device (removed if no shade is present)"
    annotation (Placement(transformation(extent={{-300,160},{-260,200}}),
        iconTransformation(extent={{-240,140},{-200,180}})));
equation
  connect(heaGai.qGai_flow, qGai_flow) annotation (Line(
      points={{-222,100},{-252,100},{-252,80},{-280,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaGai.QRad_flow, add.u2) annotation (Line(
      points={{-199,106},{-160,106},{-160,114},{-142,114}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaGai.QLat_flow, air.QLat_flow)       annotation (Line(
      points={{-200,94},{-186,94},{-186,-96},{-18,-96},{-18,-134},{40,-134},{40,
          -133}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(air.heaPorAir, heaGai.QCon_flow) annotation (Line(
      points={{40,-130},{-10,-130},{-10,-88},{-180,-88},{-180,100},{-200,100}},
      color={191,0,0},
      smooth=Smooth.None));

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
  annotation (
    Documentation(info="<html>
<p>
Room model that assumes the air to be completely mixed.
</p>
<p>
See
<a href=\"modelica://Buildings.Rooms.UsersGuide\">Buildings.Rooms.UsersGuide</a>
for detailed explanations.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 12, 2015, by Michael Wetter:<br/>
Propagated initial states to the fluid volume.
</li>
<li>
August 1, 2013, by Michael Wetter:<br/>
Introduced base class
<a href=\"modelica://Buildings.Rooms.BaseClasses.RoomHeatMassBalance\">
Buildings.Rooms.BaseClasses.RoomHeatMassBalance</a>
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
<a href=\"modelica://Buildings.Rooms.BaseClasses.HeatGain\">
Buildings.Rooms.BaseClasses.HeatGain</a>.
This closes ticket <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/46\">issue 46</a>.
</li>
<li>
August 9, 2011, by Michael Wetter:<br/>
Fixed bug that caused too high a surface temperature of the window frame.
The previous version did not compute the infrared radiation exchange between the
window frame and the sky. This has been corrected by adding the instance
<code>skyRadExcWin</code> and the parameter <code>absIRFra</code> to the
model
<a href=\"modelica://Buildings.Rooms.BaseClasses.ExteriorBoundaryConditionsWithWindow\">
Buildings.Rooms.BaseClasses.ExteriorBoundaryConditionsWithWindow</a>.
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
</html>"));
end MixedAir;

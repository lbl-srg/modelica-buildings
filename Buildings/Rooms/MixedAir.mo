within Buildings.Rooms;
model MixedAir "Model of a room in which the air is completely mixed"
  extends Buildings.Rooms.BaseClasses.RoomHeatMassBalance(
  redeclare Buildings.Rooms.BaseClasses.MixedAirHeatMassBalance air(
    final energyDynamics=energyDynamics,
    final massDynamics = massDynamics,
    final m_flow_nominal=m_flow_nominal,
    final homotopyInitialization=homotopyInitialization,
    final conMod=intConMod,
    final hFixed=hIntFixed));
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
      pattern=LinePattern.None,
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
August 1, 2013, by Michael Wetter:<br/>
Introduced base class
<a href=\"modelica://Buildings.Rooms.BaseClasses.RoomHeatMassBalance\">
Buildings.Rooms.BaseClasses.RoomHeatMassBalance</a>
as the latent heat gains are treated differently in the mixed air and in the CFD model.
</li>
</ul>
</html>"));
end MixedAir;

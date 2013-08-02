within Buildings.Rooms;
model MixedAir "Model of a room in which the air is completely mixed"
  extends Buildings.Rooms.BaseClasses.RoomHeatMassBalance(
  redeclare Buildings.Rooms.BaseClasses.MixedAirHeatMassBalance air(
    final m_flow_nominal=m_flow_nominal,
    final homotopyInitialization=homotopyInitialization,
    final conMod=intConMod,
    final hFixed=hIntFixed));

protected
  Buildings.Rooms.BaseClasses.MixedAirHeatGain heaGai(
    redeclare package Medium = Medium, final AFlo=AFlo)
    "Model to convert internal heat gains"
    annotation (Placement(transformation(extent={{-220,90},{-200,110}})));

equation
  connect(heaGai.qGai_flow, qGai_flow) annotation (Line(
      points={{-222,100},{-280,100}},
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

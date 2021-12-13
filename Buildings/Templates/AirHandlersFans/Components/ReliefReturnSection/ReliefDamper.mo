within Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection;
model ReliefDamper "Modulating relief damper without fan"
  extends
    Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.Interfaces.PartialReliefReturnSection(
    final typ=Buildings.Templates.AirHandlersFans.Types.ReliefReturnSection.ReliefDamper,
    final typDamRel=damRel.typ,
    final typFanRel=Buildings.Templates.Components.Types.Fan.None,
    final typFanRet=Buildings.Templates.Components.Types.Fan.None);

  Buildings.Templates.Components.Dampers.Modulating damRel(
    redeclare final package Medium = MediumAir,
    final m_flow_nominal=m_flow_nominal,
    final dpDamper_nominal=dpDamRel_nominal,
    final text_flip=true,
    typBla=Buildings.Templates.Components.Types.DamperBlades.Opposed)
    "Relief damper" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-150,0})));
equation
  /* Control point connection - start */
  connect(damRel.bus, bus.damRel);
  /* Control point connection - end */
  connect(port_b, damRel.port_b)
    annotation (Line(points={{-180,0},{-160,0}}, color={0,127,255}));
  connect(splEco.port_1, port_a)
    annotation (Line(points={{10,0},{180,0}}, color={0,127,255}));
  connect(damRel.port_a, splEco.port_2)
    annotation (Line(points={{-140,0},{-10,0}}, color={0,127,255}));
  annotation (Documentation(info="<html>
<p>
5.16.8 Control of Actuated Relief Dampers without Fans
5.16.8.1 Relief dampers shall be enabled when the associated
supply fan is proven ON, and disabled otherwise.
5.16.8.2 When enabled, use a P-only control loop to
modulate relief dampers to maintain 12 Pa (0.05 in. of water)
building static pressure. Close damper when disabled.
</p>
</html>"), Icon(graphics={
              Line(
          points={{-180,0},{180,0}},
          color={28,108,200},
          thickness=1),
              Line(
          points={{0,0},{0,-140}},
          color={28,108,200},
          thickness=1)}));
end ReliefDamper;

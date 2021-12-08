within Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection;
model ReliefFan "Relief fan with two-position relief damper"
  extends
    Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.Interfaces.PartialReliefReturnSection(
    final typ=Buildings.Templates.AirHandlersFans.Types.ReliefReturnSection.ReliefFan,
    final typDamRel=damRel.typ,
    final typFanRel=fanRel.typ,
    final typFanRet=Buildings.Templates.Components.Types.Fan.None);

  Buildings.Templates.Components.Dampers.TwoPosition damRel(
    redeclare final package Medium = MediumAir,
    final m_flow_nominal=m_flow_nominal,
    final dpDamper_nominal=dpDamRel_nominal,
    final text_flip=true)
    "Relief damper"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-150,0})));
  replaceable Buildings.Templates.Components.Fans.SingleVariable fanRel
    constrainedby Buildings.Templates.Components.Fans.Interfaces.PartialFan(
    redeclare final package Medium = MediumAir,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=dpFan_nominal,
    final have_senFlo=false,
    final text_flip=true,
    typSin=Buildings.Templates.Components.Types.FanSingle.Propeller)
    "Relief fan"
    annotation (choices(choice(redeclare replaceable
          Buildings.Templates.Components.Fans.SingleVariable fanRet
          "Single fan - Variable speed"), choice(redeclare replaceable
          Buildings.Templates.Components.MultipleVariable fanRet
          "Multiple fans (identical) - Variable speed")), Placement(
        transformation(extent={{-100,-10},{-120,10}})));
equation
  /* Control point connection - start */
  connect(fanRel.bus, bus.fanRet);
  connect(damRel.bus, bus.damRel);
  /* Control point connection - end */
  connect(port_b, damRel.port_b)
    annotation (Line(points={{-180,0},{-160,0}}, color={0,127,255}));
  connect(damRel.port_a, fanRel.port_b)
    annotation (Line(points={{-140,0},{-120,0}}, color={0,127,255}));
  connect(fanRel.port_a, splEco.port_2)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(port_a, splEco.port_1)
    annotation (Line(points={{180,0},{10,0}}, color={0,127,255}));
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
end ReliefFan;

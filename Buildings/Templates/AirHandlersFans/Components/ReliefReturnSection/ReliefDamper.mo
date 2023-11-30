within Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection;
model ReliefDamper "Modulating relief damper without fan"
  extends
    Buildings.Templates.AirHandlersFans.Components.Interfaces.PartialReliefReturnSection(
    final typ=Buildings.Templates.AirHandlersFans.Types.ReliefReturnSection.ReliefDamper,
    final typDamRel=damRel.typ,
    final typFanRel=Buildings.Templates.Components.Types.Fan.None,
    final typFanRet=Buildings.Templates.Components.Types.Fan.None,
    final nFanRel=0,
    final nFanRet=0);

  Buildings.Templates.Components.Dampers.Modulating damRel(
    redeclare final package Medium = MediumAir,
    use_inputFilter=energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState,
    final allowFlowReversal=allowFlowReversal,
    final dat=dat.damRel,
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
  connect(damRel.port_a, splEco.port_2)
    annotation (Line(points={{-140,0},{-10,0}}, color={0,127,255}));
  connect(splEco.port_1, port_a)
    annotation (Line(points={{10,0},{180,0}}, color={0,127,255}));
  annotation (Documentation(info="<html>
<p>
This model represents a configuration with an air economizer
and an actuated relief damper (modulating) without fan.
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

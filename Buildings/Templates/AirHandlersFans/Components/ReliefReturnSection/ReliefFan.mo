within Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection;
model ReliefFan "Relief fan with two-position relief damper"
  extends
    Buildings.Templates.AirHandlersFans.Components.Interfaces.PartialReliefReturnSection(
    final typ=Buildings.Templates.AirHandlersFans.Types.ReliefReturnSection.ReliefFan,
    final typDamRel=damRel.typ,
    final typFanRel=fanRel.typ,
    final typFanRet=Buildings.Templates.Components.Types.Fan.None,
    final nFanRel=fanRel.nFan,
    final nFanRet=0);

  Buildings.Templates.Components.Dampers.TwoPosition damRel(
    redeclare final package Medium = MediumAir,
    use_inputFilter=energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState,
    final allowFlowReversal=allowFlowReversal,
    final dat=dat.damRel,
    final text_flip=true)
    "Relief damper"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-150,0})));
  replaceable Buildings.Templates.Components.Fans.SingleVariable fanRel
    constrainedby Buildings.Templates.Components.Interfaces.PartialFan(
    redeclare final package Medium = MediumAir,
    final dat=dat.fanRel,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    final have_senFlo=false,
    final text_flip=true,
    typSin=Buildings.Templates.Components.Types.FanSingle.Propeller)
    "Relief fan"
    annotation (choices(
      choice(redeclare replaceable Buildings.Templates.Components.Fans.SingleVariable fanRet
        "Single fan - Variable speed"),
      choice(redeclare replaceable Buildings.Templates.Components.Fans.ArrayVariable fanRet
        "Fan array - Variable speed")), Placement(
        transformation(extent={{-100,-10},{-120,10}})));
equation
  /* Control point connection - start */
  connect(fanRel.bus, bus.fanRel);
  connect(damRel.bus, bus.damRel);
  /* Control point connection - end */
  connect(port_b, damRel.port_b)
    annotation (Line(points={{-180,0},{-160,0}}, color={0,127,255}));
  connect(damRel.port_a, fanRel.port_b)
    annotation (Line(points={{-140,0},{-120,0}}, color={0,127,255}));
  connect(fanRel.port_a, splEco.port_2)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(splEco.port_1, port_a)
    annotation (Line(points={{10,0},{180,0}}, color={0,127,255}));
  annotation (Documentation(info="<html>
<p>
This model represents a configuration with an air economizer
and a relief fan with an actuated relief damper (two-position).
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

within Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection;
model NoReturn "No return branch"
  extends
    Buildings.Templates.AirHandlersFans.Components.Interfaces.PartialReliefReturnSection(
    final typ=Buildings.Templates.AirHandlersFans.Types.ReliefReturnSection.NoReturn,
    final typDamRel=damRel.typ,
    final typFanRel=Buildings.Templates.Components.Types.Fan.None,
    final typFanRet=fanRet.typ);

  Buildings.Templates.Components.Actuators.Damper damRel(
    redeclare final package Medium = MediumAir,
    final typ=Buildings.Templates.Components.Types.Damper.TwoPosition,
    final dat=dat.damRel,
    use_inputFilter=energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState,
    final allowFlowReversal=allowFlowReversal,
    final text_flip=true)
    "Relief damper"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-150,0})));
  replaceable Buildings.Templates.Components.Fans.SingleVariable fanRet
    constrainedby Buildings.Templates.Components.Interfaces.PartialFan(
      redeclare final package Medium = MediumAir,
      final dat=dat.fanRet,
      final energyDynamics=energyDynamics,
      final allowFlowReversal=allowFlowReversal,
      final have_senFlo=
        typCtlFanRet==Buildings.Templates.AirHandlersFans.Types.ControlFanReturn.AirflowMeasured,
      final text_flip=true)
    "Return fan"
    annotation (choices(choice(redeclare replaceable
      Buildings.Templates.Components.Fans.SingleVariable fanRet
      "Single fan - Variable speed"), choice(redeclare replaceable
      Buildings.Templates.Components.Fans.ArrayVariable fanRet
      "Fan array - Variable speed")),
      Placement(
    transformation(extent={{70,-10},{50,10}})));

equation
  /* Control point connection - start */
  connect(fanRet.bus, bus.fanRet);
  connect(damRel.bus, bus.damRel);
  /* Control point connection - end */
  connect(port_b, damRel.port_b)
    annotation (Line(points={{-180,0},{-160,0}}, color={0,127,255}));
  connect(damRel.port_a, splEco.port_2)
    annotation (Line(points={{-140,0},{-10,0}}, color={0,127,255}));
  connect(splEco.port_1, fanRet.port_b)
    annotation (Line(points={{10,0},{50,0}}, color={0,127,255}));
  connect(fanRet.port_a, port_a)
    annotation (Line(points={{70,0},{180,0}}, color={0,127,255}));
  annotation (Documentation(info="<html>
<p>
This model represents a configuration with no air economizer
for 100% outdoor air applications (such as DOAS).
</p>
</html>"), Icon(graphics={
              Line(
          points={{-180,0},{180,0}},
          color={28,108,200},
          thickness=1)}));
end NoReturn;

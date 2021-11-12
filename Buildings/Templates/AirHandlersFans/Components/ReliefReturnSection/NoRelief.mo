within Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection;
model NoRelief "No relief branch"
  extends
    Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.Interfaces.PartialReliefReturnSection(
    final typ=Types.ReliefReturnSection.NoRelief,
    final typDamRel=Buildings.Templates.Components.Types.Damper.None,
    final typFanRel=Buildings.Templates.Components.Types.Fan.None,
    final typFanRet=fanRet.typ,
    have_recHea=false);

  replaceable .Buildings.Templates.Components.Fans.None fanRet constrainedby
    Buildings.Templates.Components.Fans.Interfaces.PartialFan(
                                                  redeclare final package
      Medium = MediumAir, final loc=Buildings.Templates.Components.Types.Location.Return)
    "Return fan"        annotation (
    choices(
      choice(redeclare Templates.BaseClasses.Fans.None fanRet "No fan"),
      choice(redeclare Templates.BaseClasses.Fans.SingleVariable fanRet
          "Single fan - Variable speed"),
      choice(redeclare Templates.BaseClasses.Fans.MultipleVariable fanRet
          "Multiple fans (identical) - Variable speed")),
    Dialog(group="Exhaust/relief/return section"),
    Placement(transformation(extent={{130,-10},{110,10}})));
  Buildings.Templates.Components.Sensors.DifferentialPressure pRet_rel(
    redeclare final package Medium = MediumAir,
    final have_sen=fanRet.typCtr == Types.ReturnFanControlSensor.Pressure,
    final loc=Buildings.Templates.Components.Types.Location.Return)
    "Return static pressure sensor"
    annotation (Placement(transformation(extent={{50,-50},{70,-30}})));

  Buildings.Templates.Components.Sensors.VolumeFlowRate VRet_flow(
    redeclare final package Medium = MediumAir,
    final have_sen,
    final loc=Buildings.Templates.Components.Types.Location.Return)
    "Return air volume flow rate sensor"
    annotation (Placement(transformation(extent={{90,-10},{70,10}})));
equation
  /* Hardware point connection - start */
  connect(fanRet.bus, bus.fanRet);
  connect(VRet_flow.y, bus.VRet_flow);
   connect(pRet_rel.y, bus.pRet_rel);
  /* Hardware point connection - end */
  connect(port_a, fanRet.port_a)
    annotation (Line(points={{180,0},{130,0}}, color={0,127,255}));
  connect(fanRet.port_b, VRet_flow.port_a)
    annotation (Line(points={{110,0},{90,0}},color={0,127,255}));
  connect(VRet_flow.port_b, port_bRet)
    annotation (Line(points={{70,0},{0,0},{0,-140}}, color={0,127,255}));
  connect(pRet_rel.port_b, port_bPre)
    annotation (Line(points={{70,-40},{80,-40},{80,-140}}, color={0,127,255}));
  connect(VRet_flow.port_b, pRet_rel.port_a) annotation (Line(points={{70,0},{
          40,0},{40,-40},{50,-40}}, color={0,127,255}));
  annotation (Icon(graphics={
              Line(
          points={{0,0},{180,0}},
          color={28,108,200},
          thickness=1),
              Line(
          points={{0,0},{0,-140}},
          color={28,108,200},
          thickness=1)}));
end NoRelief;

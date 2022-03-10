within Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection;
model NoRelief "No relief branch"
  extends
    Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.Interfaces.PartialReliefReturnSection(
    final typ=Buildings.Templates.AirHandlersFans.Types.ReliefReturnSection.NoRelief,
    final typDamRel=Buildings.Templates.Components.Types.Damper.None,
    final typFanRel=Buildings.Templates.Components.Types.Fan.None,
    final typFanRet=fanRet.typ);

  replaceable Buildings.Templates.Components.Fans.None fanRet
    constrainedby Buildings.Templates.Components.Fans.Interfaces.PartialFan(
      redeclare final package Medium = MediumAir,
      final dat=dat.fanRet,
      final have_senFlo=
        typCtlFanRet==Buildings.Templates.AirHandlersFans.Types.ControlFanReturn.AirflowTracking,
      final text_flip=true)
    "Return fan"
    annotation (
    choices(
      choice(redeclare replaceable Buildings.Templates.Components.Fans.None fanRet
        "No fan"),
      choice(redeclare replaceable Buildings.Templates.Components.Fans.SingleVariable fanRet
        "Single fan - Variable speed"),
      choice(redeclare replaceable Buildings.Templates.Components.Fans.ArrayVariable fanRet
        "Fan array - Variable speed")),
    Dialog(group="Exhaust/relief/return section"),
    Placement(transformation(extent={{70,-10},{50,10}})));

equation
  /* Control point connection - start */
  connect(fanRet.bus, bus.fanRet);
  /* Control point connection - end */
  connect(port_a, fanRet.port_a)
    annotation (Line(points={{180,0},{70,0}},  color={0,127,255}));
  connect(fanRet.port_b, splEco.port_1)
    annotation (Line(points={{50,0},{10,0}}, color={0,127,255}));
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

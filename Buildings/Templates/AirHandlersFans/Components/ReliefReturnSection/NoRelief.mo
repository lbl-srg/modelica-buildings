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
      final m_flow_nominal=m_flow_nominal,
      final dp_nominal=dpFan_nominal,
      final have_senFlo=
        typCtrFanRet==Buildings.Templates.AirHandlersFans.Types.ControlFanReturn.Airflow,
      final text_flip=true)
    "Return fan"
    annotation (
    choices(
      choice(redeclare replaceable Buildings.Templates.Components.Fans.None fanRet
        "No fan"),
      choice(redeclare replaceable Buildings.Templates.Components.Fans.SingleVariable fanRet
        "Single fan - Variable speed"),
      choice(redeclare replaceable Buildings.Templates.Components.Fans.MultipleVariable fanRet
        "Multiple fans (identical) - Variable speed")),
    Dialog(group="Exhaust/relief/return section"),
    Placement(transformation(extent={{70,-10},{50,10}})));

  Buildings.Templates.Components.Sensors.DifferentialPressure pRet_rel(
    redeclare final package Medium = MediumAir,
    final have_sen=typCtrFanRet==Buildings.Templates.AirHandlersFans.Types.ControlFanReturn.Pressure,
    final m_flow_nominal=m_flow_nominal) "Return static pressure sensor"
    annotation (Placement(transformation(extent={{50,30},{70,50}})));

equation
  /* Control point connection - start */
  connect(fanRet.bus, bus.fanRet);
   connect(pRet_rel.y, bus.pRet_rel);
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

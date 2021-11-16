within Buildings.Templates.AirHandlersFans.Components.OutdoorReliefReturnSection;
model Economizer "Air economizer"
  extends
    Buildings.Templates.AirHandlersFans.Components.OutdoorReliefReturnSection.Interfaces.PartialOutdoorReliefReturnSection(
    final typ=Buildings.Templates.AirHandlersFans.Types.OutdoorReliefReturnSection.Economizer,
    final typSecOut=secOut.typ,
    final typSecRel=secRel.typ,
    final typDamOut=secOut.typDamOut,
    final typDamOutMin=secOut.typDamOutMin,
    final typDamRel=secRel.typDamRel,
    final typDamRet=damRet.typ,
    final typFanRel=secRel.typFanRel,
    final typFanRet=secRel.typFanRet);

  replaceable
    Buildings.Templates.AirHandlersFans.Components.OutdoorSection.SingleDamper
    secOut constrainedby
    Buildings.Templates.AirHandlersFans.Components.OutdoorSection.Interfaces.PartialOutdoorSection(
      redeclare final package MediumAir = MediumAir,
      final m_flow_nominal=mSup_flow_nominal,
      final mOutMin_flow_nominal=mOutMin_flow_nominal,
      final dpDamOut_nominal=dpDamOut_nominal,
      final dpDamOutMin_nominal=dpDamOutMin_nominal,
      final have_recHea=recHea.typ<>Buildings.Templates.AirHandlersFans.Types.HeatRecovery.None)
    "Outdoor air section"
    annotation (
    choices(
      choice(redeclare Buildings.Templates.AirHandlersFans.Components.OutdoorSection.SingleDamper secOut
          "Single common OA damper (modulated) with AFMS"),
      choice(redeclare Buildings.Templates.AirHandlersFans.Components.OutdoorSection.DedicatedDamperAirflow secOut
          "Dedicated minimum OA damper (modulated) with AFMS"),
      choice(redeclare Buildings.Templates.AirHandlersFans.Components.OutdoorSection.DedicatedDamperPressure secOut
          "Dedicated minimum OA damper (two-position) with differential pressure sensor")),
    Dialog(group="Outdoor air section"),
    Placement(transformation(extent={{-58,-94},{-22,-66}})));

  replaceable
    Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.ReturnFan
    secRel constrainedby
    Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.Interfaces.PartialReliefReturnSection(
      redeclare final package MediumAir = MediumAir,
      final m_flow_nominal=mRet_flow_nominal,
      final dpDamRel_nominal=dpDamRel_nominal,
      final dpFan_nominal=dpFan_nominal,
      final typCtrFanRet=typCtrFanRet,
      final have_recHea=recHea.typ<>Buildings.Templates.AirHandlersFans.Types.HeatRecovery.None)
    "Relief/return air section" annotation (
    choices(
      choice(
        redeclare Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.ReturnFan secRel
          "Return fan - Modulated relief damper"),
      choice(
        redeclare Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.ReliefFan
          secRel
          "Relief fan - Two-position relief damper"),
      choice(
        redeclare  Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.ReliefDamper
          secRel
          "No relief fan - Modulated relief damper")),
    Dialog(group="Exhaust/relief/return section"),
    Placement(transformation(extent={{-18,66},{18,94}})));

  Buildings.Templates.Components.Dampers.Modulated damRet(
    redeclare final package Medium = MediumAir,
    final m_flow_nominal=mRet_flow_nominal,
    final dpDamper_nominal=dpDamRet_nominal)
    "Return air damper"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,0})));

  // Currently only the configuration without heat recovery is supported.
  replaceable Buildings.Templates.AirHandlersFans.Components.HeatRecovery.None recHea
    constrainedby
    Buildings.Templates.AirHandlersFans.Components.HeatRecovery.Interfaces.PartialHeatRecovery(
      redeclare final package MediumAir = MediumAir)
    "Heat recovery"
    annotation (
      Placement(transformation(extent={{-90,-10},{-70,10}})));
equation
  /* Hardware point connection - start */
  connect(damRet.bus, bus.damRet);
  /* Hardware point connection - end */
  connect(port_Rel, secRel.port_b)
    annotation (Line(points={{-180,80},{-18,80}}, color={0,127,255}));
  connect(secRel.port_a, port_Ret)
    annotation (Line(points={{18,80},{180,80}}, color={0,127,255}));
  connect(secRel.port_bRet, damRet.port_a)
    annotation (Line(points={{0,66},{0,10}}, color={0,127,255}));
  connect(port_Out, secOut.port_a)
    annotation (Line(points={{-180,-80},{-58,-80}}, color={0,127,255}));
  connect(secOut.port_b, port_Sup)
    annotation (Line(points={{-22,-80},{180,-80}}, color={0,127,255}));
  connect(damRet.port_b, port_Sup)
    annotation (Line(points={{0,-10},{0,-80},{180,-80}}, color={0,127,255}));
  connect(bus, secRel.bus) annotation (Line(
      points={{0,140},{0,94}},
      color={255,204,51},
      thickness=0.5));
  connect(secOut.bus, bus) annotation (Line(
      points={{-40,-66},{-40,120},{0,120},{0,140}},
      color={255,204,51},
      thickness=0.5));
  connect(secRel.port_bPre, port_bPre) annotation (Line(points={{8,66},{8,40},
          {80,40},{80,140}},              color={0,127,255}));
  connect(recHea.bus, bus) annotation (Line(
      points={{-80,10},{-80,120},{0,120},{0,140}},
      color={255,204,51},
      thickness=0.5));
  connect(recHea.port_aRel, secRel.port_bHeaRec) annotation (Line(points={{-70,6},
          {-60,6},{-60,56},{-4,56},{-4,66}}, color={0,127,255}));
  connect(secRel.port_aHeaRec, recHea.port_bRel) annotation (Line(points={{-8,66},
          {-8,60},{-100,60},{-100,6},{-90,6}}, color={0,127,255}));
  connect(recHea.port_aOut, secOut.port_bHeaRec) annotation (Line(points={{-90,-6},
          {-100,-6},{-100,-60},{-52,-60},{-52,-66}}, color={0,127,255}));
  connect(recHea.port_bOut, secOut.port_aHeaRec) annotation (Line(points={{-70,-6},
          {-60,-6},{-60,-56},{-48,-56},{-48,-66}}, color={0,127,255}));
end Economizer;

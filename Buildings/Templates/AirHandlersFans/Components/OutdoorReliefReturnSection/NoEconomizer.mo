within Buildings.Templates.AirHandlersFans.Components.OutdoorReliefReturnSection;
model NoEconomizer "No air economizer"
  extends
    Buildings.Templates.AirHandlersFans.Components.OutdoorReliefReturnSection.Interfaces.PartialOutdoorReliefReturnSection(
    final typ=Buildings.Templates.AirHandlersFans.Types.OutdoorReliefReturnSection.NoEconomizer,
    final typSecOut=secOut.typ,
    final typSecRel=secRel.typ,
    final typDamOut=secOut.typDamOut,
    final typDamOutMin=secOut.typDamOutMin,
    final typDamRel=secRel.typDamRel,
    final typDamRet=Buildings.Templates.Components.Types.Damper.None,
    final typFanRel=secRel.typFanRel,
    final typFanRet=secRel.typFanRet,
    final have_recHea=recHea.typ<>Buildings.Templates.AirHandlersFans.Types.HeatRecovery.None);

  Buildings.Templates.AirHandlersFans.Components.OutdoorSection.NoEconomizer secOut(
    redeclare final package MediumAir = MediumAir,
    datRec(
      final damOut=datRec.damOut,
      final damOutMin=datRec.damOutMin))
    "Outdoor air section"
    annotation (
    Dialog(group="Outdoor air section"),
    Placement(transformation(extent={{-58,-94},{-22,-66}})));
  Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.NoEconomizer secRel(
    redeclare final package MediumAir = MediumAir,
    datRec(
      final damRel=datRec.damRel),
    final dpFan_nominal=dpFan_nominal)
    "Relief/return air section"
    annotation (
    Dialog(group="Exhaust/relief/return section"),
    Placement(transformation(extent={{-18,66},{18,94}})));

  // Currently only the configuration without heat recovery is supported.
  replaceable Buildings.Templates.AirHandlersFans.Components.HeatRecovery.None recHea
    constrainedby
    Buildings.Templates.AirHandlersFans.Components.HeatRecovery.Interfaces.PartialHeatRecovery(
      redeclare final package MediumAir = MediumAir)
    "Heat recovery"
    annotation (
      Placement(transformation(extent={{-90,-10},{-70,10}})));
equation
  /* Control point connection - start */
  /* Control point connection - end */
  connect(port_Rel, secRel.port_b)
    annotation (Line(points={{-180,80},{-18,80}}, color={0,127,255}));
  connect(secRel.port_a, port_Ret)
    annotation (Line(points={{18,80},{180,80}}, color={0,127,255}));
  connect(port_Out, secOut.port_a)
    annotation (Line(points={{-180,-80},{-58,-80}}, color={0,127,255}));
  connect(secOut.port_b, port_Sup)
    annotation (Line(points={{-22,-80},{180,-80}}, color={0,127,255}));
  connect(bus, secRel.bus) annotation (Line(
      points={{0,140},{0,94}},
      color={255,204,51},
      thickness=0.5));
  connect(secOut.bus, bus) annotation (Line(
      points={{-40,-66},{-40,120},{0,120},{0,140}},
      color={255,204,51},
      thickness=0.5));
  connect(secRel.port_bPre, port_bPre) annotation (Line(points={{8,66},{8,60},{80,
          60},{80,140}},                  color={0,127,255}));
  connect(recHea.bus, bus) annotation (Line(
      points={{-80,10},{-80,120},{0,120},{0,140}},
      color={255,204,51},
      thickness=0.5));
  connect(recHea.port_aRel, secRel.port_bHeaRec) annotation (Line(points={{-70,6},
          {-60,6},{-60,56},{-4,56},{-4,66}}, color={0,127,255}));
  connect(secRel.port_aHeaRec, recHea.port_bRel) annotation (Line(points={{-8,66},
          {-8,60},{-100,60},{-100,6},{-90,6}}, color={0,127,255}));
  connect(recHea.port_aOut, secOut.port_bHeaRec) annotation (Line(points={{-90,-6},
          {-100,-6},{-100,-60},{-48,-60},{-48,-66}}, color={0,127,255}));
  connect(recHea.port_bOut, secOut.port_aHeaRec) annotation (Line(points={{-70,-6},
          {-60,-6},{-60,-56},{-44,-56},{-44,-66}}, color={0,127,255}));
end NoEconomizer;

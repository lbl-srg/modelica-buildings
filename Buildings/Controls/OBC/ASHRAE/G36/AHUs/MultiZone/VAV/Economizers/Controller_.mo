within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Economizers;
block Controller_
  Subsequences.LimitsPa.SeparateWithAFMS sepAFMS if have_separateDamper_AFMS
    "Damper position limits for units with separated minimum outdoor air damper and airflow measurement"
    annotation (Placement(transformation(extent={{-200,200},{-180,220}})));
  Subsequences.LimitsPa.SeparateWithDP sepDp if have_separateDamper_DP
    "Damper position limits for units with separated minimum outdoor air damper and differential pressure control"
    annotation (Placement(transformation(extent={{-200,140},{-180,160}})));
  Subsequences.LimitsPa.Common damLim if have_commonDamper
    annotation (Placement(transformation(extent={{-200,80},{-180,100}})));
  Subsequences.Enable enaDis
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Subsequences.Modulations.ReturnFan modRet
    "Modulate economizer dampers position for buildings with return fan controlling pressure"
    annotation (Placement(transformation(extent={{40,140},{60,160}})));
  Subsequences.Modulations.Reliefs modRel
    "Modulate economizer dampers position for buildings with relief damper or fan controlling pressure"
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  CDL.Interfaces.RealInput VOutMinSet_flow_normalized
    "Effective minimum outdoor airflow setpoint, normalized by design minimum outdoor airflow rate"
    annotation (Placement(transformation(extent={{-340,280},{-300,320}}),
        iconTransformation(extent={{-326,220},{-286,260}})));
  CDL.Interfaces.RealInput VOut_flow_normalized
    "Measured outdoor volumetric airflow rate, normalized by design minimum outdoor airflow rate"
    annotation (Placement(transformation(extent={{-340,240},{-300,280}}),
        iconTransformation(extent={{-322,192},{-282,232}})));
  CDL.Interfaces.BooleanInput                        uSupFan
    "Supply fan status"
    annotation (Placement(transformation(extent={{-340,-120},{-300,-80}}),
        iconTransformation(extent={{-326,58},{-286,98}})));
  CDL.Interfaces.IntegerInput                        uOpeMod
    "AHU operation mode status signal"
    annotation (Placement(transformation(extent={{-340,-150},{-300,-110}}),
        iconTransformation(extent={{-326,28},{-286,68}})));
  CDL.Interfaces.IntegerInput                        uFreProSta
    "Freeze protection status"
    annotation (Placement(transformation(extent={{-340,-190},{-300,-150}}),
        iconTransformation(extent={{-326,-12},{-286,28}})));
  CDL.Interfaces.RealInput uOutDamPos "Economizer outdoor air damper position"
    annotation (Placement(transformation(extent={{-340,200},{-300,240}}),
        iconTransformation(extent={{-318,156},{-278,196}})));
  CDL.Interfaces.RealInput uSupFanSpe "Supply fan speed" annotation (Placement(
        transformation(extent={{-340,170},{-300,210}}), iconTransformation(
          extent={{-310,138},{-270,178}})));
  CDL.Interfaces.RealInput dpMinOutDam
    "Measured pressure difference across the minimum outdoor air damper"
    annotation (Placement(transformation(extent={{-340,130},{-300,170}}),
        iconTransformation(extent={{-310,140},{-270,180}})));
  CDL.Interfaces.RealInput                        TOut(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Outdoor air (OA) temperature"
    annotation (Placement(transformation(extent={{-340,20},{-300,60}}),
        iconTransformation(extent={{-270,-28},{-230,12}})));
  CDL.Interfaces.RealInput                        TOutCut(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "OA temperature high limit cutoff. For differential dry bulb temeprature condition use return air temperature measurement"
    annotation (Placement(transformation(extent={{-340,-10},{-300,30}}),
        iconTransformation(extent={{-270,-58},{-230,-18}})));
  CDL.Interfaces.RealInput                        hOut(final unit="J/kg",
      final quantity="SpecificEnergy") if
                                        use_enthalpy "Outdoor air enthalpy"
    annotation (Placement(transformation(extent={{-340,-50},{-300,-10}}),
        iconTransformation(extent={{-270,-88},{-230,-48}})));
  CDL.Interfaces.RealInput                        hOutCut(final unit="J/kg",
      final quantity="SpecificEnergy") if
                                        use_enthalpy
    "OA enthalpy high limit cutoff. For differential enthalpy use return air enthalpy measurement"
    annotation (Placement(transformation(extent={{-340,-80},{-300,-40}}),
        iconTransformation(extent={{-270,-108},{-230,-68}})));
  CDL.Interfaces.RealInput                        uTSup(final unit="1")
    "Signal for supply air temperature control (T Sup Control Loop Signal in diagram)"
    annotation (Placement(transformation(extent={{-340,90},{-300,130}}),
        iconTransformation(extent={{-206,-46},{-166,-6}})));
  Generic.FreezeProtectionMixedAir                                   freProTMix(
    final controllerType=controllerTypeFre,
    final TFreSet=TFreSet,
    final k=kFre,
    final Ti=TiFre,
    final Td=TdFre) if use_TMix
    "Block that tracks TMix against a freeze protection setpoint"
    annotation (Placement(transformation(extent={{100,20},{120,40}})));
  CDL.Interfaces.RealOutput                        yRetDamPos(
    final min=0,
    final max=1,
    final unit="1") "Return air damper position"
    annotation (Placement(transformation(extent={{200,60},{240,100}}),
        iconTransformation(extent={{558,-122},{598,-82}})));
  CDL.Interfaces.RealOutput                        yOutDamPos(
    final min=0,
    final max=1,
    final unit="1") "Outdoor air damper position"
    annotation (Placement(transformation(extent={{200,-20},{240,20}}),
        iconTransformation(extent={{558,-202},{598,-162}})));
  CDL.Interfaces.RealInput                        TMix(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") if   use_TMix
    "Measured mixed air temperature, used for freeze protection"
    annotation (Placement(transformation(extent={{-340,50},{-300,90}}),
        iconTransformation(extent={{-162,-94},{-122,-54}})));
protected
  CDL.Continuous.Min                        outDamMaxFre
    "Maximum control signal for outdoor air damper due to freeze protection"
    annotation (Placement(transformation(extent={{160,-10},{180,10}})));
  CDL.Continuous.Max                        retDamMinFre
    "Minimum position for return air damper due to freeze protection"
    annotation (Placement(transformation(extent={{160,70},{180,90}})));
  CDL.Continuous.Sources.Constant                        noTMix(k=0) if not use_TMix
    "Ignore max evaluation if there is no mixed air temperature sensor"
    annotation (Placement(transformation(extent={{100,90},{120,110}})));
  CDL.Continuous.Sources.Constant                        noTMix1(k=1) if not use_TMix
    "Ignore min evaluation if there is no mixed air temperature sensor"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
protected
  CDL.Continuous.MovingMean                        movAve(final delta=delta)
    "Moving average of outdoor air flow measurement, normalized by design minimum outdoor airflow rate"
    annotation (Placement(transformation(extent={{-280,250},{-260,270}})));
equation
  connect(sepAFMS.VOutMinSet_flow_normalized, VOutMinSet_flow_normalized)
    annotation (Line(points={{-202,219},{-220,219},{-220,300},{-320,300}},
        color={0,0,127}));
  connect(sepAFMS.uOutDamPos, uOutDamPos) annotation (Line(points={{-202,204},{
          -232,204},{-232,220},{-320,220}}, color={0,0,127}));
  connect(sepAFMS.uSupFanSpe, uSupFanSpe) annotation (Line(points={{-202,201},{
          -238,201},{-238,190},{-320,190}}, color={0,0,127}));
  connect(sepDp.dpMinOutDam, dpMinOutDam) annotation (Line(points={{-202,159},{
          -262,159},{-262,150},{-320,150}}, color={0,0,127}));
  connect(VOutMinSet_flow_normalized, sepDp.VOutMinSet_flow_normalized)
    annotation (Line(points={{-320,300},{-220,300},{-220,156},{-202,156}},
        color={0,0,127}));
  connect(uOutDamPos, sepDp.uOutDamPos) annotation (Line(points={{-320,220},{
          -232,220},{-232,144},{-202,144}}, color={0,0,127}));
  connect(uSupFanSpe, sepDp.uSupFanSpe) annotation (Line(points={{-320,190},{
          -238,190},{-238,141},{-202,141}}, color={0,0,127}));
  connect(uSupFan, sepAFMS.uSupFan) annotation (Line(points={{-320,-100},{-256,
          -100},{-256,213},{-202,213}},color={255,0,255}));
  connect(uSupFan, sepDp.uSupFan) annotation (Line(points={{-320,-100},{-256,
          -100},{-256,153},{-202,153}},
                                  color={255,0,255}));
  connect(uSupFan, damLim.uSupFan) annotation (Line(points={{-320,-100},{-256,
          -100},{-256,90},{-202,90}},color={255,0,255}));
  connect(uFreProSta, sepAFMS.uFreProSta) annotation (Line(points={{-320,-170},
          {-244,-170},{-244,210},{-202,210}}, color={255,127,0}));
  connect(uFreProSta, sepDp.uFreProSta) annotation (Line(points={{-320,-170},{
          -244,-170},{-244,150},{-202,150}}, color={255,127,0}));
  connect(uFreProSta, damLim.uFreProSta) annotation (Line(points={{-320,-170},{
          -244,-170},{-244,86},{-202,86}}, color={255,127,0}));
  connect(uOpeMod, sepAFMS.uOpeMod) annotation (Line(points={{-320,-130},{-250,
          -130},{-250,207},{-202,207}}, color={255,127,0}));
  connect(uOpeMod, sepDp.uOpeMod) annotation (Line(points={{-320,-130},{-250,
          -130},{-250,147},{-202,147}}, color={255,127,0}));
  connect(uOpeMod, damLim.uOpeMod) annotation (Line(points={{-320,-130},{-250,
          -130},{-250,82},{-202,82}}, color={255,127,0}));
  connect(VOutMinSet_flow_normalized, damLim.VOutMinSet_flow_normalized)
    annotation (Line(points={{-320,300},{-220,300},{-220,98},{-202,98}}, color=
          {0,0,127}));
  connect(TOut, enaDis.TOut) annotation (Line(points={{-320,40},{-188,40},{-188,
          0},{-42,0}}, color={0,0,127}));
  connect(TOutCut, enaDis.TOutCut) annotation (Line(points={{-320,10},{-194,10},
          {-194,-2},{-42,-2}}, color={0,0,127}));
  connect(hOut, enaDis.hOut) annotation (Line(points={{-320,-30},{-194,-30},{
          -194,-4},{-42,-4}},
                         color={0,0,127}));
  connect(hOutCut, enaDis.hOutCut) annotation (Line(points={{-320,-60},{-188,
          -60},{-188,-6},{-42,-6}}, color={0,0,127}));
  connect(uSupFan, enaDis.uSupFan) annotation (Line(points={{-320,-100},{-256,
          -100},{-256,-8},{-42,-8}},color={255,0,255}));
  connect(uFreProSta, enaDis.uFreProSta) annotation (Line(points={{-320,-170},{
          -244,-170},{-244,-10},{-42,-10}}, color={255,127,0}));
  connect(damLim.yOutDamPosMin, enaDis.uOutDamPosMin) annotation (Line(points={{-178,98},
          {-140,98},{-140,-14},{-42,-14}},           color={0,0,127}));
  connect(damLim.yOutDamPosMax, enaDis.uOutDamPosMax) annotation (Line(points={{-178,94},
          {-146,94},{-146,-12},{-42,-12}},           color={0,0,127}));
  connect(damLim.yRetDamPosMin, enaDis.uRetDamPosMin) annotation (Line(points={{-178,90},
          {-152,90},{-152,-20},{-42,-20}},           color={0,0,127}));
  connect(damLim.yRetDamPosMax, enaDis.uRetDamPosMax) annotation (Line(points={{-178,86},
          {-158,86},{-158,-18},{-42,-18}},           color={0,0,127}));
  connect(damLim.yRetDamPhyPosMax, enaDis.uRetDamPhyPosMax) annotation (Line(
        points={{-178,82},{-164,82},{-164,-16},{-42,-16}}, color={0,0,127}));
  connect(sepDp.yOutDamPosMin, enaDis.uOutDamPosMin) annotation (Line(points={{
          -178,158},{-100,158},{-100,-14},{-42,-14}}, color={0,0,127}));
  connect(sepDp.yOutDamPosMax, enaDis.uOutDamPosMax) annotation (Line(points={{
          -178,154},{-106,154},{-106,-12},{-42,-12}}, color={0,0,127}));
  connect(sepDp.yRetDamPosMin, enaDis.uRetDamPosMin) annotation (Line(points={{
          -178,150},{-112,150},{-112,-20},{-42,-20}}, color={0,0,127}));
  connect(sepDp.yRetDamPosMax, enaDis.uRetDamPosMax) annotation (Line(points={{
          -178,146},{-118,146},{-118,-18},{-42,-18}}, color={0,0,127}));
  connect(sepDp.yRetDamPhyPosMax, enaDis.uRetDamPhyPosMax) annotation (Line(
        points={{-178,142},{-124,142},{-124,-16},{-42,-16}}, color={0,0,127}));
  connect(sepAFMS.yOutDamPosMin, enaDis.uOutDamPosMin) annotation (Line(points=
          {{-178,215},{-60,215},{-60,-14},{-42,-14}}, color={0,0,127}));
  connect(sepAFMS.yOutDamPosMax, enaDis.uOutDamPosMax) annotation (Line(points=
          {{-178,213},{-66,213},{-66,-12},{-42,-12}}, color={0,0,127}));
  connect(sepAFMS.yRetDamPosMin, enaDis.uRetDamPosMin) annotation (Line(points=
          {{-178,207},{-72,207},{-72,-20},{-42,-20}}, color={0,0,127}));
  connect(sepAFMS.yRetDamPosMax, enaDis.uRetDamPosMax) annotation (Line(points=
          {{-178,205},{-78,205},{-78,-18},{-42,-18}}, color={0,0,127}));
  connect(sepAFMS.yRetDamPhyPosMax, enaDis.uRetDamPhyPosMax) annotation (Line(
        points={{-178,201},{-84,201},{-84,-16},{-42,-16}}, color={0,0,127}));
  connect(uTSup, modRet.uTSup) annotation (Line(points={{-320,110},{-20,110},{
          -20,156},{38,156}}, color={0,0,127}));
  connect(uTSup, modRel.uTSup) annotation (Line(points={{-320,110},{-20,110},{
          -20,90},{38,90}}, color={0,0,127}));
  connect(damLim.yOutDamPosMin, modRel.uOutDamPosMin) annotation (Line(points={
          {-178,98},{-140,98},{-140,81},{38,81}}, color={0,0,127}));
  connect(sepDp.yOutDamPosMin, modRel.uOutDamPosMin) annotation (Line(points={{
          -178,158},{-100,158},{-100,81},{38,81}}, color={0,0,127}));
  connect(sepAFMS.yOutDamPosMin, modRel.uOutDamPosMin) annotation (Line(points=
          {{-178,215},{-60,215},{-60,81},{38,81}}, color={0,0,127}));
  connect(enaDis.yOutDamPosMax, modRel.uOutDamPosMax) annotation (Line(points={
          {-18,-4},{0,-4},{0,85},{38,85}}, color={0,0,127}));
  connect(enaDis.yRetDamPosMax, modRel.uRetDamPosMax) annotation (Line(points={
          {-18,-10},{6,-10},{6,99},{38,99}}, color={0,0,127}));
  connect(enaDis.yRetDamPosMin, modRel.uRetDamPosMin) annotation (Line(points={
          {-18,-16},{12,-16},{12,95},{38,95}}, color={0,0,127}));
  connect(enaDis.yRetDamPosMax, modRet.uRetDamPosMax) annotation (Line(points={
          {-18,-10},{6,-10},{6,150},{38,150}}, color={0,0,127}));
  connect(enaDis.yRetDamPosMin, modRet.uRetDamPosMin) annotation (Line(points={
          {-18,-16},{12,-16},{12,144},{38,144}}, color={0,0,127}));
  connect(retDamMinFre.y,yRetDamPos)
    annotation (Line(points={{182,80},{220,80}}, color={0,0,127}));
  connect(outDamMaxFre.y,yOutDamPos)
    annotation (Line(points={{182,0},{220,0}},     color={0,0,127}));
  connect(outDamMaxFre.u2,noTMix1. y)
    annotation (Line(points={{158,-6},{130,-6},{130,-20},{122,-20}},
                                                   color={0,0,127}));
  connect(retDamMinFre.u1,noTMix. y)
    annotation (Line(points={{158,86},{140,86},{140,100},{122,100}},
                                                color={0,0,127}));
  connect(freProTMix.yFrePro,retDamMinFre. u1)
    annotation (Line(points={{122,27},{140,27},{140,86},{158,86}},   color={0,0,127}));
  connect(freProTMix.yFreProInv,outDamMaxFre. u2)
    annotation (Line(points={{122,33},{130,33},{130,-6},{158,-6}},
      color={0,0,127}));
  connect(TMix, freProTMix.TMix) annotation (Line(points={{-320,70},{-40,70},{
          -40,30},{98,30}}, color={0,0,127}));
  connect(modRet.yRetDamPos, retDamMinFre.u2) annotation (Line(points={{62,156},
          {86,156},{86,74},{158,74}}, color={0,0,127}));
  connect(modRel.yRetDamPos, retDamMinFre.u2) annotation (Line(points={{62,96},
          {86,96},{86,74},{158,74}}, color={0,0,127}));
  connect(modRet.yOutDamPos, outDamMaxFre.u1) annotation (Line(points={{62,144},
          {80,144},{80,6},{158,6}}, color={0,0,127}));
  connect(modRel.yOutDamPos, outDamMaxFre.u1) annotation (Line(points={{62,84},
          {80,84},{80,6},{158,6}}, color={0,0,127}));
  connect(VOut_flow_normalized, movAve.u)
    annotation (Line(points={{-320,260},{-282,260}}, color={0,0,127}));
  connect(movAve.y, sepAFMS.VOut_flow_normalized) annotation (Line(points={{
          -258,260},{-226,260},{-226,216},{-202,216}}, color={0,0,127}));
  connect(movAve.y, damLim.VOut_flow_normalized) annotation (Line(points={{-258,
          260},{-226,260},{-226,94},{-202,94}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-340,
            -360},{340,360}})), Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-340,-360},{340,360}}), graphics={
        Rectangle(
          extent={{96,120},{184,-60}},
          lineColor={215,215,215},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
                                  Text(
          extent={{116,-46},{194,-56}},
          lineColor={95,95,95},
          textString="Freeze protection based on TMix,
not a part of G36",
          horizontalAlignment=TextAlignment.Left),
        Line(points={{156,122}}, color={28,108,200})}));
end Controller_;

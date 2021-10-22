within Buildings.Templates.AirHandlersFans.Components;
package OutdoorReliefReturnSection
  extends Modelica.Icons.Package;

  model Economizer "Air economizer"
    extends Interfaces.OutdoorReliefReturnSection(
      final typ=Types.OutdoorReliefReturnSection.Economizer,
      final have_porPre=secRel.have_porPre,
      final typDamOut=secOut.typDamOut,
      final typDamOutMin=secOut.typDamOutMin,
      final typDamRel=secRel.typDam,
      final typFanRet=secRel.typFan);

    replaceable OutdoorSection.SingleCommon secOut constrainedby
      Interfaces.OutdoorSection(redeclare final package MediumAir = MediumAir,
        final have_recHea=false) "Outdoor air section" annotation (
      choices(
        choice(redeclare BaseClasses.OutdoorSection.SingleCommon secOut
            "Single common OA damper (modulated) with AFMS"),
        choice(redeclare BaseClasses.OutdoorSection.DedicatedAirflow secOut
            "Dedicated minimum OA damper (modulated) with AFMS"),
        choice(redeclare BaseClasses.OutdoorSection.DedicatedPressure secOut
            "Dedicated minimum OA damper (two-position) with differential pressure sensor")),
      Dialog(group="Outdoor air section"),
      Placement(transformation(extent={{-58,-94},{-22,-66}})));

    replaceable
      Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.ReturnFan
      secRel constrainedby Interfaces.ReliefReturnSection(redeclare final
        package MediumAir = MediumAir, final have_recHea=false)
      "Relief/return air section" annotation (
      choices(
        choice(redeclare BaseClasses.ReliefReturnSection.ReturnFan secRel
            "Return fan - Modulated relief damper"),
        choice(redeclare BaseClasses.ReliefReturnSection.ReliefFan secRel
            "Relief fan - Two-position relief damper"),
        choice(redeclare BaseClasses.ReliefReturnSection.ReliefDamper secRel
            "No relief fan - Modulated relief damper")),
      Dialog(group="Exhaust/relief/return section"),
      Placement(transformation(extent={{-18,66},{18,94}})));

    replaceable Buildings.Templates.Components.Dampers.Modulated damRet(
        redeclare final package Medium = MediumAir, final loc=Buildings.Templates.Components.Types.Location.Return)
      "Return air damper" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={0,0})));

  equation
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
    connect(busCon, secRel.busCon) annotation (Line(
        points={{0,140},{0,94}},
        color={255,204,51},
        thickness=0.5));
    connect(secOut.busCon, busCon) annotation (Line(
        points={{-40,-66},{-40,120},{0,120},{0,140}},
        color={255,204,51},
        thickness=0.5));
    connect(damRet.busCon, busCon) annotation (Line(
        points={{10,0},{40,0},{40,120},{0,120},{0,140}},
        color={255,204,51},
        thickness=0.5));
    connect(secRel.port_bPre, port_bPre) annotation (Line(points={{8,66},{8,40},{
            80,40},{80,140}},               color={0,127,255}));
  end Economizer;

  model HeatRecovery "Heat recovery"
    extends Interfaces.OutdoorReliefReturnSection(
      final typ=Types.OutdoorReliefReturnSection.HeatRecovery,
      final have_porPre=secRel.have_porPre,
      final typDamOut=secOut.typDamOut,
      final typDamOutMin=secOut.typDamOutMin,
      final typDamRel=secRel.typDam,
      final typFanRet=secRel.typFan);

    replaceable OutdoorSection.SingleCommon secOut constrainedby
      Interfaces.OutdoorSection(redeclare final package MediumAir = MediumAir,
        final have_recHea=true) "Outdoor air section" annotation (
      choices(
        choice(redeclare BaseClasses.OutdoorSection.SingleCommon secOut
            "Single common OA damper (modulated) with AFMS"),
        choice(redeclare BaseClasses.OutdoorSection.DedicatedAirflow secOut
            "Dedicated minimum OA damper (modulated) with AFMS"),
        choice(redeclare BaseClasses.OutdoorSection.DedicatedPressure secOut
            "Dedicated minimum OA damper (two-position) with differential pressure sensor")),
      Dialog(group="Outdoor air section"),
      Placement(transformation(extent={{-58,-94},{-22,-66}})));

    replaceable
      Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.ReturnFan
      secRel constrainedby Interfaces.ReliefReturnSection(redeclare final
        package MediumAir = MediumAir, final have_recHea=true)
      "Relief/return air section" annotation (
      choices(
        choice(redeclare BaseClasses.ReliefReturnSection.ReturnFan secRel
            "Return fan - Modulated relief damper"),
        choice(redeclare BaseClasses.ReliefReturnSection.ReliefFan secRel
            "Relief fan - Two-position relief damper"),
        choice(redeclare BaseClasses.ReliefReturnSection.ReliefDamper secRel
            "No relief fan - Modulated relief damper")),
      Dialog(group="Exhaust/relief/return section"),
      Placement(transformation(extent={{-18,66},{18,94}})));

    replaceable
      Buildings.Templates.AirHandlersFans.Components.HeatRecovery.None none
      constrainedby Interfaces.HeatRecovery(redeclare final package MediumAir
        = MediumAir) "Heat recovery" annotation (choicesAllMatching=true,
        Placement(transformation(extent={{-50,-10},{-30,10}})));

  equation
    connect(port_Rel, secRel.port_b)
      annotation (Line(points={{-180,80},{-18,80}}, color={0,127,255}));
    connect(secRel.port_a, port_Ret)
      annotation (Line(points={{18,80},{180,80}}, color={0,127,255}));
    connect(port_Out, secOut.port_a)
      annotation (Line(points={{-180,-80},{-58,-80}}, color={0,127,255}));
    connect(secOut.port_b, port_Sup)
      annotation (Line(points={{-22,-80},{180,-80}}, color={0,127,255}));
    connect(busCon, secRel.busCon) annotation (Line(
        points={{0,140},{0,94}},
        color={255,204,51},
        thickness=0.5));
    connect(secOut.busCon, busCon) annotation (Line(
        points={{-40,-66},{-40,-60},{-60,-60},{-60,120},{0,120},{0,140}},
        color={255,204,51},
        thickness=0.5));
    connect(secRel.port_bPre, port_bPre) annotation (Line(points={{8,66},{8,40},{
            80,40},{80,140}},               color={0,127,255}));
    connect(secRel.port_bHeaRec, none.port_aRel)
      annotation (Line(points={{-8,66},{-8,6},{-30,6}}, color={0,127,255}));
    connect(none.busCon, busCon) annotation (Line(
        points={{-40,10},{-40,120},{0,120},{0,140}},
        color={255,204,51},
        thickness=0.5));
    connect(none.port_bRel, secRel.port_aHeaRec) annotation (Line(points={{-50,6},
            {-52,6},{-52,20},{-12,20},{-12,66}}, color={0,127,255}));
    connect(secOut.port_bHeaRec, none.port_aOut) annotation (Line(points={{-52,-66},
            {-52,-36},{-52,-6},{-50,-6}}, color={0,127,255}));
    connect(secOut.port_aHeaRec, none.port_bOut) annotation (Line(points={{-48,-66},
            {-48,-20},{-28,-20},{-28,-6},{-30,-6}}, color={0,127,255}));
  end HeatRecovery;

  model NoRelief " No relief branch"
    extends Interfaces.OutdoorReliefReturnSection(
      final typ=Types.OutdoorReliefReturnSection.NoRelief,
      final have_porPre=secRel.have_porPre,
      final typDamOut=secOut.typDamOut,
      final typDamOutMin=secOut.typDamOutMin,
      final typDamRel=secRel.typDam,
      final typFanRet=secRel.typFan);

    replaceable OutdoorSection.SingleCommon secOut constrainedby
      Interfaces.OutdoorSection(redeclare final package MediumAir = MediumAir,
        final have_recHea=false) "Outdoor air section" annotation (
      choices(
        choice(redeclare BaseClasses.OutdoorSection.SingleCommon secOut
            "Single common OA damper (modulated) with AFMS"),
        choice(redeclare BaseClasses.OutdoorSection.DedicatedAirflow secOut
            "Dedicated minimum OA damper (modulated) with AFMS"),
        choice(redeclare BaseClasses.OutdoorSection.DedicatedPressure secOut
            "Dedicated minimum OA damper (two-position) with differential pressure sensor")),
      Dialog(group="Outdoor air section"),
      Placement(transformation(extent={{-58,-94},{-22,-66}})));

    replaceable
      Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.NoRelief
      secRel(redeclare final package MediumAir = MediumAir, final have_recHea=
          false) "Relief/return air section" annotation (Dialog(group=
            "Exhaust/relief/return section"), Placement(transformation(extent={
              {-18,66},{18,94}})));

    replaceable Buildings.Templates.Components.Dampers.Modulated damRet(
        redeclare final package Medium = MediumAir, final loc=Buildings.Templates.Components.Types.Location.Return)
      "Return air damper" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={0,0})));
  equation
    connect(secRel.port_a, port_Ret)
      annotation (Line(points={{18,80},{180,80}}, color={0,127,255}));
    connect(secRel.port_bRet, damRet.port_a)
      annotation (Line(points={{0,66},{0,10}}, color={0,127,255}));
    connect(damRet.port_b, port_Sup)
      annotation (Line(points={{0,-10},{0,-80},{180,-80}}, color={0,127,255}));
    connect(secOut.port_b, port_Sup)
      annotation (Line(points={{-22,-80},{180,-80}}, color={0,127,255}));
    connect(port_Out, secOut.port_a)
      annotation (Line(points={{-180,-80},{-58,-80}}, color={0,127,255}));
    connect(secOut.busCon, busCon) annotation (Line(
        points={{-40,-66},{-40,120},{0,120},{0,140}},
        color={255,204,51},
        thickness=0.5));
    connect(secRel.busCon, busCon) annotation (Line(
        points={{0,94},{0,140}},
        color={255,204,51},
        thickness=0.5));
    connect(damRet.busCon, busCon) annotation (Line(
        points={{10,-1.77636e-15},{26,-1.77636e-15},{26,0},{40,0},{40,120},{0,120},
            {0,140}},
        color={255,204,51},
        thickness=0.5));
    connect(secRel.port_bPre, port_bPre) annotation (Line(points={{8,66},{8,60},{
            80,60},{80,140}}, color={0,127,255}));
  end NoRelief;
end OutdoorReliefReturnSection;

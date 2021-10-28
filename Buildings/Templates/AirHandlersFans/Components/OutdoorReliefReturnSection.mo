within Buildings.Templates.AirHandlersFans.Components;
package OutdoorReliefReturnSection
  extends Modelica.Icons.Package;

  model EconomizerNoRelief "Air economizer with no relief branch"
    extends .Buildings.Templates.AirHandlersFans.Components.OutdoorReliefReturnSection.Interfaces.PartialOutdoorReliefReturnSection(
      final typ=Types.OutdoorReliefReturnSection.EconomizerNoRelief,
      final have_porPre=secRel.have_porPre,
      final typDamOut=secOut.typDamOut,
      final typDamOutMin=secOut.typDamOutMin,
      final typDamRel=secRel.typDam,
      final typFanRet=secRel.typFan);

    replaceable
      Buildings.Templates.AirHandlersFans.Components.OutdoorSection.SingleDamper
      secOut constrainedby .Buildings.Templates.AirHandlersFans.Components.OutdoorSection.Interfaces.PartialOutdoorSection(
                                                     redeclare final package
        MediumAir = MediumAir, final have_recHea=false) "Outdoor air section"
      annotation (
      choices(
        choice(redeclare
            Buildings.Templates.AirHandlersFans.Components.OutdoorSection.SingleDamper
            secOut "Single common OA damper (modulated) with AFMS"),
        choice(redeclare
            Buildings.Templates.AirHandlersFans.Components.OutdoorSection.DedicatedDamperAirflow
            secOut "Dedicated minimum OA damper (modulated) with AFMS"),
        choice(redeclare
            Buildings.Templates.AirHandlersFans.Components.OutdoorSection.DedicatedDamperPressure
            secOut
            "Dedicated minimum OA damper (two-position) with differential pressure sensor")),
      Dialog(group="Outdoor air section"),
      Placement(transformation(extent={{-58,-94},{-22,-66}})));

    Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.NoRelief
      secRel(redeclare final package MediumAir = MediumAir, final have_recHea=
          false) "Relief/return air section" annotation (Dialog(group=
            "Exhaust/relief/return section"), Placement(transformation(extent={
              {-18,66},{18,94}})));

    Buildings.Templates.Components.Dampers.Modulated damRet(
      redeclare final package Medium = MediumAir,
      final loc=Buildings.Templates.Components.Types.Location.Return)
      "Return air damper"
      annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={0,0})));
  equation
    /* Hardware point connection - start */
    connect(damRet.bus, bus.damRet);
    /* Hardware point connection - end */
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
    connect(secOut.bus, bus) annotation (Line(
        points={{-40,-66},{-40,120},{0,120},{0,140}},
        color={255,204,51},
        thickness=0.5));
    connect(secRel.bus, bus) annotation (Line(
        points={{0,94},{0,140}},
        color={255,204,51},
        thickness=0.5));
    connect(secRel.port_bPre, port_bPre) annotation (Line(points={{8,66},{8,60},{
            80,60},{80,140}}, color={0,127,255}));
  end EconomizerNoRelief;

  model EconomizerWithRelief "Air economizer with relief branch"
    extends .Buildings.Templates.AirHandlersFans.Components.OutdoorReliefReturnSection.Interfaces.PartialOutdoorReliefReturnSection(
      final typ=Types.OutdoorReliefReturnSection.EconomizerWithRelief,
      final have_porPre=secRel.have_porPre,
      final typDamOut=secOut.typDamOut,
      final typDamOutMin=secOut.typDamOutMin,
      final typDamRel=secRel.typDam,
      final typFanRet=secRel.typFan);

    replaceable
      Buildings.Templates.AirHandlersFans.Components.OutdoorSection.SingleDamper
      secOut constrainedby .Buildings.Templates.AirHandlersFans.Components.OutdoorSection.Interfaces.PartialOutdoorSection(
                                                     redeclare final package
        MediumAir = MediumAir, final have_recHea=false) "Outdoor air section"
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
      secRel constrainedby .Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.Interfaces.PartialReliefReturnSection(
                                                          redeclare final
        package
        MediumAir = MediumAir, final have_recHea=false)
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
      final loc=Buildings.Templates.Components.Types.Location.Return)
      "Return air damper"
      annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={0,0})));

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
    connect(secRel.port_bPre, port_bPre) annotation (Line(points={{8,66},{8,40},{
            80,40},{80,140}},               color={0,127,255}));
  end EconomizerWithRelief;

  model HeatRecovery "Heat recovery"
    extends .Buildings.Templates.AirHandlersFans.Components.OutdoorReliefReturnSection.Interfaces.PartialOutdoorReliefReturnSection(
      final typ=Types.OutdoorReliefReturnSection.HeatRecovery,
      final have_porPre=secRel.have_porPre,
      final typDamOut=secOut.typDamOut,
      final typDamOutMin=secOut.typDamOutMin,
      final typDamRel=secRel.typDam,
      final typFanRet=secRel.typFan);

    Buildings.Templates.AirHandlersFans.Components.OutdoorSection.NoEconomizer
      secOut(redeclare final package MediumAir = MediumAir, final have_recHea=
          true) "Outdoor air section" annotation (Dialog(group=
            "Outdoor air section"), Placement(transformation(extent={{-58,-94},
              {-22,-66}})));

    replaceable
      Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.ReturnFan
      secRel constrainedby .Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.Interfaces.PartialReliefReturnSection(
                                                          redeclare final
        package MediumAir = MediumAir, final have_recHea=true)
      "Relief/return air section" annotation (
      choices(choice(redeclare BaseClasses.ReliefReturnSection.ReturnFan secRel
            "Return fan - Modulated relief damper"), choice(redeclare
            BaseClasses.ReliefReturnSection.ReliefFan secRel
            "Relief fan - Two-position relief damper")),
      Dialog(group="Exhaust/relief/return section"),
      Placement(transformation(extent={{-18,66},{18,94}})));

    replaceable
      Buildings.Templates.AirHandlersFans.Components.HeatRecovery.None none
      constrainedby .Buildings.Templates.AirHandlersFans.Components.HeatRecovery.Interfaces.PartialHeatRecovery(
                                            redeclare final package MediumAir =
          MediumAir) "Heat recovery" annotation (choicesAllMatching=true,
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
    connect(bus, secRel.bus) annotation (Line(
        points={{0,140},{0,94}},
        color={255,204,51},
        thickness=0.5));
    connect(secOut.bus, bus) annotation (Line(
        points={{-40,-66},{-40,-60},{-60,-60},{-60,120},{0,120},{0,140}},
        color={255,204,51},
        thickness=0.5));
    connect(secRel.port_bPre, port_bPre) annotation (Line(points={{8,66},{8,40},{
            80,40},{80,140}},               color={0,127,255}));
    connect(secRel.port_bHeaRec, none.port_aRel)
      annotation (Line(points={{-8,66},{-8,6},{-30,6}}, color={0,127,255}));
    connect(none.bus, bus) annotation (Line(
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

  package Interfaces "Classes defining the component interfaces"
    extends Modelica.Icons.InterfacesPackage;

    partial model PartialOutdoorReliefReturnSection
      "Outdoor/relief/return air section"

      replaceable package MediumAir=Buildings.Media.Air
        constrainedby Modelica.Media.Interfaces.PartialMedium
        "Air medium";

      parameter AirHandlersFans.Types.OutdoorReliefReturnSection typ
        "Outdoor/relief/return air section type"
        annotation (Evaluate=true, Dialog(group="Configuration"));
      parameter Boolean have_porPre
        "Set to true in case of fluid port for differential pressure sensor"
        annotation (Evaluate=true, Dialog(group="Configuration"));
      parameter Buildings.Templates.Components.Types.Damper typDamOut
        "Outdoor air damper type"
        annotation (Evaluate=true, Dialog(group="Configuration"));
      parameter Buildings.Templates.Components.Types.Damper typDamOutMin
        "Minimum outdoor air damper type"
        annotation (Evaluate=true, Dialog(group="Configuration"));
      parameter Buildings.Templates.Components.Types.Damper typDamRel
        "Relief damper type"
        annotation (Evaluate=true, Dialog(group="Configuration"));
      parameter Buildings.Templates.Components.Types.Fan typFanRet
        "Relief/return fan type"
        annotation (Evaluate=true, Dialog(group="Configuration"));

      outer parameter String id
        "System identifier";
      outer parameter ExternData.JSONFile dat
        "External parameter file";

      parameter Boolean allowFlowReversal = true
        "= false to simplify equations, assuming, but not enforcing, no flow reversal"
        annotation(Dialog(tab="Assumptions"), Evaluate=true);

      Modelica.Fluid.Interfaces.FluidPort_b port_Rel(
        redeclare final package Medium = MediumAir,
        m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
        h_outflow(start=MediumAir.h_default, nominal=MediumAir.h_default))
        if typ <> AirHandlersFans.Types.OutdoorReliefReturnSection.EconomizerNoRelief
        "Relief (exhaust) air"
        annotation (Placement(transformation(
          extent={{-190,70},{-170,90}}),iconTransformation(extent={{-190,90},{-170,
                110}})));
      Modelica.Fluid.Interfaces.FluidPort_a port_Out(
        redeclare final package Medium = MediumAir,
        m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
        h_outflow(start=MediumAir.h_default, nominal=MediumAir.h_default))
        "Outdoor air intake"
        annotation (Placement(transformation(
          extent={{-190,-90},{-170,-70}}),iconTransformation(extent={{-190,-110},{
                -170,-90}})));
      Modelica.Fluid.Interfaces.FluidPort_b port_Sup(
        redeclare final package Medium = MediumAir,
        m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
        h_outflow(start=MediumAir.h_default, nominal=MediumAir.h_default))
        "Supply air"
        annotation (
          Placement(transformation(extent={{170,-90},{190,-70}}),
            iconTransformation(extent={{170,-110},{190,-90}})));
      Modelica.Fluid.Interfaces.FluidPort_a port_Ret(
        redeclare final package Medium =MediumAir,
        m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
        h_outflow(start=MediumAir.h_default, nominal=MediumAir.h_default))
        "Return air"
        annotation (Placement(transformation(extent={{170,70},{190,90}}),
            iconTransformation(extent={{170,90},{190,110}})));
      Modelica.Fluid.Interfaces.FluidPort_b port_bPre(
        redeclare final package Medium = MediumAir) if have_porPre
        "Optional fluid connector for differential pressure sensor"
        annotation (Placement(transformation(extent={{90,130},{70,150}}),
            iconTransformation(extent={{90,130},{70,150}})));
      Buildings.Templates.AirHandlersFans.Interfaces.Bus bus "Control bus"
        annotation (Placement(transformation(
            extent={{-20,-20},{20,20}},
            rotation=0,
            origin={0,140}), iconTransformation(
            extent={{-10,-10},{10,10}},
            rotation=0,
            origin={0,140})));
      annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-180,
                -140},{180,140}}), graphics={
            Text(
              extent={{-149,-150},{151,-190}},
              lineColor={0,0,255},
              textString="%name")}),                                 Diagram(
            coordinateSystem(preserveAspectRatio=false, extent={{-180,-140},{180,
                140}})));
    end PartialOutdoorReliefReturnSection;
  end Interfaces;
end OutdoorReliefReturnSection;

within Buildings.Templates.AirHandlersFans.Components.OutdoorReliefReturnSection;
model MixedAirWithDamper "Mixed air system with return air damper"
  extends
    Buildings.Templates.AirHandlersFans.Components.Interfaces.PartialOutdoorReliefReturnSection(
    final typ=Buildings.Templates.AirHandlersFans.Types.OutdoorReliefReturnSection.MixedAirWithDamper,
    final typSecOut=secOut.typ,
    final typSecRel=secRel.typ,
    final typDamOut=secOut.typDamOut,
    final typDamOutMin=secOut.typDamOutMin,
    final typDamRel=secRel.typDamRel,
    final typDamRet=damRet.typ,
    final typFanRel=secRel.typFanRel,
    final typFanRet=secRel.typFanRet,
    final have_eco=true,
    final have_recHea=recHea.typ<>Buildings.Templates.AirHandlersFans.Types.HeatRecovery.None);

  replaceable
    Buildings.Templates.AirHandlersFans.Components.OutdoorSection.SingleDamper
    secOut constrainedby
    Buildings.Templates.AirHandlersFans.Components.Interfaces.PartialOutdoorSection(
      redeclare final package MediumAir = MediumAir,
      final energyDynamics=energyDynamics,
      final allowFlowReversal=allowFlowReversal,
      final dat=dat)
    "Outdoor air section"
    annotation (
    choices(
      choice(redeclare replaceable Buildings.Templates.AirHandlersFans.Components.OutdoorSection.SingleDamper secOut
        "Single damper for ventilation and economizer, with airflow measurement station"),
      choice(redeclare replaceable Buildings.Templates.AirHandlersFans.Components.OutdoorSection.DedicatedDampersAirflow secOut
        "Separate dampers for ventilation and economizer, with airflow measurement station"),
      choice(redeclare replaceable Buildings.Templates.AirHandlersFans.Components.OutdoorSection.DedicatedDampersPressure secOut
        "Separate dampers for ventilation and economizer, with differential pressure sensor")),
    Dialog(group="Configuration"),
    Placement(transformation(extent={{-58,-94},{-22,-66}})));

  replaceable
    Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.ReturnFan
    secRel constrainedby
    Buildings.Templates.AirHandlersFans.Components.Interfaces.PartialReliefReturnSection(
      redeclare final package MediumAir = MediumAir,
      final energyDynamics=energyDynamics,
      final allowFlowReversal=allowFlowReversal,
      final dat=dat)
    "Relief/return air section"
    annotation (
    choices(
      choice(
        redeclare Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.ReturnFan secRel
          "Return fan with modulating relief damper"),
      choice(
        redeclare Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.ReliefFan
          secRel
          "Relief fan with two-position relief damper"),
      choice(
        redeclare  Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.ReliefDamper
          secRel
          "Modulating relief damper without fan")),
    Dialog(group="Configuration"),
    Placement(transformation(extent={{-18,66},{18,94}})));

  Buildings.Templates.Components.Dampers.Modulating damRet(
    redeclare final package Medium = MediumAir,
    use_inputFilter=energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState,
    final allowFlowReversal=allowFlowReversal,
    final dat=dat.damRet,
    final text_rotation=90)
    "Return damper"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,0})));

  // Currently only the configuration without heat recovery is supported.
  replaceable Buildings.Templates.AirHandlersFans.Components.HeatRecovery.None recHea
    constrainedby
    Buildings.Templates.AirHandlersFans.Components.Interfaces.PartialHeatRecovery(
      redeclare final package MediumAir = MediumAir,
      final allowFlowReversal=allowFlowReversal)
    "Heat recovery"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));

equation
  /* Control point connection - start */
  connect(damRet.bus, bus.damRet);
  connect(bus, secRel.bus);
  connect(secOut.bus, bus);
  connect(recHea.bus, bus);
  /* Control point connection - end */
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
  connect(secRel.port_bPre, port_bPre) annotation (Line(points={{8,66},{8,60},{80,
          60},{80,140}},                  color={0,127,255}));
  connect(recHea.port_aRel, secRel.port_bHeaRec) annotation (Line(points={{-70,6},
          {-60,6},{-60,56},{-4,56},{-4,66}}, color={0,127,255}));
  connect(secRel.port_aHeaRec, recHea.port_bRel) annotation (Line(points={{-8,66},
          {-8,60},{-100,60},{-100,6},{-90,6}}, color={0,127,255}));
  connect(recHea.port_aOut, secOut.port_bHeaRec) annotation (Line(points={{-90,-6},
          {-100,-6},{-100,-60},{-48,-60},{-48,-66}}, color={0,127,255}));
  connect(recHea.port_bOut, secOut.port_aHeaRec) annotation (Line(points={{-70,-6},
          {-60,-6},{-60,-56},{-44,-56},{-44,-66}}, color={0,127,255}));
  annotation (Documentation(info="<html>
<p>
This model represents a configuration with an air economizer.
</p>
</html>"));
end MixedAirWithDamper;

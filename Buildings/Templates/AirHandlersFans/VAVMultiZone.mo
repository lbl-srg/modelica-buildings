within Buildings.Templates.AirHandlersFans;
model VAVMultiZone "Multiple-zone VAV"
/*
  HACK: In Dymola only (ticket SR00860858-01), bindings for the parameter record
  cannot be made final if propagation from a top-level record (whole building)
  is needed.
  Instead those parameter declarations are annoted with enable=false
  in the record class.
*/
  extends Buildings.Templates.AirHandlersFans.Interfaces.PartialAirHandler(
    nZon(final min=2),
    redeclare Buildings.Templates.AirHandlersFans.Data.VAVMultiZone dat(
      typCoiHeaPre=coiHeaPre.typ,
      typCoiCoo=coiCoo.typ,
      typCoiHeaReh=coiHeaReh.typ,
      typValCoiHeaPre=coiHeaPre.typVal,
      typValCoiCoo=coiCoo.typVal,
      typValCoiHeaReh=coiHeaReh.typVal,
      typDamOut=secOutRel.typDamOut,
      typDamOutMin=secOutRel.typDamOutMin,
      typDamRet=secOutRel.typDamRet,
      typDamRel=secOutRel.typDamRel,
      typSecOut=secOutRel.typSecOut,
      typCtl=ctl.typ,
      buiPreCon=ctl.buiPreCon,
      stdVen=ctl.stdVen),
    final typ=Buildings.Templates.AirHandlersFans.Types.Configuration.SingleDuct,
    final have_porRel=secOutRel.typ <> Types.OutdoorReliefReturnSection.MixedAirNoRelief,
    final have_souChiWat=coiCoo.have_sou,
    final have_souHeaWat=coiHeaPre.have_sou or coiHeaReh.have_sou,
    final typFanSup=if
      fanSupDra.typ <> Buildings.Templates.Components.Types.Fan.None then
      fanSupDra.typ elseif fanSupBlo.typ <> Buildings.Templates.Components.Types.Fan.None
      then fanSupBlo.typ else Buildings.Templates.Components.Types.Fan.None,
    final typFanRel=secOutRel.typFanRel,
    final typFanRet=secOutRel.typFanRet,
    final mChiWat_flow_nominal=if coiCoo.have_sou then dat.coiCoo.mWat_flow_nominal else 0,
    final mHeaWat_flow_nominal=(if coiHeaPre.have_sou then dat.coiHeaPre.mWat_flow_nominal else 0) +
      (if coiHeaReh.have_sou then dat.coiHeaReh.mWat_flow_nominal else 0),
    final QChiWat_flow_nominal=if coiCoo.have_sou then dat.coiCoo.Q_flow_nominal else 0,
    final QHeaWat_flow_nominal=(if coiHeaPre.have_sou then dat.coiHeaPre.Q_flow_nominal else 0) +
      (if coiHeaReh.have_sou then dat.coiHeaReh.Q_flow_nominal else 0));

  final parameter Boolean have_senPreBui=
    secOutRel.typSecRel==Buildings.Templates.AirHandlersFans.Types.ReliefReturnSection.ReliefDamper or
    secOutRel.typSecRel==Buildings.Templates.AirHandlersFans.Types.ReliefReturnSection.ReliefFan or
    secOutRel.typSecRel==Buildings.Templates.AirHandlersFans.Types.ReliefReturnSection.ReturnFan and
    secOutRel.typCtlFanRet==Buildings.Templates.AirHandlersFans.Types.ControlFanReturn.BuildingPressure
    "Set to true if building static pressure sensor is used"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  /*
  RFE: Currently only the configuration with economizer is supported.
  Hence, no choices annotation, but still replaceable to access parameter
  dialog box of the component.
  */
  inner replaceable Buildings.Templates.AirHandlersFans.Components.OutdoorReliefReturnSection.MixedAirWithDamper
    secOutRel(
    redeclare final package MediumAir = MediumAir,
    final typCtlFanRet=ctl.typCtlFanRet,
    final typCtlEco=ctl.typCtlEco,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversalAir,
    dat(
      final mOutMin_flow_nominal=dat.mOutMin_flow_nominal,
      final damOut=dat.damOut,
      final damOutMin=dat.damOutMin,
      final damRel=dat.damRel,
      final damRet=dat.damRet,
      final fanRel=dat.fanRel,
      final fanRet=dat.fanRet))
     "Outdoor/relief/return air section"
     annotation (
     Dialog(group="Configuration"), Placement(transformation(extent={{-280,-220},
            {-120,-60}})));

  Buildings.Templates.Components.Sensors.Temperature TAirMix(
    redeclare final package Medium = MediumAir,
    final have_sen=ctl.use_TMix,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.Averaging,
    final m_flow_nominal=mAirSup_flow_nominal,
    final allowFlowReversal=allowFlowReversalAir)
    "Mixed air temperature sensor"
    annotation (Placement(
        transformation(extent={{-110,-210},{-90,-190}})));

  inner replaceable Buildings.Templates.Components.Fans.None fanSupBlo
    constrainedby Buildings.Templates.Components.Interfaces.PartialFan(
      redeclare final package Medium = MediumAir,
      final energyDynamics=energyDynamics,
      final allowFlowReversal=allowFlowReversalAir,
      final dat=dat.fanSup,
      final have_senFlo=ctl.typCtlFanRet==
        Buildings.Templates.AirHandlersFans.Types.ControlFanReturn.AirflowMeasured)
    "Supply fan - Blow through"
    annotation (
      choices(
        choice(redeclare replaceable Buildings.Templates.Components.Fans.None fanSupBlo
          "No fan"),
        choice(redeclare replaceable Buildings.Templates.Components.Fans.SingleVariable fanSupBlo
          "Single fan - Variable speed"),
        choice(redeclare replaceable Buildings.Templates.Components.Fans.ArrayVariable fanSupBlo
          "Fan array - Variable speed")),
      Dialog(group="Configuration",
        enable=fanSupDra.typ==Buildings.Templates.Components.Types.Fan.None),
      Placement(transformation(extent={{-50,-210},{-30,-190}})));

  Buildings.Templates.Components.Sensors.Temperature TAirCoiHeaLvg(
    redeclare final package Medium = MediumAir,
    final have_sen=coiHeaPre.typ <> Buildings.Templates.Components.Types.Coil.None
         and coiCoo.typ <> Buildings.Templates.Components.Types.Coil.None,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.Averaging,
    final m_flow_nominal=mAirSup_flow_nominal,
    final allowFlowReversal=allowFlowReversalAir)
    "Heating coil leaving air temperature sensor"
    annotation (
      Placement(transformation(extent={{40,-210},{60,-190}})));

  Buildings.Templates.Components.Sensors.Temperature TAirCoiCooLvg(
    redeclare final package Medium = MediumAir,
    final have_sen=coiCoo.typ <> Buildings.Templates.Components.Types.Coil.None
         and coiHeaReh.typ <> Buildings.Templates.Components.Types.Coil.None,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.Averaging,
    final m_flow_nominal=mAirSup_flow_nominal,
    final allowFlowReversal=allowFlowReversalAir)
    "Cooling coil leaving air temperature sensor"
    annotation (
      Placement(transformation(extent={{100,-210},{120,-190}})));

  inner replaceable Buildings.Templates.Components.Fans.SingleVariable fanSupDra
    constrainedby Buildings.Templates.Components.Interfaces.PartialFan(
      redeclare final package Medium = MediumAir,
      final energyDynamics=energyDynamics,
      final allowFlowReversal=allowFlowReversalAir,
      final dat=dat.fanSup,
      final have_senFlo=ctl.typCtlFanRet==
        Buildings.Templates.AirHandlersFans.Types.ControlFanReturn.AirflowMeasured)
    "Supply fan - Draw through"
    annotation (
      choices(
        choice(redeclare replaceable Buildings.Templates.Components.Fans.None fanSupDra
          "No fan"),
        choice(redeclare replaceable Buildings.Templates.Components.Fans.SingleVariable fanSupDra
          "Single fan - Variable speed"),
        choice(redeclare replaceable Buildings.Templates.Components.Fans.ArrayVariable fanSupDra
          "Fan array - Variable speed")),
    Dialog(group="Configuration",
      enable=fanSupBlo.typ==Buildings.Templates.Components.Types.Fan.None),
    Placement(transformation(extent={{172,-210},{192,-190}})));

  Buildings.Templates.Components.Sensors.Temperature TAirSup(
    redeclare final package Medium = MediumAir,
    final have_sen=true,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.Standard,
    final m_flow_nominal=mAirSup_flow_nominal,
    final allowFlowReversal=allowFlowReversalAir)
    "Supply air temperature sensor"
    annotation (Placement(
        transformation(extent={{210,-210},{230,-190}})));

  Buildings.Templates.Components.Sensors.DifferentialPressure pBui_rel(
    redeclare final package Medium = MediumAir,
    final have_sen=have_senPreBui,
    final text_flip=true)
    "Building static pressure"
    annotation (Placement(transformation(extent={{10,30},{-10,50}})));

  Buildings.Fluid.Sources.Outside out(
    redeclare final package Medium=MediumAir,
    final nPorts=3)
    "Outdoor conditions"
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,90})));
  Buildings.Fluid.Sources.Boundary_pT bui(
    redeclare final package Medium = MediumAir,
    final use_p_in=have_senPreBui,
    final nPorts=1)
    "Building absolute pressure in representative space"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,60})));

  Buildings.Templates.Components.Sensors.Temperature TAirRet(
    redeclare final package Medium = MediumAir,
    final allowFlowReversal=allowFlowReversalAir,
    final have_sen=
      secOutRel.have_eco and
      (ctl.typCtlEco==Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialDryBulb or
       ctl.typCtlEco==Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.FixedDryBulbWithDifferentialDryBulb),
    final typ=Buildings.Templates.Components.Types.SensorTemperature.Standard,
    final m_flow_nominal=mAirRet_flow_nominal)
    "Return air temperature sensor"
    annotation (
      Placement(transformation(extent={{220,-90},{200,-70}})));

  Buildings.Templates.Components.Sensors.SpecificEnthalpy hAirRet(
    redeclare final package Medium = MediumAir,
    final allowFlowReversal=allowFlowReversalAir,
    final have_sen=
      secOutRel.have_eco and
      ctl.typCtlEco==Buildings.Controls.OBC.ASHRAE.G36.Types.ControlEconomizer.DifferentialEnthalpyWithFixedDryBulb,
    final m_flow_nominal=mAirRet_flow_nominal)
    "Return air enthalpy sensor"
    annotation (
      Placement(transformation(extent={{250,-90},{230,-70}})));

  Buildings.Templates.Components.Sensors.DifferentialPressure pAirSup_rel(
    redeclare final package Medium = MediumAir,
    final have_sen=true)
    "Duct static pressure sensor"
    annotation (
      Placement(transformation(extent={{250,-230},{270,-210}})));

  inner replaceable Buildings.Templates.Components.Coils.WaterBasedHeating coiHeaPre(
    redeclare final package MediumHeaWat=MediumHeaWat,
    redeclare final Buildings.Templates.Components.Valves.TwoWayModulating val)
    constrainedby Buildings.Templates.Components.Interfaces.PartialCoil(
      final dat=dat.coiHeaPre,
      redeclare final package MediumAir=MediumAir,
      final energyDynamics=energyDynamics,
      final allowFlowReversalAir=allowFlowReversalAir,
      final allowFlowReversalLiq=allowFlowReversalLiq,
      final show_T=show_T)
    "Heating coil in preheat position"
    annotation (
    choices(
      choice(
        redeclare replaceable Buildings.Templates.Components.Coils.None coiHeaPre
        "No coil"),
      choice(
        redeclare replaceable Buildings.Templates.Components.Coils.WaterBasedHeating coiHeaPre(
          redeclare final package MediumHeaWat=MediumHeaWat,
          redeclare final Buildings.Templates.Components.Valves.TwoWayModulating val)
        "Hot water coil with two-way valve"),
      choice(
        redeclare replaceable Buildings.Templates.Components.Coils.ElectricHeating coiHeaPre
        "Modulating electric heating coil")),
    Dialog(group="Configuration",
      enable=coiHeaReh.typ==Buildings.Templates.Components.Types.Coil.None),
    Placement(transformation(extent={{10,-210},{30,-190}})));

  inner replaceable Buildings.Templates.Components.Coils.WaterBasedCooling coiCoo(
    redeclare final package MediumChiWat=MediumChiWat,
    redeclare final Buildings.Templates.Components.Valves.TwoWayModulating val)
    constrainedby Buildings.Templates.Components.Interfaces.PartialCoil(
      final dat=dat.coiCoo,
      redeclare final package MediumAir=MediumAir,
      final energyDynamics=energyDynamics,
      final allowFlowReversalAir=allowFlowReversalAir,
      final allowFlowReversalLiq=allowFlowReversalLiq,
      final show_T=show_T)
    "Cooling coil"
    annotation (
      choices(
      choice(redeclare replaceable Buildings.Templates.Components.Coils.None coiCoo
        "No coil"),
      choice(redeclare replaceable Buildings.Templates.Components.Coils.WaterBasedCooling coiCoo(
        redeclare final package MediumChiWat=MediumChiWat,
        redeclare final Buildings.Templates.Components.Valves.TwoWayModulating val)
        "Chilled water coil with two-way valve")),
    Dialog(group="Configuration"),
    Placement(transformation(extent={{70,-210},{90,-190}})));
  inner replaceable Buildings.Templates.Components.Coils.None coiHeaReh
    constrainedby Buildings.Templates.Components.Interfaces.PartialCoil(
      final dat=dat.coiHeaReh,
      redeclare final package MediumAir=MediumAir,
      final energyDynamics=energyDynamics,
      final allowFlowReversalAir=allowFlowReversalAir,
      final allowFlowReversalLiq=allowFlowReversalLiq,
      final show_T=show_T)
    "Heating coil in reheat position"
    annotation (
    choices(
      choice(redeclare replaceable Buildings.Templates.Components.Coils.None coiHeaReh
        "No coil"),
      choice(redeclare replaceable Buildings.Templates.Components.Coils.WaterBasedHeating coiHeaReh(
        redeclare final package MediumHeaWat=MediumHeaWat)
        "Hot water coil"),
      choice(
        redeclare replaceable Buildings.Templates.Components.Coils.ElectricHeating coiHeaReh
        "Modulating electric heating coil")),
    Dialog(group="Configuration",
      enable=coiHeaPre.typ==Buildings.Templates.Components.Types.Coil.None and
      ctl.typ<>Buildings.Templates.AirHandlersFans.Types.Controller.G36VAVMultiZone),
    Placement(transformation(extent={{130,-210},{150,-190}})));
  Buildings.Fluid.FixedResistances.Junction junHeaWatSup(
    redeclare final package Medium = MediumHeaWat,
    final m_flow_nominal=mHeaWat_flow_nominal*{1,-1,-1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dp_nominal=fill(0, 3),
    final portFlowDirection_1=if allowFlowReversalLiq then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversalLiq then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    final portFlowDirection_3=if allowFlowReversalLiq then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else Modelica.Fluid.Types.PortFlowDirection.Leaving) if have_souHeaWat
    "HHW supply junction"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={20,-260})));
  Buildings.Fluid.FixedResistances.Junction junHeaWatRet(
    redeclare final package Medium = MediumHeaWat,
    final m_flow_nominal=mHeaWat_flow_nominal*{1,-1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dp_nominal=fill(0, 3),
    final portFlowDirection_1=if allowFlowReversalLiq then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_2=if allowFlowReversalLiq then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else Modelica.Fluid.Types.PortFlowDirection.Entering,
    final portFlowDirection_3=if allowFlowReversalLiq then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional
      else Modelica.Fluid.Types.PortFlowDirection.Leaving) if have_souHeaWat
    "HHW return junction" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-20,-240})));
  inner replaceable Buildings.Templates.AirHandlersFans.Components.Controls.G36VAVMultiZone ctl
    constrainedby
    Buildings.Templates.AirHandlersFans.Components.Interfaces.PartialControllerVAVMultizone(
      final dat=dat.ctl,
      final nZon=nZon)
    "Control selections"
    annotation (
      Dialog(group="Controls"),
      Placement(transformation(extent={{-220,-10},{-200,10}})));

initial equation
  assert(typFanSup<>Buildings.Templates.Components.Types.Fan.None,
    "In "+ getInstanceName() + ": "+
    "The template is configured with no supply fan, which is not supported.");
  assert(not (fanSupBlo.typ<>Buildings.Templates.Components.Types.Fan.None and
    fanSupDra.typ<>Buildings.Templates.Components.Types.Fan.None),
    "In "+ getInstanceName() + ": "+
    "The template is configured with both a blow-through fan and a draw-through fan, which is not supported.");
equation
  /* Control point connection - start */
  connect(TAirMix.y, bus.TAirMix);
  connect(TAirCoiHeaLvg.y, bus.TAirCoiHeaLvg);
  connect(TAirSup.y, bus.TAirSup);
  connect(pAirSup_rel.y, bus.pAirSup_rel);
  connect(hAirRet.y, bus.hAirRet);
  connect(TAirRet.y, bus.TAirRet);
  connect(fanSupDra.bus, bus.fanSup);
  connect(fanSupBlo.bus, bus.fanSup);
  connect(coiHeaPre.bus, bus.coiHea);
  connect(coiCoo.bus, bus.coiCoo);
  connect(coiHeaReh.bus, bus.coiHea);
  connect(secOutRel.bus, bus);
  connect(bui.p_in, bus.pBui);
  connect(pBui_rel.y, bus.pBui_rel);
  /* Control point connection - stop */

  connect(port_aChiWat, coiCoo.port_aSou) annotation (Line(points={{100,-280},{
          100,-268},{85,-268},{85,-210}},
                                      color={0,127,255}));
  connect(coiCoo.port_bSou, port_bChiWat) annotation (Line(points={{75,-210},{
          75,-268},{60,-268},{60,-280}},
                                      color={0,127,255}));
  connect(busWea,coiCoo.busWea)  annotation (Line(
      points={{0,280},{0,100},{76,100},{76,-190}},
      color={255,204,51},
      thickness=0.5));
  connect(TAirMix.port_b, fanSupBlo.port_a)
    annotation (Line(points={{-90,-200},{-50,-200}}, color={0,127,255}));
  connect(coiHeaReh.port_b, fanSupDra.port_a)
    annotation (Line(points={{150,-200},{172,-200}}, color={0,127,255}));
  connect(busWea, out.weaBus) annotation (Line(
      points={{0,280},{0,100},{-39.8,100}},
      color={255,204,51},
      thickness=0.5));
  connect(pBui_rel.port_b, out.ports[1]) annotation (Line(points={{-10,40},{-40,
          40},{-40,80},{-41.3333,80}},
                                  color={0,127,255}));
  connect(bui.ports[1], pBui_rel.port_a) annotation (Line(points={{40,50},{40,40},
          {10,40}},             color={0,127,255}));

  connect(ctl.busTer, busTer) annotation (Line(
      points={{-200,0},{300,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(ctl.bus, bus) annotation (Line(
      points={{-220,0},{-300,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(port_Ret, hAirRet.port_a)
    annotation (Line(points={{300,-80},{250,-80}}, color={0,127,255}));
  connect(hAirRet.port_b, TAirRet.port_a)
    annotation (Line(points={{230,-80},{220,-80}}, color={0,127,255}));
  connect(coiHeaPre.port_b, TAirCoiHeaLvg.port_a)
    annotation (Line(points={{30,-200},{40,-200}}, color={0,127,255}));
  connect(TAirCoiHeaLvg.port_b, coiCoo.port_a)
    annotation (Line(points={{60,-200},{70,-200}}, color={0,127,255}));
  connect(coiCoo.port_b, TAirCoiCooLvg.port_a)
    annotation (Line(points={{90,-200},{100,-200}}, color={0,127,255}));
  connect(TAirCoiCooLvg.port_b, coiHeaReh.port_a)
    annotation (Line(points={{120,-200},{130,-200}}, color={0,127,255}));
  connect(secOutRel.port_Sup, TAirMix.port_a)
    annotation (Line(points={{-120,-200},{-110,-200}}, color={0,127,255}));
  connect(secOutRel.port_bPre, out.ports[2]) annotation (Line(points={{-162,-60},
          {-162,80},{-40,80}},                       color={0,127,255}));
  connect(port_Rel, secOutRel.port_Rel)
    annotation (Line(points={{-300,-80},{-280,-80}}, color={0,127,255}));
  connect(port_Out, secOutRel.port_Out)
    annotation (Line(points={{-300,-200},{-280,-200}}, color={0,127,255}));
  connect(TAirSup.port_b, port_Sup)
    annotation (Line(points={{230,-200},{300,-200}}, color={0,127,255}));
  connect(TAirSup.port_b, pAirSup_rel.port_a) annotation (Line(points={{230,-200},
          {240,-200},{240,-220},{250,-220}}, color={0,127,255}));
  connect(fanSupDra.port_b, TAirSup.port_a)
    annotation (Line(points={{192,-200},{210,-200}}, color={0,127,255}));
  connect(port_aHeaWat, junHeaWatSup.port_1)
    annotation (Line(points={{20,-280},{20,-270}}, color={0,127,255}));
  connect(port_bHeaWat, junHeaWatRet.port_2)
    annotation (Line(points={{-20,-280},{-20,-250}}, color={0,127,255}));
  connect(junHeaWatSup.port_3, coiHeaReh.port_aSou) annotation (Line(points={{
          30,-260},{145,-260},{145,-210}}, color={0,127,255}));
  connect(coiHeaReh.port_bSou, junHeaWatRet.port_3) annotation (Line(points={{135,
          -210},{135,-240},{-10,-240}}, color={0,127,255}));
  connect(coiHeaPre.port_bSou, junHeaWatRet.port_1) annotation (Line(points={{15,
          -210},{15,-220},{-20,-220},{-20,-230}}, color={0,127,255}));
  connect(junHeaWatSup.port_2, coiHeaPre.port_aSou) annotation (Line(points={{20,-250},
          {20,-220},{25,-220},{25,-210}},          color={0,127,255}));
  connect(out.ports[3], pAirSup_rel.port_b) annotation (Line(points={{-38.6667,
          80},{280,80},{280,-220},{270,-220}},
                                           color={0,127,255}));
  connect(secOutRel.port_Ret, TAirRet.port_b) annotation (Line(points={{-120,-80.2},
          {40,-80.2},{40,-80},{200,-80}}, color={0,127,255}));
  connect(fanSupBlo.port_b, coiHeaPre.port_a)
    annotation (Line(points={{-30,-200},{10,-200}}, color={0,127,255}));
  annotation (
    __ctrlFlow_template,
    defaultComponentName="VAV",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-200,120},{200,80}},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          fillColor={0,127,127},
          lineColor={0,127,127}),
        Rectangle(
          extent={{-200,-80},{200,-120}},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          fillColor={0,127,127},
          lineColor={0,127,127}),
        Ellipse(
          extent={{110,-80},{150,-120}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,100,199},
          visible=typFanSup <> Buildings.Templates.Components.Types.Fan.None),
        Polygon(
          points={{130,-81},{130,-119},{149,-100},{130,-81}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255},
          visible=typFanSup <> Buildings.Templates.Components.Types.Fan.None),
        Ellipse(
          extent={{-20,120},{20,80}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,100,199},
          visible=typFanRet <> Buildings.Templates.Components.Types.Fan.None
               or typFanRel <> Buildings.Templates.Components.Types.Fan.None),
        Polygon(
          points={{0,119},{0,81},{-19,100},{0,119}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255},
          visible=typFanRet <> Buildings.Templates.Components.Types.Fan.None
               or typFanRel <> Buildings.Templates.Components.Types.Fan.None),
        Rectangle(
          extent={{48,-80},{78,-120}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5,
          visible=coiCoo.typ <> Buildings.Templates.Components.Types.Coil.None),
        Line(
          points={{78,-80},{48,-120}},
          color={0,0,0},
          thickness=0.5,
          visible=coiCoo.typ <> Buildings.Templates.Components.Types.Coil.None),
        Rectangle(
          extent={{-78,-80},{-48,-120}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5,
          visible=coiHeaPre.typ <> Buildings.Templates.Components.Types.Coil.None
               or coiHeaReh.typ <> Buildings.Templates.Components.Types.Coil.None),
        Line(
          points={{-48,-80},{-78,-120}},
          color={0,0,0},
          thickness=0.5,
          visible=coiHeaPre.typ <> Buildings.Templates.Components.Types.Coil.None
               or coiHeaReh.typ <> Buildings.Templates.Components.Types.Coil.None),
        Line(
          points={{-160,-80},{-180,-120}},
          color={0,0,0},
          thickness=0.5),
        Ellipse(
          extent={{-174,-96},{-166,-104}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,0}),
        Line(
          points={{-160,120},{-180,80}},
          color={0,0,0},
          thickness=0.5),
        Ellipse(
          extent={{-174,104},{-166,96}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,0}),
        Rectangle(
          extent={{-80,20},{80,-20}},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          fillColor={0,127,127},
          lineColor={0,127,127},
          origin={-130,0},
          rotation=-90),
        Line(
          points={{20,10},{-20,-10}},
          color={0,0,0},
          thickness=0.5,
          origin={-130,0},
          rotation=360),
        Ellipse(
          extent={{-134,4},{-126,-4}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,0}),
        Line(
          points={{50,-200},{50,-120}},
          color={28,108,200},
          pattern=LinePattern.Dash,
          thickness=5,
          visible=have_souChiWat),
        Line(
          points={{-50,-200},{-50,-120}},
          color={238,46,47},
          thickness=5,
          visible=have_souHeaWat),
        Line(
          points={{130,-200},{130,-194},{76,-194},{76,-120}},
          color={28,108,200},
          thickness=5,
          visible=have_souChiWat),
        Line(
          points={{-130,-200},{-130,-194},{-76,-194},{-76,-120}},
          color={238,46,47},
          thickness=5,
          visible=have_souHeaWat,
          pattern=LinePattern.Dash)}),
Diagram(
    coordinateSystem(preserveAspectRatio=false, extent={{-300,-280},{300,280}}),
      graphics={
        Line(points={{300,-70},{-120,-70}}, color={0,0,0}),
        Line(points={{300,-90},{-120,-90}}, color={0,0,0}),
        Line(points={{300,-210},{-120,-210}}, color={0,0,0}),
        Line(points={{300,-190},{-120,-190}}, color={0,0,0}),
        Line(
          visible=have_senPreBui,
          points={{-16,40},{-10,40}},
          color={0,0,0},
          thickness=1),
        Line(
          visible=have_senPreBui,
          points={{16,40},{10,40}},
          color={0,0,0},
          thickness=1),
        Text(
          visible=have_senPreBui,
          extent={{18,46},{60,34}},
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          fontName="sans-serif",
          textString="REPRESENTATIVE SPACE INSIDE BUILDING"),
        Text(
          visible=have_senPreBui,
          extent={{-60,46},{-18,34}},
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Right,
          fontName="sans-serif",
          textString="REFERENCE OUTSIDE BUILDING"),
        Polygon(points={{251,-220},{251,-206},{250,-206},{250,-221},{256,-221},{
              256,-220},{251,-220}}, lineColor={0,0,0}),
        Rectangle(extent={{264,-220},{270,-221}}, lineColor={0,0,0})}),
    Documentation(info="<html>
<h4>Description</h4>
<p>
This template represents a multiple-zone VAV air handler for
a single duct system serving <b>at least two</b> terminal units.
</p>
<p>
The possible configuration options are enumerated in the table below.
The user may refer to ASHRAE (2021) for further details.
The first option displayed in bold characters corresponds to the default configuration.<br/>
</p>
<table summary=\"summary\" border=\"1\">
<tr><th>Configuration parameter</th><th>Options</th><th>Notes</th></tr>
<tr><td>Outdoor air section</td>
<td>
<b>Single damper for ventilation and economizer, with airflow measurement station</b><br/>
Separate dampers for ventilation and economizer, with airflow measurement station<br/>
Separate dampers for ventilation and economizer, with differential pressure sensor
</td>
<td></td>
</tr>
<tr><td>Relief/return air section</td>
<td>
<b>Return fan with modulating relief damper</b><br/>
Modulating relief damper without fan<br/>
Relief fan with two-position relief damper
</td>
<td>Nonactuated barometric relief is currently not supported.</td>
</tr>
<tr><td>Supply fan - Blow-through position</td>
<td>
<b>No fan</b><br/>
Single fan - Variable speed<br/>
Fan array - Variable speed
</td>
<td>At least one supply fan must be specified, either in blow-through
or draw-through position. Those two configurations are exclusive from
one another.<br/>
ASHRAE Guideline 36 does not have any particular logic yet for handling fan arrays.
If a fan array is selected, all of the fans are currently controlled together at
the same speed, regardless of the number of VFDs.
</td>
</tr>
<tr><td>Heating coil - Preheat position</td>
<td>
<b>Hot water coil with two-way valve</b><br/>
Modulating electric heating coil<br/>
No coil
</td>
<td></td>
</tr>
<tr><td>Cooling coil</td>
<td>
<b>Chilled water coil with two-way valve</b><br/>
No coil
</td>
<td></td>
</tr>
<tr><td>Heating coil - Reheat position</td>
<td>
<b>No coil</b>
</td>
<td>
ASHRAE Guideline 36 does not support heating coils in reheat position
yet.
</td>
</tr>
<tr><td>Supply fan - Draw-through position</td>
<td>
<b>Single fan - Variable speed</b><br/>
Fan array - Variable speed<br/>
No fan
</td>
<td>At least one supply fan must be specified, either in blow-through
or draw-through position. Those two configurations are exclusive from
one another.<br/>
ASHRAE Guideline 36 does not have any particular logic yet for handling fan arrays.
If a fan array is selected, all of the fans are currently controlled together at
the same speed, regardless of the number of VFDs.
</td>
</tr>
<tr><td>Return fan</td>
<td>
<b>Single fan - Variable speed</b><br/>
Fan array - Variable speed<br/>
No fan
</td>
<td>The relief fan and the return fan are both optional and
they are exclusive from one another.</td>
</tr>
<tr><td>Relief fan</td>
<td>
<b>No fan</b><br/>
Single fan - Variable speed<br/>
Fan array - Variable speed
</td>
<td>The relief fan and the return fan are both optional and
they are exclusive from one another.</td>
</tr>
<tr><td>Controller</td>
<td>
<b>ASHRAE Guideline 36 controller</b>
</td>
<td>
An open loop controller is also available for validation purposes only.
</td>
</tr>
<tr><td>Exhaust fan</td>
<td>
<i>Not available: see note</i>
</td>
<td>All exhaust fans that normally operate with the air handler must
be configured separately, by means of a dedicated template.
<!-- RFE: This should be integrated in the AHU template ultimately. -->
</td>
</tr>
<tr><td>Heat recovery</td>
<td>
<i>Not available: see note</i>
</td>
<td>Currently no heat recovery equipment is supported.
<!-- RFE: This should be integrated in the AHU template ultimately. -->
</td>
</tr>
</table>
<h4>Simulation model assumptions and requirements</h4>
<h5>Pressure reference</h5>
<p>
The duct static pressure sensors use the outdoor absolute pressure
as an approximation of the reference pressure in the mechanical room
where the air handler is located.
</p>
<p>
When a building static pressure measurement is required by the control
sequence
(<code>ctl.typCtlFanRet=AirHandlersFans.Types.ControlFanReturn.BuildingPressure</code>),
the corresponding sensor <code>pBui_rel</code> is instantiated
within the current class.
In this case, an additional variable <code>pBui</code> needs to be
connected to the control bus to pass in the value of the absolute pressure
in a representative space of the building.
This is a modeling requirement, the actual control point remains the
relative building static pressure.
</p>
<h4>References</h4>
<ul>
<li>
ASHRAE, 2021. Guideline 36-2021, High-Performance Sequences of Operation
for HVAC Systems. Atlanta, GA.
</li>
</ul>
</html>",
        revisions="<html>
<ul>
<li>
February 11, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end VAVMultiZone;

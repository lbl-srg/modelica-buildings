within Buildings.Templates.ChilledWaterPlant.Components.Economizer;
model WatersideEconomizer "Waterside economizer"
  extends
    Buildings.Templates.ChilledWaterPlant.Components.Economizer.Interfaces.PartialEconomizer(
     final typ=Buildings.Templates.ChilledWaterPlant.Components.Types.Economizer.WatersideEconomizer);


  Buildings.Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU hex(
    redeclare final package Medium1 = MediumConWat,
    redeclare final package Medium2 = MediumChiWat,
    final allowFlowReversal1=allowFlowReversal1,
    final allowFlowReversal2=allowFlowReversal2,
    final use_Q_flow_nominal=true,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    final dp1_nominal=dat.dpConWatHex_nominal,
    final dp2_nominal=dat.dpChiWatHex_nominal,
    final m1_flow_nominal=m1_flow_nominal,
    final m2_flow_nominal=m2_flow_nominal,
    final Q_flow_nominal=dat.QHex_flow_nominal,
    final T_a1_nominal=dat.T_ConWatHexEnt_nominal,
    final T_a2_nominal=dat.T_ChiWatHexEnt_nominal)
    "Waterside economizer heat exchanger"
    annotation (Placement(
        transformation(extent={{10,10},{-10,-10}}, rotation=180,
        origin={0,30})));

  Buildings.Templates.Components.Sensors.Temperature TChiWatEcoEnt(
    redeclare final package Medium = MediumChiWat,
    final m_flow_nominal=m2_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final have_sen=true) "Chilled water return temperature before economizer"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={80,-60})));
  Buildings.Templates.Components.Sensors.Temperature TChiWatEcoLvg(
    redeclare final package Medium = MediumChiWat,
    final m_flow_nominal=m2_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final have_sen=true) "Chilled water return temperature after economizer"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-70,-60})));

  // If bypass valve

  Buildings.Templates.Components.Valves.TwoWayModulating valChiWatEcoByp(
    redeclare final package Medium = MediumChiWat,
    final dat=dat.valChiWatEcoByp) if have_valChiWatEcoByp
    "Waterside economizer chilled water side bypass valve"
    annotation (Placement(transformation(extent={{10,-70},{-10,-50}})));
  Buildings.Templates.Components.Sensors.DifferentialPressure dpChiWatHex(
    redeclare final package Medium = MediumChiWat,
    final have_sen=true,
    final text_flip=true) if have_valChiWatEcoByp
    "Waterside economizer heat exchanger chilled water side differential pressure"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=180)));
  Buildings.Templates.BaseClasses.PassThroughFluid pasHex(
    redeclare final package Medium = MediumChiWat) if have_valChiWatEcoByp
    "Heat exchanger passthrough"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=90,
        origin={40,-40})));

  // If heat exchanger pump

  Buildings.Templates.Components.Pumps.MultipleVariable pumEco(
    redeclare final package Medium = MediumChiWat,
    final nPum=1,
    final dat={dat.pumEco},
    final have_singlePort_a=true,
    final have_singlePort_b=true)
    if not have_valChiWatEcoByp
    "Waterside economizer heat exchanger pump"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={60,-20})));
  Buildings.Templates.Components.Sensors.Temperature TChiWatHexEnt(
    redeclare final package Medium = MediumChiWat,
    final m_flow_nominal=m2_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final have_sen=true) if not have_valChiWatEcoByp
    "Waterside economizer heat exchanger entering temperature" annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={60,10})));
  Buildings.Templates.BaseClasses.PassThroughFluid pasChiWatEcoByp(
    redeclare each final package Medium = MediumChiWat)
    if not have_valChiWatEcoByp
    "Bypass passthrough"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=180,
        origin={0,-80})));

  // Condenser water side

  Buildings.Templates.Components.Valves.TwoWayTwoPosition valConWatEco(
      redeclare final package Medium = MediumConWat,
      final dat=dat.valConWatEco)
    "Waterside economizer condenser water side isolation valve"
    annotation (Placement(transformation(extent={{70,50},{90,70}})));
  Buildings.Templates.Components.Sensors.Temperature TConWatEcoRet(
    redeclare final package Medium = MediumConWat,
    final m_flow_nominal=m1_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final have_sen=true)
    "Waterside economizer condenser water return temperature"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=0,
        origin={50,60})));


equation
  /* Control point connection - start */
  connect(TChiWatEcoLvg.y, busCon.TChiWatEcoLvg);
  connect(TChiWatEcoEnt.y, busCon.TChiWatEcoEnt);
  connect(TChiWatHexEnt.y, busCon.TChiWatHexEnt);
  connect(TConWatEcoRet.y, busCon.TConWatEcoRet);
  connect(dpChiWatHex.y, busCon.dpChiWatHex);
  /* Control point connection - stop */

  connect(busCon.valConWatEco, valConWatEco.bus) annotation (Line(
      points={{0.1,100.1},{0.1,90},{80,90},{80,70}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(busCon.valChiWatEcoByp, valChiWatEcoByp.bus) annotation (Line(
      points={{0.1,100.1},{0.1,90},{-30,90},{-30,-32},{0,-32},{0,-50}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(busCon.pumEco,pumEco. bus) annotation (Line(
      points={{0.1,100.1},{0.1,90},{30,90},{30,-20},{50,-20}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));

  connect(hex.port_b2, TChiWatEcoLvg.port_a) annotation (Line(points={{-10,24},{
          -40,24},{-40,-60},{-60,-60}}, color={0,127,255}));
  connect(hex.port_b1, TConWatEcoRet.port_b)
    annotation (Line(points={{10,36},{20,36},{20,60},{40,60}},
      color={0,127,255}));
  connect(valConWatEco.port_b, port_b1)
    annotation (Line(points={{90,60},{100,60}}, color={0,127,255}));
  connect(valConWatEco.port_a, TConWatEcoRet.port_a)
    annotation (Line(points={{70,60},{60,60}}, color={0,127,255}));
  connect(TChiWatEcoLvg.port_b, port_b2)
    annotation (Line(points={{-80,-60},{-100,-60}}, color={0,127,255}));
  connect(dpChiWatHex.port_a, hex.port_a2)
    annotation (Line(points={{10,0},{16,0},{20,0},{20,24},{10,24}},
      color={0,127,255}));
  connect(dpChiWatHex.port_b, hex.port_b2)
    annotation (Line(points={{-10,0},{-16,0},{-20,0},{-20,24},{-10,24}},
      color={0,127,255}));
  connect(pasHex.port_b, hex.port_a2)
    annotation (Line(points={{40,-30},{40,24},{10,24}}, color={0,127,255}));
  connect(valChiWatEcoByp.port_b, TChiWatEcoLvg.port_a)
    annotation (Line(points={{-10,-60},{-60,-60}}, color={0,127,255}));
  connect(pasChiWatEcoByp.port_b, TChiWatEcoLvg.port_a) annotation (Line(points=
         {{-10,-80},{-40,-80},{-40,-60},{-60,-60}}, color={0,127,255}));
  connect(port_a2, TChiWatEcoEnt.port_a)
    annotation (Line(points={{100,-60},{90,-60}}, color={0,127,255}));
  connect(TChiWatEcoEnt.port_b, valChiWatEcoByp.port_a)
    annotation (Line(points={{70,-60},{10,-60}}, color={0,127,255}));
  connect(TChiWatEcoEnt.port_b,pumEco. port_a)
    annotation (Line(points={{70,-60},{60,-60},{60,-30}}, color={0,127,255}));
  connect(TChiWatEcoEnt.port_b, pasHex.port_a)
    annotation (Line(points={{70,-60},{40,-60},{40,-50}}, color={0,127,255}));
  connect(TChiWatEcoEnt.port_b, pasChiWatEcoByp.port_a) annotation (Line(points=
         {{70,-60},{60,-60},{60,-80},{10,-80}}, color={0,127,255}));
  connect(pumEco.port_b, TChiWatHexEnt.port_a)
    annotation (Line(points={{60,-10},{60,0}}, color={0,127,255}));
  connect(TChiWatHexEnt.port_b, hex.port_a2)
    annotation (Line(points={{60,20},{60,24},{10,24}}, color={0,127,255}));
  connect(port_a1, hex.port_a1)
    annotation (Line(points={{-100,60},{-40,60},{-40,36},{-10,36}},
      color={0,127,255}));

end WatersideEconomizer;

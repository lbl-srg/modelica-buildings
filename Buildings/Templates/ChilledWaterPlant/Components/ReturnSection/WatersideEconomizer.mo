within Buildings.Templates.ChilledWaterPlant.Components.ReturnSection;
model WatersideEconomizer
  extends
    Buildings.Templates.ChilledWaterPlant.Components.ReturnSection.Interfaces.PartialChilledWaterReturnSection(
      final typ=Buildings.Templates.ChilledWaterPlant.Components.Types.WatersideEconomizer.WatersideEconomizer,
      final isAirCoo = false)
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));

  // fixme WIP

  Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU hex(
    redeclare final package Medium1 = MediumCW,
    redeclare final package Medium2 = MediumCHW,
    final allowFlowReversal1=allowFlowReversal1,
    final allowFlowReversal2=allowFlowReversal1,
    final use_Q_flow_nominal=true,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    final dp1_nominal=dp1Hex_nominal,
    final dp2_nominal=dp2Hex_nominal,
    final m1_flow_nominal=m1_flow_nominal,
    final m2_flow_nominal=m2_flow_nominal,
    final Q_flow_nominal=Q_flow_nominal,
    final T_a1_nominal=T_a1_nominal,
    final T_a2_nominal=T_a2_nominal)
    "Heat exchanger" annotation (Placement(
        transformation(extent={{10,10},{-10,-10}}, rotation=180,
        origin={0,30})));

  Buildings.Templates.Components.Sensors.Temperature TWSERet(
    redeclare final package Medium = MediumCHW,
    final m_flow_nominal=m2_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final have_sen=true) "Waterside economizer leaving temperature" annotation (
     Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-70,-60})));

  // If bypass valve
  Buildings.Templates.Components.Valves.TwoWayModulating valByp(
    redeclare final package Medium = MediumCHW,
    final m_flow_nominal=m2_flow_nominal,
    final dpValve_nominal=dpValByp_nominal) if have_val
    "Waterside economizer bypass valve"
    annotation (Placement(transformation(extent={{10,-70},{-10,-50}})));
  Buildings.Templates.Components.Sensors.DifferentialPressure dpCHW(
    redeclare final package Medium = MediumCHW,
    final have_sen=true,
    final text_flip=true) if have_val
    "Waterside economizer differential pressure"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=180,
        origin={0,-20})));
  Buildings.Templates.BaseClasses.PassThroughFluid pasSup(
    redeclare final package Medium = MediumCHW)
    if have_val "Supply passthrough" annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={40,-20})));

  // If supply pump
  Buildings.Templates.Components.Sensors.Temperature TWSESup(
    redeclare final package Medium = MediumCHW,
    final m_flow_nominal=m2_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final have_sen=true) if not have_val
    "Waterside economizer entering temperature"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={70,-40})));
  Buildings.Templates.Components.Pumps.ParallelVariable pum(
    redeclare final package Medium = MediumCHW) if not have_val
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={70,0})));
  Buildings.Templates.BaseClasses.PassThroughFluid pasByp(
    redeclare each final package Medium = MediumCHW)
    if not have_val "Bypass passthrough" annotation (
      Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={0,-80})));

  //Condenser water side
  Buildings.Templates.Components.Sensors.Temperature TWSEConRet(
    redeclare final package Medium = MediumCW,
    final m_flow_nominal=m1_flow_nominal,
    final typ=Buildings.Templates.Components.Types.SensorTemperature.InWell,
    final have_sen=true)
    "Waterside economizer condenser water return temperature" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={40,60})));
  Buildings.Templates.Components.Valves.TwoWayModulating valCon(
    redeclare final package Medium = MediumCW,
    final m_flow_nominal=m1_flow_nominal,
    final dpValve_nominal=dpValCon_nominal)
    annotation (Placement(transformation(extent={{60,50},{80,70}})));

equation
  connect(hex.port_b2, TWSERet.port_a) annotation (Line(points={{-10,24},{-40,24},
          {-40,-60},{-60,-60}}, color={0,127,255}));
  connect(port_a1, hex.port_a1) annotation (Line(points={{-100,60},{-16,60},{-16,
          36},{-10,36}},
                       color={0,127,255}));
  connect(hex.port_b1, TWSEConRet.port_b) annotation (Line(points={{10,36},{24,36},
          {24,60},{30,60}}, color={0,127,255}));
  connect(valCon.port_b, port_b1)
    annotation (Line(points={{80,60},{100,60}}, color={0,127,255}));
  connect(valCon.port_a, TWSEConRet.port_a)
    annotation (Line(points={{60,60},{50,60}}, color={0,127,255}));
  connect(TWSERet.port_b, port_b2)
    annotation (Line(points={{-80,-60},{-100,-60}}, color={0,127,255}));
  connect(pum.port_b, hex.port_a2)
    annotation (Line(points={{70,10},{70,24},{10,24}},  color={0,127,255}));
  connect(dpCHW.port_a, hex.port_a2) annotation (Line(points={{10,-20},{20,-20},
          {20,24},{10,24}}, color={0,127,255}));
  connect(dpCHW.port_b, hex.port_b2) annotation (Line(points={{-10,-20},{-20,
          -20},{-20,24},{-10,24}},
                              color={0,127,255}));
  connect(pasSup.port_b, hex.port_a2)
    annotation (Line(points={{40,-10},{40,24},{10,24}}, color={0,127,255}));
  connect(valByp.port_b, TWSERet.port_a)
    annotation (Line(points={{-10,-60},{-60,-60}}, color={0,127,255}));
  connect(pasByp.port_b, TWSERet.port_a) annotation (Line(points={{-10,-80},{-40,
          -80},{-40,-60},{-60,-60}}, color={0,127,255}));
  connect(port_a2, TWSESup.port_a)
    annotation (Line(points={{100,-60},{70,-60},{70,-50}}, color={0,127,255}));
  connect(TWSESup.port_b, pum.port_a)
    annotation (Line(points={{70,-30},{70,-10}}, color={0,127,255}));
  connect(port_a2, pasSup.port_a)
    annotation (Line(points={{100,-60},{40,-60},{40,-30}}, color={0,127,255}));
  connect(port_a2, valByp.port_a)
    annotation (Line(points={{100,-60},{10,-60}}, color={0,127,255}));
  connect(port_a2, pasByp.port_a) annotation (Line(points={{100,-60},{40,-60},{40,
          -80},{10,-80}}, color={0,127,255}));
end WatersideEconomizer;

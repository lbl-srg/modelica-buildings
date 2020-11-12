within Buildings.Fluid.HeatExchangers.Validation;
model WetCoilEffectivenessNTU_FCU
  "Validation of WetCoilEffectivesnessNTU based on fan coil unit performance data"
  extends Modelica.Icons.Example;
  package MediumAir = Buildings.Media.Air;
  package MediumWater = Buildings.Media.Water;
  // Nominal conditions refer to purely sensible cooling conditions (inlet
  // water at 16 degC) that are used to parameterize coil models with UA
  // as a parameter.
  parameter Modelica.SIunits.MassFlowRate Q1_flow_nominal = 1176;
  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal=
    Q1_flow_nominal / (T_b1_nominal - T_a1_nominal) / cp1_nominal;
  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal = 485 * 1.2 / 3600;
  parameter Modelica.SIunits.Temperature T_a1_nominal = 16 + 273.15;
  parameter Modelica.SIunits.Temperature T_b1_nominal = T_a1_nominal + 2;
  parameter Modelica.SIunits.Temperature T_a2_nominal = 27 + 273.15;
  parameter Modelica.SIunits.Temperature T_b2_nominal=
    T_a2_nominal - Q1_flow_nominal / cp2_nominal / m2_flow_nominal;
  parameter Modelica.SIunits.MassFraction X_w2_nominal=0.010203;
  parameter Modelica.SIunits.SpecificHeatCapacity cp1_nominal = MediumWater.specificHeatCapacityCp(
    MediumWater.setState_pTX(MediumWater.p_default, T_a1_nominal))
    "Source side specific heat capacity at nominal conditions";
  parameter Modelica.SIunits.SpecificHeatCapacity cp2_nominal = MediumAir.specificHeatCapacityCp(
    MediumAir.setState_pTX(MediumAir.p_default, T_a2_nominal))
    "Load side specific heat capacity at nominal conditions";
  parameter Modelica.SIunits.ThermalConductance CMin_nominal=
      min(m1_flow_nominal * cp1_nominal, m2_flow_nominal * cp2_nominal)
    "Minimum capacity flow rate at nominal conditions";
  parameter Modelica.SIunits.ThermalConductance CMax_nominal=
      max(m1_flow_nominal * cp1_nominal, m2_flow_nominal * cp2_nominal)
    "Maximum capacity flow rate at nominal conditions";
  parameter Real Z = CMin_nominal / CMax_nominal
    "Ratio of capacity flow rates (CMin/CMax) at nominal conditions";
  parameter Buildings.Fluid.Types.HeatExchangerConfiguration hexCon=
    Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow
    "Heat exchanger configuration";
  parameter Modelica.SIunits.ThermalConductance UA_nominal=
    Buildings.Fluid.HeatExchangers.BaseClasses.ntu_epsilonZ(
    eps=abs(Q1_flow_nominal / (CMin_nominal * (T_a1_nominal - T_a2_nominal))),
    Z=Z,
    flowRegime=Integer(hexCon)) * CMin_nominal
    "Thermal conductance at nominal conditions";
  Buildings.Fluid.HeatExchangers.WetCoilEffectivesnessNTU cooCoi16_IBPSA(
    redeclare package Medium1 = MediumWater,
    redeclare package Medium2 = MediumAir,
    Q_flow_nominal=Q1_flow_nominal,
    dp1_nominal=0,
    dp2_nominal=0,
    m1_flow_nominal=m1_flow_nominal,
    configuration=hexCon,
    m2_flow_nominal=m2_flow_nominal,
    T_a1_nominal=T_a1_nominal,
    T_a2_nominal=T_a2_nominal,
    X_w2_nominal=X_w2_nominal)
    "Cooling coil with nominal conditions for cooling at 16 degrees water inlet temperature"
    annotation (Placement(transformation(extent={{-10,76},{10,96}})));
  Sources.MassFlowSource_T bouAirCoo(
    redeclare package Medium = MediumAir,
    use_m_flow_in=true,
    T=T_a2_nominal,
    X={X_w2_nominal,1 - X_w2_nominal},
    nPorts=1) "Air boundary: 27/19 dry/wet bulb temperature"
    annotation (Placement(transformation(extent={{60,70},{40,90}})));
    // fixme: reformat the table so it is readable.
  Modelica.Blocks.Sources.CombiTimeTable cooData(
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    table=[
      0,485,1176,2176,2934;
      10000,420,1053,1948,2657;
      20000,330,865,1600,2209;
      30000,236,626,1158,1618;
      40000,123,389,720,1018;
      50000,0,0.001,0.001,0.001])
    "Manufacturers data for cooling mode - 1. air flow rate 2.power at 16 degC 3.sensible power at 7 degC 4.total power at 7degC"
    annotation (Placement(transformation(extent={{-130,90},{-110,110}})));
  Sources.MassFlowSource_T bouAirCoo1(
    redeclare package Medium = MediumAir,
    use_m_flow_in=true,
    T=T_a2_nominal,
    X={X_w2_nominal, 1 - X_w2_nominal},
    nPorts=1)
    "Air boundary: 27/19 dry/wet bulb temperature"
    annotation (Placement(transformation(extent={{60,-26},{40,-6}})));
  Modelica.Blocks.Math.Gain gainFloFcu16(k=1/cp1_nominal/2)
    "Conversion factor from power to kg/s water"
    annotation (Placement(transformation(extent={{-66,94},{-54,106}})));
  Modelica.Blocks.Math.Gain gain(k=1.2/3600)
    "Conversion factor from l/h to kg/s"
    annotation (Placement(transformation(extent={{-2,106},{18,126}})));
  Sources.MassFlowSource_T bouWatCoo16(
    use_m_flow_in=true,
    redeclare package Medium = MediumWater,
    T=T_a1_nominal,
    nPorts=1) "Water boundary at 16 degrees"
    annotation (Placement(transformation(extent={{-40,82},{-20,102}})));
  Sources.MassFlowSource_T bouWatCoo7(
    use_m_flow_in=true,
    redeclare package Medium = MediumWater,
    T=7 + 273.15,
    nPorts=1) "Water boundary at 7 degrees"
    annotation (Placement(transformation(extent={{-40,-14},{-20,6}})));
  Modelica.Blocks.Math.Gain gainFloFcu7(k=1/cp1_nominal/5)
    "Conversion factor from power to kg/s water"
    annotation (Placement(transformation(extent={{-66,-2},{-54,10}})));
  Buildings.Fluid.HeatExchangers.WetCoilEffectivesnessNTU cooCoi7_IBPSA(
    redeclare package Medium1 = MediumWater,
    redeclare package Medium2 = MediumAir,
    show_T=true,
    dp1_nominal=0,
    dp2_nominal=0,
    m1_flow_nominal=2934/5/cp1_nominal,
    configuration=hexCon,
    m2_flow_nominal=m2_flow_nominal,
    Q_flow_nominal=2934,
    T_a1_nominal=280.15,
    T_a2_nominal=T_a2_nominal,
    X_w2_nominal=X_w2_nominal)
    "Cooling coil with nominal conditions for cooling at 7 degrees water inlet temperature"
    annotation (Placement(transformation(extent={{-10,-20},{10,0}})));
  Sources.Boundary_pT sinAir(
    redeclare package Medium = MediumAir, nPorts=7)
    "Air sink"
    annotation (Placement(transformation(extent={{-130,-10},{-110,10}})));
  Sources.Boundary_pT sinWat(
    redeclare package Medium = MediumWater, nPorts=7)
    "Water sink"
    annotation (Placement(transformation(extent={{130,-10},{110,10}})));
  Buildings.Fluid.HeatExchangers.WetCoilEffectivesnessNTU cooCoi7Param16_IBPSA(
    redeclare package Medium1 = MediumWater,
    redeclare package Medium2 = MediumAir,
    Q_flow_nominal=Q1_flow_nominal,
    dp1_nominal=0,
    dp2_nominal=0,
    m1_flow_nominal=m1_flow_nominal,
    configuration=hexCon,
    m2_flow_nominal=m2_flow_nominal,
    T_a1_nominal=T_a1_nominal,
    T_a2_nominal=T_a2_nominal,
    X_w2_nominal=X_w2_nominal)
    "Cooling coil with nominal conditions for cooling at 16 degrees water inlet temperature and boundary conditions of 7 degrees water inlet"
    annotation (Placement(transformation(extent={{-10,-66},{10,-46}})));

  Sources.MassFlowSource_T bouWatCoo7v2(
    use_m_flow_in=true,
    redeclare package Medium = MediumWater,
    T=280.15,
    nPorts=1) "Water boundary at 7 degrees"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Sources.MassFlowSource_T bouAirCoo2(
    redeclare package Medium = MediumAir,
    use_m_flow_in=true,
    T=27 + 273.15,
    X={X_w2_nominal,1 - X_w2_nominal},
    nPorts=1)
    "Air boundary: 27/19 dry/wet bulb temperature"
    annotation (Placement(transformation(extent={{60,-72},{40,-52}})));
  WetEffectivenessNTU_Fuzzy_V2_2_4 cooCoi16(
    redeclare package Medium1 = MediumWater,
    redeclare package Medium2 = MediumAir,
    configuration=hexCon,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    UA_nominal=UA_nominal,
    dp1_nominal=0,
    dp2_nominal=0)
    annotation (Placement(transformation(extent={{-10,52},{10,72}})));
  Sources.MassFlowSource_T bouWatCoo1(
    use_m_flow_in=true,
    redeclare package Medium = MediumWater,
    T=T_a1_nominal,
    nPorts=1) "Water boundary at 16 degrees"
    annotation (Placement(transformation(extent={{-40,58},{-20,78}})));
  Sources.MassFlowSource_T bouAirCoo3(
    redeclare package Medium = MediumAir,
    use_m_flow_in=true,
    T=T_a2_nominal,
    X={X_w2_nominal,1 - X_w2_nominal},
    nPorts=1) "Air boundary: 27/19 dry/wet bulb temperature"
    annotation (Placement(transformation(extent={{60,46},{40,66}})));
  Sources.MassFlowSource_T bouWatCoo7v1(
    use_m_flow_in=true,
    redeclare package Medium = MediumWater,
    T=7 + 273.15,
    nPorts=1) "Water boundary at 7 degrees"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Sources.MassFlowSource_T bouAirCoo5(
    redeclare package Medium = MediumAir,
    use_m_flow_in=true,
    T=T_a2_nominal,
    X={X_w2_nominal,1 - X_w2_nominal},
    nPorts=1)
    "Air boundary: 27/19 dry/wet bulb temperature"
    annotation (Placement(transformation(extent={{60,-102},{40,-82}})));
  WetEffectivenessNTU_Fuzzy_V2_2_4 cooCoi7Param16(
    redeclare package Medium1 = MediumWater,
    redeclare package Medium2 = MediumAir,
    configuration=hexCon,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    UA_nominal=UA_nominal,
    dp1_nominal=0,
    dp2_nominal=0)
    annotation (Placement(transformation(extent={{-10,-96},{10,-76}})));
  WetCoilCounterFlow cooCoi16_Dis(
    redeclare package Medium1 = MediumWater,
    redeclare package Medium2 = MediumAir,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    dp2_nominal=0,
    allowFlowReversal1=true,
    allowFlowReversal2=true,
    dp1_nominal=0,
    UA_nominal=UA_nominal,
    show_T=true,
    nEle=10,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{-10,24},{10,44}})));
  Sources.MassFlowSource_T bouWatCoo3(
    use_m_flow_in=true,
    redeclare package Medium = MediumWater,
    T=T_a1_nominal,
    nPorts=1) "Water boundary at 16 degrees"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Sources.MassFlowSource_T bouAirCoo6(
    redeclare package Medium = MediumAir,
    use_m_flow_in=true,
    T=T_a2_nominal,
    X={X_w2_nominal,1 - X_w2_nominal},
    nPorts=1) "Air boundary: 27/19 dry/wet bulb temperature"
    annotation (Placement(transformation(extent={{60,18},{40,38}})));
  WetCoilCounterFlow cooCoi7Param16_Dis(
    redeclare package Medium1 = MediumWater,
    redeclare package Medium2 = MediumAir,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    dp2_nominal=0,
    allowFlowReversal1=true,
    allowFlowReversal2=true,
    dp1_nominal=0,
    UA_nominal=UA_nominal,
    show_T=true,
    nEle=10,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{-10,-124},{10,-104}})));
  Sources.MassFlowSource_T bouWatCoo7v3(
    use_m_flow_in=true,
    redeclare package Medium = MediumWater,
    T=280.15,
    nPorts=1) "Water boundary at 7 degrees"
    annotation (Placement(transformation(extent={{-40,-118},{-20,-98}})));
  Sources.MassFlowSource_T bouAirCoo4(
    redeclare package Medium = MediumAir,
    use_m_flow_in=true,
    T=T_a2_nominal,
    X={X_w2_nominal,1 - X_w2_nominal},
    nPorts=1)
    "Air boundary: 27/19 dry/wet bulb temperature"
    annotation (Placement(transformation(extent={{60,-130},{40,-110}})));
equation
  // fixme: enable or delete the assertion
  //assert(abs(cooCoi7.Q1_flow-cooCoi7Reverse.Q1_flow)+
  //       abs(cooCoi7.mWat1_flow-cooCoi7Reverse.mWat2_flow)<1e-10,
  //      "The models cooCoi7 and cooCoi7Reverse do
  //      not return identical results as required.");
  connect(gainFloFcu16.u, cooData.y[2])
    annotation (Line(points={{-67.2,100},{-109,100}},color={0,0,127}));
  connect(gain.u, cooData.y[1])
    annotation (Line(points={{-4,116},{-74,116},{-74,100},{-109,100}},
                                                  color={0,0,127}));
  connect(gain.y, bouAirCoo.m_flow_in)
    annotation (Line(points={{19,116},{68,116},{68,88},{62,88}},
                                                          color={0,0,127}));
  connect(gainFloFcu16.y, bouWatCoo16.m_flow_in) annotation (Line(points={{-53.4,
          100},{-42,100}},           color={0,0,127}));
  connect(gainFloFcu7.y,bouWatCoo7. m_flow_in)
    annotation (Line(points={{-53.4,4},{-42,4}},     color={0,0,127}));
  connect(gainFloFcu7.u, cooData.y[4]) annotation (Line(points={{-67.2,4},{-74,4},
          {-74,100},{-109,100}},     color={0,0,127}));
  connect(bouWatCoo7v2.m_flow_in, gainFloFcu7.y) annotation (Line(points={{-42,-42},
          {-50,-42},{-50,4},{-53.4,4}},color={0,0,127}));
  connect(gain.y, bouAirCoo1.m_flow_in) annotation (Line(points={{19,116},{68,116},
          {68,-8},{62,-8}}, color={0,0,127}));
  connect(gain.y, bouAirCoo2.m_flow_in) annotation (Line(points={{19,116},{68,116},
          {68,-54},{62,-54}}, color={0,0,127}));
  connect(bouWatCoo7v2.ports[1], cooCoi7Param16_IBPSA.port_a1)
    annotation (Line(points={{-20,-50},{-10,-50}}, color={0,127,255}));
  connect(bouWatCoo7.ports[1], cooCoi7_IBPSA.port_a1)
    annotation (Line(points={{-20,-4},{-10,-4}},   color={0,127,255}));
  connect(cooCoi7_IBPSA.port_b1, sinWat.ports[1]) annotation (Line(points={{10,-4},
          {20,-4},{20,4},{80,4},{80,3.42857},{110,3.42857}},      color={0,127,255}));
  connect(cooCoi7Param16_IBPSA.port_b1, sinWat.ports[2]) annotation (Line(
        points={{10,-50},{46,-50},{46,-52},{80,-52},{80,2.28571},{110,2.28571}},
                                                                     color={0,127,
          255}));
  connect(cooCoi16_IBPSA.port_b1, sinWat.ports[3]) annotation (Line(points={{10,92},
          {20,92},{20,116},{80,116},{80,1.14286},{110,1.14286}},
                                        color={0,127,255}));
  connect(bouAirCoo1.ports[1], cooCoi7_IBPSA.port_a2)
    annotation (Line(points={{40,-16},{10,-16}}, color={0,127,255}));
  connect(bouAirCoo2.ports[1], cooCoi7Param16_IBPSA.port_a2)
    annotation (Line(points={{40,-62},{10,-62}}, color={0,127,255}));
  connect(sinAir.ports[1], cooCoi16_IBPSA.port_b2) annotation (Line(points={{-110,
          3.42857},{-80,3.42857},{-80,80},{-10,80}},
                                           color={0,127,255}));
  connect(cooCoi7_IBPSA.port_b2, sinAir.ports[2]) annotation (Line(points={{-10,-16},
          {-80,-16},{-80,2.28571},{-110,2.28571}},
                                            color={0,127,255}));
  connect(cooCoi7Param16_IBPSA.port_b2, sinAir.ports[3]) annotation (Line(
        points={{-10,-62},{-80,-62},{-80,1.14286},{-110,1.14286}},   color={0,127,
          255}));
  connect(cooCoi16.port_b2, sinAir.ports[4]) annotation (Line(points={{-10,56},{
          -80,56},{-80,1.11022e-16},{-110,1.11022e-16}},
                                      color={0,127,255}));
  connect(cooCoi16.port_b1, sinWat.ports[4]) annotation (Line(points={{10,68},{80,
          68},{80,1.11022e-16},{110,1.11022e-16}},
                                color={0,127,255}));
  connect(bouAirCoo.ports[1], cooCoi16_IBPSA.port_a2) annotation (Line(points={{40,80},
          {10,80}},                        color={0,127,255}));
  connect(bouWatCoo16.ports[1], cooCoi16_IBPSA.port_a1) annotation (Line(points={{-20,92},
          {-10,92}},                            color={0,127,255}));
  connect(bouWatCoo1.ports[1], cooCoi16.port_a1)
    annotation (Line(points={{-20,68},{-10,68}}, color={0,127,255}));
  connect(bouAirCoo3.ports[1], cooCoi16.port_a2) annotation (Line(points={{40,56},
          {10,56}},                 color={0,127,255}));
  connect(gain.y, bouAirCoo3.m_flow_in) annotation (Line(points={{19,116},{68,
          116},{68,64},{62,64}},
                            color={0,0,127}));
  connect(gainFloFcu16.y, bouWatCoo1.m_flow_in) annotation (Line(points={{-53.4,
          100},{-48,100},{-48,76},{-42,76}},
                                           color={0,0,127}));
  connect(bouWatCoo7v1.ports[1], cooCoi7Param16.port_a1)
    annotation (Line(points={{-20,-80},{-10,-80}},   color={0,127,255}));
  connect(cooCoi7Param16.port_b2, sinAir.ports[5]) annotation (Line(points={{-10,-92},
          {-80,-92},{-80,-2},{-110,-2},{-110,-1.14286}},        color={0,127,255}));
  connect(bouAirCoo5.ports[1], cooCoi7Param16.port_a2)
    annotation (Line(points={{40,-92},{10,-92}},   color={0,127,255}));
  connect(cooCoi7Param16.port_b1, sinWat.ports[5]) annotation (Line(points={{10,-80},
          {80,-80},{80,-1.14286},{110,-1.14286}},
        color={0,127,255}));
  connect(bouWatCoo7v2.m_flow_in, bouWatCoo7v1.m_flow_in) annotation (Line(
        points={{-42,-42},{-50,-42},{-50,-72},{-42,-72}},   color={0,0,127}));
  connect(gain.y, bouAirCoo5.m_flow_in) annotation (Line(points={{19,116},{68,116},
          {68,-84},{62,-84}},                       color={0,0,127}));
  connect(bouWatCoo3.ports[1],cooCoi16_Dis. port_a1)
    annotation (Line(points={{-20,40},{-10,40}}, color={0,127,255}));
  connect(bouAirCoo6.ports[1],cooCoi16_Dis. port_a2)
    annotation (Line(points={{40,28},{10,28}}, color={0,127,255}));
  connect(sinAir.ports[6],cooCoi16_Dis. port_b2) annotation (Line(points={{-110,
          -2.28571},{-80,-2.28571},{-80,28},{-10,28}}, color={0,127,255}));
  connect(cooCoi16_Dis.port_b1, sinWat.ports[6]) annotation (Line(points={{10,40},
          {80,40},{80,-2.28571},{110,-2.28571}}, color={0,127,255}));
  connect(gainFloFcu16.y, bouWatCoo3.m_flow_in) annotation (Line(points={{-53.4,
          100},{-48,100},{-48,48},{-42,48}}, color={0,0,127}));
  connect(gain.y, bouAirCoo6.m_flow_in) annotation (Line(points={{19,116},{68,
          116},{68,36},{62,36}}, color={0,0,127}));
  connect(bouWatCoo7v3.ports[1],cooCoi7Param16_Dis. port_a1)
    annotation (Line(points={{-20,-108},{-10,-108}}, color={0,127,255}));
  connect(bouAirCoo4.ports[1],cooCoi7Param16_Dis. port_a2)
    annotation (Line(points={{40,-120},{10,-120}}, color={0,127,255}));
  connect(cooCoi7Param16_Dis.port_b2, sinAir.ports[7]) annotation (Line(points={
          {-10,-120},{-80,-120},{-80,-3.42857},{-110,-3.42857}}, color={0,127,255}));
  connect(gainFloFcu7.y, bouWatCoo7v3.m_flow_in) annotation (Line(points={{-53.4,
          4},{-50,4},{-50,-100},{-42,-100}}, color={0,0,127}));
  connect(gain.y, bouAirCoo4.m_flow_in) annotation (Line(points={{19,116},{68,116},
          {68,-112},{62,-112}}, color={0,0,127}));
  connect(cooCoi7Param16_Dis.port_b1, sinWat.ports[7]) annotation (Line(points={
          {10,-108},{80,-108},{80,0},{110,0},{110,-3.42857}}, color={0,127,255}));
  annotation (experiment(
      StopTime=50000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Lsodar"), __Dymola_Commands(
        file="Resources/Scripts/Dymola/Fluid/HeatExchangers/Validation/WetCoilEffectivenessNTU_FCU.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
fixme: complete info section.
</p>
</html>", revisions="<html>
<p>
fixme: add revision section
</p>
</html>"),
    Diagram(coordinateSystem(extent={{-140,-140},{140,140}}), graphics={Text(
          extent={{-134,146},{-12,110}},
          lineColor={28,108,200},
          textString="Water mass flow rate computed based on a constant deltaT at each operating point")}));
end WetCoilEffectivenessNTU_FCU;

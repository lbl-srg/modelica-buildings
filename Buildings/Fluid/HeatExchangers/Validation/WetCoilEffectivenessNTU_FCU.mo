within Buildings.Fluid.HeatExchangers.Validation;
model WetCoilEffectivenessNTU_FCU
  "Validation of WetCoilEffectivesnessNTU based on fan coil unit performance data"
  extends Modelica.Icons.Example;
  package MediumAir = Buildings.Media.Air;
  package MediumWater = Buildings.Media.Water;
  parameter Modelica.SIunits.SpecificHeatCapacity cpWat = MediumWater.cp_const;

  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal = 485*1.2/3600;
  parameter Modelica.SIunits.Temperature T_a1_nominal = 16 + 273.15;
  parameter Modelica.SIunits.Temperature T_a2_nominal = 27 + 273.15;
  parameter Modelica.SIunits.MassFraction X_w2_nominal=0.010203;
  Buildings.Fluid.HeatExchangers.WetCoilEffectivesnessNTU cooCoi16_IBPSA(
    redeclare package Medium1 = MediumWater,
    redeclare package Medium2 = MediumAir,
    Q_flow_nominal=1176,
    dp1_nominal=0,
    dp2_nominal=0,
    m1_flow_nominal=1176/2/4180,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CrossFlowUnmixed,
    m2_flow_nominal=m2_flow_nominal,
    T_a1_nominal=289.15,
    T_a2_nominal=T_a2_nominal,
    X_w2_nominal=X_w2_nominal)
    "Cooling coil with nominal conditions for cooling at 16 degrees water inlet temperature"
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));
  Sources.MassFlowSource_T bouAirCoo(
    redeclare package Medium = MediumAir,
    use_m_flow_in=true,
    T=300.15,
    X={X_w2_nominal,1 - X_w2_nominal},
    nPorts=1) "Air boundary: 27/19 dry/wet bulb temperature"
    annotation (Placement(transformation(extent={{60,34},{40,54}})));
    // fixme: reformat the table so it is readable.
  Modelica.Blocks.Sources.CombiTimeTable cooData(smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
      table=[0,485,1176,2176,2934; 10000,420,1053,1948,2657; 20000,330,865,1600,
        2209; 30000,236,626,1158,1618; 40000,123,389,720,1018; 50000,0,0.001,0.001,
        0.001])
    "Manufacturers data for cooling mode - 1. air flow rate 2.power at 16 degC 3.sensible power at 7 degC 4.total power at 7degC"
    annotation (Placement(transformation(extent={{-130,90},{-110,110}})));
  Sources.MassFlowSource_T bouAirCoo1(
    redeclare package Medium = MediumAir,
    use_m_flow_in=true,
    T=T_a2_nominal,
    X={X_w2_nominal, 1 - X_w2_nominal},
    nPorts=1)
    "Air boundary: 27/19 dry/wet bulb temperature"
    annotation (Placement(transformation(extent={{60,-46},{40,-26}})));
  Modelica.Blocks.Math.Gain gainFloFcu16(k=1/4180/2)
    "Conversion factor from power to kg/s water "
    annotation (Placement(transformation(extent={{-66,58},{-54,70}})));
  Modelica.Blocks.Math.Gain gain(k=1.2/3600)
    "Conversion factor from l/h to kg/s"
    annotation (Placement(transformation(extent={{-2,70},{18,90}})));
  Sources.MassFlowSource_T bouWatCoo16(
    use_m_flow_in=true,
    redeclare package Medium = MediumWater,
    T=289.15,
    nPorts=1) "Water boundary at 16 degrees"
    annotation (Placement(transformation(extent={{-40,46},{-20,66}})));
  Sources.MassFlowSource_T bouWatCoo7(
    use_m_flow_in=true,
    redeclare package Medium = MediumWater,
    T=7 + 273.15,
    nPorts=1) "Water boundary at 7 degrees"
    annotation (Placement(transformation(extent={{-40,-34},{-20,-14}})));
  Modelica.Blocks.Math.Gain gainFloFcu7(k=1/4180/5)
    "Conversion factor from power to kg/s water "
    annotation (Placement(transformation(extent={{-66,-22},{-54,-10}})));
  Buildings.Fluid.HeatExchangers.WetCoilEffectivesnessNTU cooCoi7_IBPSA(
    redeclare package Medium1 = MediumWater,
    redeclare package Medium2 = MediumAir,
    show_T=true,
    dp1_nominal=0,
    dp2_nominal=0,
    m1_flow_nominal=2934/5/4180,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CrossFlowUnmixed,
    m2_flow_nominal=m2_flow_nominal,
    Q_flow_nominal=2934,
    T_a1_nominal=280.15,
    T_a2_nominal=T_a2_nominal,
    X_w2_nominal=X_w2_nominal)
    "Cooling coil with nominal conditions for cooling at 7 degrees water inlet temperature"
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  Sources.Boundary_pT sinAir(
    redeclare package Medium = MediumAir, nPorts=6)
    "Air sink"
    annotation (Placement(transformation(extent={{-130,-10},{-110,10}})));
  Sources.Boundary_pT sinWat(
    redeclare package Medium = MediumWater, nPorts=6)
    "Water sink"
    annotation (Placement(transformation(extent={{130,-10},{110,10}})));
  Buildings.Fluid.HeatExchangers.WetCoilEffectivesnessNTU cooCoi7Param16_IBPSA(
    redeclare package Medium1 = MediumWater,
    redeclare package Medium2 = MediumAir,
    Q_flow_nominal=1176,
    dp1_nominal=0,
    dp2_nominal=0,
    m1_flow_nominal=1176/2/4180,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CrossFlowUnmixed,
    m2_flow_nominal=m2_flow_nominal,
    T_a1_nominal=289.15,
    T_a2_nominal=T_a2_nominal,
    X_w2_nominal=X_w2_nominal)
    "Cooling coil with nominal conditions for cooling at 7 degrees water inlet temperature and boundary conditions of 16 degrees water inlet"
    annotation (Placement(transformation(extent={{-10,-100},{10,-80}})));

  Sources.MassFlowSource_T bouWatCoo7v2(
    use_m_flow_in=true,
    redeclare package Medium = MediumWater,
    T=7 + 273.15,
    nPorts=1) "Water boundary at 7 degrees"
    annotation (Placement(transformation(extent={{-40,-94},{-20,-74}})));
  Sources.MassFlowSource_T bouAirCoo2(
    redeclare package Medium = MediumAir,
    use_m_flow_in=true,
    T=27 + 273.15,
    X={X_w2_nominal,1 - X_w2_nominal},
    nPorts=1)
    "Air boundary: 27/19 dry/wet bulb temperature"
    annotation (Placement(transformation(extent={{60,-106},{40,-86}})));
  WetEffectivenessNTU_Fuzzy_V2_2_4 cooCoi16(
    redeclare package Medium1 = MediumWater,
    redeclare package Medium2 = MediumAir,
    configuration=cooCoi16_IBPSA.configuration,
    m1_flow_nominal=cooCoi16_IBPSA.m1_flow_nominal,
    m2_flow_nominal=cooCoi16_IBPSA.m2_flow_nominal,
    UA_nominal=cooCoi16_IBPSA.UA_nominal,
    dp1_nominal=0,
    dp2_nominal=0)
    annotation (Placement(transformation(extent={{-10,16},{10,36}})));
  Sources.MassFlowSource_T bouWatCoo1(
    use_m_flow_in=true,
    redeclare package Medium = MediumWater,
    T=289.15,
    nPorts=1) "Water boundary at 16 degrees"
    annotation (Placement(transformation(extent={{-40,22},{-20,42}})));
  Sources.MassFlowSource_T bouAirCoo3(
    redeclare package Medium = MediumAir,
    use_m_flow_in=true,
    T=300.15,
    X={X_w2_nominal,1 - X_w2_nominal},
    nPorts=1) "Air boundary: 27/19 dry/wet bulb temperature"
    annotation (Placement(transformation(extent={{60,10},{40,30}})));
  Sources.MassFlowSource_T bouWatCoo2(
    use_m_flow_in=true,
    redeclare package Medium = MediumWater,
    T=7 + 273.15,
    nPorts=1) "Water boundary at 7 degrees"
    annotation (Placement(transformation(extent={{-40,-62},{-20,-42}})));
  Sources.MassFlowSource_T bouAirCoo4(
    redeclare package Medium = MediumAir,
    use_m_flow_in=true,
    T=T_a2_nominal,
    X={X_w2_nominal,1 - X_w2_nominal},
    nPorts=1)
    "Air boundary: 27/19 dry/wet bulb temperature"
    annotation (Placement(transformation(extent={{60,-74},{40,-54}})));
  WetEffectivenessNTU_Fuzzy_V2_2_4 cooCoi7(
    redeclare package Medium1 = MediumWater,
    redeclare package Medium2 = MediumAir,
    show_T=true,
    configuration=cooCoi7_IBPSA.configuration,
    m1_flow_nominal=cooCoi7_IBPSA.m1_flow_nominal,
    m2_flow_nominal=cooCoi7_IBPSA.m2_flow_nominal,
    UA_nominal=cooCoi7_IBPSA.UA_nominal,
    dp1_nominal=0,
    dp2_nominal=0)
    annotation (Placement(transformation(extent={{-10,-68},{10,-48}})));
  Sources.MassFlowSource_T bouWatCoo7v1(
    use_m_flow_in=true,
    redeclare package Medium = MediumWater,
    T=7 + 273.15,
    nPorts=1) "Water boundary at 7 degrees"
    annotation (Placement(transformation(extent={{-40,-124},{-20,-104}})));
  Sources.MassFlowSource_T bouAirCoo5(
    redeclare package Medium = MediumAir,
    use_m_flow_in=true,
    T=27 + 273.15,
    X={X_w2_nominal,1 - X_w2_nominal},
    nPorts=1)
    "Air boundary: 27/19 dry/wet bulb temperature"
    annotation (Placement(transformation(extent={{60,-136},{40,-116}})));
  WetEffectivenessNTU_Fuzzy_V2_2_4 cooCoi7Param16(
    redeclare package Medium1 = MediumWater,
    redeclare package Medium2 = MediumAir,
    configuration=cooCoi7Param16_IBPSA.configuration,
    m1_flow_nominal=cooCoi7Param16_IBPSA.m1_flow_nominal,
    m2_flow_nominal=cooCoi7Param16_IBPSA.m2_flow_nominal,
    UA_nominal=cooCoi7Param16_IBPSA.UA_nominal,
    dp1_nominal=0,
    dp2_nominal=0)
    annotation (Placement(transformation(extent={{-10,-130},{10,-110}})));
equation
  // fixme: enable or delete the assertion
  //assert(abs(cooCoi7.Q1_flow-cooCoi7Reverse.Q1_flow)+
  //       abs(cooCoi7.mWat1_flow-cooCoi7Reverse.mWat2_flow)<1e-10,
  //      "The models cooCoi7 and cooCoi7Reverse do
  //      not return identical results as required.");
  connect(gainFloFcu16.u, cooData.y[2])
    annotation (Line(points={{-67.2,64},{-74,64},{-74,100},{-109,100}},
                                                     color={0,0,127}));
  connect(gain.u, cooData.y[1])
    annotation (Line(points={{-4,80},{-74,80},{-74,100},{-109,100}},
                                                  color={0,0,127}));
  connect(gain.y, bouAirCoo.m_flow_in)
    annotation (Line(points={{19,80},{68,80},{68,52},{62,52}},
                                                          color={0,0,127}));
  connect(gainFloFcu16.y, bouWatCoo16.m_flow_in) annotation (Line(points={{-53.4,
          64},{-42,64}},             color={0,0,127}));
  connect(gainFloFcu7.y,bouWatCoo7. m_flow_in)
    annotation (Line(points={{-53.4,-16},{-42,-16}}, color={0,0,127}));
  connect(gainFloFcu7.u, cooData.y[4]) annotation (Line(points={{-67.2,-16},{
          -74,-16},{-74,100},{-109,100}},
                                     color={0,0,127}));
  connect(bouWatCoo7v2.m_flow_in, gainFloFcu7.y) annotation (Line(points={{-42,-76},
          {-50,-76},{-50,-16},{-53.4,-16}},
                                       color={0,0,127}));
  connect(gain.y, bouAirCoo1.m_flow_in) annotation (Line(points={{19,80},{68,80},
          {68,-28},{62,-28}},
                            color={0,0,127}));
  connect(gain.y, bouAirCoo2.m_flow_in) annotation (Line(points={{19,80},{68,80},
          {68,-88},{62,-88}}, color={0,0,127}));
  connect(bouWatCoo7v2.ports[1], cooCoi7Param16_IBPSA.port_a1)
    annotation (Line(points={{-20,-84},{-10,-84}}, color={0,127,255}));
  connect(bouWatCoo7.ports[1], cooCoi7_IBPSA.port_a1)
    annotation (Line(points={{-20,-24},{-10,-24}}, color={0,127,255}));
  connect(cooCoi7_IBPSA.port_b1, sinWat.ports[1]) annotation (Line(points={{10,-24},
          {20,-24},{20,-16},{80,-16},{80,3.33333},{110,3.33333}}, color={0,127,255}));
  connect(cooCoi7Param16_IBPSA.port_b1, sinWat.ports[2]) annotation (Line(
        points={{10,-84},{20,-84},{20,-80},{80,-80},{80,2},{110,2}}, color={0,127,
          255}));
  connect(cooCoi16_IBPSA.port_b1, sinWat.ports[3]) annotation (Line(points={{10,56},
          {20,56},{20,60},{80,60},{80,0.666667},{110,0.666667}},
                                        color={0,127,255}));
  connect(bouAirCoo1.ports[1], cooCoi7_IBPSA.port_a2)
    annotation (Line(points={{40,-36},{10,-36}}, color={0,127,255}));
  connect(bouAirCoo2.ports[1], cooCoi7Param16_IBPSA.port_a2)
    annotation (Line(points={{40,-96},{10,-96}}, color={0,127,255}));
  connect(sinAir.ports[1], cooCoi16_IBPSA.port_b2) annotation (Line(points={{-110,
          3.33333},{-80,3.33333},{-80,44},{-10,44}},
                                           color={0,127,255}));
  connect(cooCoi7_IBPSA.port_b2, sinAir.ports[2]) annotation (Line(points={{-10,
          -36},{-80,-36},{-80,2},{-110,2}}, color={0,127,255}));
  connect(cooCoi7Param16_IBPSA.port_b2, sinAir.ports[3]) annotation (Line(
        points={{-10,-96},{-80,-96},{-80,0.666667},{-110,0.666667}}, color={0,127,
          255}));
  connect(cooCoi16.port_b2, sinAir.ports[4]) annotation (Line(points={{-10,20},
          {-80,20},{-80,-0.666667},{-110,-0.666667}},
                                      color={0,127,255}));
  connect(cooCoi16.port_b1, sinWat.ports[4]) annotation (Line(points={{10,32},{
          80,32},{80,-0.666667},{110,-0.666667}},
                                color={0,127,255}));
  connect(bouAirCoo.ports[1], cooCoi16_IBPSA.port_a2) annotation (Line(points={{40,44},
          {10,44}},                        color={0,127,255}));
  connect(bouWatCoo16.ports[1], cooCoi16_IBPSA.port_a1) annotation (Line(points=
         {{-20,56},{-16,56},{-16,56},{-10,56}}, color={0,127,255}));
  connect(bouWatCoo1.ports[1], cooCoi16.port_a1)
    annotation (Line(points={{-20,32},{-10,32}}, color={0,127,255}));
  connect(bouAirCoo3.ports[1], cooCoi16.port_a2) annotation (Line(points={{40,20},
          {10,20}},                 color={0,127,255}));
  connect(gain.y, bouAirCoo3.m_flow_in) annotation (Line(points={{19,80},{68,80},
          {68,28},{62,28}}, color={0,0,127}));
  connect(gainFloFcu16.y, bouWatCoo1.m_flow_in) annotation (Line(points={{-53.4,
          64},{-48,64},{-48,40},{-42,40}}, color={0,0,127}));
  connect(bouWatCoo2.ports[1], cooCoi7.port_a1)
    annotation (Line(points={{-20,-52},{-10,-52}}, color={0,127,255}));
  connect(cooCoi7.port_b1, sinWat.ports[5]) annotation (Line(points={{10,-52},{
          80,-52},{80,-2},{110,-2}},
                                  color={0,127,255}));
  connect(bouAirCoo4.ports[1], cooCoi7.port_a2) annotation (Line(points={{40,-64},
          {10,-64}},                   color={0,127,255}));
  connect(cooCoi7.port_b2, sinAir.ports[5]) annotation (Line(points={{-10,-64},
          {-80,-64},{-80,-2},{-110,-2}},color={0,127,255}));
  connect(bouWatCoo7v1.ports[1], cooCoi7Param16.port_a1)
    annotation (Line(points={{-20,-114},{-10,-114}}, color={0,127,255}));
  connect(cooCoi7Param16.port_b2, sinAir.ports[6]) annotation (Line(points={{-10,
          -126},{-80,-126},{-80,-4},{-110,-4},{-110,-3.33333}}, color={0,127,255}));
  connect(bouAirCoo5.ports[1], cooCoi7Param16.port_a2)
    annotation (Line(points={{40,-126},{10,-126}}, color={0,127,255}));
  connect(cooCoi7Param16.port_b1, sinWat.ports[6]) annotation (Line(points={{10,
          -114},{46,-114},{46,-108},{80,-108},{80,-3.33333},{110,-3.33333}},
        color={0,127,255}));
  connect(bouWatCoo7v2.m_flow_in, bouWatCoo7v1.m_flow_in) annotation (Line(
        points={{-42,-76},{-50,-76},{-50,-106},{-42,-106}}, color={0,0,127}));
  connect(gain.y, bouAirCoo5.m_flow_in) annotation (Line(points={{19,80},{19,
          80.122},{68,80.122},{68,-118},{62,-118}}, color={0,0,127}));
  connect(gain.y, bouAirCoo4.m_flow_in) annotation (Line(points={{19,80},{19,
          78.122},{68,78.122},{68,-56},{62,-56}}, color={0,0,127}));
  connect(gainFloFcu7.y, bouWatCoo2.m_flow_in) annotation (Line(points={{-53.4,
          -16},{-53.4,-15.9756},{-50,-15.9756},{-50,-44},{-42,-44}}, color={0,0,
          127}));
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
    Diagram(coordinateSystem(extent={{-140,-140},{140,140}})));
end WetCoilEffectivenessNTU_FCU;

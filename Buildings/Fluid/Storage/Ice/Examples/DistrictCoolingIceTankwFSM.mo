within Buildings.Fluid.Storage.Ice.Examples;
model DistrictCoolingIceTankwFSM
  "Example that tests the ice tank model for a simplified district cooling application controlled by a finite state machine"
  extends Modelica.Icons.Example;

  package MediumGlycol = Buildings.Media.Antifreeze.PropyleneGlycolWater (
    property_T=293.15, X_a=0.30) "Fluid medium";
  package MediumWater = Buildings.Media.Water "Fluid medium";
  package MediumAir = Buildings.Media.Air "Fluid medium";

  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal=1
    "Nominal mass flow rate of air through the chiller condenser coil";
  parameter Modelica.Units.SI.MassFlowRate mWat_flow_nominal=1
    "Nominal mass flow rate of water through the water circuit";
  parameter Modelica.Units.SI.MassFlowRate mGly_flow_nominal=1
    "Nominal mass flow rate of glycol through the glycol circuit";

   parameter Modelica.Units.SI.Temperature TStaVol = 273.15 + 1
    "Initial water temperature of volume";

  parameter
    Chillers.Data.ElectricEIR.ElectricEIRChiller_York_YCAL0033EE_101kW_3_1COP_AirCooled
    perChiWat
    annotation (Placement(transformation(extent={{24,-180},{44,-160}})));
  Controls.OBC.CDL.Continuous.Sources.Constant chiWatTSet(k=273.15 + 6)
    "Set point"
    annotation (Placement(transformation(extent={{70,-144},{82,-132}})));
  Chillers.ElectricEIR chiWat(
    redeclare package Medium1 = MediumAir,
    redeclare package Medium2 = MediumWater,
    m1_flow_nominal=mCon_flow_nominal,
    m2_flow_nominal=mWat_flow_nominal,
    dp2_nominal=0,
    dp1_nominal=0,
    per=perChiWat,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={138,-89})));
  Modelica.Blocks.Sources.Sine disCooLoad(
    amplitude=1,
    f=0.001157,
    offset=1,
    startTime=1)
    annotation (Placement(transformation(extent={{238,-46},{226,-34}})));
  HeatExchangers.HeaterCooler_u disCooCoi(
    redeclare package Medium = MediumWater,
    m_flow_nominal=mWat_flow_nominal,
    dp_nominal=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    Q_flow_nominal=4500)
    "District cooling coil" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={212,-80})));
  Actuators.Valves.TwoWayLinear val1(
    redeclare package Medium = MediumWater,
    m_flow_nominal=mWat_flow_nominal,
    dpValve_nominal=6000,
    dpFixed_nominal=0,
    y_start=0,
    use_inputFilter=false)
    "Control valve for water loop" annotation (
      Placement(transformation(
        extent={{-4,4},{4,-4}},
        rotation=90,
        origin={92,-40})));
  Actuators.Valves.TwoWayLinear val2(
    redeclare package Medium = MediumWater,
    m_flow_nominal=mWat_flow_nominal,
    dpValve_nominal=6000,
    dpFixed_nominal=0,
    y_start=0,
    use_inputFilter=false)
    "Control valve for water loop" annotation (
      Placement(transformation(
        extent={{4,4},{-4,-4}},
        rotation=90,
        origin={112,-80})));
  Actuators.Valves.TwoWayLinear val3(
    redeclare package Medium = MediumWater,
    m_flow_nominal=mWat_flow_nominal,
    dpValve_nominal=6000,
    dpFixed_nominal=0,
    y_start=0,
    use_inputFilter=false)
    "Control valve for water loop" annotation (
      Placement(transformation(
        extent={{-4,4},{4,-4}},
        rotation=90,
        origin={132,-40})));
  Movers.FlowControlled_m_flow pum2(
    redeclare package Medium = MediumWater,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mWat_flow_nominal) "Pump" annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={92,-110})));
  Movers.FlowControlled_m_flow pum3(
    redeclare package Medium = MediumWater,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mWat_flow_nominal) "Pump" annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={132,-120})));
  Movers.FlowControlled_m_flow pum4(
    redeclare package Medium = MediumWater,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mWat_flow_nominal) "Pump" annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={204,-30})));
  Sensors.TemperatureTwoPort temSen1(
    redeclare package Medium = MediumWater,
    m_flow_nominal=mWat_flow_nominal,
    T_start=TStaVol)                                    "Water temperature" annotation (
      Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={92,-60})));
  Sensors.TemperatureTwoPort temSen2(redeclare package Medium = MediumWater,
      m_flow_nominal=mWat_flow_nominal) "Water temperature" annotation (
      Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=90,
        origin={132,-60})));
  Sensors.TemperatureTwoPort temSen3(redeclare package Medium = MediumWater,
      m_flow_nominal=mWat_flow_nominal) "Water temperature" annotation (
      Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={212,-104})));
  Sources.MassFlowSource_T           sou1(
    nPorts=1,
    redeclare package Medium = MediumAir,
    m_flow=mCon_flow_nominal) "Weather data"
    annotation (Placement(transformation(extent={{6,-6},{-6,6}},
        rotation=0,
        origin={156,-60})));
  Sources.Boundary_pT sin1(redeclare package Medium = MediumAir, nPorts=1)
                "Pressure source"
    annotation (Placement(
        transformation(
        extent={{5,-5},{-5,5}},
        origin={157,-111})));
  Sources.Boundary_pT preSou1(redeclare package Medium = MediumWater, nPorts=1)
    "Source for pressure and to account for thermal expansion of water"
    annotation (Placement(transformation(extent={{188,-86},{176,-74}})));
  Controls.OBC.CDL.Conversions.BooleanToReal booToReaPum2(realTrue=
        mWat_flow_nominal, realFalse=mWat_flow_nominal/10)
                           "Pump signal"
    annotation (Placement(transformation(extent={{68,-116},{80,-104}})));
  Controls.OBC.CDL.Conversions.BooleanToReal booToReaVal1(realTrue=1, realFalse=
       0.1) "Valve signal"
    annotation (Placement(transformation(extent={{70,-16},{82,-4}})));
  Controls.OBC.CDL.Conversions.BooleanToReal           booToReaPum3(realTrue=
        mWat_flow_nominal, realFalse=mWat_flow_nominal/10)
                           "Pump signal"
    annotation (Placement(transformation(extent={{156,-148},{144,-136}})));
  Controls.OBC.CDL.Continuous.Sources.Constant pum4Flow(k=mWat_flow_nominal)
    "Pump 4 flow rate"
    annotation (Placement(transformation(extent={{238,-22},{226,-10}})));
  Modelica.StateGraph.StepWithSignal mod2(nIn=1, nOut=1)
    "Serve district loads with borefield"
    annotation (Placement(transformation(extent={{18,94},{30,82}})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    "Root of the state graph"
    annotation (Placement(transformation(extent={{-224,128},{-210,142}})));
  Modelica.StateGraph.StepWithSignal mod5(nOut=1, nIn=1)
    "Serve district loads with chiller"
    annotation (Placement(transformation(extent={{-116,58},{-104,70}})));
  Modelica.StateGraph.InitialStep ste0(nOut=1, nIn=1) "Initial Step"
    annotation (Placement(transformation(extent={{-232,82},{-220,94}})));
  Controls.OBC.CDL.Continuous.GreaterThreshold greThrT3(t=273.15 + 11)
    "Threshold for district water temperature"
    annotation (Placement(transformation(extent={{228,-100},{240,-88}})));
  Controls.OBC.CDL.Continuous.LessThreshold lesThrT3(t=273.15 + 7)
    "Threshold for district water temperature"
    annotation (Placement(transformation(extent={{228,-122},{240,-110}})));
  Modelica.StateGraph.TransitionWithSignal T0 "Transition from initial step"
    annotation (Placement(transformation(extent={{-214,78},{-194,98}})));
  Modelica.StateGraph.TransitionWithSignal T6 "Transition from mode 2"
    annotation (Placement(transformation(extent={{-256,78},{-236,98}})));
  Modelica.StateGraph.Parallel parallel
    "Split for alternative execution paths"
    annotation (Placement(transformation(extent={{-192,20},{-4,156}})));
  Modelica.StateGraph.Step ste1(nOut=1, nIn=1) "Step 1"
    annotation (Placement(transformation(extent={{-160,112},{-148,124}})));
  Modelica.StateGraph.Step ste2(nOut=1, nIn=1) "Step 2"
    annotation (Placement(transformation(extent={{-46,112},{-34,124}})));
  Controls.OBC.CDL.Continuous.Switch swiVal3
    annotation (Placement(transformation(extent={{172,-16},{160,-4}})));
  Controls.OBC.CDL.Continuous.Sources.Constant val3On(k=1)
    "Valve 3 on position"
    annotation (Placement(transformation(extent={{190,-14},{178,-26}})));
  Controls.OBC.CDL.Continuous.Sources.Constant val3Off(k=0.1)
    "Valve 3 off position"
    annotation (Placement(transformation(extent={{190,-6},{178,6}})));
  Modelica.StateGraph.TransitionWithSignal
                                 T5 "Transition to mode 2"
    annotation (Placement(transformation(extent={{-2,78},{18,98}})));
  parameter Data.Tank.Generic perIceTan(
    mIce_max=1/4*2846.35,
    coeCha={1.76953858E-04,0,0,0,0,0},
    dtCha=10,
    coeDisCha={5.54E-05,-1.45679E-04,9.28E-05,1.126122E-03,-1.1012E-03,3.00544E-04},
    dtDisCha=10) "Tank performance data" annotation (Placement(transformation(extent={{-56,
            -180},{-36,-160}})));

  Buildings.Fluid.Storage.Ice.Tank iceTanUnc(
    redeclare package Medium = MediumGlycol,
    m_flow_nominal=mGly_flow_nominal,
    dp_nominal=10000,
    SOC_start=3/4,
    per=perIceTan) "Uncontrolled ice tank" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-142,-96})));
  Controls.OBC.CDL.Continuous.Sources.Constant chiGlyTSet(k=273.15 - 6.7)
    "Set point"
    annotation (Placement(transformation(extent={{-72,-28},{-84,-16}})));
  Chillers.ElectricEIR chiGly(
    redeclare package Medium1 = MediumAir,
    redeclare package Medium2 = MediumGlycol,
    m1_flow_nominal=mCon_flow_nominal,
    m2_flow_nominal=mGly_flow_nominal,
    dp2_nominal=0,
    dp1_nominal=0,
    per=perChiGly,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-96,-93})));
  Actuators.Valves.TwoWayLinear val4(
    redeclare package Medium = MediumGlycol,
    m_flow_nominal=mGly_flow_nominal,
    dpValve_nominal=6000,
    dpFixed_nominal=0,
    y_start=0,
    use_inputFilter=false)
    "Control valve for glycol loop" annotation (
      Placement(transformation(
        extent={{-4,4},{4,-4}},
        rotation=90,
        origin={-142,-44})));
  Actuators.Valves.TwoWayLinear val5(
    redeclare package Medium = MediumGlycol,
    m_flow_nominal=mGly_flow_nominal,
    dpValve_nominal=6000,
    dpFixed_nominal=0,
    y_start=0,
    use_inputFilter=false)
    "Control valve for glycol loop" annotation (
      Placement(transformation(
        extent={{4,-4},{-4,4}},
        rotation=90,
        origin={-122,-62})));
  Actuators.Valves.TwoWayLinear val6(
    redeclare package Medium = MediumGlycol,
    m_flow_nominal=mGly_flow_nominal,
    dpValve_nominal=6000,
    dpFixed_nominal=0,
    y_start=0,
    use_inputFilter=false)
    "Control valve for glycol loop" annotation (
      Placement(transformation(
        extent={{-4,4},{4,-4}},
        rotation=90,
        origin={-102,-44})));
  Actuators.Valves.TwoWayLinear val7(
    redeclare package Medium = MediumGlycol,
    m_flow_nominal=mGly_flow_nominal,
    dpValve_nominal=6000,
    dpFixed_nominal=0,
    y_start=0,
    use_inputFilter=false)
    "Control valve for glycol loop" annotation (
      Placement(transformation(
        extent={{4,-4},{-4,4}},
        rotation=90,
        origin={-42,-44})));
  Movers.FlowControlled_m_flow pum1(
    redeclare package Medium = MediumGlycol,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mGly_flow_nominal) "Pump" annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={-42,-124})));
  Movers.FlowControlled_m_flow pum5(
    redeclare package Medium = MediumGlycol,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mGly_flow_nominal) "Pump" annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-142,-118})));
  Movers.FlowControlled_m_flow pum6(
    redeclare package Medium = MediumGlycol,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mGly_flow_nominal) "Pump" annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-108,-124})));
  Sensors.TemperatureTwoPort temSen4(redeclare package Medium = MediumGlycol,
      m_flow_nominal=mGly_flow_nominal) "Glycol temperature" annotation (
      Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-142,-74})));
  Sensors.TemperatureTwoPort temSen5(redeclare package Medium = MediumGlycol,
      m_flow_nominal=mGly_flow_nominal) "Glycol temperature" annotation (
      Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=90,
        origin={-102,-64})));
  Sensors.TemperatureTwoPort temSen6(redeclare package Medium = MediumGlycol,
      m_flow_nominal=mGly_flow_nominal) "Glycol temperature" annotation (
      Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=90,
        origin={-42,-104})));
  Sources.MassFlowSource_T sou2(
    nPorts=1,
    redeclare package Medium = MediumAir,
    m_flow=mCon_flow_nominal) "Weather data"
    annotation (Placement(transformation(extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-78,-64})));
  Sources.Boundary_pT sin2(redeclare package Medium = MediumAir, nPorts=1)
                "Pressure source"
    annotation (Placement(
        transformation(
        extent={{5,-5},{-5,5}},
        origin={-95,-115},
        rotation=180)));
  Sources.Boundary_pT preSou2(redeclare package Medium = MediumGlycol, nPorts=1)
    "Source for pressure and to account for thermal expansion of glycol"
    annotation (Placement(transformation(extent={{-78,-90},{-66,-78}})));
  Controls.OBC.CDL.Conversions.BooleanToReal booToReaPum6(realTrue=
        mGly_flow_nominal, realFalse=mGly_flow_nominal/10)
                           "Pump signal"
    annotation (Placement(transformation(extent={{-94,-154},{-106,-142}})));
  parameter Chillers.Data.ElectricEIR.Generic perChiGly(
    QEva_flow_nominal=-100582,
    COP_nominal=3.1,
    PLRMax=1.15,
    PLRMinUnl=0.1,
    PLRMin=0.1,
    etaMotor=1.0,
    mEva_flow_nominal=1000*0.0043,
    mCon_flow_nominal=1.2*9.4389,
    TEvaLvg_nominal=273.15 - 8.33,
    capFunT={-0.2660645697,0.0998714035,-0.0023814154,0.0628316481,-0.0009644649,
        -0.0011249224},
    EIRFunT={0.1807017787,0.0271530312,-0.0004553574,0.0188175079,0.0002623276,-0.0012881189},
    EIRFunPLR={0.0,1.0,0.0},
    TEvaLvgMin=273.15 - 11,
    TEvaLvgMax=273.15 - 5,
    TConEnt_nominal=273.15 + 20,
    TConEntMin=273.15 + 15,
    TConEntMax=273.15 + 40)
    annotation (Placement(transformation(extent={{-16,-180},{4,-160}})));

  Controls.OBC.CDL.Continuous.LessThreshold lesThrT4(t=273.15 - 2)
    "Threshold for ice tank temperature"
    annotation (Placement(transformation(extent={{-162,-70},{-174,-58}})));
  Controls.OBC.CDL.Continuous.GreaterThreshold greThrT4(t=273.15 + 1)
    "Threshold for ice tank temperature"
    annotation (Placement(transformation(extent={{-162,-88},{-174,-76}})));
  Controls.OBC.CDL.Continuous.LessThreshold lesThrT6(t=273.15 + 4)
    "Threshold for hex glycol temperature"
    annotation (Placement(transformation(extent={{-16,-116},{-4,-104}})));
  Controls.OBC.CDL.Continuous.GreaterThreshold
                                            greThrT6(t=273.15 + 8)
    "Threshold for hex glycol temperature"
    annotation (Placement(transformation(extent={{-16,-132},{-4,-120}})));
  Controls.OBC.CDL.Continuous.Sources.Constant pum5Flow(k=mGly_flow_nominal)
    "Pump 5 flow rate"
    annotation (Placement(transformation(extent={{-174,-124},{-162,-112}})));
  Controls.OBC.CDL.Conversions.BooleanToReal booToReaVal5(realTrue=1, realFalse=
       0.1)
    "Valve signal"
    annotation (Placement(transformation(extent={{-170,-154},{-158,-142}})));
  Controls.OBC.CDL.Conversions.BooleanToReal booToReaPum1(realTrue=
        mGly_flow_nominal, realFalse=mGly_flow_nominal/10) "Pump signal"
    annotation (Placement(transformation(extent={{-14,-148},{-26,-136}})));
  Modelica.StateGraph.TransitionWithSignal T3 "Transition to mode 4"
    annotation (Placement(transformation(extent={{-130,124},{-110,144}})));
  Modelica.StateGraph.StepWithSignal mod4(nIn=1, nOut=1)
    "Serve district loads with chiller and borefield"
    annotation (Placement(transformation(extent={{-110,140},{-98,128}})));
  Modelica.StateGraph.TransitionWithSignal T4 "Transition from mode 4"
    annotation (Placement(transformation(extent={{-96,124},{-76,144}})));
  Modelica.StateGraph.TransitionWithSignal T2 "Transition from mode 1"
    annotation (Placement(transformation(extent={{-78,90},{-58,110}})));
  Modelica.StateGraph.StepWithSignal mod1(nIn=1, nOut=1) "Charge borefield"
    annotation (Placement(transformation(extent={{-106,94},{-94,106}})));
  Modelica.StateGraph.TransitionWithSignal T1 "Transition to mode 1"
    annotation (Placement(transformation(extent={{-134,90},{-114,110}})));
  Modelica.StateGraph.Alternative alternative
    "Split for alternative execution paths"
    annotation (Placement(transformation(extent={{-144,86},{-50,150}})));
  Controls.OBC.CDL.Continuous.Sources.Constant val4On(k=1)
    "Valve 4 on position"
    annotation (Placement(transformation(extent={{-120,-50},{-132,-38}})));
  Controls.OBC.CDL.Continuous.Sources.Constant val6Off(k=0.1)
    "Valve 6 off position"
    annotation (Placement(transformation(extent={{-74,-50},{-86,-38}})));
  HeatExchangers.ConstantEffectiveness hex(
    redeclare package Medium1 = MediumGlycol,
    redeclare package Medium2 = MediumWater,
    m1_flow_nominal=mGly_flow_nominal,
    m2_flow_nominal=mWat_flow_nominal,
    eps=0.8,
    dp2_nominal=0,
    dp1_nominal=0) "Heat exchanger" annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=90,origin={24,-87})));
  Controls.OBC.CDL.Logical.MultiOr mulOrT6(nin=4) annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-246,58})));
  Controls.OBC.CDL.Logical.MultiOr mulOrT5(nin=3) annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={8,58})));
  Controls.OBC.CDL.Conversions.BooleanToReal booToReaVal2(realTrue=1, realFalse=
       0.1) "Valve signal"
    annotation (Placement(transformation(extent={{68,6},{80,18}})));
  Controls.OBC.CDL.Logical.MultiOr   mulOr2(nin=2)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=0,
        origin={54,-110})));
  Controls.OBC.CDL.Logical.MultiOr   mulOr1(nin=2)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-156,-10})));
  Controls.OBC.CDL.Conversions.BooleanToReal booToReaVal7(realTrue=1, realFalse=
       0.1)
    "Valve signal"
    annotation (Placement(transformation(extent={{-124,-16},{-112,-4}})));
equation
  connect(pum3.port_b,chiWat. port_a2)
    annotation (Line(points={{132,-114},{132,-99}},
                                                 color={0,127,255}));
  connect(chiWat.port_b2,temSen2. port_a)
    annotation (Line(points={{132,-79},{132,-66}},
                                              color={0,127,255}));
  connect(temSen2.port_b,val2. port_a) annotation (Line(points={{132,-54},{132,
          -50},{112,-50},{112,-76}},
                           color={0,127,255}));
  connect(temSen2.port_b,val3. port_a)
    annotation (Line(points={{132,-54},{132,-44}},
                                               color={0,127,255}));
  connect(temSen1.port_b,val1. port_a)
    annotation (Line(points={{92,-54},{92,-44}},
                                               color={0,127,255}));
  connect(val1.port_b,val3. port_b) annotation (Line(points={{92,-36},{92,-30},
          {132,-30},{132,-36}},
                           color={0,127,255}));
  connect(pum4.port_a,val3. port_b)
    annotation (Line(points={{198,-30},{132,-30},{132,-36}},
                                                        color={0,127,255}));
  connect(pum4.port_b,disCooCoi. port_a)
    annotation (Line(points={{210,-30},{212,-30},{212,-70}},
                                                          color={0,127,255}));
  connect(disCooCoi.port_b,temSen3. port_a)
    annotation (Line(points={{212,-90},{212,-98}}, color={0,127,255}));
  connect(temSen3.port_b,pum3. port_a) annotation (Line(points={{212,-110},{212,
          -132},{132,-132},{132,-126}},
                                   color={0,127,255}));
  connect(pum2.port_a,pum3. port_a) annotation (Line(points={{92,-116},{92,-132},
          {132,-132},{132,-126}},
                              color={0,127,255}));
  connect(val3.port_b,pum3. port_a) annotation (Line(points={{132,-36},{132,-30},
          {172,-30},{172,-132},{132,-132},{132,-126}},
                                                color={0,127,255}));
  connect(val2.port_b,pum2. port_a) annotation (Line(points={{112,-84},{112,
          -122},{92,-122},{92,-116}},
                             color={0,127,255}));
  connect(sou1.ports[1],chiWat. port_a1)
    annotation (Line(points={{150,-60},{144,-60},{144,-79}},
                                                      color={0,127,255}));
  connect(chiWat.port_b1,sin1. ports[1])
    annotation (Line(points={{144,-99},{144,-111},{152,-111}},
                                                          color={0,127,255}));
  connect(preSou1.ports[1],pum3. port_a) annotation (Line(points={{176,-80},{
          172,-80},{172,-132},{132,-132},{132,-126}},
                                           color={0,127,255}));
  connect(disCooCoi.u,disCooLoad. y)
    annotation (Line(points={{218,-68},{218,-40},{225.4,-40}},
                                                            color={0,0,127}));
  connect(booToReaPum2.y,pum2. m_flow_in)
    annotation (Line(points={{81.2,-110},{84.8,-110}},
                                                    color={0,0,127}));
  connect(booToReaPum3.y,pum3. m_flow_in) annotation (Line(points={{142.8,-142},
          {120,-142},{120,-120},{124.8,-120}},
                                     color={0,0,127}));
  connect(pum4Flow.y,pum4. m_flow_in) annotation (Line(points={{224.8,-16},{204,
          -16},{204,-22.8}},
                       color={0,0,127}));
  connect(chiWat.TSet,chiWatTSet. y) annotation (Line(points={{135,-77},{135,
          -72},{124,-72},{124,-110},{116,-110},{116,-138},{83.2,-138}},
                                                          color={0,0,127}));
  connect(chiWat.on,booToReaPum3. u) annotation (Line(points={{141,-77},{141,
          -70},{166,-70},{166,-142},{157.2,-142}},
                                         color={255,0,255}));
  connect(temSen3.T,lesThrT3. u) annotation (Line(points={{218.6,-104},{224,
          -104},{224,-116},{226.8,-116}},
                                  color={0,0,127}));
  connect(temSen3.T,greThrT3. u) annotation (Line(points={{218.6,-104},{224,
          -104},{224,-94},{226.8,-94}},
                                  color={0,0,127}));
  connect(mod5.active, booToReaPum3.u) annotation (Line(points={{-110,57.4},{
          -110,20},{38,20},{38,-154},{166,-154},{166,-142},{157.2,-142}},
                                                                   color={255,0,
          255}));
  connect(swiVal3.u3, val3On.y) annotation (Line(points={{173.2,-14.8},{176,
          -14.8},{176,-20},{176.8,-20}},
                                color={0,0,127}));
  connect(val3Off.y, swiVal3.u1) annotation (Line(points={{176.8,0},{176,0},{
          176,-5.2},{173.2,-5.2}},
                               color={0,0,127}));
  connect(pum5.port_b, iceTanUnc.port_a)
    annotation (Line(points={{-142,-112},{-142,-106}},
                                                     color={0,127,255}));
  connect(iceTanUnc.port_b, temSen4.port_a)
    annotation (Line(points={{-142,-86},{-142,-80}},
                                                  color={0,127,255}));
  connect(temSen4.port_b,val4. port_a)
    annotation (Line(points={{-142,-68},{-142,-48}},
                                                   color={0,127,255}));
  connect(val4.port_b,val6. port_b) annotation (Line(points={{-142,-40},{-142,
          -34},{-102,-34},{-102,-40}},
                              color={0,127,255}));
  connect(val7.port_a,val6. port_b) annotation (Line(points={{-42,-40},{-42,-34},
          {-102,-34},{-102,-40}},
                         color={0,127,255}));
  connect(temSen6.port_b,pum1. port_a)
    annotation (Line(points={{-42,-110},{-42,-118}},
                                               color={0,127,255}));
  connect(pum6.port_b,chiGly. port_a2)
    annotation (Line(points={{-108,-118},{-108,-110},{-102,-110},{-102,-103}},
                                                   color={0,127,255}));
  connect(chiGly.port_b2,temSen5. port_a)
    annotation (Line(points={{-102,-83},{-102,-70}},
                                                color={0,127,255}));
  connect(temSen5.port_b,val5. port_a) annotation (Line(points={{-102,-58},{
          -102,-54},{-122,-54},{-122,-58}},
                                 color={0,127,255}));
  connect(val6.port_a,temSen5. port_b)
    annotation (Line(points={{-102,-48},{-102,-58}},
                                                 color={0,127,255}));
  connect(pum1.port_b,pum6. port_a) annotation (Line(points={{-42,-130},{-42,
          -136},{-108,-136},{-108,-130}},
                               color={0,127,255}));
  connect(pum5.port_a,val5. port_b) annotation (Line(points={{-142,-124},{-142,
          -128},{-122,-128},{-122,-66}},
                                    color={0,127,255}));
  connect(pum5.port_a,pum6. port_a) annotation (Line(points={{-142,-124},{-142,
          -136},{-108,-136},{-108,-130}},
                                     color={0,127,255}));
  connect(val6.port_b,pum6. port_a) annotation (Line(points={{-102,-40},{-102,
          -34},{-62,-34},{-62,-136},{-108,-136},{-108,-130}},
                                                   color={0,127,255}));
  connect(sou2.ports[1],chiGly. port_a1)
    annotation (Line(points={{-84,-64},{-90,-64},{-90,-83}},
                                                         color={0,127,255}));
  connect(chiGly.port_b1,sin2. ports[1]) annotation (Line(points={{-90,-103},{
          -90,-115}},          color={0,127,255}));
  connect(preSou2.ports[1],pum6. port_a) annotation (Line(points={{-66,-84},{
          -62,-84},{-62,-136},{-108,-136},{-108,-130}},
                                             color={0,127,255}));
  connect(chiGly.TSet,chiGlyTSet. y) annotation (Line(points={{-99,-81},{-99,
          -72},{-92,-72},{-92,-22},{-85.2,-22}},
                                        color={0,0,127}));
  connect(booToReaPum6.y,pum6. m_flow_in) annotation (Line(points={{-107.2,-148},
          {-118,-148},{-118,-124},{-115.2,-124}},
                                     color={0,0,127}));
  connect(chiGly.on,booToReaPum6. u) annotation (Line(points={{-93,-81},{-93,
          -76},{-80,-76},{-80,-148},{-92.8,-148}},
                                    color={255,0,255}));
  connect(lesThrT4.u,temSen4. T) annotation (Line(points={{-160.8,-64},{-154,
          -64},{-154,-74},{-148.6,-74}},
                      color={0,0,127}));
  connect(greThrT4.u,temSen4. T) annotation (Line(points={{-160.8,-82},{-154,
          -82},{-154,-74},{-148.6,-74}},
                             color={0,0,127}));
  connect(temSen6.T, lesThrT6.u) annotation (Line(points={{-35.4,-104},{-22,
          -104},{-22,-110},{-17.2,-110}},
                                  color={0,0,127}));
  connect(temSen6.T,greThrT6. u) annotation (Line(points={{-35.4,-104},{-22,
          -104},{-22,-126},{-17.2,-126}},
                                  color={0,0,127}));
  connect(mod1.active, booToReaPum6.u) annotation (Line(points={{-100,93.4},{
          -100,50},{-196,50},{-196,-170},{-80,-170},{-80,-148},{-92.8,-148}},
                                                                       color={255,
          0,255}));
  connect(greThrT4.y,T1. condition) annotation (Line(points={{-175.2,-82},{-186,
          -82},{-186,26},{-124,26},{-124,88}},
                                            color={255,0,255}));
  connect(val4On.y,val4. y)
    annotation (Line(points={{-133.2,-44},{-137.2,-44}},
                                                   color={0,0,127}));
  connect(val6Off.y,val6. y)
    annotation (Line(points={{-87.2,-44},{-97.2,-44}},
                                                   color={0,0,127}));
  connect(pum5Flow.y,pum5. m_flow_in)
    annotation (Line(points={{-160.8,-118},{-149.2,-118}},
                                                      color={0,0,127}));
  connect(booToReaPum1.y,pum1. m_flow_in) annotation (Line(points={{-27.2,-142},
          {-30,-142},{-30,-124},{-34.8,-124}},
                                           color={0,0,127}));
  connect(T3.outPort, mod4.inPort[1])
    annotation (Line(points={{-118.5,134},{-110.6,134}}, color={0,0,0}));
  connect(mod4.outPort[1], T4.inPort)
    annotation (Line(points={{-97.7,134},{-90,134}}, color={0,0,0}));
  connect(T1.outPort, mod1.inPort[1])
    annotation (Line(points={{-122.5,100},{-106.6,100}}, color={0,0,0}));
  connect(mod1.outPort[1], T2.inPort)
    annotation (Line(points={{-93.7,100},{-72,100}}, color={0,0,0}));
  connect(alternative.split[1],T1. inPort) annotation (Line(points={{-134.13,
          118},{-132,118},{-132,100},{-128,100}},
                                             color={0,0,0}));
  connect(T2.outPort,alternative. join[1]) annotation (Line(points={{-66.5,100},
          {-62,100},{-62,118},{-59.87,118}}, color={0,0,0}));
  connect(alternative.split[2],T3. inPort) annotation (Line(points={{-134.13,
          118},{-132,118},{-132,134},{-124,134}},
                                           color={0,0,0}));
  connect(T4.outPort,alternative. join[2]) annotation (Line(points={{-84.5,134},
          {-62,134},{-62,118},{-59.87,118}},
                                           color={0,0,0}));
  connect(mod1.active, booToReaVal5.u) annotation (Line(points={{-100,93.4},{
          -100,50},{-196,50},{-196,-148},{-171.2,-148}},
                                                    color={255,0,255}));
  connect(pum2.port_b, hex.port_a2)
    annotation (Line(points={{92,-104},{92,-97},{30,-97}},color={0,127,255}));
  connect(hex.port_b2, temSen1.port_a)
    annotation (Line(points={{30,-77},{92,-77},{92,-66}},
                                                     color={0,127,255}));
  connect(hex.port_b1, temSen6.port_a) annotation (Line(points={{18,-97},{-42,
          -97},{-42,-98}},
                      color={0,127,255}));
  connect(val7.port_b, hex.port_a1)
    annotation (Line(points={{-42,-48},{-42,-77},{18,-77}},
                                                       color={0,127,255}));
  connect(mod5.outPort[1], parallel.join[2]) annotation (Line(points={{-103.7,
          64},{-32,64},{-32,88},{-25.15,88}},   color={0,0,0}));
  connect(mod5.inPort[1], parallel.split[2]) annotation (Line(points={{-116.6,
          64},{-164,64},{-164,88},{-170.85,88}},  color={0,0,0}));
  connect(T0.outPort, parallel.inPort)
    annotation (Line(points={{-202.5,88},{-194.82,88}},   color={0,0,0}));
  connect(ste0.outPort[1], T0.inPort)
    annotation (Line(points={{-219.7,88},{-208,88}},   color={0,0,0}));
  connect(parallel.outPort, T5.inPort)
    annotation (Line(points={{-2.12,88},{4,88}},   color={0,0,0}));
  connect(T6.outPort, ste0.inPort[1])
    annotation (Line(points={{-244.5,88},{-232.6,88}},   color={0,0,0}));
  connect(T5.outPort, mod2.inPort[1])
    annotation (Line(points={{9.5,88},{17.4,88}},   color={0,0,0}));
  connect(mod2.outPort[1], T6.inPort) annotation (Line(points={{30.3,88},{36,88},
          {36,168},{-256,168},{-256,88},{-250,88}},   color={0,0,0}));
  connect(T0.condition, greThrT3.y) annotation (Line(points={{-204,76},{-204,26},
          {246,26},{246,-94},{241.2,-94}},  color={255,0,255}));
  connect(mulOrT6.y, T6.condition)
    annotation (Line(points={{-246,65.2},{-246,76}},   color={255,0,255}));
  connect(greThrT3.y, mulOrT6.u[1]) annotation (Line(points={{241.2,-94},{246,
          -94},{246,26},{-246,26},{-246,50.8},{-249.15,50.8}},color={255,0,255}));
  connect(greThrT4.y, mulOrT6.u[2]) annotation (Line(points={{-175.2,-82},{-248,
          -82},{-248,50.8},{-247.05,50.8}},
                                         color={255,0,255}));
  connect(mulOrT5.y, T5.condition)
    annotation (Line(points={{8,65.2},{8,76}},   color={255,0,255}));
  connect(lesThrT4.y, mulOrT5.u[1]) annotation (Line(points={{-175.2,-64},{-192,
          -64},{-192,38},{5.2,38},{5.2,50.8}},
                                             color={255,0,255}));
  connect(lesThrT6.y, mulOrT5.u[2]) annotation (Line(points={{-2.8,-110},{8,
          -110},{8,50.8}},      color={255,0,255}));
  connect(lesThrT3.y, mulOrT5.u[3]) annotation (Line(points={{241.2,-116},{254,
          -116},{254,44},{12,44},{12,50.8},{10.8,50.8}},
                                                    color={255,0,255}));
  connect(greThrT6.y, mulOrT6.u[3]) annotation (Line(points={{-2.8,-126},{0,
          -126},{0,32},{-244,32},{-244,50.8},{-244.95,50.8}},color={255,0,255}));
  connect(lesThrT3.y, mulOrT6.u[4]) annotation (Line(points={{241.2,-116},{254,
          -116},{254,44},{-242,44},{-242,50.8},{-242.85,50.8}},
                                                              color={255,0,255}));
  connect(booToReaVal2.u, mod4.active) annotation (Line(points={{66.8,12},{54,
          12},{54,156},{-104,156},{-104,140.6}},
                                             color={255,0,255}));
  connect(mulOr2.y, booToReaPum2.u)
    annotation (Line(points={{61.2,-110},{66.8,-110}},
                                                     color={255,0,255}));
  connect(booToReaPum2.u, booToReaVal1.u) annotation (Line(points={{66.8,-110},
          {64,-110},{64,-10},{68.8,-10}},
                                   color={255,0,255}));
  connect(mulOr2.u[1], mod2.active) annotation (Line(points={{46.8,-107.9},{44,
          -107.9},{44,106},{24,106},{24,94.6}},
                                         color={255,0,255}));
  connect(booToReaPum2.u, swiVal3.u2) annotation (Line(points={{66.8,-110},{64,
          -110},{64,4},{174,4},{174,12},{194,12},{194,-10},{173.2,-10}},
                                                                   color={255,0,
          255}));
  connect(mod2.active, mulOr1.u[1]) annotation (Line(points={{24,94.6},{24,160},
          {-180,160},{-180,-7.9},{-163.2,-7.9}}, color={255,0,255}));
  connect(mod4.active, mulOr1.u[2]) annotation (Line(points={{-104,140.6},{-104,
          160},{-180,160},{-180,-12.1},{-163.2,-12.1}},
                                                      color={255,0,255}));
  connect(mulOr1.y, booToReaVal7.u)
    annotation (Line(points={{-148.8,-10},{-125.2,-10}},
                                                       color={255,0,255}));
  connect(booToReaPum1.u, booToReaVal7.u) annotation (Line(points={{-12.8,-142},
          {-6,-142},{-6,-152},{-56,-152},{-56,2},{-136,2},{-136,-10},{-125.2,
          -10}},
        color={255,0,255}));
  connect(mod4.active, mulOr2.u[2]) annotation (Line(points={{-104,140.6},{-104,
          152},{44,152},{44,-112.1},{46.8,-112.1}},
                                                  color={255,0,255}));
  connect(ste1.outPort[1], alternative.inPort)
    annotation (Line(points={{-147.7,118},{-145.41,118}}, color={0,0,0}));
  connect(parallel.split[1], ste1.inPort[1]) annotation (Line(points={{-170.85,
          88},{-164,88},{-164,118},{-160.6,118}},             color={0,0,0}));
  connect(ste2.outPort[1], parallel.join[1]) annotation (Line(points={{-33.7,
          118},{-32,118},{-32,88},{-25.15,88}}, color={0,0,0}));
  connect(alternative.outPort, ste2.inPort[1])
    annotation (Line(points={{-49.06,118},{-46.6,118}}, color={0,0,0}));
  connect(greThrT6.y, T3.condition) annotation (Line(points={{-2.8,-126},{0,
          -126},{0,32},{-120,32},{-120,122}},
                                           color={255,0,255}));
  connect(mulOrT5.y, T2.condition) annotation (Line(points={{8,65.2},{8,70},{
          -68,70},{-68,88}},
                           color={255,0,255}));
  connect(mulOrT5.y, T4.condition) annotation (Line(points={{8,65.2},{8,70},{
          -86,70},{-86,122}},
                           color={255,0,255}));
  connect(booToReaVal1.y, val1.y) annotation (Line(points={{83.2,-10},{104,-10},
          {104,-40},{96.8,-40}},
                              color={0,0,127}));
  connect(booToReaVal2.y, val2.y) annotation (Line(points={{81.2,12},{118,12},{
          118,-80},{116.8,-80}},                  color={0,0,127}));
  connect(swiVal3.y, val3.y) annotation (Line(points={{158.8,-10},{140,-10},{
          140,-40},{136.8,-40}},
                           color={0,0,127}));
  connect(booToReaVal5.y, val5.y) annotation (Line(points={{-156.8,-148},{-130,
          -148},{-130,-62},{-126.8,-62}},
                                       color={0,0,127}));
  connect(booToReaVal7.y, val7.y) annotation (Line(points={{-110.8,-10},{-50,
          -10},{-50,-44},{-46.8,-44}},
                                color={0,0,127}));
  annotation (
    experiment(
      StopTime=2500,
      Interval=1,
      Tolerance=1e-06),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Ice/Examples/Tank.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>
This example is to verify the ice tank model <a href=\"Buildings.Fluid.Storage.Ice\">Buildings.Fluid.Storage.Ice</a> through its implementation in a simplified district cooling system.
</p>
</p>
<p align=\"center\">
<img alt=\"image of ice system\" width=\"750\" src=\"modelica://Buildings/Resources/Images/Fluid/Storage/IceSystem.png\"/>
</p>
<p>
</html>", revisions="<html>
<ul>
<li>
March 1, 2022, by Dre Helmns:<br/>
Implementation of ice tank in a simplified district cooling system.<br/>
<li>
December 14, 2021, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-260,-180},{260,180}})),
    Icon(coordinateSystem(extent={{-260,-180},{260,180}})));
end DistrictCoolingIceTankwFSM;

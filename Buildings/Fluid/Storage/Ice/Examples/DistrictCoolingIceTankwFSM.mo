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
    annotation (Placement(transformation(extent={{20,-100},{40,-80}})));
  Controls.OBC.CDL.Continuous.Sources.Constant chiWatTSet(k=273.15 + 6)
    "Set point"
    annotation (Placement(transformation(extent={{66,-64},{78,-52}})));
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
        origin={134,-9})));
  Modelica.Blocks.Sources.Sine disCooLoad(
    amplitude=1,
    f=0.00001157,
    offset=1,
    startTime=1)
    annotation (Placement(transformation(extent={{234,34},{222,46}})));
  HeatExchangers.HeaterCooler_u disCooCoi(
    redeclare package Medium = MediumWater,
    m_flow_nominal=mWat_flow_nominal,
    dp_nominal=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    Q_flow_nominal=1500)
    "District cooling coil" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={208,0})));
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
        origin={88,40})));
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
        origin={108,0})));
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
        origin={128,40})));
  Movers.FlowControlled_m_flow pum2(
    redeclare package Medium = MediumWater,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mWat_flow_nominal) "Pump" annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={88,-30})));
  Movers.FlowControlled_m_flow pum3(
    redeclare package Medium = MediumWater,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mWat_flow_nominal) "Pump" annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={128,-40})));
  Movers.FlowControlled_m_flow pum4(
    redeclare package Medium = MediumWater,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mWat_flow_nominal) "Pump" annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={200,50})));
  Sensors.TemperatureTwoPort temSen1(
    redeclare package Medium = MediumWater,
    m_flow_nominal=mWat_flow_nominal,
    T_start=TStaVol)                                    "Water temperature" annotation (
      Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={88,20})));
  Sensors.TemperatureTwoPort temSen2(redeclare package Medium = MediumWater,
      m_flow_nominal=mWat_flow_nominal) "Water temperature" annotation (
      Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=90,
        origin={128,20})));
  Sensors.TemperatureTwoPort temSen3(redeclare package Medium = MediumWater,
      m_flow_nominal=mWat_flow_nominal) "Water temperature" annotation (
      Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={208,-24})));
  Sources.MassFlowSource_T           sou1(
    nPorts=1,
    redeclare package Medium = MediumAir,
    m_flow=mCon_flow_nominal) "Weather data"
    annotation (Placement(transformation(extent={{6,-6},{-6,6}},
        rotation=0,
        origin={152,20})));
  Sources.Boundary_pT sin1(redeclare package Medium = MediumAir, nPorts=1)
                "Pressure source"
    annotation (Placement(
        transformation(
        extent={{5,-5},{-5,5}},
        origin={153,-31})));
  Sources.Boundary_pT preSou1(redeclare package Medium = MediumWater, nPorts=1)
    "Source for pressure and to account for thermal expansion of water"
    annotation (Placement(transformation(extent={{184,-6},{172,6}})));
  Controls.OBC.CDL.Conversions.BooleanToReal booToReaPum2(realTrue=
        mWat_flow_nominal, realFalse=mWat_flow_nominal/10)
                           "Pump signal"
    annotation (Placement(transformation(extent={{64,-36},{76,-24}})));
  Controls.OBC.CDL.Conversions.BooleanToReal booToReaVal1(realTrue=1, realFalse=
       0.1) "Valve signal"
    annotation (Placement(transformation(extent={{66,64},{78,76}})));
  Controls.OBC.CDL.Conversions.BooleanToReal           booToReaPum3(realTrue=
        mWat_flow_nominal, realFalse=mWat_flow_nominal/10)
                           "Pump signal"
    annotation (Placement(transformation(extent={{152,-68},{140,-56}})));
  Controls.OBC.CDL.Continuous.Sources.Constant pum4Flow(k=mWat_flow_nominal)
    "Pump 4 flow rate"
    annotation (Placement(transformation(extent={{234,58},{222,70}})));
  Actuators.Motors.IdealMotor motVal1(tOpe=60) "Motor model"
    annotation (Placement(transformation(extent={{84,64},{96,76}})));
  Actuators.Motors.IdealMotor motVal3(tOpe=60) "Motor model"
    annotation (Placement(transformation(extent={{152,64},{140,76}})));
  Modelica.StateGraph.StepWithSignal mod2(nIn=1, nOut=1)
    "Serve district loads with borefield"
    annotation (Placement(transformation(extent={{14,174},{26,162}})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    "Root of the state graph"
    annotation (Placement(transformation(extent={{-228,208},{-214,222}})));
  Modelica.StateGraph.StepWithSignal mod5(nOut=1, nIn=1)
    "Serve district loads with chiller"
    annotation (Placement(transformation(extent={{-112,138},{-100,150}})));
  Modelica.StateGraph.InitialStep ste0(nOut=1, nIn=1) "Initial Step"
    annotation (Placement(transformation(extent={{-236,162},{-224,174}})));
  Controls.OBC.CDL.Continuous.GreaterThreshold greThrT3(t=273.15 + 11)
    "Threshold for district water temperature"
    annotation (Placement(transformation(extent={{224,-20},{236,-8}})));
  Controls.OBC.CDL.Continuous.LessThreshold lesThrT3(t=273.15 + 7)
    "Threshold for district water temperature"
    annotation (Placement(transformation(extent={{224,-42},{236,-30}})));
  Modelica.StateGraph.TransitionWithSignal T0 "Transition from initial step"
    annotation (Placement(transformation(extent={{-218,158},{-198,178}})));
  Modelica.StateGraph.TransitionWithSignal T6 "Transition from mode 2"
    annotation (Placement(transformation(extent={{-260,158},{-240,178}})));
  Modelica.StateGraph.Parallel parallel
    "Split for alternative execution paths"
    annotation (Placement(transformation(extent={{-196,100},{-8,236}})));
  Modelica.StateGraph.Step ste1(nOut=1, nIn=1) "Step 1"
    annotation (Placement(transformation(extent={{-164,192},{-152,204}})));
  Modelica.StateGraph.Step ste2(nOut=1, nIn=1) "Step 2"
    annotation (Placement(transformation(extent={{-50,192},{-38,204}})));
  Controls.OBC.CDL.Continuous.Switch swiVal3
    annotation (Placement(transformation(extent={{168,64},{156,76}})));
  Controls.OBC.CDL.Continuous.Sources.Constant val3On(k=1)
    "Valve 3 on position"
    annotation (Placement(transformation(extent={{186,66},{174,54}})));
  Controls.OBC.CDL.Continuous.Sources.Constant val3Off(k=0.1)
    "Valve 3 off position"
    annotation (Placement(transformation(extent={{186,74},{174,86}})));
  Modelica.StateGraph.TransitionWithSignal
                                 T5 "Transition to mode 2"
    annotation (Placement(transformation(extent={{-6,158},{14,178}})));
  parameter Data.Tank.Generic                             perIceTan(
    mIce_max=1/4*2846.35,
    coeCha={1.76953858E-04,0,0,0,0,0},
    dtCha=10,
    coeDisCha={5.54E-05,-1.45679E-04,9.28E-05,1.126122E-03,-1.1012E-03,3.00544E-04},
    dtDisCha=10) "Tank performance data" annotation (Placement(transformation(extent={{-60,
            -100},{-40,-80}})));

  Buildings.Fluid.Storage.Ice.Tank iceTanUnc(
    redeclare package Medium = MediumGlycol,
    m_flow_nominal=mGly_flow_nominal,
    dp_nominal=10000,
    SOC_start=3/4,
    per=perIceTan) "Uncontrolled ice tank" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-146,-16})));
  Controls.OBC.CDL.Continuous.Sources.Constant chiGlyTSet(k=273.15 - 6.7)
    "Set point"
    annotation (Placement(transformation(extent={{-76,52},{-88,64}})));
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
        origin={-100,-13})));
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
        origin={-146,36})));
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
        origin={-126,18})));
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
        origin={-106,36})));
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
        origin={-46,36})));
  Movers.FlowControlled_m_flow pum1(
    redeclare package Medium = MediumGlycol,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mGly_flow_nominal) "Pump" annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={-46,-44})));
  Movers.FlowControlled_m_flow pum5(
    redeclare package Medium = MediumGlycol,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mGly_flow_nominal) "Pump" annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-146,-38})));
  Movers.FlowControlled_m_flow pum6(
    redeclare package Medium = MediumGlycol,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mGly_flow_nominal) "Pump" annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-112,-44})));
  Sensors.TemperatureTwoPort temSen4(redeclare package Medium = MediumGlycol,
      m_flow_nominal=mGly_flow_nominal) "Glycol temperature" annotation (
      Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-146,6})));
  Sensors.TemperatureTwoPort temSen5(redeclare package Medium = MediumGlycol,
      m_flow_nominal=mGly_flow_nominal) "Glycol temperature" annotation (
      Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=90,
        origin={-106,16})));
  Sensors.TemperatureTwoPort temSen6(redeclare package Medium = MediumGlycol,
      m_flow_nominal=mGly_flow_nominal) "Glycol temperature" annotation (
      Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=90,
        origin={-46,-24})));
  Sources.MassFlowSource_T sou2(
    nPorts=1,
    redeclare package Medium = MediumAir,
    m_flow=mCon_flow_nominal) "Weather data"
    annotation (Placement(transformation(extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-82,16})));
  Sources.Boundary_pT sin2(redeclare package Medium = MediumAir, nPorts=1)
                "Pressure source"
    annotation (Placement(
        transformation(
        extent={{5,-5},{-5,5}},
        origin={-99,-35},
        rotation=180)));
  Sources.Boundary_pT preSou2(redeclare package Medium = MediumGlycol, nPorts=1)
    "Source for pressure and to account for thermal expansion of glycol"
    annotation (Placement(transformation(extent={{-82,-10},{-70,2}})));
  Controls.OBC.CDL.Conversions.BooleanToReal booToReaPum6(realTrue=
        mGly_flow_nominal, realFalse=mGly_flow_nominal/10)
                           "Pump signal"
    annotation (Placement(transformation(extent={{-98,-74},{-110,-62}})));
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
    annotation (Placement(transformation(extent={{-20,-100},{0,-80}})));

  Controls.OBC.CDL.Continuous.LessThreshold lesThrT4(t=273.15 - 2)
    "Threshold for ice tank temperature"
    annotation (Placement(transformation(extent={{-166,10},{-178,22}})));
  Controls.OBC.CDL.Continuous.GreaterThreshold greThrT4(t=273.15 + 1)
    "Threshold for ice tank temperature"
    annotation (Placement(transformation(extent={{-166,-8},{-178,4}})));
  Controls.OBC.CDL.Continuous.LessThreshold lesThrT6(t=273.15 + 2)
    "Threshold for hex glycol temperature"
    annotation (Placement(transformation(extent={{-20,-36},{-8,-24}})));
  Controls.OBC.CDL.Continuous.GreaterThreshold
                                            greThrT6(t=273.15 + 3)
    "Threshold for hex glycol temperature"
    annotation (Placement(transformation(extent={{-20,-52},{-8,-40}})));
  Actuators.Motors.IdealMotor motVal7(tOpe=60) "Motor model"
    annotation (Placement(transformation(extent={{-106,64},{-94,76}})));
  Controls.OBC.CDL.Continuous.Sources.Constant pum5Flow(k=mGly_flow_nominal)
    "Pump 5 flow rate"
    annotation (Placement(transformation(extent={{-178,-44},{-166,-32}})));
  Actuators.Motors.IdealMotor motVal5(tOpe=60) "Motor model"
    annotation (Placement(transformation(extent={{-154,-74},{-142,-62}})));
  Controls.OBC.CDL.Conversions.BooleanToReal booToReaVal5(realTrue=1, realFalse=
       0.1)
    "Valve signal"
    annotation (Placement(transformation(extent={{-174,-74},{-162,-62}})));
  Controls.OBC.CDL.Conversions.BooleanToReal booToReaPum1(realTrue=
        mGly_flow_nominal, realFalse=mGly_flow_nominal/10) "Pump signal"
    annotation (Placement(transformation(extent={{-18,-68},{-30,-56}})));
  Modelica.StateGraph.TransitionWithSignal T3 "Transition to mode 4"
    annotation (Placement(transformation(extent={{-124,204},{-104,224}})));
  Modelica.StateGraph.StepWithSignal mod4(nIn=1, nOut=1)
    "Serve district loads with chiller and borefield"
    annotation (Placement(transformation(extent={{-106,220},{-94,208}})));
  Modelica.StateGraph.TransitionWithSignal T4 "Transition from mode 4"
    annotation (Placement(transformation(extent={{-96,204},{-76,224}})));
  Modelica.StateGraph.TransitionWithSignal T2 "Transition from mode 1"
    annotation (Placement(transformation(extent={{-88,170},{-68,190}})));
  Modelica.StateGraph.StepWithSignal mod1(nIn=1, nOut=1) "Charge borefield"
    annotation (Placement(transformation(extent={{-104,174},{-92,186}})));
  Modelica.StateGraph.TransitionWithSignal T1 "Transition to mode 1"
    annotation (Placement(transformation(extent={{-132,170},{-112,190}})));
  Modelica.StateGraph.Alternative alternative
    "Split for alternative execution paths"
    annotation (Placement(transformation(extent={{-144,166},{-58,230}})));
  Controls.OBC.CDL.Continuous.Sources.Constant val4On(k=1)
    "Valve 4 on position"
    annotation (Placement(transformation(extent={{-124,30},{-136,42}})));
  Controls.OBC.CDL.Continuous.Sources.Constant val6Off(k=0.1)
    "Valve 6 off position"
    annotation (Placement(transformation(extent={{-78,30},{-90,42}})));
  HeatExchangers.ConstantEffectiveness hex(
    redeclare package Medium1 = MediumGlycol,
    redeclare package Medium2 = MediumWater,
    m1_flow_nominal=mGly_flow_nominal,
    m2_flow_nominal=mWat_flow_nominal,
    eps=0.8,
    dp2_nominal=0,
    dp1_nominal=0) "Heat exchanger" annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=90,origin={20,-7})));
  Controls.OBC.CDL.Logical.MultiOr mulOrT6(nin=4) annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-250,138})));
  Controls.OBC.CDL.Logical.MultiOr mulOrT5(nin=3) annotation (Placement(
        transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={4,138})));
  Controls.OBC.CDL.Conversions.BooleanToReal booToReaVal2(realTrue=1, realFalse=
       0.1) "Valve signal"
    annotation (Placement(transformation(extent={{64,86},{76,98}})));
  Actuators.Motors.IdealMotor motVal2(tOpe=60) "Motor model"
    annotation (Placement(transformation(extent={{84,86},{96,98}})));
  Controls.OBC.CDL.Logical.MultiOr   mulOr2(nin=2)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=0,
        origin={50,-30})));
  Controls.OBC.CDL.Logical.MultiOr   mulOr1(nin=2)
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-160,70})));
  Controls.OBC.CDL.Conversions.BooleanToReal booToReaVal7(realTrue=1, realFalse=
       0.1)
    "Valve signal"
    annotation (Placement(transformation(extent={{-128,64},{-116,76}})));
equation
  connect(pum3.port_b,chiWat. port_a2)
    annotation (Line(points={{128,-34},{128,-19}},
                                                 color={0,127,255}));
  connect(chiWat.port_b2,temSen2. port_a)
    annotation (Line(points={{128,1},{128,14}},
                                              color={0,127,255}));
  connect(temSen2.port_b,val2. port_a) annotation (Line(points={{128,26},{128,30},
          {108,30},{108,4}},
                           color={0,127,255}));
  connect(temSen2.port_b,val3. port_a)
    annotation (Line(points={{128,26},{128,36}},
                                               color={0,127,255}));
  connect(temSen1.port_b,val1. port_a)
    annotation (Line(points={{88,26},{88,36}}, color={0,127,255}));
  connect(val1.port_b,val3. port_b) annotation (Line(points={{88,44},{88,50},{128,
          50},{128,44}},   color={0,127,255}));
  connect(pum4.port_a,val3. port_b)
    annotation (Line(points={{194,50},{128,50},{128,44}},
                                                        color={0,127,255}));
  connect(pum4.port_b,disCooCoi. port_a)
    annotation (Line(points={{206,50},{208,50},{208,10}}, color={0,127,255}));
  connect(disCooCoi.port_b,temSen3. port_a)
    annotation (Line(points={{208,-10},{208,-18}}, color={0,127,255}));
  connect(temSen3.port_b,pum3. port_a) annotation (Line(points={{208,-30},{208,-52},
          {128,-52},{128,-46}},    color={0,127,255}));
  connect(pum2.port_a,pum3. port_a) annotation (Line(points={{88,-36},{88,-52},{
          128,-52},{128,-46}},color={0,127,255}));
  connect(val3.port_b,pum3. port_a) annotation (Line(points={{128,44},{128,50},{
          168,50},{168,-52},{128,-52},{128,-46}},
                                                color={0,127,255}));
  connect(val2.port_b,pum2. port_a) annotation (Line(points={{108,-4},{108,-42},
          {88,-42},{88,-36}},color={0,127,255}));
  connect(sou1.ports[1],chiWat. port_a1)
    annotation (Line(points={{146,20},{140,20},{140,1}},
                                                      color={0,127,255}));
  connect(chiWat.port_b1,sin1. ports[1])
    annotation (Line(points={{140,-19},{140,-31},{148,-31}},
                                                          color={0,127,255}));
  connect(preSou1.ports[1],pum3. port_a) annotation (Line(points={{172,0},{168,0},
          {168,-52},{128,-52},{128,-46}},  color={0,127,255}));
  connect(disCooCoi.u,disCooLoad. y)
    annotation (Line(points={{214,12},{214,40},{221.4,40}}, color={0,0,127}));
  connect(booToReaPum2.y,pum2. m_flow_in)
    annotation (Line(points={{77.2,-30},{80.8,-30}},color={0,0,127}));
  connect(booToReaPum3.y,pum3. m_flow_in) annotation (Line(points={{138.8,-62},{
          116,-62},{116,-40},{120.8,-40}},
                                     color={0,0,127}));
  connect(pum4Flow.y,pum4. m_flow_in) annotation (Line(points={{220.8,64},{200,64},
          {200,57.2}}, color={0,0,127}));
  connect(booToReaVal1.y, motVal1.u)
    annotation (Line(points={{79.2,70},{82.8,70}}, color={0,0,127}));
  connect(motVal1.y, val1.y) annotation (Line(points={{96.6,70},{100,70},{100,40},
          {92.8,40}}, color={0,0,127}));
  connect(val3.y,motVal3. y)
    annotation (Line(points={{132.8,40},{136,40},{136,70},{139.4,70}},
                                                   color={0,0,127}));
  connect(chiWat.TSet,chiWatTSet. y) annotation (Line(points={{131,3},{131,8},{120,
          8},{120,-30},{112,-30},{112,-58},{79.2,-58}},   color={0,0,127}));
  connect(chiWat.on,booToReaPum3. u) annotation (Line(points={{137,3},{137,10},{
          162,10},{162,-62},{153.2,-62}},color={255,0,255}));
  connect(temSen3.T,lesThrT3. u) annotation (Line(points={{214.6,-24},{220,-24},
          {220,-36},{222.8,-36}}, color={0,0,127}));
  connect(temSen3.T,greThrT3. u) annotation (Line(points={{214.6,-24},{220,-24},
          {220,-14},{222.8,-14}}, color={0,0,127}));
  connect(mod5.active, booToReaPum3.u) annotation (Line(points={{-106,137.4},{-106,
          100},{34,100},{34,-74},{162,-74},{162,-62},{153.2,-62}}, color={255,0,
          255}));
  connect(motVal3.u, swiVal3.y)
    annotation (Line(points={{153.2,70},{154.8,70}}, color={0,0,127}));
  connect(swiVal3.u3, val3On.y) annotation (Line(points={{169.2,65.2},{172,65.2},
          {172,60},{172.8,60}}, color={0,0,127}));
  connect(val3Off.y, swiVal3.u1) annotation (Line(points={{172.8,80},{172,80},{172,
          74.8},{169.2,74.8}}, color={0,0,127}));
  connect(pum5.port_b, iceTanUnc.port_a)
    annotation (Line(points={{-146,-32},{-146,-26}}, color={0,127,255}));
  connect(iceTanUnc.port_b, temSen4.port_a)
    annotation (Line(points={{-146,-6},{-146,0}}, color={0,127,255}));
  connect(temSen4.port_b,val4. port_a)
    annotation (Line(points={{-146,12},{-146,32}}, color={0,127,255}));
  connect(val4.port_b,val6. port_b) annotation (Line(points={{-146,40},{-146,46},
          {-106,46},{-106,40}},
                              color={0,127,255}));
  connect(val7.port_a,val6. port_b) annotation (Line(points={{-46,40},{-46,46},{
          -106,46},{-106,40}},
                         color={0,127,255}));
  connect(temSen6.port_b,pum1. port_a)
    annotation (Line(points={{-46,-30},{-46,-38}},
                                               color={0,127,255}));
  connect(pum6.port_b,chiGly. port_a2)
    annotation (Line(points={{-112,-38},{-112,-30},{-106,-30},{-106,-23}},
                                                   color={0,127,255}));
  connect(chiGly.port_b2,temSen5. port_a)
    annotation (Line(points={{-106,-3},{-106,10}},
                                                color={0,127,255}));
  connect(temSen5.port_b,val5. port_a) annotation (Line(points={{-106,22},{-106,
          26},{-126,26},{-126,22}},
                                 color={0,127,255}));
  connect(val6.port_a,temSen5. port_b)
    annotation (Line(points={{-106,32},{-106,22}},
                                                 color={0,127,255}));
  connect(pum1.port_b,pum6. port_a) annotation (Line(points={{-46,-50},{-46,-56},
          {-112,-56},{-112,-50}},
                               color={0,127,255}));
  connect(pum5.port_a,val5. port_b) annotation (Line(points={{-146,-44},{-146,-48},
          {-126,-48},{-126,14}},    color={0,127,255}));
  connect(pum5.port_a,pum6. port_a) annotation (Line(points={{-146,-44},{-146,-56},
          {-112,-56},{-112,-50}},    color={0,127,255}));
  connect(val6.port_b,pum6. port_a) annotation (Line(points={{-106,40},{-106,46},
          {-66,46},{-66,-56},{-112,-56},{-112,-50}},
                                                   color={0,127,255}));
  connect(sou2.ports[1],chiGly. port_a1)
    annotation (Line(points={{-88,16},{-94,16},{-94,-3}},color={0,127,255}));
  connect(chiGly.port_b1,sin2. ports[1]) annotation (Line(points={{-94,-23},{-94,
          -35}},               color={0,127,255}));
  connect(preSou2.ports[1],pum6. port_a) annotation (Line(points={{-70,-4},{-66,
          -4},{-66,-56},{-112,-56},{-112,-50}},
                                             color={0,127,255}));
  connect(chiGly.TSet,chiGlyTSet. y) annotation (Line(points={{-103,-1},{-103,8},
          {-96,8},{-96,58},{-89.2,58}}, color={0,0,127}));
  connect(booToReaPum6.y,pum6. m_flow_in) annotation (Line(points={{-111.2,-68},
          {-122,-68},{-122,-44},{-119.2,-44}},
                                     color={0,0,127}));
  connect(chiGly.on,booToReaPum6. u) annotation (Line(points={{-97,-1},{-97,4},{
          -84,4},{-84,-68},{-96.8,-68}},
                                    color={255,0,255}));
  connect(lesThrT4.u,temSen4. T) annotation (Line(points={{-164.8,16},{-158,16},
          {-158,6},{-152.6,6}},
                      color={0,0,127}));
  connect(greThrT4.u,temSen4. T) annotation (Line(points={{-164.8,-2},{-158,-2},
          {-158,6},{-152.6,6}},
                             color={0,0,127}));
  connect(temSen6.T, lesThrT6.u) annotation (Line(points={{-39.4,-24},{-26,-24},
          {-26,-30},{-21.2,-30}}, color={0,0,127}));
  connect(temSen6.T,greThrT6. u) annotation (Line(points={{-39.4,-24},{-26,-24},
          {-26,-46},{-21.2,-46}}, color={0,0,127}));
  connect(booToReaVal5.y, motVal5.u)
    annotation (Line(points={{-160.8,-68},{-155.2,-68}}, color={0,0,127}));
  connect(motVal5.y,val5. y) annotation (Line(points={{-141.4,-68},{-134,-68},{-134,
          18},{-130.8,18}},
                      color={0,0,127}));
  connect(mod1.active, booToReaPum6.u) annotation (Line(points={{-98,173.4},{-98,
          130},{-200,130},{-200,-90},{-84,-90},{-84,-68},{-96.8,-68}}, color={255,
          0,255}));
  connect(lesThrT4.y,T2. condition) annotation (Line(points={{-179.2,16},{-196,16},
          {-196,118},{-78,118},{-78,168}},
                                         color={255,0,255}));
  connect(greThrT4.y,T1. condition) annotation (Line(points={{-179.2,-2},{-190,-2},
          {-190,106},{-122,106},{-122,168}},color={255,0,255}));
  connect(motVal7.y,val7. y) annotation (Line(points={{-93.4,70},{-54,70},{-54,36},
          {-50.8,36}}, color={0,0,127}));
  connect(val4On.y,val4. y)
    annotation (Line(points={{-137.2,36},{-141.2,36}},
                                                   color={0,0,127}));
  connect(val6Off.y,val6. y)
    annotation (Line(points={{-91.2,36},{-101.2,36}},
                                                   color={0,0,127}));
  connect(lesThrT6.y, T3.condition) annotation (Line(points={{-6.8,-30},{4,-30},
          {4,94},{-114,94},{-114,202}}, color={255,0,255}));
  connect(greThrT6.y,T4. condition) annotation (Line(points={{-6.8,-46},{-4,-46},
          {-4,112},{-86,112},{-86,202}},  color={255,0,255}));
  connect(pum5Flow.y,pum5. m_flow_in)
    annotation (Line(points={{-164.8,-38},{-153.2,-38}},
                                                      color={0,0,127}));
  connect(booToReaPum1.y,pum1. m_flow_in) annotation (Line(points={{-31.2,-62},{
          -34,-62},{-34,-44},{-38.8,-44}}, color={0,0,127}));
  connect(T3.outPort, mod4.inPort[1])
    annotation (Line(points={{-112.5,214},{-106.6,214}}, color={0,0,0}));
  connect(mod4.outPort[1], T4.inPort)
    annotation (Line(points={{-93.7,214},{-90,214}}, color={0,0,0}));
  connect(T1.outPort, mod1.inPort[1])
    annotation (Line(points={{-120.5,180},{-104.6,180}}, color={0,0,0}));
  connect(mod1.outPort[1], T2.inPort)
    annotation (Line(points={{-91.7,180},{-82,180}}, color={0,0,0}));
  connect(alternative.split[1],T1. inPort) annotation (Line(points={{-134.97,198},
          {-132,198},{-132,180},{-126,180}}, color={0,0,0}));
  connect(T2.outPort,alternative. join[1]) annotation (Line(points={{-76.5,180},
          {-70,180},{-70,198},{-67.03,198}}, color={0,0,0}));
  connect(alternative.split[2],T3. inPort) annotation (Line(points={{-134.97,198},
          {-132,198},{-132,214},{-118,214}},
                                           color={0,0,0}));
  connect(T4.outPort,alternative. join[2]) annotation (Line(points={{-84.5,214},
          {-70,214},{-70,198},{-67.03,198}},
                                           color={0,0,0}));
  connect(mod1.active, booToReaVal5.u) annotation (Line(points={{-98,173.4},{-98,
          130},{-200,130},{-200,-68},{-175.2,-68}}, color={255,0,255}));
  connect(pum2.port_b, hex.port_a2)
    annotation (Line(points={{88,-24},{88,-17},{26,-17}}, color={0,127,255}));
  connect(hex.port_b2, temSen1.port_a)
    annotation (Line(points={{26,3},{88,3},{88,14}}, color={0,127,255}));
  connect(hex.port_b1, temSen6.port_a) annotation (Line(points={{14,-17},{-46,-17},
          {-46,-18}}, color={0,127,255}));
  connect(val7.port_b, hex.port_a1)
    annotation (Line(points={{-46,32},{-46,3},{14,3}}, color={0,127,255}));
  connect(mod5.outPort[1], parallel.join[2]) annotation (Line(points={{-99.7,
          144},{-36,144},{-36,168},{-29.15,168}},
                                                color={0,0,0}));
  connect(mod5.inPort[1], parallel.split[2]) annotation (Line(points={{-112.6,
          144},{-168,144},{-168,168},{-174.85,168}},
                                                  color={0,0,0}));
  connect(T0.outPort, parallel.inPort)
    annotation (Line(points={{-206.5,168},{-198.82,168}}, color={0,0,0}));
  connect(ste0.outPort[1], T0.inPort)
    annotation (Line(points={{-223.7,168},{-212,168}}, color={0,0,0}));
  connect(parallel.outPort, T5.inPort)
    annotation (Line(points={{-6.12,168},{0,168}}, color={0,0,0}));
  connect(T6.outPort, ste0.inPort[1])
    annotation (Line(points={{-248.5,168},{-236.6,168}}, color={0,0,0}));
  connect(T5.outPort, mod2.inPort[1])
    annotation (Line(points={{5.5,168},{13.4,168}}, color={0,0,0}));
  connect(mod2.outPort[1], T6.inPort) annotation (Line(points={{26.3,168},{32,168},
          {32,248},{-260,248},{-260,168},{-254,168}}, color={0,0,0}));
  connect(T0.condition, greThrT3.y) annotation (Line(points={{-208,156},{-208,106},
          {242,106},{242,-14},{237.2,-14}}, color={255,0,255}));
  connect(mulOrT6.y, T6.condition)
    annotation (Line(points={{-250,145.2},{-250,156}}, color={255,0,255}));
  connect(greThrT3.y, mulOrT6.u[1]) annotation (Line(points={{237.2,-14},{242,-14},
          {242,106},{-250,106},{-250,130.8},{-253.15,130.8}}, color={255,0,255}));
  connect(greThrT4.y, mulOrT6.u[2]) annotation (Line(points={{-179.2,-2},{-252,-2},
          {-252,130.8},{-251.05,130.8}}, color={255,0,255}));
  connect(mulOrT5.y, T5.condition)
    annotation (Line(points={{4,145.2},{4,156}}, color={255,0,255}));
  connect(lesThrT4.y, mulOrT5.u[1]) annotation (Line(points={{-179.2,16},{-196,16},
          {-196,118},{1.2,118},{1.2,130.8}}, color={255,0,255}));
  connect(lesThrT6.y, mulOrT5.u[2]) annotation (Line(points={{-6.8,-30},{4,-30},
          {4,130.8},{4,130.8}}, color={255,0,255}));
  connect(lesThrT3.y, mulOrT5.u[3]) annotation (Line(points={{237.2,-36},{250,-36},
          {250,124},{8,124},{8,130.8},{6.8,130.8}}, color={255,0,255}));
  connect(greThrT6.y, mulOrT6.u[3]) annotation (Line(points={{-6.8,-46},{-4,-46},
          {-4,112},{-248,112},{-248,130.8},{-248.95,130.8}}, color={255,0,255}));
  connect(lesThrT3.y, mulOrT6.u[4]) annotation (Line(points={{237.2,-36},{250,-36},
          {250,124},{-246,124},{-246,130.8},{-246.85,130.8}}, color={255,0,255}));
  connect(booToReaVal2.y, motVal2.u)
    annotation (Line(points={{77.2,92},{82.8,92}}, color={0,0,127}));
  connect(val2.y, motVal2.y) annotation (Line(points={{112.8,-8.88178e-16},{112.8,
          0},{114,0},{114,92},{96.6,92}}, color={0,0,127}));
  connect(booToReaVal2.u, mod4.active) annotation (Line(points={{62.8,92},{50,92},
          {50,236},{-100,236},{-100,220.6}}, color={255,0,255}));
  connect(mulOr2.y, booToReaPum2.u)
    annotation (Line(points={{57.2,-30},{62.8,-30}}, color={255,0,255}));
  connect(booToReaPum2.u, booToReaVal1.u) annotation (Line(points={{62.8,-30},{60,
          -30},{60,70},{64.8,70}}, color={255,0,255}));
  connect(mulOr2.u[1], mod2.active) annotation (Line(points={{42.8,-27.9},{40,-27.9},
          {40,186},{20,186},{20,174.6}}, color={255,0,255}));
  connect(booToReaPum2.u, swiVal3.u2) annotation (Line(points={{62.8,-30},{60,-30},
          {60,84},{170,84},{170,92},{190,92},{190,70},{169.2,70}}, color={255,0,
          255}));
  connect(mod2.active, mulOr1.u[1]) annotation (Line(points={{20,174.6},{20,240},
          {-184,240},{-184,72.1},{-167.2,72.1}}, color={255,0,255}));
  connect(mod4.active, mulOr1.u[2]) annotation (Line(points={{-100,220.6},{-100,
          240},{-184,240},{-184,67.9},{-167.2,67.9}}, color={255,0,255}));
  connect(booToReaVal7.y, motVal7.u)
    annotation (Line(points={{-114.8,70},{-107.2,70}}, color={0,0,127}));
  connect(mulOr1.y, booToReaVal7.u)
    annotation (Line(points={{-152.8,70},{-129.2,70}}, color={255,0,255}));
  connect(booToReaPum1.u, booToReaVal7.u) annotation (Line(points={{-16.8,-62},{
          -10,-62},{-10,-72},{-60,-72},{-60,86},{-140,86},{-140,70},{-129.2,70}},
        color={255,0,255}));
  connect(mod4.active, mulOr2.u[2]) annotation (Line(points={{-100,220.6},{-100,
          232},{40,232},{40,-32.1},{42.8,-32.1}}, color={255,0,255}));
  connect(ste1.outPort[1], alternative.inPort)
    annotation (Line(points={{-151.7,198},{-145.29,198}}, color={0,0,0}));
  connect(parallel.split[1], ste1.inPort[1]) annotation (Line(points={{-174.85,
          168},{-168,168},{-168,198},{-164.6,198},{-164.6,198}},
                                                              color={0,0,0}));
  connect(ste2.outPort[1], parallel.join[1]) annotation (Line(points={{-37.7,
          198},{-36,198},{-36,168},{-29.15,168}},
                                                color={0,0,0}));
  connect(alternative.outPort, ste2.inPort[1])
    annotation (Line(points={{-57.14,198},{-50.6,198}}, color={0,0,0}));
  annotation (
    experiment(
      StopTime=400,
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
    Diagram(coordinateSystem(extent={{-220,-120},{260,120}})),
    Icon(coordinateSystem(extent={{-220,-120},{260,120}})));
end DistrictCoolingIceTankwFSM;

within Buildings.Applications.DHC.Examples.FifthGeneration.UnidirectionalSeries.Examples.BaseClasses;
partial model RN_BaseModel_bck
  package MediumWater = Buildings.Media.Water "Medium model";
  inner parameter Data.DesignDataDHC datDes "Design values"
    annotation (Placement(transformation(extent={{-460,280},{-440,300}})));
  Agents.BoreField borFie(redeclare package Medium = MediumWater)
    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-2,-440})));
  Buildings.Fluid.Sensors.TemperatureTwoPort Tml1(
    redeclare package Medium = MediumWater,
    allowFlowReversal=false,
    m_flow_nominal=datDes.mDisPip_flow_nominal,
    tau=0)
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-80,-300})));
  Modelica.Blocks.Sources.RealExpression heatFromToBHF(
    y=4184*(Tml1.T - Tml5.T) *massFlowRateInRLTN.m_flow)
    "in W"
    annotation (Placement(transformation(extent={{-46,-358},{-26,-338}})));
  Distribution.BaseClasses.Pump_m_flow pumpMainRLTN(redeclare package Medium =
        MediumWater, m_flow_nominal=datDes.mDisPip_flow_nominal) "Pump"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={80,-360})));
  Distribution.BaseClasses.Junction splSup3(
    redeclare package Medium = MediumWater,
    m_flow_nominal=datDes.mDisPip_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={80,-20})));
  Distribution.BaseClasses.Junction splSup4(
    redeclare package Medium = MediumWater,
    m_flow_nominal=datDes.mDisPip_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={80,-60})));
  Fluid.Sensors.TemperatureTwoPort tempBeforeProsumer3(
    redeclare package Medium = MediumWater,
    allowFlowReversal=false,
    m_flow_nominal=datDes.mDisPip_flow_nominal,
    tau=0)
    annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=180,
        origin={120,-20})));
  Fluid.Sensors.TemperatureTwoPort tempAfterProsumer3(redeclare package Medium =
                     MediumWater,
    allowFlowReversal=false,
    m_flow_nominal=datDes.mDisPip_flow_nominal,
    tau=0)
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={120,-60})));
  Buildings.Fluid.Sensors.MassFlowRate massFlowRateThroughProsumer3(
    redeclare package Medium = MediumWater,
    allowFlowReversal=true)
    annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={100,-60})));
  Buildings.Fluid.Sensors.MassFlowRate massFlowRateInRLTN(
    redeclare package Medium = MediumWater,
    allowFlowReversal=true)
    annotation (Placement(
        transformation(
        extent={{6,6},{-6,-6}},
        rotation=180,
        origin={40,220})));
  Distribution.BaseClasses.Junction splSup5(
    redeclare package Medium = MediumWater,
    m_flow_nominal=datDes.mDisPip_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={80,180})));
  Distribution.BaseClasses.Junction splSup6(
    redeclare package Medium = MediumWater,
    m_flow_nominal=datDes.mDisPip_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={80,140})));
  Fluid.Sensors.TemperatureTwoPort tempBeforeProsumer2(
    redeclare package Medium = MediumWater,
    allowFlowReversal=false,
    m_flow_nominal=datDes.mDisPip_flow_nominal,
    tau=0)
    annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=180,
        origin={120,180})));
  Fluid.Sensors.TemperatureTwoPort tempAfterProsumer2(
    redeclare package Medium = MediumWater,
    allowFlowReversal=false,
    m_flow_nominal=datDes.mDisPip_flow_nominal,
    tau=0)
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={120,140})));
  Buildings.Fluid.Sensors.MassFlowRate massFlowRateThroughProsumer2(
    redeclare package Medium = MediumWater,
    allowFlowReversal=true)
    annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=0,
        origin={100,140})));
  Buildings.Fluid.Sensors.MassFlowRate massFlowRateBypassSFApartment(
    redeclare package Medium = MediumWater,
    allowFlowReversal=true)
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={80,160})));
  Buildings.Fluid.Sensors.MassFlowRate massFlowRateBypassSFRetail(
    redeclare package Medium = MediumWater,
    allowFlowReversal=true)
    annotation (
      Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={80,-40})));
  Buildings.Applications.DHC.Examples.FifthGeneration.UnidirectionalSeries.Agents.EnergyTransferStation
    ets1(
    redeclare package Medium = MediumWater,
    QCoo_flow_nominal=sum(bui1.terUni.QCoo_flow_nominal),
    QHea_flow_nominal=sum(bui1.terUni.QHea_flow_nominal))
    "Energy transfer station"
    annotation (Placement(transformation(extent={{-360,-40},{-320,0}})));
  Distribution.BaseClasses.Junction splSup7(
    redeclare package Medium = MediumWater,
    m_flow_nominal=datDes.mDisPip_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-80,0})));
  Distribution.BaseClasses.Junction splSup8(
    redeclare package Medium = MediumWater,
    m_flow_nominal=datDes.mDisPip_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-80,-40})));
  Fluid.Sensors.TemperatureTwoPort          tempBeforeProsumer1(redeclare
      package Medium = MediumWater,
    allowFlowReversal=false,        m_flow_nominal=datDes.mDisPip_flow_nominal,
    tau=0)                          annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=180,
        origin={-120,-40})));
  Fluid.Sensors.TemperatureTwoPort          tempAfterProsumer1(redeclare
      package Medium = MediumWater,
    allowFlowReversal=false,        m_flow_nominal=datDes.mDisPip_flow_nominal,
    tau=0)                          annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=180,
        origin={-120,0})));
  Buildings.Fluid.Sensors.MassFlowRate massFlowRateThroughProsumer1(
      redeclare package Medium = MediumWater, allowFlowReversal=true)
    annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=0,
        origin={-100,0})));
  Buildings.Fluid.Sensors.MassFlowRate massFlowRateBypassSFLargeOfficediv4(
      redeclare package Medium = MediumWater, allowFlowReversal=true)
    annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=-90,
        origin={-80,-20})));
  Fluid.Sensors.TemperatureTwoPort          Tml2(redeclare package Medium =
        MediumWater,
    allowFlowReversal=false,
                     m_flow_nominal=datDes.mDisPip_flow_nominal,
    tau=0)           annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-80,-100})));
  Fluid.Sensors.TemperatureTwoPort          Tml4(redeclare package Medium =
        MediumWater,
    allowFlowReversal=false,
    m_flow_nominal=datDes.mDisPip_flow_nominal,
    tau=0)           annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=90,
        origin={80,120})));
  Fluid.Sensors.TemperatureTwoPort          Tml5(redeclare package Medium =
        MediumWater,
    allowFlowReversal=false,
    m_flow_nominal=datDes.mDisPip_flow_nominal,
    tau=0)           annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={80,-100})));
  Fluid.Sensors.TemperatureTwoPort          Tml3(redeclare package Medium =
        MediumWater, m_flow_nominal=datDes.mDisPip_flow_nominal)
                     annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=180,
        origin={0,220})));
  Distribution.BaseClasses.Junction splSup1(
    redeclare package Medium = MediumWater,
    m_flow_nominal=datDes.mDisPip_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-80,-190})));
  Distribution.BaseClasses.Junction splSup2(
    redeclare package Medium = MediumWater,
    m_flow_nominal=datDes.mDisPip_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-80,-270})));
  Buildings.Fluid.Sensors.MassFlowRate massFlowRateBypassPlant(redeclare
      package Medium = MediumWater, allowFlowReversal=true) annotation (
      Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=-90,
        origin={-80,-230})));
  Buildings.Fluid.HeatExchangers.ConstantEffectiveness plant(
    redeclare package Medium1 = MediumWater,
    redeclare package Medium2 = MediumWater,
    allowFlowReversal2=false,
    final m1_flow_nominal=datDes.mPla_flow_nominal,
    final m2_flow_nominal=datDes.mPla_flow_nominal,
    show_T=true,
    final dp1_nominal(displayUnit="bar") = 50000,
    final dp2_nominal(displayUnit="bar") = 50000,
    final eps=datDes.epsPla)                                                 "Heat exchanger" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-146,-240})));
  Fluid.Sensors.TemperatureTwoPort          tempBeforePlantPrimSide(
      redeclare package Medium = MediumWater,
    allowFlowReversal=false,                  m_flow_nominal=datDes.mDisPip_flow_nominal,
    tau=0)                                    annotation (Placement(
        transformation(
        extent={{-6,6},{6,-6}},
        rotation=180,
        origin={-120,-270})));
  Fluid.Sensors.TemperatureTwoPort          tempAfterPlantPrimSide(
      redeclare package Medium = MediumWater,
    allowFlowReversal=false,                  m_flow_nominal=datDes.mDisPip_flow_nominal,
    tau=0)                                    annotation (Placement(
        transformation(
        extent={{6,6},{-6,-6}},
        rotation=180,
        origin={-120,-190})));
  Buildings.Fluid.Sensors.MassFlowRate massFlowRateThroughPrimSidePlant(
      redeclare package Medium = MediumWater, allowFlowReversal=true)
    annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=0,
        origin={-100,-190})));
  Distribution.BaseClasses.Pump_m_flow pumpPrimarySidePlant(
    redeclare package Medium = MediumWater,
    final m_flow_nominal=datDes.mPla_flow_nominal,
    dp_nominal=50000) "Pump" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-140,-210})));
  Modelica.Blocks.Sources.Constant mFlowInputPlant(final k=datDes.mPla_flow_nominal)
                                                            "kg/s"
    annotation (Placement(transformation(extent={{-100,-238},{-116,-222}})));
  Buildings.Fluid.Sources.Boundary_pT sewageSourceAtConstTemp(
    redeclare package Medium = MediumWater,
    T=290.15,
    nPorts=2) "17°C"
    annotation (Placement(transformation(extent={{-200,-250},{-180,-230}})));
  Distribution.BaseClasses.Pump_m_flow pumpSecondarySidePlant(
    redeclare package Medium = MediumWater,
    final m_flow_nominal=datDes.mPla_flow_nominal,
    dp_nominal=50000) "Pump" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-180,-210})));
  Fluid.Sensors.TemperatureTwoPort          tempAfterPlantSecondSide(
      redeclare package Medium = MediumWater,
    allowFlowReversal=false,                  m_flow_nominal=datDes.mDisPip_flow_nominal,
    tau=0)                                    annotation (Placement(
        transformation(
        extent={{-6,6},{6,-6}},
        rotation=180,
        origin={-166,-270})));
  Modelica.Blocks.Sources.RealExpression heatFromToPlantPrimarySide(y=4184*(
        tempAfterPlantPrimSide.T - tempBeforePlantPrimSide.T)*
        massFlowRateThroughPrimSidePlant.m_flow) "in W"
    annotation (Placement(transformation(extent={{-120,-260},{-100,-240}})));
  Distribution.BaseClasses.PipeDistribution res(
    redeclare package Medium = MediumWater,
    final m_flow_nominal=datDes.mDisPip_flow_nominal,
    final R=datDes.RDisPip) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={80,-310})));
  Distribution.BaseClasses.PipeDistribution res1(
    redeclare package Medium = MediumWater,
    final m_flow_nominal=datDes.mDisPip_flow_nominal,
    final R=datDes.RDisPip) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-80,-330})));
  Distribution.BaseClasses.PipeDistribution distributionPipe(
    redeclare package Medium = MediumWater,
    final m_flow_nominal=datDes.mDisPip_flow_nominal,
    final R=datDes.RDisPip) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-80,70})));
  Distribution.BaseClasses.PipeDistribution res4(
    redeclare package Medium = MediumWater,
    final m_flow_nominal=datDes.mDisPip_flow_nominal,
    final R=datDes.RDisPip) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={80,70})));
  Buildings.Fluid.Sensors.MassFlowRate massFlowRateThroughProsumer1AfterSB(
      redeclare package Medium = MediumWater, allowFlowReversal=true)
    annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-100,-40})));
  Buildings.Fluid.Sensors.MassFlowRate massFlowRateThroughProsumer2AfterSB(
      redeclare package Medium = MediumWater, allowFlowReversal=true)
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={100,180})));
  Buildings.Fluid.Sensors.MassFlowRate massFlowRateThroughProsumer3AfterSB(
      redeclare package Medium = MediumWater, allowFlowReversal=true)
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={100,-20})));
  Modelica.Blocks.Continuous.Integrator integrator(k=0.001*(1/3600))
    annotation (Placement(transformation(extent={{-6,-358},{14,-338}})));
  Buildings.Fluid.Sources.Boundary_pT bou(redeclare package Medium =
        MediumWater, nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={130,-340})));
  Distribution.BaseClasses.PipeDistribution res3(
    redeclare package Medium = MediumWater,
    final m_flow_nominal=datDes.mDisPip_flow_nominal,
    final R=datDes.RDisPip) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-80,-130})));
  Distribution.BaseClasses.PipeDistribution res5(
    redeclare package Medium = MediumWater,
    final m_flow_nominal=datDes.mDisPip_flow_nominal,
    final R=datDes.RDisPip) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={80,-130})));
  Distribution.BaseClasses.PipeDistribution res2(
    redeclare package Medium = MediumWater,
    final m_flow_nominal=datDes.mDisPip_flow_nominal,
    final R=datDes.RDisPip) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={80,-172})));
  Distribution.BaseClasses.PipeDistribution res6(
    redeclare package Medium = MediumWater,
    final m_flow_nominal=datDes.mDisPip_flow_nominal,
    final R=datDes.RDisPip) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={80,-210})));
  PowerMeter EPumPla(nu=2) "Plant pump power consumption"
    annotation (Placement(transformation(extent={{-154,-158},{-142,-146}})));
  PowerMeter EPumPro(nu=1)
                     "Prosumer pump power consumption"
    annotation (Placement(transformation(extent={{246,282},{258,294}})));
  PowerMeter EPumDis(nu=2) "Distribution network pump power consumption"
    annotation (Placement(transformation(extent={{222,-386},{234,-374}})));
  PowerMeter EHeaPum(nu=1)
                     "Heat pump power consumption"
    annotation (Placement(transformation(extent={{246,262},{258,274}})));
  PowerMeter EBorFie(nu=1) "Heat from borefield"
    annotation (Placement(transformation(extent={{-38,-466},{-26,-454}})));
  PowerMeter EPlant(nu=1) "Plant power consumption"
    annotation (Placement(transformation(extent={{-66,-256},{-54,-244}})));
  Modelica.Blocks.Sources.RealExpression heatFromToNetwrokProsumer1(y=4184*(
        tempBeforeProsumer1.T - tempAfterProsumer1.T)*
        massFlowRateThroughProsumer1.m_flow) "in W"
    annotation (Placement(transformation(extent={{-180,-90},{-160,-70}})));
  PowerMeter EProsumer1(nu=1) "Prosumer 1 power consumption"
    annotation (Placement(transformation(extent={{-118,-86},{-106,-74}})));
  PowerMeter EProsumer2(nu=1) "Prosumer 2 power consumption"
    annotation (Placement(transformation(extent={{180,94},{168,106}})));
  Modelica.Blocks.Sources.RealExpression heatFromToNetwrokProsumer2(y=4184*(
        tempBeforeProsumer2.T - tempAfterProsumer2.T)*
        massFlowRateThroughProsumer2.m_flow) "in W"
    annotation (Placement(transformation(extent={{220,90},{200,110}})));
  Modelica.Blocks.Sources.RealExpression heatFromToNetwrokProsumer3(y=4184*(
        tempBeforeProsumer3.T - tempAfterProsumer3.T)*
        massFlowRateThroughProsumer3.m_flow) "in W"
    annotation (Placement(transformation(extent={{240,-110},{220,-90}})));
  PowerMeter EProsumer3(nu=1) "Prosumer 3 power consumption"
    annotation (Placement(transformation(extent={{180,-106},{168,-94}})));
  PowerMeter ESumProsumers(nu=3) "Prosumers power consumption"
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=0,
        origin={226,-160})));
  Modelica.Blocks.Math.MultiSum EEleTot(
    nu=2, y(unit="J", displayUnit="kWh")) "Total electrical energy"
    annotation (Placement(transformation(extent={{284,274},{296,286}})));

  Buildings.Utilities.IO.Files.Printer pri(
    samplePeriod=8760*3600,
    header="Total electricity use [J]",
    configuration=3,
    significantDigits=5)
    annotation (Placement(transformation(extent={{352,270},{372,290}})));
  Distribution.BaseClasses.Pump_m_flow pumpBHS(redeclare package Medium =
        MediumWater, m_flow_nominal=datDes.mSto_flow_nominal) "Pump"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={50,-440})));
  Distribution.BaseClasses.Junction splSup9(
    redeclare package Medium = MediumWater,
    m_flow_nominal=datDes.mDisPip_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={80,-400})));
  Distribution.BaseClasses.Junction splSup10(
    redeclare package Medium = MediumWater,
    m_flow_nominal=datDes.mDisPip_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-80,-400})));
  ConstraintViolation TVio(
    final uMin=datDes.TLooMin,
    final uMax=datDes.TLooMax,
    nu=5)
    "Outputs the fraction of times when the temperature constraints are violated"
    annotation (Placement(transformation(extent={{324,324},{336,336}})));
  Buildings.Utilities.IO.Files.Printer pri1(
    samplePeriod=8760*3600,
    header="Temperature constraint violation [-]",
    configuration=3,
    significantDigits=5)
    annotation (Placement(transformation(extent={{352,320},{372,340}})));
  Modelica.Blocks.Math.MultiSum EPumTot(nu=3, y(unit="J", displayUnit="kWh"))
    "Total electrical energy for pumps"
    annotation (Placement(transformation(extent={{284,302},{296,314}})));
  Loads.Examples.BaseClasses.GeojsonSpawn1Z6BuildingPump bui1(redeclare package
      Medium1 = MediumWater, nPorts1=2) "Building"
    annotation (Placement(transformation(extent={{-360,40},{-340,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetHeaWatSup(k=ets1.THeaWatSup_nominal)
    "Heating water supply temperature set point"
    annotation (Placement(transformation(extent={{-460,230},{-440,250}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetChiWatSup(k=ets1.TChiWatSup_nominal)
    "Chilled water supply temperature set point"
    annotation (Placement(transformation(extent={{-460,200},{-440,220}})));
  Loads.Examples.BaseClasses.GeojsonSpawn1Z6BuildingPump bui2(
    redeclare package Medium1 = MediumWater,
    idfPath=
        "modelica://Buildings/Applications/DHC/Loads/Examples/BaseClasses/GeojsonExportSpawn/Resources/Data/B5a6b99ec37f4de7f94021950/RefBldgSmallOfficeNew2004_Chicago.idf",
    nPorts1=2) "Building"
    annotation (Placement(transformation(extent={{320,180},{340,200}})));

  Agents.EnergyTransferStation ets2(
    redeclare package Medium = MediumWater,
    QCoo_flow_nominal=sum(bui2.terUni.QCoo_flow_nominal),
    QHea_flow_nominal=sum(bui2.terUni.QHea_flow_nominal))
    "Energy transfer station"
    annotation (Placement(transformation(extent={{320,80},{360,120}})));
  Loads.Examples.BaseClasses.GeojsonSpawn1Z6BuildingPump bui3(redeclare package
      Medium1 = MediumWater, nPorts1=2) "Building"
    annotation (Placement(transformation(extent={{320,-20},{340,0}})));
  Agents.EnergyTransferStation
    ets3(
    redeclare package Medium = MediumWater,
    QCoo_flow_nominal=sum(bui3.terUni.QCoo_flow_nominal),
    QHea_flow_nominal=sum(bui3.terUni.QHea_flow_nominal))
    "Energy transfer station"
    annotation (Placement(transformation(extent={{320,-120},{360,-80}})));
protected
  constant Real scaFacLoa = 10 "Scaling factor for load profiles that are read by the model";
equation
  connect(massFlowRateThroughProsumer3.port_a, tempAfterProsumer3.port_b)
    annotation (Line(points={{106,-60},{114,-60}},   color={0,127,255}));
  connect(massFlowRateThroughProsumer3.port_b, splSup4.port_3)
    annotation (Line(points={{94,-60},{90,-60}},    color={0,127,255}));
  connect(massFlowRateThroughProsumer2.port_a, tempAfterProsumer2.port_b)
    annotation (Line(points={{106,140},{114,140}},
                                                 color={0,127,255}));
  connect(massFlowRateThroughProsumer2.port_b, splSup6.port_3)
    annotation (Line(points={{94,140},{90,140}},color={0,127,255}));
  connect(massFlowRateBypassSFApartment.port_a, splSup5.port_2)
    annotation (Line(points={{80,166},{80,170}}, color={0,127,255}));
  connect(massFlowRateBypassSFApartment.port_b, splSup6.port_1)
    annotation (Line(points={{80,154},{80,150}},color={0,127,255}));
  connect(massFlowRateBypassSFRetail.port_a, splSup3.port_2)
    annotation (Line(points={{80,-34},{80,-30}}, color={0,127,255}));
  connect(massFlowRateBypassSFRetail.port_b, splSup4.port_1)
    annotation (Line(points={{80,-46},{80,-50}}, color={0,127,255}));
  connect(splSup8.port_2, massFlowRateBypassSFLargeOfficediv4.port_a)
    annotation (Line(points={{-80,-30},{-80,-26}},color={0,127,255}));
  connect(splSup7.port_1, massFlowRateBypassSFLargeOfficediv4.port_b)
    annotation (Line(points={{-80,-10},{-80,-14}}, color={0,127,255}));
  connect(massFlowRateThroughProsumer1.port_b, splSup7.port_3)
    annotation (Line(points={{-94,0},{-92,0},{-92,6.66134e-16},{-90,
          6.66134e-16}},                            color={0,127,255}));
  connect(massFlowRateThroughProsumer1.port_a, tempAfterProsumer1.port_b)
    annotation (Line(points={{-106,0},{-110,0},{-110,-4.44089e-16},{-114,
          -4.44089e-16}},                            color={0,127,255}));
  connect(Tml2.port_b, splSup8.port_1)
    annotation (Line(points={{-80,-94},{-80,-50}},
                                                 color={0,127,255}));
  connect(Tml4.port_a, splSup6.port_2)
    annotation (Line(points={{80,126},{80,130}},
                                              color={0,127,255}));
  connect(massFlowRateInRLTN.port_b, splSup5.port_1) annotation (Line(
        points={{46,220},{80,220},{80,190}},color={0,127,255}));
  connect(Tml3.port_b, massFlowRateInRLTN.port_a)
    annotation (Line(points={{6,220},{34,220}},   color={0,127,255}));
  connect(Tml5.port_a, splSup4.port_2)
    annotation (Line(points={{80,-94},{80,-70}},   color={0,127,255}));
  connect(massFlowRateBypassPlant.port_b, splSup1.port_1) annotation (Line(
        points={{-80,-224},{-80,-200}},         color={0,127,255}));
  connect(massFlowRateBypassPlant.port_a, splSup2.port_2)
    annotation (Line(points={{-80,-236},{-80,-260}},
                                                   color={0,127,255}));
  connect(tempBeforePlantPrimSide.port_a, splSup2.port_3)
    annotation (Line(points={{-114,-270},{-90,-270}}, color={0,127,255}));
  connect(massFlowRateThroughPrimSidePlant.port_b, splSup1.port_3)
    annotation (Line(points={{-94,-190},{-90,-190}},
                                                   color={0,127,255}));
  connect(tempAfterPlantPrimSide.port_b, massFlowRateThroughPrimSidePlant.port_a)
    annotation (Line(points={{-114,-190},{-106,-190}},
                                                     color={0,127,255}));
  connect(mFlowInputPlant.y, pumpPrimarySidePlant.m_flow_in) annotation (
      Line(points={{-116.8,-230},{-120,-230},{-120,-210},{-128,-210}},
                                                                   color={0,
          0,127}));
  connect(tempAfterPlantSecondSide.port_a, plant.port_b2) annotation (Line(
        points={{-160,-270},{-152,-270},{-152,-250}},color={0,127,255}));
  connect(tempAfterPlantSecondSide.port_b, sewageSourceAtConstTemp.ports[1])
    annotation (Line(points={{-172,-270},{-180,-270},{-180,-238}},color={0,
          127,255}));
  connect(mFlowInputPlant.y, pumpSecondarySidePlant.m_flow_in) annotation (
      Line(points={{-116.8,-230},{-122,-230},{-122,-224},{-200,-224},{-200,-210},
          {-192,-210}},color={0,0,127}));
  connect(Tml1.port_b, splSup2.port_1)
    annotation (Line(points={{-80,-294},{-80,-280}}, color={0,127,255}));
  connect(pumpPrimarySidePlant.port_b, tempAfterPlantPrimSide.port_a)
    annotation (Line(points={{-140,-200},{-140,-190},{-126,-190}},
                                                                color={0,
          127,255}));
  connect(pumpPrimarySidePlant.port_a, plant.port_b1)
    annotation (Line(points={{-140,-220},{-140,-230}},
                                                     color={0,127,255}));
  connect(pumpSecondarySidePlant.port_b, plant.port_a2) annotation (Line(
        points={{-180,-200},{-180,-190},{-152,-190},{-152,-230}},
                                                              color={0,127,
          255}));
  connect(pumpSecondarySidePlant.port_a, sewageSourceAtConstTemp.ports[2])
    annotation (Line(points={{-180,-220},{-180,-242}},
                                                     color={0,127,255}));
  connect(res.port_b, pumpMainRLTN.port_a)
    annotation (Line(points={{80,-320},{80,-350}}, color={0,127,255}));
  connect(res1.port_b, Tml1.port_a)
    annotation (Line(points={{-80,-320},{-80,-306}}, color={0,127,255}));
  connect(distributionPipe.port_b, Tml3.port_a)
    annotation (Line(points={{-80,80},{-80,220},{-6,220}},
                                                  color={0,127,255}));
  connect(distributionPipe.port_a, splSup7.port_2) annotation (Line(points={{-80,60},
          {-80,10}},                 color={0,127,255}));
  connect(res4.port_a, Tml4.port_b)
    annotation (Line(points={{80,80},{80,114}},
                                              color={0,127,255}));
  connect(res4.port_b, splSup3.port_1)
    annotation (Line(points={{80,60},{80,-10}},  color={0,127,255}));
  connect(plant.port_a1, tempBeforePlantPrimSide.port_b) annotation (Line(
        points={{-140,-250},{-140,-270},{-126,-270}}, color={0,127,255}));
  connect(heatFromToBHF.y, integrator.u)
    annotation (Line(points={{-25,-348},{-8,-348}}, color={0,0,127}));
  connect(bou.ports[1], pumpMainRLTN.port_a) annotation (Line(points={{120,
          -340},{80,-340},{80,-350}},
                                color={0,127,255}));
  connect(res3.port_a, splSup1.port_2)
    annotation (Line(points={{-80,-140},{-80,-180}}, color={0,127,255}));
  connect(res5.port_b, Tml5.port_b)
    annotation (Line(points={{80,-120},{80,-106}}, color={0,127,255}));
  connect(res3.port_b, Tml2.port_a)
    annotation (Line(points={{-80,-120},{-80,-106}},color={0,127,255}));
  connect(res2.port_b, res5.port_a)
    annotation (Line(points={{80,-162},{80,-140}}, color={0,127,255}));
  connect(res.port_a, res6.port_a)
    annotation (Line(points={{80,-300},{80,-220}}, color={0,127,255}));
  connect(res6.port_b, res2.port_a)
    annotation (Line(points={{80,-200},{80,-182}}, color={0,127,255}));
  connect(pumpSecondarySidePlant.P, EPumPla.u[1]) annotation (Line(points={{-189,
          -199},{-189,-150},{-186,-150},{-186,-149.9},{-154,-149.9}},
                                                               color={0,0,127}));
  connect(pumpPrimarySidePlant.P, EPumPla.u[2]) annotation (Line(points={{-131,
          -199},{-131,-174},{-160,-174},{-160,-154.1},{-154,-154.1}},
                                                         color={0,0,127}));
  connect(ets1.PPum, EPumPro.u[1]) annotation (Line(points={{-318.571,-4.28571},
          {-264,-4.28571},{-264,288},{246,288}},       color={0,0,127}));
  connect(ets1.PCom, EHeaPum.u[1]) annotation (Line(points={{-318.571,-1.42857},
          {-260,-1.42857},{-260,268},{246,268}},     color={0,0,127}));
  connect(EPumDis.u[1], pumpMainRLTN.P)
    annotation (Line(points={{222,-377.9},{170,-377.9},{170,-386},{72,
          -386},{72,-371},{71,-371}},                        color={0,0,127}));
  connect(EBorFie.u[1], borFie.Q_flow) annotation (Line(points={{-38,-460},{-52,
          -460},{-52,-448},{-13,-448}}, color={0,0,127}));
  connect(heatFromToPlantPrimarySide.y, EPlant.u[1])
    annotation (Line(points={{-99,-250},{-66,-250}}, color={0,0,127}));
  connect(heatFromToNetwrokProsumer1.y, EProsumer1.u[1])
    annotation (Line(points={{-159,-80},{-118,-80}}, color={0,0,127}));
  connect(EProsumer2.u[1], heatFromToNetwrokProsumer2.y) annotation (Line(
        points={{180,100},{190,100},{190,100},{199,100}}, color={0,0,127}));
  connect(EProsumer3.u[1], heatFromToNetwrokProsumer3.y)
    annotation (Line(points={{180,-100},{219,-100}}, color={0,0,127}));
  connect(heatFromToNetwrokProsumer1.y, ESumProsumers.u[1]) annotation (Line(
        points={{-159,-80},{-132,-80},{-132,-110},{220,-110},{220,-157.2}},
        color={0,0,127}));
  connect(heatFromToNetwrokProsumer3.y, ESumProsumers.u[2]) annotation (Line(
        points={{219,-100},{200,-100},{200,-160},{220,-160}},
                              color={0,0,127}));
  connect(heatFromToNetwrokProsumer2.y, ESumProsumers.u[3]) annotation (Line(
        points={{199,100},{190,100},{190,60},{254,60},{254,-120},{220,-120},{
          220,-162.8}},                                           color={0,0,
          127}));
  connect(EHeaPum.y, EEleTot.u[1]) annotation (Line(points={{259.02,268},{266,
          268},{266,282.1},{284,282.1}},
                                      color={0,0,127}));
  connect(EEleTot.y, pri.x[1])
    annotation (Line(points={{297.02,280},{350,280}}, color={0,0,127}));
  connect(borFie.port_a, pumpBHS.port_b)
    annotation (Line(points={{8,-440},{40,-440}}, color={0,127,255}));
  connect(res1.port_a, splSup10.port_1)
    annotation (Line(points={{-80,-340},{-80,-390}}, color={0,127,255}));
  connect(splSup10.port_2, borFie.port_b) annotation (Line(points={{-80,
          -410},{-80,-440},{-12,-440}},
                                 color={0,127,255}));
  connect(pumpBHS.port_a, splSup9.port_2) annotation (Line(points={{60,-440},
          {80,-440},{80,-410}},color={0,127,255}));
  connect(splSup9.port_1, pumpMainRLTN.port_b)
    annotation (Line(points={{80,-390},{80,-370}}, color={0,127,255}));
  connect(splSup10.port_3, splSup9.port_3)
    annotation (Line(points={{-70,-400},{70,-400}}, color={0,127,255}));
  connect(pumpBHS.P, EPumDis.u[2]) annotation (Line(points={{39,-431},{24,
          -431},{24,-430},{20,-430},{20,-420},{200,-420},{200,-382.1},{
          222,-382.1}},                                    color={0,0,127}));
  connect(Tml1.T, TVio.u[1]) annotation (Line(points={{-86.6,-300},{-292,-300},
          {-292,333.36},{324,333.36}},color={0,0,127}));
  connect(Tml2.T, TVio.u[2]) annotation (Line(points={{-86.6,-100},{-282,
          -100},{-282,331.68},{324,331.68}},
                                 color={0,0,127}));
  connect(Tml3.T, TVio.u[3]) annotation (Line(points={{6.66134e-16,226.6},
          {6.66134e-16,330},{324,330}},
                           color={0,0,127}));
  connect(Tml4.T, TVio.u[4]) annotation (Line(points={{86.6,120},{220,120},{220,
          328.32},{324,328.32}}, color={0,0,127}));
  connect(Tml5.T, TVio.u[5]) annotation (Line(points={{86.6,-100},{140,-100},{
          140,-80},{260,-80},{260,326.64},{324,326.64}},
                                                       color={0,0,127}));
  connect(TVio.y, pri1.x[1])
    annotation (Line(points={{337.02,330},{350,330}}, color={0,0,127}));
  connect(EPumPro.y, EPumTot.u[1]) annotation (Line(points={{259.02,288},{266,
          288},{266,310.8},{284,310.8}}, color={0,0,127}));
  connect(EPumDis.y, EPumTot.u[2]) annotation (Line(points={{235.02,-380},
          {268,-380},{268,308},{284,308}},
                                      color={0,0,127}));
  connect(EPumPla.y, EPumTot.u[3]) annotation (Line(points={{-140.98,-152},{
          -132,-152},{-132,-88},{-270,-88},{-270,328},{270,328},{270,305.2},{
          284,305.2}}, color={0,0,127}));
  connect(EPumTot.y, EEleTot.u[2]) annotation (Line(points={{297.02,308},{300,
          308},{300,294},{276,294},{276,277.9},{284,277.9}}, color={0,0,127}));
  connect(bui1.ports_b1[1], ets1.port_aHeaWat) annotation (Line(points={{-320,30},
          {-320,32},{-300,32},{-300,8},{-380,8},{-380,-28.5714},{-360,-28.5714}},
                      color={0,127,255}));
  connect(ets1.port_bHeaWat, bui1.ports_a1[1]) annotation (Line(points={{-320,
          -28.5714},{-312,-28.5714},{-312,-28},{-302,-28},{-302,-60},{-400,-60},
          {-400,36},{-380,36},{-380,30}}, color={0,127,255}));
  connect(bui1.ports_b1[2], ets1.port_aChi) annotation (Line(points={{-320,34},
          {-320,28},{-304,28},{-304,12},{-384,12},{-384,-37.1429},{-360,
          -37.1429}}, color={0,127,255}));
  connect(ets1.port_bChi, bui1.ports_a1[2]) annotation (Line(points={{-320,
          -37.2857},{-312,-37.2857},{-312,-36},{-306,-36},{-306,-56},{-396,-56},
          {-396,30},{-380,30},{-380,34}}, color={0,127,255}));
  connect(TSetHeaWatSup.y, ets1.TSetHeaWat) annotation (Line(points={{-438,240},
          {-420,240},{-420,-2.85714},{-361.429,-2.85714}}, color={0,0,127}));
  connect(TSetChiWatSup.y, ets1.TSetChiWat) annotation (Line(points={{-438,210},
          {-420,210},{-420,-8.57143},{-361.429,-8.57143}}, color={0,0,127}));
  connect(bui2.ports_b1[1], ets2.port_aHeaWat) annotation (Line(points={{360,170},
          {400,170},{400,60},{300,60},{300,92},{320,92},{320,91.4286}},
        color={0,127,255}));
  connect(ets2.port_bHeaWat, bui2.ports_a1[1]) annotation (Line(points={{360,
          91.4286},{382,91.4286},{382,148},{292,148},{292,170},{300,170}},
        color={0,127,255}));
  connect(bui2.ports_b1[2], ets2.port_aChi) annotation (Line(points={{360,174},
          {366,174},{366,168},{394,168},{394,66},{306,66},{306,82.8571},{320,
          82.8571}}, color={0,127,255}));
  connect(ets2.port_bChi, bui2.ports_a1[2]) annotation (Line(points={{360,
          82.7143},{370,82.7143},{370,82},{388,82},{388,154},{296,154},{296,170},
          {300,170},{300,174}}, color={0,127,255}));
  connect(TSetHeaWatSup.y, ets2.TSetHeaWat) annotation (Line(points={{-438,240},
          {288,240},{288,117.143},{318.571,117.143}}, color={0,0,127}));
  connect(TSetChiWatSup.y, ets2.TSetChiWat) annotation (Line(points={{-438,210},
          {284,210},{284,111.429},{318.571,111.429}}, color={0,0,127}));
  connect(bui3.ports_b1[1], ets3.port_aHeaWat) annotation (Line(points={{360,-30},
          {400,-30},{400,-140},{300,-140},{300,-108.571},{320,-108.571}},
        color={0,127,255}));
  connect(ets3.port_bHeaWat, bui3.ports_a1[1]) annotation (Line(points={{360,
          -108.571},{384,-108.571},{384,-54},{288,-54},{288,-30},{300,-30}},
        color={0,127,255}));
  connect(bui3.ports_b1[2], ets3.port_aChi) annotation (Line(points={{360,-26},
          {360,-34},{394,-34},{394,-134},{306,-134},{306,-117.143},{320,
          -117.143}}, color={0,127,255}));
  connect(ets3.port_bChi, bui3.ports_a1[2]) annotation (Line(points={{360,
          -117.286},{368,-117.286},{368,-118},{388,-118},{388,-50},{292,-50},{
          292,-30},{300,-30},{300,-26}}, color={0,127,255}));
  connect(TSetHeaWatSup.y, ets3.TSetHeaWat) annotation (Line(points={{-438,240},
          {288,240},{288,-82.8571},{318.571,-82.8571}}, color={0,0,127}));
  connect(TSetChiWatSup.y, ets3.TSetChiWat) annotation (Line(points={{-438,210},
          {284,210},{284,-88},{302,-88},{302,-88.5714},{318.571,-88.5714}},
        color={0,0,127}));
  connect(tempBeforeProsumer1.port_a, massFlowRateThroughProsumer1AfterSB.port_b)
    annotation (Line(points={{-114,-40},{-106,-40}}, color={0,127,255}));
  connect(massFlowRateThroughProsumer1AfterSB.port_a, splSup8.port_3)
    annotation (Line(points={{-94,-40},{-90,-40}}, color={0,127,255}));
  connect(splSup3.port_3, massFlowRateThroughProsumer3AfterSB.port_a)
    annotation (Line(points={{90,-20},{94,-20}}, color={0,127,255}));
  connect(tempBeforeProsumer3.port_a, massFlowRateThroughProsumer3AfterSB.port_b)
    annotation (Line(points={{114,-20},{106,-20}}, color={0,127,255}));
  connect(tempBeforeProsumer3.port_b, ets3.port_a) annotation (Line(
        points={{126,-20},{280,-20},{280,-100},{320,-100}}, color={0,127,
          255}));
  connect(ets3.port_b, tempAfterProsumer3.port_a) annotation (Line(points={{360,
          -100},{380,-100},{380,-60},{126,-60}},          color={0,127,
          255}));
  connect(splSup5.port_3, massFlowRateThroughProsumer2AfterSB.port_a)
    annotation (Line(points={{90,180},{94,180}}, color={0,127,255}));
  connect(tempBeforeProsumer2.port_a, massFlowRateThroughProsumer2AfterSB.port_b)
    annotation (Line(points={{114,180},{106,180}}, color={0,127,255}));
  connect(tempBeforeProsumer2.port_b, ets2.port_a) annotation (Line(
        points={{126,180},{280,180},{280,100},{320,100}}, color={0,127,
          255}));
  connect(ets2.port_b, tempAfterProsumer2.port_a) annotation (Line(points={{360,100},
          {368,100},{368,140},{126,140}},               color={0,127,255}));
  connect(ets1.port_b, tempAfterProsumer1.port_a) annotation (Line(points={{-320,
          -20},{-140,-20},{-140,8.88178e-16},{-126,8.88178e-16}},
        color={0,127,255}));
  connect(tempBeforeProsumer1.port_b, ets1.port_a) annotation (Line(
        points={{-126,-40},{-260,-40},{-260,-48},{-370,-48},{-370,-20},{
          -360,-20}}, color={0,127,255}));
  annotation (Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-480,-500},{480,
            500}})),
    experiment(StopTime=31536000, __Dymola_NumberOfIntervals=8760),
    Icon(coordinateSystem(extent={{-320,-480},{380,360}})));
end RN_BaseModel_bck;

within Buildings.Examples.DistrictReservoirNetworks.Examples.BaseClasses;
partial model RN_BaseModel_StepCompare
  package MediumWater = Buildings.Media.Water "Medium model";

  parameter DesignValues datDes "Design values"
    annotation (Placement(transformation(extent={{-240,222},{-220,242}})));

  Buildings.Examples.DistrictReservoirNetworks.Agents.EnergyTransferStation proHos(redeclare
      package Medium =
               MediumWater, filNam=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Examples/DistrictReservoirNetworks/Examples/SwissHospital_20190916.mos"))
    "Prosumer hospital"
    annotation (Placement(transformation(extent={{180,-54},{220,-14}})));
  Agents.OneUTube borFieG(redeclare package Medium = MediumWater) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-50,-440})));
  Fluid.Sensors.TemperatureTwoPort          Tml1(redeclare package Medium =
        MediumWater,
    allowFlowReversal=false,
                     m_flow_nominal=datDes.mDisPip_flow_nominal,
    tau=0)           annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-80,-300})));
  Modelica.Blocks.Sources.RealExpression heatFromToBHF(y=4184*(Tml1.T - Tml5.T)
        *massFlowRateInRLTN.m_flow)
                                   "in W"
    annotation (Placement(transformation(extent={{-60,-320},{-40,-300}})));
  Pump_m_flow                                  pumpMainRLTN(
    redeclare package Medium = MediumWater,
    m_flow_nominal=datDes.mDisPip_flow_nominal)
                            "Pump"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={80,-370})));
  Networks.TJunction splSup3(
    redeclare package Medium = MediumWater,
    m_flow_nominal = datDes.mDisPip_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={80,8})));
  Networks.TJunction splSup4(
    redeclare package Medium = MediumWater,
    m_flow_nominal = datDes.mDisPip_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={80,-72})));
  Fluid.Sensors.TemperatureTwoPort          tempBeforeProsumer3(redeclare
      package Medium = MediumWater,
    allowFlowReversal=false,        m_flow_nominal=datDes.mDisPip_flow_nominal,
    tau=0)                          annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=180,
        origin={120,-32})));
  Fluid.Sensors.TemperatureTwoPort          tempAfterProsumer3(redeclare
      package Medium = MediumWater,
    allowFlowReversal=false,        m_flow_nominal=datDes.mDisPip_flow_nominal,
    tau=0)                          annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={120,-72})));
  Buildings.Fluid.Sensors.MassFlowRate massFlowRateThroughProsumer3(
      redeclare package Medium = MediumWater, allowFlowReversal=true)
    annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={100,-72})));
  Buildings.Fluid.Sensors.MassFlowRate massFlowRateInRLTN(redeclare package
      Medium = MediumWater, allowFlowReversal=true) annotation (Placement(
        transformation(
        extent={{6,6},{-6,-6}},
        rotation=180,
        origin={40,238})));
  Buildings.Examples.DistrictReservoirNetworks.Agents.EnergyTransferStation proApa(redeclare
      package Medium =
               MediumWater, filNam=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Examples/DistrictReservoirNetworks/Examples/SwissResidential_20190916.mos"))
    "Prosumer apartment"
    annotation (Placement(transformation(extent={{180,158},{220,198}})));
  Networks.TJunction splSup5(
    redeclare package Medium = MediumWater,
    m_flow_nominal = datDes.mDisPip_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={80,218})));
  Networks.TJunction splSup6(
    redeclare package Medium = MediumWater,
    m_flow_nominal = datDes.mDisPip_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={80,138})));
  Fluid.Sensors.TemperatureTwoPort          tempBeforeProsumer2(redeclare
      package Medium = MediumWater,
    allowFlowReversal=false,        m_flow_nominal=datDes.mDisPip_flow_nominal,
    tau=0)                          annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=180,
        origin={120,178})));
  Fluid.Sensors.TemperatureTwoPort          tempAfterProsumer2(redeclare
      package Medium = MediumWater,
    allowFlowReversal=false,        m_flow_nominal=datDes.mDisPip_flow_nominal,
    tau=0)                          annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={120,138})));
  Buildings.Fluid.Sensors.MassFlowRate massFlowRateThroughProsumer2(
      redeclare package Medium = MediumWater, allowFlowReversal=true)
    annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=0,
        origin={100,138})));
  Buildings.Fluid.Sensors.MassFlowRate massFlowRateBypassSFApartment(
      redeclare package Medium = MediumWater, allowFlowReversal=true)
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={80,178})));
  Buildings.Fluid.Sensors.MassFlowRate massFlowRateBypassSFRetail(redeclare
      package Medium = MediumWater, allowFlowReversal=true) annotation (
      Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=-90,
        origin={80,-32})));
  Buildings.Examples.DistrictReservoirNetworks.Agents.EnergyTransferStation proOff(redeclare
      package Medium =
               MediumWater, filNam=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Examples/DistrictReservoirNetworks/Examples/SwissOffice_20190916.mos"))
    "Prosumer office"
    annotation (Placement(transformation(extent={{-180,-40},{-220,0}})));
  Networks.TJunction splSup7(
    redeclare package Medium = MediumWater,
    m_flow_nominal = datDes.mDisPip_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-80,20})));
  Networks.TJunction splSup8(
    redeclare package Medium = MediumWater,
    m_flow_nominal = datDes.mDisPip_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-80,-60})));
  Fluid.Sensors.TemperatureTwoPort          tempBeforeProsumer1(redeclare
      package Medium = MediumWater,
    allowFlowReversal=false,        m_flow_nominal=datDes.mDisPip_flow_nominal,
    tau=0)                          annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=180,
        origin={-120,-20})));
  Fluid.Sensors.TemperatureTwoPort          tempAfterProsumer1(redeclare
      package Medium = MediumWater,
    allowFlowReversal=false,        m_flow_nominal=datDes.mDisPip_flow_nominal,
    tau=0)                          annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=180,
        origin={-120,20})));
  Buildings.Fluid.Sensors.MassFlowRate massFlowRateThroughProsumer1(
      redeclare package Medium = MediumWater, allowFlowReversal=true)
    annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=0,
        origin={-100,20})));
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
        origin={-80,-94})));
  Fluid.Sensors.TemperatureTwoPort          Tml4(redeclare package Medium =
        MediumWater,
    allowFlowReversal=false,
    m_flow_nominal=datDes.mDisPip_flow_nominal,
    tau=0)           annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=90,
        origin={80,118})));
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
        origin={0,238})));
  Networks.TJunction splSup1(
    redeclare package Medium = MediumWater,
    m_flow_nominal = datDes.mDisPip_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-80,-190})));
  Networks.TJunction splSup2(
    redeclare package Medium = MediumWater,
    m_flow_nominal = datDes.mDisPip_flow_nominal*{1,1,1},
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
  Pump_m_flow                                  pumpPrimarySidePlant(
    redeclare package Medium = MediumWater,
    final m_flow_nominal=datDes.mPla_flow_nominal,
    dp_nominal=50000)       "Pump" annotation (Placement(transformation(
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
  Pump_m_flow                                  pumpSecondarySidePlant(
    redeclare package Medium = MediumWater,
    final m_flow_nominal=datDes.mPla_flow_nominal,
    dp_nominal=50000)       "Pump" annotation (Placement(transformation(
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
  Networks.DistributionPipe res(
    redeclare package Medium = MediumWater,
    final m_flow_nominal=datDes.mDisPip_flow_nominal,
    final R=datDes.RDisPip)
                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={80,-330})));
  Networks.DistributionPipe res1(
    redeclare package Medium = MediumWater,
    final m_flow_nominal=datDes.mDisPip_flow_nominal,
    final R=datDes.RDisPip)
                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-80,-330})));
  Networks.DistributionPipe distributionPipe(
    redeclare package Medium = MediumWater,
    final m_flow_nominal=datDes.mDisPip_flow_nominal,
    final R=datDes.RDisPip)
                     annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-80,72})));
  Networks.DistributionPipe res4(
    redeclare package Medium = MediumWater,
    final m_flow_nominal=datDes.mDisPip_flow_nominal,
    final R=datDes.RDisPip)
                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={80,72})));
  Networks.SwitchBoxEnergyTransferStation switchBoxProsumerWithPumps(final
      m_flow_nominal=datDes.mDisPip_flow_nominal,                    redeclare
      package MediumInSwitch = MediumWater) annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={-150,0})));
  Networks.SwitchBoxEnergyTransferStation switchBoxProsumerWithPumps1(final
      m_flow_nominal=datDes.mDisPip_flow_nominal,
      redeclare package MediumInSwitch = MediumWater) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={150,158})));
  Networks.SwitchBoxEnergyTransferStation switchBoxProsumerWithPumps2(final
      m_flow_nominal=datDes.mDisPip_flow_nominal,
      redeclare package MediumInSwitch = MediumWater) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={150,-52})));
  Buildings.Fluid.Sensors.MassFlowRate massFlowRateThroughProsumer1AfterSB(
      redeclare package Medium = MediumWater, allowFlowReversal=true)
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={-200,32})));
  Buildings.Fluid.Sensors.MassFlowRate massFlowRateThroughProsumer2AfterSB(
      redeclare package Medium = MediumWater, allowFlowReversal=true)
    annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=0,
        origin={200,138})));
  Buildings.Fluid.Sensors.MassFlowRate massFlowRateThroughProsumer3AfterSB(
      redeclare package Medium = MediumWater, allowFlowReversal=true)
    annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=0,
        origin={200,-72})));
  Modelica.Blocks.Continuous.Integrator integrator(k=0.001*(1/3600))
    annotation (Placement(transformation(extent={{-20,-320},{0,-300}})));
  Buildings.Fluid.Sources.Boundary_pT bou(redeclare package Medium =
        MediumWater, nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={130,-350})));
  Networks.DistributionPipe res3(
    redeclare package Medium = MediumWater,
    final m_flow_nominal=datDes.mDisPip_flow_nominal,
    final R=datDes.RDisPip)
                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-80,-130})));
  Networks.DistributionPipe res5(
    redeclare package Medium = MediumWater,
    final m_flow_nominal=datDes.mDisPip_flow_nominal,
    final R=datDes.RDisPip)
                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={80,-130})));
  Networks.DistributionPipe res2(
    redeclare package Medium = MediumWater,
    final m_flow_nominal=datDes.mDisPip_flow_nominal,
    final R=datDes.RDisPip)
                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={80,-172})));
  Networks.DistributionPipe res6(
    redeclare package Medium = MediumWater,
    final m_flow_nominal=datDes.mDisPip_flow_nominal,
    final R=datDes.RDisPip)
                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={80,-210})));
  PowerMeter EPumPla(nu=2) "Plant pump power consumption"
    annotation (Placement(transformation(extent={{-154,-158},{-142,-146}})));
  PowerMeter EPumPro(nu=6)
                     "Prosumer pump power consumption"
    annotation (Placement(transformation(extent={{246,282},{258,294}})));
  PowerMeter EPumDis(nu=2) "Distribution network pump power consumption"
    annotation (Placement(transformation(extent={{106,-396},{118,-384}})));
  PowerMeter EHeaPum(nu=3)
                     "Heat pump power consumption"
    annotation (Placement(transformation(extent={{246,262},{258,274}})));
  PowerMeter EBorFieG(nu=1) "Heat from borefield"
    annotation (Placement(transformation(extent={{-86,-466},{-74,-454}})));
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
    annotation (Placement(transformation(extent={{220,-110},{200,-90}})));
  PowerMeter EProsumer3(nu=1) "Prosumer 3 power consumption"
    annotation (Placement(transformation(extent={{182,-106},{170,-94}})));
  PowerMeter ESumProsumers(nu=3) "Prosumers power consumption"
    annotation (Placement(transformation(extent={{-6,-6},{6,6}},
        rotation=0,
        origin={294,-114})));
  Modelica.Blocks.Math.MultiSum EEleTot(
    nu=2, y(unit="J", displayUnit="kWh")) "Total electrical energy"
    annotation (Placement(transformation(extent={{284,274},{296,286}})));

  Buildings.Utilities.IO.Files.Printer pri(
    samplePeriod=8760*3600,
    header="Total electricity use [J]",
    configuration=3,
    significantDigits=5)
    annotation (Placement(transformation(extent={{352,270},{372,290}})));
  Pump_m_flow                                  pumpBHS(
    redeclare package Medium = MediumWater,
    m_flow_nominal=datDes.mSto_flow_nominal)
                            "Pump" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={50,-440})));
  Networks.TJunction splSup9(
    redeclare package Medium = MediumWater,
    m_flow_nominal=datDes.mDisPip_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={80,-410})));
  Networks.TJunction splSup10(
    redeclare package Medium = MediumWater,
    m_flow_nominal=datDes.mDisPip_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-80,-410})));
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
  Agents.OneUTubeWithTough borFieTough(redeclare package Medium = MediumWater)
    annotation (Placement(transformation(extent={{-40,-470},{-60,-490}})));
  Fluid.Sensors.TemperatureTwoPort tempToBore(
    redeclare package Medium = MediumWater,
    allowFlowReversal=false,
    m_flow_nominal=datDes.mSto_flow_nominal,
    tau=0) annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=180,
        origin={20,-440})));
  Fluid.Sensors.MassFlowRate massFlowRateToBore(redeclare package Medium =
        MediumWater, allowFlowReversal=true) annotation (Placement(
        transformation(
        extent={{6,6},{-6,-6}},
        rotation=0,
        origin={0,-440})));
  Fluid.Sources.MassFlowSource_T           sou(
    redeclare package Medium = MediumWater,
    use_m_flow_in=true,
    nPorts=1,
    use_T_in=true)
              "Source"
    annotation (Placement(transformation(extent={{0,-490},{-20,-470}},
        rotation=0)));
  Fluid.Sources.Boundary_pT           sin(redeclare package Medium =
        MediumWater, nPorts=1)
              "Sink"
    annotation (Placement(transformation(extent={{-140,-490},{-120,-470}},
        rotation=0)));
  PowerMeter EBorFieTough(nu=1) "Heat from borefield"
    annotation (Placement(transformation(extent={{-86,-506},{-74,-494}})));
protected
  constant Real scaFacLoa = 10 "Scaling factor for load profiles that are read by the model";
equation
  connect(splSup3.port_3, tempBeforeProsumer3.port_a) annotation (Line(
        points={{90,8},{100,8},{100,-32},{114,-32}},     color={0,127,255}));
  connect(massFlowRateThroughProsumer3.port_a, tempAfterProsumer3.port_b)
    annotation (Line(points={{106,-72},{114,-72}},   color={0,127,255}));
  connect(massFlowRateThroughProsumer3.port_b, splSup4.port_3)
    annotation (Line(points={{94,-72},{90,-72}},    color={0,127,255}));
  connect(splSup5.port_3, tempBeforeProsumer2.port_a) annotation (Line(
        points={{90,218},{100,218},{100,178},{114,178}},
                                                       color={0,127,255}));
  connect(massFlowRateThroughProsumer2.port_a, tempAfterProsumer2.port_b)
    annotation (Line(points={{106,138},{114,138}},
                                                 color={0,127,255}));
  connect(massFlowRateThroughProsumer2.port_b, splSup6.port_3)
    annotation (Line(points={{94,138},{90,138}},color={0,127,255}));
  connect(massFlowRateBypassSFApartment.port_a, splSup5.port_2)
    annotation (Line(points={{80,184},{80,208}}, color={0,127,255}));
  connect(massFlowRateBypassSFApartment.port_b, splSup6.port_1)
    annotation (Line(points={{80,172},{80,148}},color={0,127,255}));
  connect(massFlowRateBypassSFRetail.port_a, splSup3.port_2)
    annotation (Line(points={{80,-26},{80,-2}},  color={0,127,255}));
  connect(massFlowRateBypassSFRetail.port_b, splSup4.port_1)
    annotation (Line(points={{80,-38},{80,-62}}, color={0,127,255}));
  connect(splSup8.port_2, massFlowRateBypassSFLargeOfficediv4.port_a)
    annotation (Line(points={{-80,-50},{-80,-26}},color={0,127,255}));
  connect(splSup7.port_1, massFlowRateBypassSFLargeOfficediv4.port_b)
    annotation (Line(points={{-80,10},{-80,-14}},  color={0,127,255}));
  connect(tempBeforeProsumer1.port_a, splSup8.port_3) annotation (Line(
        points={{-114,-20},{-100,-20},{-100,-60},{-90,-60}},
                                                         color={0,127,255}));
  connect(massFlowRateThroughProsumer1.port_b, splSup7.port_3)
    annotation (Line(points={{-94,20},{-90,20}},    color={0,127,255}));
  connect(massFlowRateThroughProsumer1.port_a, tempAfterProsumer1.port_b)
    annotation (Line(points={{-106,20},{-114,20}},   color={0,127,255}));
  connect(Tml2.port_b, splSup8.port_1)
    annotation (Line(points={{-80,-88},{-80,-70}},
                                                 color={0,127,255}));
  connect(Tml4.port_a, splSup6.port_2)
    annotation (Line(points={{80,124},{80,128}},
                                              color={0,127,255}));
  connect(massFlowRateInRLTN.port_b, splSup5.port_1) annotation (Line(
        points={{46,238},{80,238},{80,228}},color={0,127,255}));
  connect(Tml3.port_b, massFlowRateInRLTN.port_a)
    annotation (Line(points={{6,238},{34,238}},   color={0,127,255}));
  connect(Tml5.port_a, splSup4.port_2)
    annotation (Line(points={{80,-94},{80,-82}},   color={0,127,255}));
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
    annotation (Line(points={{80,-340},{80,-360}}, color={0,127,255}));
  connect(res1.port_b, Tml1.port_a)
    annotation (Line(points={{-80,-320},{-80,-306}}, color={0,127,255}));
  connect(distributionPipe.port_b, Tml3.port_a)
    annotation (Line(points={{-80,82},{-80,238},{-6,238}},
                                                  color={0,127,255}));
  connect(distributionPipe.port_a, splSup7.port_2) annotation (Line(points={{-80,62},
          {-80,30}},                 color={0,127,255}));
  connect(res4.port_a, Tml4.port_b)
    annotation (Line(points={{80,82},{80,112}},
                                              color={0,127,255}));
  connect(res4.port_b, splSup3.port_1)
    annotation (Line(points={{80,62},{80,18}},   color={0,127,255}));
  connect(plant.port_a1, tempBeforePlantPrimSide.port_b) annotation (Line(
        points={{-140,-250},{-140,-270},{-126,-270}}, color={0,127,255}));
  connect(tempBeforeProsumer3.port_b, switchBoxProsumerWithPumps2.port_a1)
    annotation (Line(points={{126,-32},{130,-32},{130,-47},{139.9,-47}},
        color={0,127,255}));
  connect(tempAfterProsumer3.port_a, switchBoxProsumerWithPumps2.port_b2)
    annotation (Line(points={{126,-72},{130,-72},{130,-57},{140,-57}},
        color={0,127,255}));
  connect(switchBoxProsumerWithPumps2.port_b1, proHos.port_a) annotation (Line(
        points={{160,-47},{170,-47},{170,-34},{180,-34}}, color={0,127,255}));
  connect(tempBeforeProsumer2.port_b, switchBoxProsumerWithPumps1.port_a1)
    annotation (Line(points={{126,178},{130,178},{130,163},{139.9,163}},
                                                                     color=
          {0,127,255}));
  connect(tempAfterProsumer2.port_a, switchBoxProsumerWithPumps1.port_b2)
    annotation (Line(points={{126,138},{130,138},{130,153},{140,153}},
                                                                   color={0,
          127,255}));
  connect(switchBoxProsumerWithPumps1.port_b1, proApa.port_a) annotation (Line(
        points={{160,163},{170,163},{170,178},{180,178}}, color={0,127,255}));
  connect(proApa.m_flow_HPSH, switchBoxProsumerWithPumps1.mFHPSH) annotation (
      Line(points={{220.286,168},{224,168},{224,220},{158,220},{158,169}},
        color={0,0,127}));
  connect(proApa.m_flow_HPDHW, switchBoxProsumerWithPumps1.mFHPDHW) annotation (
     Line(points={{220.286,163.714},{228,163.714},{228,224},{156,224},{156,169}},
        color={0,0,127}));
  connect(proApa.m_flow_FC, switchBoxProsumerWithPumps1.mFFC) annotation (Line(
        points={{220.286,159.429},{230,159.429},{230,228},{154,228},{154,169}},
        color={0,0,127}));
  connect(proHos.m_flow_HPSH, switchBoxProsumerWithPumps2.mFHPSH) annotation (
      Line(points={{220.286,-44},{224,-44},{224,10},{158,10},{158,-41}}, color=
          {0,0,127}));
  connect(proHos.m_flow_HPDHW, switchBoxProsumerWithPumps2.mFHPDHW) annotation (
     Line(points={{220.286,-48.2857},{226,-48.2857},{226,14},{156,14},{156,-41}},
        color={0,0,127}));
  connect(proHos.m_flow_FC, switchBoxProsumerWithPumps2.mFFC) annotation (Line(
        points={{220.286,-52.5714},{228,-52.5714},{228,18},{154,18},{154,-41}},
        color={0,0,127}));
  connect(tempBeforeProsumer1.port_b, switchBoxProsumerWithPumps.port_a1)
    annotation (Line(points={{-126,-20},{-134,-20},{-134,-5},{-139.9,-5}},
        color={0,127,255}));
  connect(tempAfterProsumer1.port_a, switchBoxProsumerWithPumps.port_b2)
    annotation (Line(points={{-126,20},{-134,20},{-134,5},{-140,5}},
        color={0,127,255}));
  connect(proOff.port_a, switchBoxProsumerWithPumps.port_b1) annotation (Line(
        points={{-180,-20},{-170,-20},{-170,-5},{-160,-5}}, color={0,127,255}));
  connect(proOff.m_flow_HPSH, switchBoxProsumerWithPumps.mFHPSH) annotation (
      Line(points={{-220.286,-30},{-224,-30},{-224,-50},{-158,-50},{-158,-11}},
        color={0,0,127}));
  connect(proOff.m_flow_HPDHW, switchBoxProsumerWithPumps.mFHPDHW) annotation (
      Line(points={{-220.286,-34.2857},{-226,-34.2857},{-226,-52},{-156,-52},{
          -156,-11}}, color={0,0,127}));
  connect(proOff.m_flow_FC, switchBoxProsumerWithPumps.mFFC) annotation (Line(
        points={{-220.286,-38.5714},{-228,-38.5714},{-228,-54},{-154,-54},{-154,
          -11}}, color={0,0,127}));
  connect(massFlowRateThroughProsumer1AfterSB.port_b,
    switchBoxProsumerWithPumps.port_a2) annotation (Line(points={{-194,32},{-170,
          32},{-170,5},{-159.9,5}},            color={0,127,255}));
  connect(massFlowRateThroughProsumer1AfterSB.port_a, proOff.port_b)
    annotation (Line(points={{-206,32},{-240,32},{-240,-20},{-219.857,-20}},
        color={0,127,255}));
  connect(massFlowRateThroughProsumer2AfterSB.port_a, proApa.port_b)
    annotation (Line(points={{206,138},{240,138},{240,178},{219.857,178}},
        color={0,127,255}));
  connect(switchBoxProsumerWithPumps1.port_a2,
    massFlowRateThroughProsumer2AfterSB.port_b) annotation (Line(points={{159.9,
          153},{170,153},{170,138},{194,138}},   color={0,127,255}));
  connect(massFlowRateThroughProsumer3AfterSB.port_a, proHos.port_b)
    annotation (Line(points={{206,-72},{240,-72},{240,-34},{219.857,-34}},
        color={0,127,255}));
  connect(massFlowRateThroughProsumer3AfterSB.port_b,
    switchBoxProsumerWithPumps2.port_a2) annotation (Line(points={{194,-72},{
          170,-72},{170,-57},{159.9,-57}},     color={0,127,255}));
  connect(heatFromToBHF.y, integrator.u)
    annotation (Line(points={{-39,-310},{-22,-310}},color={0,0,127}));
  connect(bou.ports[1], pumpMainRLTN.port_a) annotation (Line(points={{120,-350},
          {80,-350},{80,-360}}, color={0,127,255}));
  connect(res3.port_a, splSup1.port_2)
    annotation (Line(points={{-80,-140},{-80,-180}}, color={0,127,255}));
  connect(res5.port_b, Tml5.port_b)
    annotation (Line(points={{80,-120},{80,-106}}, color={0,127,255}));
  connect(res3.port_b, Tml2.port_a)
    annotation (Line(points={{-80,-120},{-80,-100}},color={0,127,255}));
  connect(res2.port_b, res5.port_a)
    annotation (Line(points={{80,-162},{80,-140}}, color={0,127,255}));
  connect(res.port_a, res6.port_a)
    annotation (Line(points={{80,-320},{80,-220}}, color={0,127,255}));
  connect(res6.port_b, res2.port_a)
    annotation (Line(points={{80,-200},{80,-182}}, color={0,127,255}));
  connect(pumpSecondarySidePlant.P, EPumPla.u[1]) annotation (Line(points={{-189,
          -199},{-189,-150},{-186,-150},{-186,-149.9},{-154,-149.9}},
                                                               color={0,0,127}));
  connect(pumpPrimarySidePlant.P, EPumPla.u[2]) annotation (Line(points={{-131,-199},
          {-131,-174},{-164,-174},{-164,-154.1},{-154,-154.1}},
                                                         color={0,0,127}));
  connect(proOff.PPum, EPumPro.u[1]) annotation (Line(points={{-220.714,8.57143},
          {-264,8.57143},{-264,291.5},{246,291.5}}, color={0,0,127}));
  connect(proApa.PPum, EPumPro.u[2]) annotation (Line(points={{220.714,206.571},
          {234,206.571},{234,290.1},{246,290.1}}, color={0,0,127}));
  connect(proHos.PPum, EPumPro.u[3]) annotation (Line(points={{220.714,-5.42857},
          {236,-5.42857},{236,288.7},{246,288.7}}, color={0,0,127}));
  connect(proOff.PCom, EHeaPum.u[1]) annotation (Line(points={{-220.714,11.4286},
          {-260,11.4286},{-260,270.8},{246,270.8}}, color={0,0,127}));
  connect(proApa.PCom, EHeaPum.u[2]) annotation (Line(points={{220.714,209.429},
          {230,209.429},{230,210},{238,210},{238,268},{246,268}}, color={0,0,
          127}));
  connect(proHos.PCom, EHeaPum.u[3]) annotation (Line(points={{220.714,-2.57143},
          {242,-2.57143},{242,265.2},{246,265.2}}, color={0,0,127}));
  connect(EPumDis.u[1], pumpMainRLTN.P)
    annotation (Line(points={{106,-387.9},{71,-387.9},{71,-381}},
                                                             color={0,0,127}));
  connect(EBorFieG.u[1], borFieG.Q_flow) annotation (Line(points={{-86,-460},{
          -100,-460},{-100,-448},{-61,-448}}, color={0,0,127}));
  connect(switchBoxProsumerWithPumps.PPum, EPumPro.u[4]) annotation (Line(
        points={{-150,10.8333},{-150,287.3},{246,287.3}},
        color={0,0,127}));
  connect(switchBoxProsumerWithPumps1.PPum, EPumPro.u[5]) annotation (Line(
        points={{150,147.167},{150,146},{164,146},{164,290},{246,290},{246,
          285.9}},                                              color={0,0,127}));
  connect(switchBoxProsumerWithPumps2.PPum, EPumPro.u[6]) annotation (Line(
        points={{150,-62.8333},{150,-76},{166,-76},{166,284.5},{246,284.5}},
        color={0,0,127}));
  connect(heatFromToPlantPrimarySide.y, EPlant.u[1])
    annotation (Line(points={{-99,-250},{-66,-250}}, color={0,0,127}));
  connect(heatFromToNetwrokProsumer1.y, EProsumer1.u[1])
    annotation (Line(points={{-159,-80},{-118,-80}}, color={0,0,127}));
  connect(EProsumer2.u[1], heatFromToNetwrokProsumer2.y) annotation (Line(
        points={{180,100},{190,100},{190,100},{199,100}}, color={0,0,127}));
  connect(EProsumer3.u[1], heatFromToNetwrokProsumer3.y)
    annotation (Line(points={{182,-100},{199,-100}}, color={0,0,127}));
  connect(heatFromToNetwrokProsumer1.y, ESumProsumers.u[1]) annotation (Line(
        points={{-159,-80},{-132,-80},{-132,-110},{288,-110},{288,-111.2}},
        color={0,0,127}));
  connect(heatFromToNetwrokProsumer3.y, ESumProsumers.u[2]) annotation (Line(
        points={{199,-100},{194,-100},{194,-114},{288,-114}},
                              color={0,0,127}));
  connect(heatFromToNetwrokProsumer2.y, ESumProsumers.u[3]) annotation (Line(
        points={{199,100},{190,100},{190,60},{276,60},{276,-118},{288,-118},{
          288,-116.8}},                                           color={0,0,
          127}));
  connect(EHeaPum.y, EEleTot.u[1]) annotation (Line(points={{259.02,268},{266,
          268},{266,282.1},{284,282.1}},
                                      color={0,0,127}));
  connect(EEleTot.y, pri.x[1])
    annotation (Line(points={{297.02,280},{350,280}}, color={0,0,127}));
  connect(res1.port_a, splSup10.port_1)
    annotation (Line(points={{-80,-340},{-80,-400}}, color={0,127,255}));
  connect(splSup10.port_2, borFieG.port_b) annotation (Line(points={{-80,-420},
          {-80,-440},{-60,-440}}, color={0,127,255}));
  connect(pumpBHS.port_a, splSup9.port_2) annotation (Line(points={{60,-440},{
          80,-440},{80,-420}}, color={0,127,255}));
  connect(splSup9.port_1, pumpMainRLTN.port_b)
    annotation (Line(points={{80,-400},{80,-380}}, color={0,127,255}));
  connect(splSup10.port_3, splSup9.port_3)
    annotation (Line(points={{-70,-410},{70,-410}}, color={0,127,255}));
  connect(pumpBHS.P, EPumDis.u[2]) annotation (Line(points={{39,-431},{18,-431},
          {18,-422},{100,-422},{100,-392.1},{106,-392.1}}, color={0,0,127}));
  connect(Tml1.T, TVio.u[1]) annotation (Line(points={{-86.6,-300},{-292,-300},
          {-292,333.36},{324,333.36}},color={0,0,127}));
  connect(Tml2.T, TVio.u[2]) annotation (Line(points={{-86.6,-94},{-282,-94},{
          -282,331.68},{324,331.68}},
                                 color={0,0,127}));
  connect(Tml3.T, TVio.u[3]) annotation (Line(points={{4.44089e-16,244.6},{
          4.44089e-16,330},{324,330}},
                           color={0,0,127}));
  connect(Tml4.T, TVio.u[4]) annotation (Line(points={{86.6,118},{304,118},{304,
          328.32},{324,328.32}}, color={0,0,127}));
  connect(Tml5.T, TVio.u[5]) annotation (Line(points={{86.6,-100},{140,-100},{
          140,-132},{310,-132},{310,326.64},{324,326.64}},
                                                       color={0,0,127}));
  connect(TVio.y, pri1.x[1])
    annotation (Line(points={{337.02,330},{350,330}}, color={0,0,127}));
  connect(EPumPro.y, EPumTot.u[1]) annotation (Line(points={{259.02,288},{266,
          288},{266,310.8},{284,310.8}}, color={0,0,127}));
  connect(EPumDis.y, EPumTot.u[2]) annotation (Line(points={{119.02,-390},{268,
          -390},{268,308},{284,308}}, color={0,0,127}));
  connect(EPumPla.y, EPumTot.u[3]) annotation (Line(points={{-140.98,-152},{
          -132,-152},{-132,-88},{-270,-88},{-270,328},{270,328},{270,305.2},{
          284,305.2}}, color={0,0,127}));
  connect(EPumTot.y, EEleTot.u[2]) annotation (Line(points={{297.02,308},{300,
          308},{300,294},{276,294},{276,277.9},{284,277.9}}, color={0,0,127}));
  connect(tempToBore.port_a, pumpBHS.port_b)
    annotation (Line(points={{26,-440},{40,-440}}, color={0,127,255}));
  connect(borFieG.port_a, massFlowRateToBore.port_b)
    annotation (Line(points={{-40,-440},{-6,-440}}, color={0,127,255}));
  connect(massFlowRateToBore.port_a, tempToBore.port_b)
    annotation (Line(points={{6,-440},{14,-440}}, color={0,127,255}));
  connect(tempToBore.T, sou.T_in) annotation (Line(points={{20,-446.6},{20,-476},
          {2,-476}}, color={0,0,127}));
  connect(massFlowRateToBore.m_flow, sou.m_flow_in) annotation (Line(points={{0,
          -446.6},{0,-460},{14,-460},{14,-472},{2,-472}}, color={0,0,127}));
  connect(sou.ports[1], borFieTough.port_a)
    annotation (Line(points={{-20,-480},{-40,-480}}, color={0,127,255}));
  connect(borFieTough.port_b, sin.ports[1])
    annotation (Line(points={{-60,-480},{-120,-480}}, color={0,127,255}));
  connect(borFieTough.Q_flow, EBorFieTough.u[1]) annotation (Line(points={{-61,
          -488},{-100,-488},{-100,-500},{-86,-500}}, color={0,0,127}));
  annotation (Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-320,-480},{380,360}})),
    experiment(StopTime=31536000, __Dymola_NumberOfIntervals=8760),
    Icon(coordinateSystem(extent={{-320,-480},{380,360}})));
end RN_BaseModel_StepCompare;

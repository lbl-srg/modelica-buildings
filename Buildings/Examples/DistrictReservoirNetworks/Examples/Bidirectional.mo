within Buildings.Examples.DistrictReservoirNetworks.Examples;
model Bidirectional "Bidirectional network"
  extends Modelica.Icons.Example;
  package MediumWater = Buildings.Media.Water "Medium model";

  parameter DesignValues datDes(
    mDisPip_flow_nominal = 50,
    RDisPip=250,
    epsPla = 0.7)
     "Design values"
    annotation (Placement(transformation(extent={{-180,280},{-160,300}})));

  Agents.BoreField borFie(redeclare package Medium = MediumWater) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={0,-320})));
  Fluid.Sensors.TemperatureTwoPort          Twp1(redeclare package Medium =
        MediumWater, m_flow_nominal=datDes.mDisPip_flow_nominal)
                     annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=90,
        origin={-160,-140})));
  Modelica.Blocks.Sources.RealExpression heatFromToBHF(y=4184*(Twp1.T - Tcp1.T)
        *massFlowRateInBHBeforeBHF.m_flow)        "in W"
    annotation (Placement(transformation(extent={{-10,-190},{10,-170}})));
  Fluid.Sensors.TemperatureTwoPort          tempBeforeProsumer3(redeclare
      package Medium = MediumWater, m_flow_nominal=datDes.mDisPip_flow_nominal)
                                    annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=180,
        origin={-120,160})));
  Fluid.Sensors.TemperatureTwoPort          tempAfterProsumer3(redeclare
      package Medium = MediumWater, m_flow_nominal=datDes.mDisPip_flow_nominal)
                                    annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=180,
        origin={60,160})));
  Buildings.Fluid.Sensors.MassFlowRate massFlowRateThroughProsumer3(
      redeclare package Medium = MediumWater, allowFlowReversal=true)
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={100,160})));
  Networks.TJunction splSup5(
    redeclare package Medium = MediumWater,
    m_flow_nominal=
      datDes.mDisPip_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-160,80})));
  Networks.TJunction splSup6(
    redeclare package Medium = MediumWater,
      m_flow_nominal = datDes.mDisPip_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={160,80})));
  Fluid.Sensors.TemperatureTwoPort          tempBeforeProsumer2(redeclare
      package Medium = MediumWater, m_flow_nominal=datDes.mDisPip_flow_nominal)
                                    annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=180,
        origin={-120,80})));
  Fluid.Sensors.TemperatureTwoPort          tempAfterProsumer2(redeclare
      package Medium = MediumWater, m_flow_nominal=datDes.mDisPip_flow_nominal)
                                    annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=180,
        origin={60,80})));
  Buildings.Fluid.Sensors.MassFlowRate massFlowRateThroughProsumer2(
      redeclare package Medium = MediumWater, allowFlowReversal=true)
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={100,80})));
  Networks.TJunction splSup7(
    redeclare package Medium = MediumWater,
      m_flow_nominal = datDes.mDisPip_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={160,0})));
  Networks.TJunction splSup8(
    redeclare package Medium = MediumWater,
      m_flow_nominal = datDes.mDisPip_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-160,0})));
  Fluid.Sensors.TemperatureTwoPort          tempBeforeProsumer1(redeclare
      package Medium = MediumWater, m_flow_nominal=datDes.mDisPip_flow_nominal)
                                    annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=180,
        origin={-120,0})));
  Fluid.Sensors.TemperatureTwoPort          tempAfterProsumer1(redeclare
      package Medium = MediumWater, m_flow_nominal=datDes.mDisPip_flow_nominal)
                                    annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=180,
        origin={60,0})));
  Buildings.Fluid.Sensors.MassFlowRate massFlowRateThroughProsumer1(
      redeclare package Medium = MediumWater, allowFlowReversal=true)
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={100,0})));
  Fluid.Sensors.TemperatureTwoPort          Twp2(redeclare package Medium =
        MediumWater, m_flow_nominal=datDes.mDisPip_flow_nominal)
                     annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=90,
        origin={-160,-52})));
  Fluid.Sensors.TemperatureTwoPort          Tcp1(redeclare package Medium =
        MediumWater, m_flow_nominal=datDes.mDisPip_flow_nominal)
                     annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={160,-140})));
  Networks.TJunction splSup1(
    redeclare package Medium = MediumWater,
      m_flow_nominal = datDes.mDisPip_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-160,-80})));
  Networks.TJunction splSup2(
    redeclare package Medium = MediumWater,
      m_flow_nominal = datDes.mDisPip_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={160,-80})));
  Buildings.Fluid.HeatExchangers.ConstantEffectiveness plant(
    redeclare package Medium1 = MediumWater,
    redeclare package Medium2 = MediumWater,
    allowFlowReversal2=false,
    final m1_flow_nominal=datDes.mPla_flow_nominal,
    final m2_flow_nominal=datDes.mPla_flow_nominal,
    show_T=true,
    dp1_nominal(displayUnit="kPa") = 50000,
    dp2_nominal(displayUnit="kPa") = 50000,
    final eps=datDes.epsPla)
                   "Heat exchanger" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={0,-86})));
  Fluid.Sensors.TemperatureTwoPort          tempBeforePlantPrimSide(
      redeclare package Medium = MediumWater,
    allowFlowReversal=false,                  m_flow_nominal=datDes.mDisPip_flow_nominal,
    tau=0)                                    annotation (Placement(
        transformation(
        extent={{-6,6},{6,-6}},
        rotation=180,
        origin={60,-80})));
  Fluid.Sensors.TemperatureTwoPort          tempAfterPlantPrimSide(
      redeclare package Medium = MediumWater,
    allowFlowReversal=false,                  m_flow_nominal=datDes.mDisPip_flow_nominal,
    tau=0)                                    annotation (Placement(
        transformation(
        extent={{-6,6},{6,-6}},
        rotation=180,
        origin={-120,-80})));
  Buildings.Fluid.Sensors.MassFlowRate massFlowRateThroughPrimSidePlant(
      redeclare package Medium = MediumWater, allowFlowReversal=true)
    annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={102,-80})));
  BaseClasses.Pump_m_flow                      pumpPrimarySidePlant(
    redeclare package Medium = MediumWater,
    final m_flow_nominal=datDes.mPla_flow_nominal,
    dp_nominal=50000)       "Pump" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-80,-80})));
  Modelica.Blocks.Sources.Constant mFlowInputPlant(final k=datDes.mPla_flow_nominal)
                                                            "kg/s"
    annotation (Placement(transformation(extent={{-32,-68},{-48,-52}})));
  Buildings.Fluid.Sources.Boundary_pT sewageSourceAtConstTemp(
    redeclare package Medium = MediumWater,
    T=290.15,
    nPorts=2) "17°C"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-150})));
  BaseClasses.Pump_m_flow                      pumpSecondarySidePlant(
    redeclare package Medium = MediumWater,
    final m_flow_nominal=datDes.mPla_flow_nominal,
    dp_nominal=50000)       "Pump" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-80,-120})));
  Fluid.Sensors.TemperatureTwoPort          tempAfterPlantSecondSide(
      redeclare package Medium = MediumWater,
    allowFlowReversal=false,                  m_flow_nominal=datDes.mDisPip_flow_nominal,
    tau=0)                                    annotation (Placement(
        transformation(
        extent={{-6,6},{6,-6}},
        rotation=180,
        origin={60,-140})));
  Modelica.Blocks.Sources.RealExpression heatFromToPlantPrimarySide(y=4184*(
        tempAfterPlantPrimSide.T - tempBeforePlantPrimSide.T)*
        massFlowRateThroughPrimSidePlant.m_flow) "in W"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  Fluid.Sensors.TemperatureTwoPort          Tcp2(redeclare package Medium =
        MediumWater, m_flow_nominal=datDes.mDisPip_flow_nominal)
                     annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=90,
        origin={160,-52})));
  Fluid.Sensors.TemperatureTwoPort          Tcp3(redeclare package Medium =
        MediumWater, m_flow_nominal=datDes.mDisPip_flow_nominal)
                     annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=90,
        origin={160,28})));
  Fluid.Sensors.TemperatureTwoPort          Twp3(redeclare package Medium =
        MediumWater, m_flow_nominal=datDes.mDisPip_flow_nominal)
                     annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=90,
        origin={-160,28})));
  Fluid.Sensors.TemperatureTwoPort          Tcp4(redeclare package Medium =
        MediumWater, m_flow_nominal=datDes.mDisPip_flow_nominal)
                     annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=90,
        origin={160,110})));
  Fluid.Sensors.TemperatureTwoPort          Twp4(redeclare package Medium =
        MediumWater, m_flow_nominal=datDes.mDisPip_flow_nominal)
                     annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=90,
        origin={-160,110})));
  Buildings.Fluid.Sensors.MassFlowRate massFlowRateInBHBeforeBHF(redeclare
      package Medium = MediumWater, allowFlowReversal=true) annotation (
      Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=0,
        origin={120,-200})));
  Agents.EnergyTransferStation proOff(
    redeclare package Medium = MediumWater,
    filNam=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Examples/DistrictReservoirNetworks/Examples/SwissOffice_20190916.mos"))
    "Prosumer office"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}})));
  Agents.EnergyTransferStation proApa(
    redeclare package Medium = MediumWater,
    filNam=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Examples/DistrictReservoirNetworks/Examples/SwissResidential_20190916.mos"))
    "Prosumer apartment"
    annotation (Placement(transformation(extent={{-20,60},{20,100}})));
  Agents.EnergyTransferStation proHos(
    redeclare package Medium = MediumWater,
    filNam=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Examples/DistrictReservoirNetworks/Examples/SwissHospital_20190916.mos"))
    "Prosumer hospital"
    annotation (Placement(transformation(extent={{-20,140},{20,180}})));
  Networks.DistributionPipe distributionPipe3(
    redeclare package Medium = MediumWater,
    m_flow_nominal=56.45,
    final R=datDes.RDisPip)
                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={160,-170})));
  Networks.DistributionPipe distributionPipe7(
    redeclare package Medium = MediumWater,
    m_flow_nominal=56.45,
    final R=datDes.RDisPip)
                     annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-160,-170})));
  Networks.DistributionPipe distributionPipe6(
    redeclare package Medium = MediumWater,
    m_flow_nominal=67.9,
    final R=datDes.RDisPip)
                     annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-160,-30})));
  Networks.DistributionPipe distributionPipe1(
    redeclare package Medium = MediumWater,
    m_flow_nominal=64.89,
    final R=datDes.RDisPip)
                     annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-160,50})));
  Networks.DistributionPipe distributionPipe(
    redeclare package Medium = MediumWater,
    m_flow_nominal=18.29,
    final R=datDes.RDisPip)
                     annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-160,130})));
  Networks.DistributionPipe distributionPipe4(
    redeclare package Medium = MediumWater,
    m_flow_nominal=64.89,
    final R=datDes.RDisPip)
                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={160,50})));
  Networks.DistributionPipe distributionPipe5(
    redeclare package Medium = MediumWater,
    m_flow_nominal=67.9,
    final R=datDes.RDisPip)
                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={160,-30})));
  Networks.SwitchBoxBorehole switchBoxBHSWithPumps(final m_flow_nominal=datDes.mSto_flow_nominal,
                                                   redeclare package
      MediumInSwitch = MediumWater)
    annotation (Placement(transformation(extent={{-12,-270},{12,-250}})));
  Networks.TJunction splSup3(
    redeclare package Medium = MediumWater,
      m_flow_nominal = datDes.mDisPip_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,-220})));
  Networks.TJunction splSup4(
    redeclare package Medium = MediumWater,
      m_flow_nominal = datDes.mDisPip_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={60,-220})));
  Buildings.Fluid.Sensors.MassFlowRate massFlowRateThroughBypassBHF(
      redeclare package Medium = MediumWater, allowFlowReversal=true)
    annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={0,-220})));
  Buildings.Fluid.Sensors.MassFlowRate massFlowRateThroughBHF(redeclare package
      Medium =         MediumWater, allowFlowReversal=true) annotation (
      Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={-40,-320})));
  BaseClasses.Pump_m_flow                      pumpBHS(
    redeclare package Medium = MediumWater,
    m_flow_nominal=datDes.mSto_flow_nominal)
                            "Pump" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={40,-320})));
  Modelica.Blocks.Math.Abs mFlowBHSOneDirection "in kg/s"
    annotation (Placement(transformation(extent={{110,-310},{90,-290}})));
  Networks.Controls.PumpMode pumpOperationMode
    annotation (Placement(transformation(extent={{90,-270},{70,-250}})));
  Modelica.Blocks.Continuous.Integrator integrator(k=0.001*(1/3600))
    annotation (Placement(transformation(extent={{32,-190},{52,-170}})));
  Buildings.Fluid.Sources.Boundary_pT bou(redeclare package Medium =
        MediumWater, nPorts=1) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-188,14})));
  Networks.DistributionPipe distributionPipe2(
    redeclare package Medium = MediumWater,
    m_flow_nominal=18.29,
    final R=datDes.RDisPip)
                     annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={160,130})));
  BaseClasses.PowerMeter
             EPumPro(nu=3)
                     "Prosumer pump power consumption"
    annotation (Placement(transformation(extent={{66,242},{78,254}})));
  BaseClasses.PowerMeter
             EHeaPum(nu=3)
                     "Heat pump power consumption"
    annotation (Placement(transformation(extent={{66,222},{78,234}})));
  BaseClasses.PowerMeter
             EPumPla(nu=2) "Plant pump power consumption"
    annotation (Placement(transformation(extent={{-84,-46},{-72,-34}})));
  BaseClasses.PowerMeter
             EPumDis(nu=2) "Distribution network pump power consumption"
    annotation (Placement(transformation(extent={{162,-286},{174,-274}})));
  BaseClasses.PowerMeter EBorFie(nu=1) "Heat from borefield"
    annotation (Placement(transformation(extent={{6,-366},{18,-354}})));
  BaseClasses.PowerMeter EPlant(nu=1) "Plant power consumption"
    annotation (Placement(transformation(extent={{54,-66},{66,-54}})));
  BaseClasses.PowerMeter EProsumer1(nu=1) "Prosumer 1 power consumption"
    annotation (Placement(transformation(extent={{96,14},{108,26}})));
  Modelica.Blocks.Sources.RealExpression heatFromToNetwrokProsumer1(y=4184*(
        tempBeforeProsumer1.T - tempAfterProsumer1.T)*
        massFlowRateThroughProsumer1.m_flow) "in W"
    annotation (Placement(transformation(extent={{50,10},{70,30}})));
  Modelica.Blocks.Sources.RealExpression heatFromToNetwrokProsumer2(y=4184*(
        tempBeforeProsumer2.T - tempAfterProsumer2.T)*
        massFlowRateThroughProsumer2.m_flow) "in W"
    annotation (Placement(transformation(extent={{52,90},{72,110}})));
  BaseClasses.PowerMeter EProsumer2(nu=1) "Prosumer 2 power consumption"
    annotation (Placement(transformation(extent={{96,94},{108,106}})));
  Modelica.Blocks.Sources.RealExpression heatFromToNetwrokProsumer3(y=4184*(
        tempBeforeProsumer3.T - tempAfterProsumer3.T)*
        massFlowRateThroughProsumer3.m_flow) "in W"
    annotation (Placement(transformation(extent={{50,170},{70,190}})));
  BaseClasses.PowerMeter EProsumer3(nu=1) "Prosumer 3 power consumption"
    annotation (Placement(transformation(extent={{94,174},{106,186}})));
  BaseClasses.PowerMeter ESumProsumers(nu=3) "Prosumers power consumption"
    annotation (Placement(transformation(extent={{136,214},{148,226}})));

  Modelica.Blocks.Math.MultiSum EEleTot(nu=2, y(unit="J", displayUnit="kWh"))
    "Total electrical energy"
    annotation (Placement(transformation(extent={{166,244},{178,256}})));
  Buildings.Utilities.IO.Files.Printer pri(
    samplePeriod=8760*3600,
    header="Total electricity use [J]",
    configuration=3,
    significantDigits=5)
    annotation (Placement(transformation(extent={{200,240},{220,260}})));
  BaseClasses.ConstraintViolation TVio(
    final uMin=datDes.TLooMin,
    final uMax=datDes.TLooMax,
    nu=8)
    "Outputs the fraction of times when the temperature constraints are violated"
    annotation (Placement(transformation(extent={{244,294},{256,306}})));
  Buildings.Utilities.IO.Files.Printer pri1(
    samplePeriod=8760*3600,
    header="Temperature constraint violation [-]",
    configuration=3,
    significantDigits=5)
    annotation (Placement(transformation(extent={{280,290},{300,310}})));
  Modelica.Blocks.Math.MultiSum EPumTot(nu=3, y(unit="J", displayUnit="kWh"))
    "Total electrical energy of pumps"
    annotation (Placement(transformation(extent={{104,254},{116,266}})));
equation
  connect(massFlowRateThroughProsumer3.port_a, tempAfterProsumer3.port_b)
    annotation (Line(points={{94,160},{66,160}}, color={0,127,255}));
  connect(splSup5.port_3, tempBeforeProsumer2.port_a)
    annotation (Line(points={{-150,80},{-126,80}}, color={0,127,255}));
  connect(massFlowRateThroughProsumer2.port_a, tempAfterProsumer2.port_b)
    annotation (Line(points={{94,80},{66,80}}, color={0,127,255}));
  connect(massFlowRateThroughProsumer2.port_b, splSup6.port_3)
    annotation (Line(points={{106,80},{150,80}}, color={0,127,255}));
  connect(massFlowRateThroughProsumer1.port_b, splSup7.port_3)
    annotation (Line(points={{106,0},{150,0}},   color={0,127,255}));
  connect(massFlowRateThroughProsumer1.port_a, tempAfterProsumer1.port_b)
    annotation (Line(points={{94,0},{66,0}},   color={0,127,255}));
  connect(pumpPrimarySidePlant.port_a, plant.port_b1)
    annotation (Line(points={{-70,-80},{-10,-80}},   color={0,127,255}));
  connect(mFlowInputPlant.y, pumpPrimarySidePlant.m_flow_in) annotation (
      Line(points={{-48.8,-60},{-80,-60},{-80,-68}},               color={0,
          0,127}));
  connect(pumpSecondarySidePlant.port_a, sewageSourceAtConstTemp.ports[1])
    annotation (Line(points={{-90,-120},{-100,-120},{-100,-140},{-2,-140}},
                                                     color={0,127,255}));
  connect(tempAfterPlantSecondSide.port_b, sewageSourceAtConstTemp.ports[2])
    annotation (Line(points={{54,-140},{2,-140}},                 color={0,
          127,255}));
  connect(tempBeforePlantPrimSide.port_a, massFlowRateThroughPrimSidePlant.port_b)
    annotation (Line(points={{66,-80},{96,-80}}, color={0,127,255}));
  connect(splSup2.port_3, massFlowRateThroughPrimSidePlant.port_a)
    annotation (Line(points={{150,-80},{108,-80}}, color={0,127,255}));
  connect(splSup8.port_3, tempBeforeProsumer1.port_a)
    annotation (Line(points={{-150,0},{-126,0}},   color={0,127,255}));
  connect(pumpPrimarySidePlant.port_b, tempAfterPlantPrimSide.port_a)
    annotation (Line(points={{-90,-80},{-114,-80}}, color={0,127,255}));
  connect(pumpSecondarySidePlant.port_b, plant.port_a2) annotation (Line(
        points={{-70,-120},{-40,-120},{-40,-92},{-10,-92}},
                                                          color={0,127,255}));
  connect(mFlowInputPlant.y, pumpSecondarySidePlant.m_flow_in) annotation (
      Line(points={{-48.8,-60},{-60,-60},{-60,-100},{-80,-100},{-80,-108}},
        color={0,0,127}));
  connect(tempAfterPlantSecondSide.port_a, plant.port_b2) annotation (Line(
        points={{66,-140},{100,-140},{100,-120},{40,-120},{40,-92},{10,-92}},
        color={0,127,255}));
  connect(Twp1.port_b, splSup1.port_1)
    annotation (Line(points={{-160,-134},{-160,-90}}, color={0,127,255}));
  connect(splSup1.port_3, tempAfterPlantPrimSide.port_b)
    annotation (Line(points={{-150,-80},{-126,-80}}, color={0,127,255}));
  connect(Tcp2.port_b, splSup2.port_2)
    annotation (Line(points={{160,-58},{160,-70}}, color={0,127,255}));
  connect(Tcp3.port_b, splSup7.port_1)
    annotation (Line(points={{160,22},{160,10}}, color={0,127,255}));
  connect(Tcp4.port_b, splSup6.port_1)
    annotation (Line(points={{160,104},{160,90}}, color={0,127,255}));
  connect(proApa.port_a, tempBeforeProsumer2.port_b)
    annotation (Line(points={{-20,80},{-114,80}}, color={0,127,255}));
  connect(proApa.port_b, tempAfterProsumer2.port_a)
    annotation (Line(points={{19.8571,80},{54,80}}, color={0,127,255}));
  connect(proHos.port_a, tempBeforeProsumer3.port_b)
    annotation (Line(points={{-20,160},{-114,160}}, color={0,127,255}));
  connect(proHos.port_b, tempAfterProsumer3.port_a)
    annotation (Line(points={{19.8571,160},{54,160}}, color={0,127,255}));
  connect(proOff.port_a, tempBeforeProsumer1.port_b)
    annotation (Line(points={{-20,0},{-114,0}}, color={0,127,255}));
  connect(proOff.port_b, tempAfterProsumer1.port_a)
    annotation (Line(points={{19.8571,0},{54,0}}, color={0,127,255}));
  connect(distributionPipe3.port_a, Tcp1.port_b)
    annotation (Line(points={{160,-160},{160,-146}}, color={0,127,255}));
  connect(distributionPipe3.port_b, massFlowRateInBHBeforeBHF.port_a)
    annotation (Line(points={{160,-180},{160,-200},{126,-200}}, color={0,127,255}));
  connect(distributionPipe7.port_b, Twp1.port_a)
    annotation (Line(points={{-160,-160},{-160,-146}}, color={0,127,255}));
  connect(splSup8.port_1, distributionPipe6.port_b)
    annotation (Line(points={{-160,-10},{-160,-20}}, color={0,127,255}));
  connect(distributionPipe6.port_a, Twp2.port_b)
    annotation (Line(points={{-160,-40},{-160,-46}}, color={0,127,255}));
  connect(Twp2.port_a, splSup1.port_2)
    annotation (Line(points={{-160,-58},{-160,-70}}, color={0,127,255}));
  connect(Twp3.port_a, splSup8.port_2)
    annotation (Line(points={{-160,22},{-160,10}}, color={0,127,255}));
  connect(Twp4.port_a, splSup5.port_2)
    annotation (Line(points={{-160,104},{-160,90}}, color={0,127,255}));
  connect(distributionPipe1.port_a, Twp3.port_b)
    annotation (Line(points={{-160,40},{-160,34}}, color={0,127,255}));
  connect(splSup5.port_1, distributionPipe1.port_b)
    annotation (Line(points={{-160,70},{-160,60}}, color={0,127,255}));
  connect(Twp4.port_b, distributionPipe.port_a)
    annotation (Line(points={{-160,116},{-160,120}}, color={0,127,255}));
  connect(distributionPipe.port_b, tempBeforeProsumer3.port_a) annotation (Line(
        points={{-160,140},{-160,160},{-126,160}}, color={0,127,255}));
  connect(splSup6.port_2, distributionPipe4.port_a)
    annotation (Line(points={{160,70},{160,60}}, color={0,127,255}));
  connect(Tcp3.port_a, distributionPipe4.port_b)
    annotation (Line(points={{160,34},{160,40}}, color={0,127,255}));
  connect(splSup7.port_2, distributionPipe5.port_a)
    annotation (Line(points={{160,-10},{160,-20}}, color={0,127,255}));
  connect(Tcp2.port_a, distributionPipe5.port_b)
    annotation (Line(points={{160,-46},{160,-40}}, color={0,127,255}));
  connect(splSup2.port_1, Tcp1.port_a)
    annotation (Line(points={{160,-90},{160,-134}}, color={0,127,255}));
  connect(plant.port_a1, tempBeforePlantPrimSide.port_b)
    annotation (Line(points={{10,-80},{54,-80}}, color={0,127,255}));
  connect(splSup4.port_1, massFlowRateInBHBeforeBHF.port_b) annotation (
      Line(points={{60,-210},{60,-200},{114,-200}}, color={0,127,255}));
  connect(distributionPipe7.port_a, splSup3.port_2) annotation (Line(points={{-160,
          -180},{-160,-200},{-60,-200},{-60,-210}}, color={0,127,255}));
  connect(massFlowRateThroughBypassBHF.port_a, splSup4.port_3)
    annotation (Line(points={{6,-220},{50,-220}}, color={0,127,255}));
  connect(massFlowRateThroughBypassBHF.port_b, splSup3.port_3)
    annotation (Line(points={{-6,-220},{-50,-220}}, color={0,127,255}));
  connect(massFlowRateThroughBHF.port_a, borFie.port_b) annotation (Line(points=
         {{-34,-320},{-22,-320},{-22,-320},{-10,-320}}, color={0,127,255}));
  connect(borFie.port_a, pumpBHS.port_b)
    annotation (Line(points={{10,-320},{30,-320}}, color={0,127,255}));
  connect(massFlowRateInBHBeforeBHF.m_flow, mFlowBHSOneDirection.u)
    annotation (Line(points={{120,-206.6},{120,-300},{112,-300}}, color={0,
          0,127}));
  connect(mFlowBHSOneDirection.y, pumpBHS.m_flow_in) annotation (Line(
        points={{89,-300},{40,-300},{40,-308}}, color={0,0,127}));
  connect(massFlowRateInBHBeforeBHF.m_flow, pumpOperationMode.massFlowInBN)
    annotation (Line(points={{120,-206.6},{120,-260},{92,-260}},   color={0,
          0,127}));
  connect(massFlowRateThroughBHF.port_b, switchBoxBHSWithPumps.port_a1)
    annotation (Line(points={{-46,-320},{-60,-320},{-60,-280},{-6,-280},{-6,
          -270.1}}, color={0,127,255}));
  connect(pumpBHS.port_a, switchBoxBHSWithPumps.port_b2) annotation (Line(
        points={{50,-320},{60,-320},{60,-280},{6,-280},{6,-270}}, color={0,
          127,255}));
  connect(switchBoxBHSWithPumps.port_a2, splSup4.port_2) annotation (Line(
        points={{6,-250.1},{6,-240},{60,-240},{60,-230}}, color={0,127,255}));
  connect(switchBoxBHSWithPumps.port_b1, splSup3.port_1) annotation (Line(
        points={{-6,-250},{-6,-240},{-60,-240},{-60,-230}}, color={0,127,
          255}));
  connect(pumpOperationMode.massFlowPumps, switchBoxBHSWithPumps.massFlow)
    annotation (Line(points={{69,-260},{20,-260},{20,-236},{-20,-236},{-20,-260},
          {-12.6,-260}},           color={0,0,127}));
  connect(heatFromToBHF.y, integrator.u)
    annotation (Line(points={{11,-180},{30,-180}}, color={0,0,127}));
  connect(bou.ports[1], splSup8.port_2) annotation (Line(points={{-178,14},{-170,
          14},{-170,10},{-160,10}},      color={0,127,255}));
  connect(Tcp4.port_a, distributionPipe2.port_b)
    annotation (Line(points={{160,116},{160,120}}, color={0,127,255}));
  connect(distributionPipe2.port_a, massFlowRateThroughProsumer3.port_b)
    annotation (Line(points={{160,140},{160,160},{106,160}}, color={0,127,255}));
  connect(pumpPrimarySidePlant.P, EPumPla.u[1]) annotation (Line(points={{-91,-71},
          {-94,-71},{-94,-37.9},{-84,-37.9}}, color={0,0,127}));
  connect(pumpSecondarySidePlant.P, EPumPla.u[2]) annotation (Line(points={{-69,
          -111},{-64,-111},{-64,-102},{-96,-102},{-96,-42.1},{-84,-42.1}},
        color={0,0,127}));
  connect(pumpBHS.P, EPumDis.u[1]) annotation (Line(points={{29,-311},{20,-311},
          {20,-282},{140,-282},{140,-277.9},{162,-277.9}}, color={0,0,127}));
  connect(switchBoxBHSWithPumps.PPum, EPumDis.u[2]) annotation (Line(points={{13,-260},
          {16,-260},{16,-278},{142,-278},{142,-282.1},{162,-282.1}},
        color={0,0,127}));
  connect(proHos.PCom, EHeaPum.u[1]) annotation (Line(points={{20.7143,191.429},
          {40,191.429},{40,230.8},{66,230.8}}, color={0,0,127}));
  connect(proApa.PCom, EHeaPum.u[2]) annotation (Line(points={{20.7143,111.429},
          {42,111.429},{42,228},{66,228}}, color={0,0,127}));
  connect(proOff.PCom, EHeaPum.u[3]) annotation (Line(points={{20.7143,31.4286},
          {44,31.4286},{44,225.2},{66,225.2}}, color={0,0,127}));
  connect(proHos.PPum, EPumPro.u[1]) annotation (Line(points={{20.7143,188.571},
          {24,188.571},{24,250.8},{66,250.8}}, color={0,0,127}));
  connect(proApa.PPum, EPumPro.u[2]) annotation (Line(points={{20.7143,108.571},
          {26,108.571},{26,248},{66,248}}, color={0,0,127}));
  connect(proOff.PPum, EPumPro.u[3]) annotation (Line(points={{20.7143,28.5714},
          {28,28.5714},{28,245.2},{66,245.2}}, color={0,0,127}));
  connect(EBorFie.u[1], borFie.Q_flow) annotation (Line(points={{6,-360},{-20,
          -360},{-20,-328},{-11,-328}}, color={0,0,127}));
  connect(heatFromToPlantPrimarySide.y, EPlant.u[1])
    annotation (Line(points={{41,-60},{54,-60}}, color={0,0,127}));
  connect(heatFromToNetwrokProsumer1.y, EProsumer1.u[1]) annotation (Line(
        points={{71,20},{84,20},{84,20},{96,20}}, color={0,0,127}));
  connect(heatFromToNetwrokProsumer2.y, EProsumer2.u[1])
    annotation (Line(points={{73,100},{96,100}}, color={0,0,127}));
  connect(heatFromToNetwrokProsumer3.y, EProsumer3.u[1])
    annotation (Line(points={{71,180},{94,180}}, color={0,0,127}));
  connect(heatFromToNetwrokProsumer3.y, ESumProsumers.u[1]) annotation (Line(
        points={{71,180},{76,180},{76,182},{82,182},{82,212},{110,212},{110,
          222.8},{136,222.8}}, color={0,0,127}));
  connect(heatFromToNetwrokProsumer2.y, ESumProsumers.u[2]) annotation (Line(
        points={{73,100},{73,120},{100,120},{100,140},{112,140},{112,220},{136,
          220}}, color={0,0,127}));
  connect(heatFromToNetwrokProsumer1.y, ESumProsumers.u[3]) annotation (Line(
        points={{71,20},{71,44},{118,44},{118,218},{136,218},{136,217.2}},
        color={0,0,127}));
  connect(EHeaPum.y, EEleTot.u[1]) annotation (Line(points={{79.02,228},{122,
          228},{122,252.1},{166,252.1}},
                                      color={0,0,127}));
  connect(EEleTot.y, pri.x[1])
    annotation (Line(points={{179.02,250},{198,250}}, color={0,0,127}));
  connect(tempBeforeProsumer3.T, TVio.u[1]) annotation (Line(points={{-120,166.6},
          {-120,300},{244,300},{244,303.675}}, color={0,0,127}));
  connect(Twp3.T, TVio.u[2]) annotation (Line(points={{-153.4,28},{-140,28},{-140,
          302.625},{244,302.625}}, color={0,0,127}));
  connect(Twp2.T, TVio.u[3]) annotation (Line(points={{-153.4,-52},{-136,-52},{-136,
          301.575},{244,301.575}}, color={0,0,127}));
  connect(Twp1.T, TVio.u[4]) annotation (Line(points={{-153.4,-140},{-134,-140},
          {-134,300.525},{244,300.525}}, color={0,0,127}));
  connect(Tcp4.T, TVio.u[5]) annotation (Line(points={{166.6,110},{228,110},{228,
          299.475},{244,299.475}}, color={0,0,127}));
  connect(Tcp3.T, TVio.u[6]) annotation (Line(points={{166.6,28},{232,28},{232,298.425},
          {244,298.425}}, color={0,0,127}));
  connect(Tcp2.T, TVio.u[7]) annotation (Line(points={{166.6,-52},{234,-52},{234,
          297.375},{244,297.375}}, color={0,0,127}));
  connect(Tcp1.T, TVio.u[8]) annotation (Line(points={{166.6,-140},{238,-140},{238,
          296},{244,296},{244,296.325}}, color={0,0,127}));
  connect(TVio.y, pri1.x[1])
    annotation (Line(points={{257.02,300},{278,300}}, color={0,0,127}));
  connect(EPumPro.y, EPumTot.u[1]) annotation (Line(points={{79.02,248},{92,248},
          {92,262.8},{104,262.8}}, color={0,0,127}));
  connect(EPumPla.y, EPumTot.u[2]) annotation (Line(points={{-70.98,-40},{-52,
          -40},{-52,260},{104,260}}, color={0,0,127}));
  connect(EPumDis.y, EPumTot.u[3]) annotation (Line(points={{175.02,-280},{190,
          -280},{190,240},{100,240},{100,257.2},{104,257.2}}, color={0,0,127}));
  connect(EPumTot.y, EEleTot.u[2]) annotation (Line(points={{117.02,260},{142,
          260},{142,247.9},{166,247.9}}, color={0,0,127}));
  annotation (Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-380},{320,320}})),
        __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Examples/DistrictReservoirNetworks/Examples/Bidirectional.mos"
        "Simulate and plot"),
    experiment(
      StopTime=31536000,
      __Dymola_NumberOfIntervals=8760,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"));
end Bidirectional;

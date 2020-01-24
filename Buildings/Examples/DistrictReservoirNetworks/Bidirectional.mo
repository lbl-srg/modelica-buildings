within Buildings.Examples.DistrictReservoirNetworks;
model Bidirectional "Bidirectional network"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water "Medium model";

  parameter Buildings.Examples.DistrictReservoirNetworks.DesignValues datDes(
    mDisPip_flow_nominal = 50,
    RDisPip=250,
    epsPla = 0.7)
     "Design values"
    annotation (Placement(transformation(extent={{-180,280},{-160,300}})));

   Buildings.Examples.DistrictReservoirNetworks.BaseClasses.Agents.BoreField borFie(
     redeclare package Medium = Medium)
     "Bore field" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={0,-320})));
  Fluid.Sensors.TemperatureTwoPort Twp1(redeclare package Medium =
        Medium, m_flow_nominal=datDes.mDisPip_flow_nominal)
    "Temperature sensor in distribution pipe"
                     annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=90,
        origin={-160,-140})));
  BaseClasses.Networks.TJunction splSup5(
    redeclare package Medium = Medium,
    m_flow_nominal=
      datDes.mDisPip_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-160,80})));
  BaseClasses.Networks.TJunction splSup6(
    redeclare package Medium = Medium,
      m_flow_nominal = datDes.mDisPip_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={160,80})));
  BaseClasses.Networks.TJunction splSup7(
    redeclare package Medium = Medium,
      m_flow_nominal = datDes.mDisPip_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={160,0})));
  BaseClasses.Networks.TJunction splSup8(
    redeclare package Medium = Medium,
      m_flow_nominal = datDes.mDisPip_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-160,0})));
  Fluid.Sensors.TemperatureTwoPort Twp2(redeclare package Medium =
        Medium, m_flow_nominal=datDes.mDisPip_flow_nominal)
    "Temperature sensor in distribution pipe"
                     annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=90,
        origin={-160,-52})));
  Fluid.Sensors.TemperatureTwoPort Tcp1(redeclare package Medium =
        Medium, m_flow_nominal=datDes.mDisPip_flow_nominal)
    "Temperature sensor in distribution pipe"
                     annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={160,-140})));
  BaseClasses.Networks.TJunction splSup1(
    redeclare package Medium = Medium,
      m_flow_nominal = datDes.mDisPip_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-160,-80})));
  BaseClasses.Networks.TJunction splSup2(
    redeclare package Medium = Medium,
      m_flow_nominal = datDes.mDisPip_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={160,-80})));
  Buildings.Fluid.HeatExchangers.ConstantEffectiveness plant(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
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
  Fluid.Sensors.EnthalpyFlowRate senEntFloPlaIn(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=datDes.mDisPip_flow_nominal,
    tau=0) "Enthalpy flow rate at plant inlet" annotation (Placement(
        transformation(
        extent={{-6,6},{6,-6}},
        rotation=180,
        origin={40,-80})));
  Fluid.Sensors.EnthalpyFlowRate senEntPlaOut(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=datDes.mDisPip_flow_nominal,
    tau=0) "Enthalpy flow rate at plant outlet" annotation (Placement(
        transformation(
        extent={{-6,6},{6,-6}},
        rotation=180,
        origin={-120,-80})));
  BaseClasses.Pump_m_flow pumPlaPri(
    redeclare package Medium = Medium,
    final m_flow_nominal=datDes.mPla_flow_nominal,
    dp_nominal=50000) "Pump plant primary side" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-80,-80})));
  Modelica.Blocks.Sources.Constant mSetPla_flow(final k=datDes.mPla_flow_nominal)
    "Set point for mass flow rate of plant"
    annotation (Placement(transformation(extent={{-32,-74},{-48,-58}})));
  Buildings.Fluid.Sources.Boundary_pT sewBouCon(
    redeclare package Medium = Medium,
    T=290.15,
    nPorts=2) "Boundary condition for sewage source" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-150})));
  BaseClasses.Pump_m_flow pumPlaSec(
    redeclare package Medium = Medium,
    final m_flow_nominal=datDes.mPla_flow_nominal,
    dp_nominal=50000) "Pump plant secondary side" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-80,-120})));
  Fluid.Sensors.TemperatureTwoPort Tcp2(redeclare package Medium =
        Medium, m_flow_nominal=datDes.mDisPip_flow_nominal)
    "Temperature sensor in distribution pipe"
                     annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=90,
        origin={160,-52})));
  Fluid.Sensors.TemperatureTwoPort Tcp3(redeclare package Medium =
        Medium, m_flow_nominal=datDes.mDisPip_flow_nominal)
    "Temperature sensor in distribution pipe"
                     annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=90,
        origin={160,28})));
  Fluid.Sensors.TemperatureTwoPort Twp3(redeclare package Medium =
        Medium, m_flow_nominal=datDes.mDisPip_flow_nominal)
    "Temperature sensor in distribution pipe"
                     annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=90,
        origin={-160,28})));
  Fluid.Sensors.TemperatureTwoPort Tcp4(redeclare package Medium =
        Medium, m_flow_nominal=datDes.mDisPip_flow_nominal)
    "Temperature sensor in distribution pipe"
                     annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=90,
        origin={160,110})));
  Fluid.Sensors.TemperatureTwoPort Twp4(redeclare package Medium =
        Medium, m_flow_nominal=datDes.mDisPip_flow_nominal)
    "Temperature sensor in distribution pipe"
                     annotation (Placement(transformation(
        extent={{-6,6},{6,-6}},
        rotation=90,
        origin={-160,110})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFloPriBor(redeclare package Medium =
        Medium, allowFlowReversal=true)
    "Mass flow rate sensor upstream of borefield" annotation (Placement(
        transformation(
        extent={{6,6},{-6,-6}},
        rotation=0,
        origin={120,-200})));
  BaseClasses.Agents.EnergyTransferStation proOff(
    redeclare package Medium = Medium,
    filNam=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Examples/DistrictReservoirNetworks/Examples/SwissOffice_20190916.mos"))
    "Prosumer office"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}})));
  BaseClasses.Agents.EnergyTransferStation proApa(
    redeclare package Medium = Medium,
    filNam=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Examples/DistrictReservoirNetworks/Examples/SwissResidential_20190916.mos"))
    "Prosumer apartment"
    annotation (Placement(transformation(extent={{-20,60},{20,100}})));
  BaseClasses.Agents.EnergyTransferStation proHos(
    redeclare package Medium = Medium,
    filNam=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Examples/DistrictReservoirNetworks/Examples/SwissHospital_20190916.mos"))
    "Prosumer hospital"
    annotation (Placement(transformation(extent={{-20,140},{20,180}})));
  BaseClasses.Networks.DistributionPipe disPip8(
    redeclare package Medium = Medium,
    m_flow_nominal=56.45,
    final R=datDes.RDisPip) "Distribution pipe" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={160,-170})));
  BaseClasses.Networks.DistributionPipe disPip7(
    redeclare package Medium = Medium,
    m_flow_nominal=56.45,
    final R=datDes.RDisPip) "Distribution pipe" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-160,-170})));
  BaseClasses.Networks.DistributionPipe disPip5(
    redeclare package Medium = Medium,
    m_flow_nominal=67.9,
    final R=datDes.RDisPip) "Distribution pipe" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-160,-30})));
  BaseClasses.Networks.DistributionPipe disPip3(
    redeclare package Medium = Medium,
    m_flow_nominal=64.89,
    final R=datDes.RDisPip) "Distribution pipe" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-160,50})));
  BaseClasses.Networks.DistributionPipe disPip1(
    redeclare package Medium = Medium,
    m_flow_nominal=18.29,
    final R=datDes.RDisPip) "Distribution pipe" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-160,130})));
  BaseClasses.Networks.DistributionPipe disPip4(
    redeclare package Medium = Medium,
    m_flow_nominal=64.89,
    final R=datDes.RDisPip) "Distribution pipe" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={160,50})));
  BaseClasses.Networks.DistributionPipe disPip6(
    redeclare package Medium = Medium,
    m_flow_nominal=67.9,
    final R=datDes.RDisPip) "Distribution pipe" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={160,-30})));
  BaseClasses.Networks.SwitchBoxBorehole swiBoxBorFie(final m_flow_nominal=datDes.mSto_flow_nominal,
      redeclare package Medium = Medium)
    "Flow switch box at borefield"
    annotation (Placement(transformation(extent={{-12,-270},{12,-250}})));
  BaseClasses.Networks.TJunction splSup3(
    redeclare package Medium = Medium,
      m_flow_nominal = datDes.mDisPip_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,-220})));
  BaseClasses.Networks.TJunction splSup4(
    redeclare package Medium = Medium,
      m_flow_nominal = datDes.mDisPip_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={60,-220})));
  Buildings.Fluid.Sensors.MassFlowRate senBorFieByPas(redeclare package Medium =
        Medium, allowFlowReversal=true) "Mass flow rate through bypass"
    annotation (Placement(transformation(
        extent={{6,-6},{-6,6}},
        rotation=0,
        origin={0,-220})));
  BaseClasses.Pump_m_flow                      pumpBHS(
    redeclare package Medium = Medium,
    m_flow_nominal=datDes.mSto_flow_nominal)
                            "Pump" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={40,-320})));
  Modelica.Blocks.Math.Abs conBorFiePum "Controller for borefield pump"
    annotation (Placement(transformation(extent={{110,-310},{90,-290}})));
  BaseClasses.Networks.Controls.PumpMode conPumMod "Controller for pump mode"
    annotation (Placement(transformation(extent={{90,-270},{70,-250}})));
  Buildings.Fluid.Sources.Boundary_pT bou(redeclare package Medium =
        Medium, nPorts=1) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-188,14})));
  BaseClasses.Networks.DistributionPipe disPip2(
    redeclare package Medium = Medium,
    m_flow_nominal=18.29,
    final R=datDes.RDisPip) "Distribution pipe" annotation (Placement(
        transformation(
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
    annotation (Placement(transformation(extent={{-86,-28},{-74,-16}})));
  BaseClasses.PowerMeter
             EPumDis(nu=2) "Distribution network pump power consumption"
    annotation (Placement(transformation(extent={{162,-286},{174,-274}})));
  BaseClasses.PowerMeter EBorFie(nu=1) "Heat from borefield"
    annotation (Placement(transformation(extent={{-28,-334},{-40,-322}})));
  BaseClasses.PowerMeter EPlant(nu=2) "Plant heat input into the district loop"
    annotation (Placement(transformation(extent={{102,-56},{116,-42}})));
  BaseClasses.PowerMeter EProsumer1(nu=1) "Prosumer 1 power consumption"
    annotation (Placement(transformation(extent={{94,20},{106,32}})));
  BaseClasses.PowerMeter EProsumer2(nu=1) "Prosumer 2 power consumption"
    annotation (Placement(transformation(extent={{94,100},{106,112}})));
  BaseClasses.PowerMeter EProsumer3(nu=1) "Prosumer 3 power consumption"
    annotation (Placement(transformation(extent={{94,180},{106,192}})));
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
  BaseClasses.PowerMeter EFroBorFie2(nu=2) "Energy from borefield"
    annotation (Placement(transformation(extent={{94,-186},{106,-174}})));
  Fluid.Sensors.EnthalpyFlowRate senEntBorOut(redeclare package Medium =
        Medium, m_flow_nominal=datDes.mDisPip_flow_nominal)
    "Enthalpy flow rate at borefield outlet" annotation (Placement(
        transformation(
        extent={{-6,6},{6,-6}},
        rotation=180,
        origin={-120,-200})));
  Fluid.Sensors.EnthalpyFlowRate senEntBorIn(redeclare package Medium =
        Medium, m_flow_nominal=datDes.mDisPip_flow_nominal)
    "Enthalpy flow rate at borefield inlet" annotation (Placement(
        transformation(
        extent={{6,6},{-6,-6}},
        rotation=180,
        origin={80,-200})));
protected
  Modelica.Blocks.Math.Gain gaiEntFlo(k=-1)
    "Gain to switch sign of enthalpy flow rate"
    annotation (Placement(transformation(extent={{68,-72},{88,-52}})));
equation
  connect(pumPlaPri.port_a, plant.port_b1)
    annotation (Line(points={{-70,-80},{-10,-80}}, color={0,127,255}));
  connect(mSetPla_flow.y, pumPlaPri.m_flow_in) annotation (Line(points={{-48.8,
          -66},{-80,-66},{-80,-68}}, color={0,0,127}));
  connect(pumPlaSec.port_a, sewBouCon.ports[1]) annotation (Line(points={{-90,
          -120},{-100,-120},{-100,-140},{-2,-140}},
                                              color={0,127,255}));
  connect(pumPlaPri.port_b, senEntPlaOut.port_a)
    annotation (Line(points={{-90,-80},{-114,-80}}, color={0,127,255}));
  connect(pumPlaSec.port_b, plant.port_a2) annotation (Line(points={{-70,-120},
          {-40,-120},{-40,-92},{-10,-92}}, color={0,127,255}));
  connect(mSetPla_flow.y, pumPlaSec.m_flow_in) annotation (Line(points={{-48.8,
          -66},{-60,-66},{-60,-100},{-80,-100},{-80,-108}}, color={0,0,127}));
  connect(Twp1.port_b, splSup1.port_1)
    annotation (Line(points={{-160,-134},{-160,-90}}, color={0,127,255}));
  connect(splSup1.port_3, senEntPlaOut.port_b)
    annotation (Line(points={{-150,-80},{-126,-80}}, color={0,127,255}));
  connect(Tcp2.port_b, splSup2.port_2)
    annotation (Line(points={{160,-58},{160,-70}}, color={0,127,255}));
  connect(Tcp3.port_b, splSup7.port_1)
    annotation (Line(points={{160,22},{160,10}}, color={0,127,255}));
  connect(Tcp4.port_b, splSup6.port_1)
    annotation (Line(points={{160,104},{160,90}}, color={0,127,255}));
  connect(disPip8.port_a, Tcp1.port_b)
    annotation (Line(points={{160,-160},{160,-146}}, color={0,127,255}));
  connect(disPip8.port_b, senMasFloPriBor.port_a) annotation (Line(points={{160,
          -180},{160,-200},{126,-200}}, color={0,127,255}));
  connect(disPip7.port_b, Twp1.port_a)
    annotation (Line(points={{-160,-160},{-160,-146}}, color={0,127,255}));
  connect(splSup8.port_1, disPip5.port_b)
    annotation (Line(points={{-160,-10},{-160,-20}}, color={0,127,255}));
  connect(disPip5.port_a, Twp2.port_b)
    annotation (Line(points={{-160,-40},{-160,-46}}, color={0,127,255}));
  connect(Twp2.port_a, splSup1.port_2)
    annotation (Line(points={{-160,-58},{-160,-70}}, color={0,127,255}));
  connect(Twp3.port_a, splSup8.port_2)
    annotation (Line(points={{-160,22},{-160,10}}, color={0,127,255}));
  connect(Twp4.port_a, splSup5.port_2)
    annotation (Line(points={{-160,104},{-160,90}}, color={0,127,255}));
  connect(disPip3.port_a, Twp3.port_b)
    annotation (Line(points={{-160,40},{-160,34}}, color={0,127,255}));
  connect(splSup5.port_1, disPip3.port_b)
    annotation (Line(points={{-160,70},{-160,60}}, color={0,127,255}));
  connect(Twp4.port_b, disPip1.port_a)
    annotation (Line(points={{-160,116},{-160,120}}, color={0,127,255}));
  connect(splSup6.port_2, disPip4.port_a)
    annotation (Line(points={{160,70},{160,60}}, color={0,127,255}));
  connect(Tcp3.port_a, disPip4.port_b)
    annotation (Line(points={{160,34},{160,40}}, color={0,127,255}));
  connect(splSup7.port_2, disPip6.port_a)
    annotation (Line(points={{160,-10},{160,-20}}, color={0,127,255}));
  connect(Tcp2.port_a, disPip6.port_b)
    annotation (Line(points={{160,-46},{160,-40}}, color={0,127,255}));
  connect(splSup2.port_1, Tcp1.port_a)
    annotation (Line(points={{160,-90},{160,-134}}, color={0,127,255}));
  connect(plant.port_a1, senEntFloPlaIn.port_b)
    annotation (Line(points={{10,-80},{34,-80}}, color={0,127,255}));
  connect(senBorFieByPas.port_a, splSup4.port_3)
    annotation (Line(points={{6,-220},{50,-220}}, color={0,127,255}));
  connect(senBorFieByPas.port_b, splSup3.port_3)
    annotation (Line(points={{-6,-220},{-50,-220}}, color={0,127,255}));
  connect(borFie.port_a, pumpBHS.port_b)
    annotation (Line(points={{10,-320},{30,-320}}, color={0,127,255}));
  connect(senMasFloPriBor.m_flow, conBorFiePum.u) annotation (Line(points={{120,
          -206.6},{120,-300},{112,-300}}, color={0,0,127}));
  connect(conBorFiePum.y, pumpBHS.m_flow_in)
    annotation (Line(points={{89,-300},{40,-300},{40,-308}}, color={0,0,127}));
  connect(senMasFloPriBor.m_flow, conPumMod.mBorFie_flow) annotation (Line(
        points={{120,-206.6},{120,-260},{92,-260}}, color={0,0,127}));
  connect(pumpBHS.port_a, swiBoxBorFie.port_b2) annotation (Line(points={{50,
          -320},{60,-320},{60,-292},{6,-292},{6,-270}}, color={0,127,255}));
  connect(swiBoxBorFie.port_a2, splSup4.port_2) annotation (Line(points={{6,-250.1},
          {6,-240},{60,-240},{60,-230}}, color={0,127,255}));
  connect(swiBoxBorFie.port_b1, splSup3.port_1) annotation (Line(points={{-6,-250},
          {-6,-240},{-60,-240},{-60,-230}}, color={0,127,255}));
  connect(conPumMod.mPum_flow, swiBoxBorFie.massFlow) annotation (Line(points={
          {69,-260},{40,-260},{40,-236},{-20,-236},{-20,-260},{-14,-260}},
        color={0,0,127}));
  connect(bou.ports[1], splSup8.port_2) annotation (Line(points={{-178,14},{-170,
          14},{-170,10},{-160,10}},      color={0,127,255}));
  connect(Tcp4.port_a, disPip2.port_b)
    annotation (Line(points={{160,116},{160,120}}, color={0,127,255}));
  connect(pumPlaPri.P, EPumPla.u[1]) annotation (Line(points={{-91,-71},{-94,-71},
          {-94,-19.9},{-86,-19.9}}, color={0,0,127}));
  connect(pumPlaSec.P, EPumPla.u[2]) annotation (Line(points={{-69,-111},{-64,-111},
          {-64,-102},{-96,-102},{-96,-24.1},{-86,-24.1}}, color={0,0,127}));
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
  connect(EBorFie.u[1], borFie.Q_flow) annotation (Line(points={{-28,-328},{-11,
          -328}},                       color={0,0,127}));
  connect(EHeaPum.y, EEleTot.u[1]) annotation (Line(points={{79.02,228},{122,
          228},{122,252.1},{166,252.1}},
                                      color={0,0,127}));
  connect(EEleTot.y, pri.x[1])
    annotation (Line(points={{179.02,250},{198,250}}, color={0,0,127}));
  connect(Twp3.T, TVio.u[1]) annotation (Line(points={{-153.4,28},{-140,28},{
          -140,303.675},{244,303.675}},
                                   color={0,0,127}));
  connect(Twp2.T, TVio.u[2]) annotation (Line(points={{-153.4,-52},{-136,-52},{
          -136,302.625},{244,302.625}},
                                   color={0,0,127}));
  connect(Twp1.T, TVio.u[3]) annotation (Line(points={{-153.4,-140},{-134,-140},
          {-134,301.575},{244,301.575}}, color={0,0,127}));
  connect(Tcp4.T, TVio.u[4]) annotation (Line(points={{166.6,110},{228,110},{
          228,300.525},{244,300.525}},
                                   color={0,0,127}));
  connect(Tcp3.T, TVio.u[5]) annotation (Line(points={{166.6,28},{232,28},{232,
          299.475},{244,299.475}},
                          color={0,0,127}));
  connect(Tcp2.T, TVio.u[6]) annotation (Line(points={{166.6,-52},{234,-52},{
          234,298.425},{244,298.425}},
                                   color={0,0,127}));
  connect(Tcp1.T, TVio.u[7]) annotation (Line(points={{166.6,-140},{238,-140},{
          238,296},{244,296},{244,297.375}},
                                         color={0,0,127}));
  connect(TVio.y, pri1.x[1])
    annotation (Line(points={{257.02,300},{278,300}}, color={0,0,127}));
  connect(EPumPro.y, EPumTot.u[1]) annotation (Line(points={{79.02,248},{92,248},
          {92,262.8},{104,262.8}}, color={0,0,127}));
  connect(EPumPla.y, EPumTot.u[2]) annotation (Line(points={{-72.98,-22},{-52,
          -22},{-52,260},{104,260}}, color={0,0,127}));
  connect(EPumDis.y, EPumTot.u[3]) annotation (Line(points={{175.02,-280},{190,
          -280},{190,240},{100,240},{100,257.2},{104,257.2}}, color={0,0,127}));
  connect(EPumTot.y, EEleTot.u[2]) annotation (Line(points={{117.02,260},{142,
          260},{142,247.9},{166,247.9}}, color={0,0,127}));
  connect(Twp4.T, TVio.u[8]) annotation (Line(points={{-153.4,110},{-144,110},{
          -144,296.325},{244,296.325}}, color={0,0,127}));
  connect(proHos.QPro, EProsumer3.u[1]) annotation (Line(points={{20.7143,
          185.714},{82.3572,185.714},{82.3572,186},{94,186}}, color={0,0,127}));
  connect(proHos.QPro, ESumProsumers.u[1]) annotation (Line(points={{20.7143,
          185.714},{82,185.714},{82,222.8},{136,222.8}}, color={0,0,127}));
  connect(proApa.QPro, ESumProsumers.u[2]) annotation (Line(points={{20.7143,
          105.714},{84,105.714},{84,220},{136,220}}, color={0,0,127}));
  connect(proOff.QPro, ESumProsumers.u[3]) annotation (Line(points={{20.7143,
          25.7143},{46,25.7143},{46,217.2},{136,217.2}}, color={0,0,127}));
  connect(proApa.QPro, EProsumer2.u[1]) annotation (Line(points={{20.7143,
          105.714},{88,105.714},{88,106},{94,106}}, color={0,0,127}));
  connect(proOff.QPro, EProsumer1.u[1]) annotation (Line(points={{20.7143,
          25.7143},{58.3572,25.7143},{58.3572,26},{94,26}}, color={0,0,127}));
  connect(proHos.port_b, disPip2.port_a) annotation (Line(points={{19.8571,160},
          {160,160},{160,140}}, color={0,127,255}));
  connect(proApa.port_b, splSup6.port_3)
    annotation (Line(points={{19.8571,80},{150,80}}, color={0,127,255}));
  connect(splSup7.port_3, proOff.port_b)
    annotation (Line(points={{150,0},{19.8571,0}}, color={0,127,255}));
  connect(splSup8.port_3, proOff.port_a)
    annotation (Line(points={{-150,0},{-20,0}}, color={0,127,255}));
  connect(splSup5.port_3, proApa.port_a)
    annotation (Line(points={{-150,80},{-20,80}}, color={0,127,255}));
  connect(disPip1.port_b, proHos.port_a) annotation (Line(points={{-160,140},{
          -160,160},{-20,160}}, color={0,127,255}));
  connect(disPip7.port_a, senEntBorOut.port_b) annotation (Line(points={{-160,
          -180},{-160,-200},{-126,-200}}, color={0,127,255}));
  connect(senEntBorOut.port_a, splSup3.port_2) annotation (Line(points={{-114,
          -200},{-60,-200},{-60,-210}}, color={0,127,255}));
  connect(senMasFloPriBor.port_b, senEntBorIn.port_b)
    annotation (Line(points={{114,-200},{86,-200}}, color={0,127,255}));
  connect(senEntBorIn.port_a, splSup4.port_1) annotation (Line(points={{74,-200},
          {60,-200},{60,-210}}, color={0,127,255}));
  connect(senEntBorOut.H_flow, EFroBorFie2.u[1]) annotation (Line(points={{-120,
          -193.4},{-120,-177.9},{94,-177.9}}, color={0,0,127}));
  connect(senEntBorIn.H_flow, EFroBorFie2.u[2]) annotation (Line(points={{80,
          -193.4},{80,-182.1},{94,-182.1}}, color={0,0,127}));
  connect(borFie.port_b, swiBoxBorFie.port_a1) annotation (Line(points={{-10,
          -320},{-20,-320},{-20,-280},{-6,-280},{-6,-270.1}}, color={0,127,255}));
  connect(swiBoxBorFie.PPum, EPumDis.u[1]) annotation (Line(points={{13,-260},{
          16,-260},{16,-277.9},{162,-277.9}}, color={0,0,127}));
  connect(pumpBHS.P, EPumDis.u[2]) annotation (Line(points={{29,-311},{20,-311},
          {20,-282.1},{162,-282.1}}, color={0,0,127}));
  connect(senEntFloPlaIn.H_flow, gaiEntFlo.u)
    annotation (Line(points={{40,-73.4},{40,-62},{66,-62}}, color={0,0,127}));
  connect(senEntPlaOut.H_flow, EPlant.u[1]) annotation (Line(points={{-120,
          -73.4},{-120,-46.55},{102,-46.55}}, color={0,0,127}));
  connect(gaiEntFlo.y, EPlant.u[2]) annotation (Line(points={{89,-62},{96,-62},
          {96,-51.45},{102,-51.45}}, color={0,0,127}));
  connect(senEntFloPlaIn.port_a, splSup2.port_3)
    annotation (Line(points={{46,-80},{150,-80}}, color={0,127,255}));
  connect(plant.port_b2, sewBouCon.ports[2]) annotation (Line(points={{10,-92},
          {20,-92},{20,-140},{2,-140}}, color={0,127,255}));
  annotation (Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-380},{320,320}})),
        __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Examples/DistrictReservoirNetworks/Bidirectional.mos"
        "Simulate and plot"),
    experiment(
      StopTime=31536000,
      __Dymola_NumberOfIntervals=8760,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    Documentation(info="<html>
<p>
System model for bi-directional network.
</p>
<p>
In the bi-directional network, the mass flow rate in the distribution pipe
changes direction depending on the water flow rate that the substations
draw from the distribution pipe.
</p>
</html>", revisions="<html>
<ul>
<li>
January 12, 2020, by Michael Wetter:<br/>
Added documentation.
</li>
</ul>
</html>"));
end Bidirectional;

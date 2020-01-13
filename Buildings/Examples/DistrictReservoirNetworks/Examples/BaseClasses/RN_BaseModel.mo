within Buildings.Examples.DistrictReservoirNetworks.Examples.BaseClasses;
partial model RN_BaseModel
  package Medium = Buildings.Media.Water "Medium model";

  parameter DesignValues datDes "Design values"
    annotation (Placement(transformation(extent={{-240,222},{-220,242}})));

  Buildings.Examples.DistrictReservoirNetworks.Agents.EnergyTransferStation proHos(redeclare
      package Medium =
               Medium, filNam=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Examples/DistrictReservoirNetworks/Examples/SwissHospital_20190916.mos"))
    "Prosumer hospital"
    annotation (Placement(transformation(extent={{180,-54},{220,-14}})));
  Agents.BoreField borFie(redeclare package Medium = Medium) annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-2,-440})));
  Fluid.Sensors.TemperatureTwoPort Tml1(redeclare package Medium =
        Medium,
    allowFlowReversal=false,
                     m_flow_nominal=datDes.mDisPip_flow_nominal,
    tau=0)           annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-80,-300})));
  Pump_m_flow                                  pumpMainRLTN(
    redeclare package Medium = Medium,
    m_flow_nominal=datDes.mDisPip_flow_nominal)
                            "Pump"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={80,-290})));
  Buildings.Fluid.Sensors.MassFlowRate massFlowRateInRLTN(redeclare package
      Medium = Medium, allowFlowReversal=true) annotation (Placement(
        transformation(
        extent={{6,6},{-6,-6}},
        rotation=180,
        origin={40,238})));
  Buildings.Examples.DistrictReservoirNetworks.Agents.EnergyTransferStation proApa(redeclare
      package Medium =
               Medium, filNam=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Examples/DistrictReservoirNetworks/Examples/SwissResidential_20190916.mos"))
    "Prosumer apartment"
    annotation (Placement(transformation(extent={{180,158},{220,198}})));
  Buildings.Examples.DistrictReservoirNetworks.Agents.EnergyTransferStation proOff(redeclare
      package Medium =
               Medium, filNam=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Examples/DistrictReservoirNetworks/Examples/SwissOffice_20190916.mos"))
    "Prosumer office"
    annotation (Placement(transformation(extent={{-180,-40},{-220,0}})));
  Fluid.Sensors.TemperatureTwoPort Tml2(redeclare package Medium =
        Medium,
    allowFlowReversal=false,
                     m_flow_nominal=datDes.mDisPip_flow_nominal,
    tau=0)           annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=90,
        origin={-80,-94})));
  Fluid.Sensors.TemperatureTwoPort Tml4(redeclare package Medium =
        Medium,
    allowFlowReversal=false,
    m_flow_nominal=datDes.mDisPip_flow_nominal,
    tau=0)           annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=90,
        origin={80,118})));
  Fluid.Sensors.TemperatureTwoPort Tml5(redeclare package Medium =
        Medium,
    allowFlowReversal=false,
    m_flow_nominal=datDes.mDisPip_flow_nominal,
    tau=0)           annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=270,
        origin={80,-92})));
  Fluid.Sensors.TemperatureTwoPort Tml3(redeclare package Medium =
        Medium, m_flow_nominal=datDes.mDisPip_flow_nominal)
                     annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=180,
        origin={0,238})));
  Networks.TJunction splSup1(
    redeclare package Medium = Medium,
    m_flow_nominal = datDes.mDisPip_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-80,-190})));
  Networks.TJunction splSup2(
    redeclare package Medium = Medium,
    m_flow_nominal = datDes.mDisPip_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-80,-270})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFloByPasPla(redeclare package
      Medium = Medium, allowFlowReversal=true)
    "Mass flow rate sensor for bypass of plant" annotation (Placement(
        transformation(
        extent={{6,6},{-6,-6}},
        rotation=-90,
        origin={-80,-230})));
  Buildings.Fluid.HeatExchangers.ConstantEffectiveness plant(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
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
        origin={-206,-250})));
  Pump_m_flow pumPlaPri(
    redeclare package Medium = Medium,
    final m_flow_nominal=datDes.mPla_flow_nominal,
    dp_nominal=50000) "Pump on primary side of plant" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-200,-210})));
  Modelica.Blocks.Sources.Constant mFlowInputPlant(final k=datDes.mPla_flow_nominal)
                                                            "kg/s"
    annotation (Placement(transformation(extent={{-280,-224},{-264,-240}})));
  Buildings.Fluid.Sources.Boundary_pT sewBouCon(
    redeclare package Medium = Medium,
    T=290.15,
    nPorts=2) "Boundary condition for sewage source"
    annotation (Placement(transformation(extent={{-270,-280},{-250,-260}})));
  Pump_m_flow pumPlaSec(
    redeclare package Medium = Medium,
    final m_flow_nominal=datDes.mPla_flow_nominal,
    dp_nominal=50000) "Pump on secondary side of plant" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-240,-210})));
  Networks.DistributionPipe disPip7(
    redeclare package Medium = Medium,
    final m_flow_nominal=datDes.mDisPip_flow_nominal,
    final R=datDes.RDisPip) "Distribution pipe" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={80,-250})));
  Networks.DistributionPipe disPip8(
    redeclare package Medium = Medium,
    final m_flow_nominal=datDes.mDisPip_flow_nominal,
    final R=datDes.RDisPip) "Distribution pipe" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-80,-330})));
  Networks.DistributionPipe disPip2(
    redeclare package Medium = Medium,
    final m_flow_nominal=datDes.mDisPip_flow_nominal,
    final R=datDes.RDisPip) "Distribution pipe" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-80,72})));
  Networks.DistributionPipe disPip3(
    redeclare package Medium = Medium,
    final m_flow_nominal=datDes.mDisPip_flow_nominal,
    final R=datDes.RDisPip) "Distribution pipe" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={80,72})));
  Networks.SwitchBoxEnergyTransferStation switchBoxProsumerWithPumps(final
      m_flow_nominal=datDes.mDisPip_flow_nominal,                    redeclare
      package Medium = Medium) annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={-150,0})));
  Networks.SwitchBoxEnergyTransferStation switchBoxProsumerWithPumps1(final
      m_flow_nominal=datDes.mDisPip_flow_nominal,
      redeclare package Medium = Medium) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={150,158})));
  Networks.SwitchBoxEnergyTransferStation switchBoxProsumerWithPumps2(final
      m_flow_nominal=datDes.mDisPip_flow_nominal,
      redeclare package Medium = Medium) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={150,-52})));
  Buildings.Fluid.Sensors.MassFlowRate massFlowRateThroughProsumer2AfterSB(
      redeclare package Medium = Medium, allowFlowReversal=true)
    annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=0,
        origin={200,138})));
  Buildings.Fluid.Sensors.MassFlowRate massFlowRateThroughProsumer3AfterSB(
      redeclare package Medium = Medium, allowFlowReversal=true)
    annotation (Placement(transformation(
        extent={{6,6},{-6,-6}},
        rotation=0,
        origin={200,-72})));
  Buildings.Fluid.Sources.Boundary_pT bou(redeclare package Medium =
        Medium, nPorts=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={130,-270})));
  Networks.DistributionPipe disPip1(
    redeclare package Medium = Medium,
    final m_flow_nominal=datDes.mDisPip_flow_nominal,
    final R=datDes.RDisPip) "Distribution pipe" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-80,-130})));
  Networks.DistributionPipe disPip4(
    redeclare package Medium = Medium,
    final m_flow_nominal=datDes.mDisPip_flow_nominal,
    final R=datDes.RDisPip) "Distribution pipe" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={80,-130})));
  Networks.DistributionPipe disPip5(
    redeclare package Medium = Medium,
    final m_flow_nominal=datDes.mDisPip_flow_nominal,
    final R=datDes.RDisPip) "Distribution pipe" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={80,-172})));
  Networks.DistributionPipe disPip6(
    redeclare package Medium = Medium,
    final m_flow_nominal=datDes.mDisPip_flow_nominal,
    final R=datDes.RDisPip) "Distribution pipe" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={80,-210})));
  PowerMeter EPumPla(nu=2) "Plant pump power consumption"
    annotation (Placement(transformation(extent={{-176,-166},{-164,-154}})));
  PowerMeter EPumPro(nu=6)
                     "Prosumer pump power consumption"
    annotation (Placement(transformation(extent={{246,282},{258,294}})));
  PowerMeter EPumDis(nu=2) "Distribution network pump power consumption"
    annotation (Placement(transformation(extent={{114,-326},{126,-314}})));
  PowerMeter EHeaPum(nu=3)
                     "Heat pump power consumption"
    annotation (Placement(transformation(extent={{246,262},{258,274}})));
  PowerMeter EBorFie(nu=1) "Heat from borefield"
    annotation (Placement(transformation(extent={{-28,-464},{-40,-452}})));
  PowerMeter EDisOff(nu=1) "Office heat cosumption from district loop"
    annotation (Placement(transformation(extent={{-220,-78},{-208,-66}})));
  PowerMeter EDisApa(nu=1) "Apartment heat consumption from district loop"
    annotation (Placement(transformation(extent={{284,198},{296,210}})));
  PowerMeter EDisHos(nu=1) "Hospital heat consumption from district loop"
    annotation (Placement(transformation(extent={{284,-14},{296,-2}})));
  PowerMeter EDisPro(nu=3) "Prosumer heat consumption from district loop"
    annotation (Placement(transformation(
        extent={{-6,-6},{6,6}},
        rotation=0,
        origin={290,-114})));
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
    redeclare package Medium = Medium,
    m_flow_nominal=datDes.mSto_flow_nominal)
                            "Pump" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={50,-440})));
  Networks.TJunction splSup9(
    redeclare package Medium = Medium,
    m_flow_nominal=datDes.mDisPip_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={80,-402})));
  Networks.TJunction splSup10(
    redeclare package Medium = Medium,
    m_flow_nominal=datDes.mDisPip_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=false) "Flow splitter" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-80,-402})));
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
  Fluid.Sensors.EnthalpyFlowRate senEntPlaOut(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=datDes.mDisPip_flow_nominal,
    tau=0) "Enthalpy flow rate at plant outlet" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-158,-190})));
  Fluid.Sensors.EnthalpyFlowRate senEntFloPlaIn(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    m_flow_nominal=datDes.mDisPip_flow_nominal,
    tau=0) "Enthalpy flow rate at plant inlet" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={-160,-270})));
  PowerMeter             EPlant(nu=2) "Plant heat input into the district loop"
    annotation (Placement(transformation(extent={{-114,-228},{-100,-214}})));
  PowerMeter EFroBorFie2(nu=2) "Energy from borefield"
    annotation (Placement(transformation(extent={{-6,-386},{6,-374}})));
  Fluid.Sensors.EnthalpyFlowRate senEntBorIn(redeclare package Medium =
        Medium, m_flow_nominal=datDes.mDisPip_flow_nominal)
    "Enthalpy flow rate at borefield inlet" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={80,-360})));
  Fluid.Sensors.EnthalpyFlowRate senEntBorOut(redeclare package Medium =
        Medium, m_flow_nominal=datDes.mDisPip_flow_nominal)
    "Enthalpy flow rate at borefield outlet" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-80,-360})));
protected
  constant Real scaFacLoa = 10 "Scaling factor for load profiles that are read by the model";
  Modelica.Blocks.Math.Gain gaiEntFlo(k=-1)
    "Gain to switch sign of enthalpy flow rate"
    annotation (Placement(transformation(extent={{-146,-258},{-126,-238}})));
equation
  connect(Tml3.port_b, massFlowRateInRLTN.port_a)
    annotation (Line(points={{6,238},{34,238}},   color={0,127,255}));
  connect(senMasFloByPasPla.port_b, splSup1.port_1)
    annotation (Line(points={{-80,-224},{-80,-200}}, color={0,127,255}));
  connect(senMasFloByPasPla.port_a, splSup2.port_2)
    annotation (Line(points={{-80,-236},{-80,-260}}, color={0,127,255}));
  connect(mFlowInputPlant.y, pumPlaPri.m_flow_in) annotation (Line(points={{
          -263.2,-232},{-180,-232},{-180,-210},{-188,-210}}, color={0,0,127}));
  connect(mFlowInputPlant.y, pumPlaSec.m_flow_in) annotation (Line(points={{
          -263.2,-232},{-260,-232},{-260,-210},{-252,-210}}, color={0,0,127}));
  connect(Tml1.port_b, splSup2.port_1)
    annotation (Line(points={{-80,-294},{-80,-280}}, color={0,127,255}));
  connect(pumPlaPri.port_a, plant.port_b1)
    annotation (Line(points={{-200,-220},{-200,-240}}, color={0,127,255}));
  connect(pumPlaSec.port_b, plant.port_a2) annotation (Line(points={{-240,-200},
          {-240,-190},{-220,-190},{-220,-236},{-212,-236},{-212,-240}}, color={
          0,127,255}));
  connect(pumPlaSec.port_a, sewBouCon.ports[1]) annotation (Line(points={{-240,
          -220},{-240,-268},{-250,-268}}, color={0,127,255}));
  connect(disPip7.port_b, pumpMainRLTN.port_a)
    annotation (Line(points={{80,-260},{80,-280}}, color={0,127,255}));
  connect(disPip8.port_b, Tml1.port_a)
    annotation (Line(points={{-80,-320},{-80,-306}}, color={0,127,255}));
  connect(disPip2.port_b, Tml3.port_a)
    annotation (Line(points={{-80,82},{-80,238},{-6,238}}, color={0,127,255}));
  connect(disPip3.port_a, Tml4.port_b)
    annotation (Line(points={{80,82},{80,112}}, color={0,127,255}));
  connect(switchBoxProsumerWithPumps2.port_b1, proHos.port_a) annotation (Line(
        points={{160,-47},{170,-47},{170,-34},{180,-34}}, color={0,127,255}));
  connect(switchBoxProsumerWithPumps1.port_b1, proApa.port_a) annotation (Line(
        points={{160,163},{170,163},{170,178},{180,178}}, color={0,127,255}));
  connect(proApa.m_flow_HPSH, switchBoxProsumerWithPumps1.mSpaHea_flow)
    annotation (Line(points={{220.286,168},{224,168},{224,220},{158,220},{158,
          169}}, color={0,0,127}));
  connect(proApa.m_flow_HPDHW, switchBoxProsumerWithPumps1.mDomHotWat_flow)
    annotation (Line(points={{220.286,163.714},{228,163.714},{228,224},{156,224},
          {156,169}}, color={0,0,127}));
  connect(proApa.m_flow_FC, switchBoxProsumerWithPumps1.mFreCoo_flow)
    annotation (Line(points={{220.286,159.429},{230,159.429},{230,228},{154,228},
          {154,169}}, color={0,0,127}));
  connect(proHos.m_flow_HPSH, switchBoxProsumerWithPumps2.mSpaHea_flow)
    annotation (Line(points={{220.286,-44},{224,-44},{224,10},{158,10},{158,-41}},
        color={0,0,127}));
  connect(proHos.m_flow_HPDHW, switchBoxProsumerWithPumps2.mDomHotWat_flow)
    annotation (Line(points={{220.286,-48.2857},{226,-48.2857},{226,14},{156,14},
          {156,-41}}, color={0,0,127}));
  connect(proHos.m_flow_FC, switchBoxProsumerWithPumps2.mFreCoo_flow)
    annotation (Line(points={{220.286,-52.5714},{228,-52.5714},{228,18},{154,18},
          {154,-41}}, color={0,0,127}));
  connect(proOff.port_a, switchBoxProsumerWithPumps.port_b1) annotation (Line(
        points={{-180,-20},{-170,-20},{-170,-5},{-160,-5}}, color={0,127,255}));
  connect(proOff.m_flow_HPSH, switchBoxProsumerWithPumps.mSpaHea_flow)
    annotation (Line(points={{-220.286,-30},{-224,-30},{-224,-50},{-158,-50},{
          -158,-11}}, color={0,0,127}));
  connect(proOff.m_flow_HPDHW, switchBoxProsumerWithPumps.mDomHotWat_flow)
    annotation (Line(points={{-220.286,-34.2857},{-226,-34.2857},{-226,-52},{
          -156,-52},{-156,-11}}, color={0,0,127}));
  connect(proOff.m_flow_FC, switchBoxProsumerWithPumps.mFreCoo_flow)
    annotation (Line(points={{-220.286,-38.5714},{-228,-38.5714},{-228,-54},{
          -154,-54},{-154,-11}}, color={0,0,127}));
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
  connect(bou.ports[1], pumpMainRLTN.port_a) annotation (Line(points={{120,-270},
          {80,-270},{80,-280}}, color={0,127,255}));
  connect(disPip1.port_a, splSup1.port_2)
    annotation (Line(points={{-80,-140},{-80,-180}}, color={0,127,255}));
  connect(disPip4.port_b, Tml5.port_b)
    annotation (Line(points={{80,-120},{80,-98}},  color={0,127,255}));
  connect(disPip1.port_b, Tml2.port_a)
    annotation (Line(points={{-80,-120},{-80,-100}}, color={0,127,255}));
  connect(disPip5.port_b, disPip4.port_a)
    annotation (Line(points={{80,-162},{80,-140}}, color={0,127,255}));
  connect(disPip7.port_a, disPip6.port_a)
    annotation (Line(points={{80,-240},{80,-220}}, color={0,127,255}));
  connect(disPip6.port_b, disPip5.port_a)
    annotation (Line(points={{80,-200},{80,-182}}, color={0,127,255}));
  connect(pumPlaSec.P, EPumPla.u[1]) annotation (Line(points={{-249,-199},{-249,
          -158},{-246,-158},{-246,-157.9},{-176,-157.9}}, color={0,0,127}));
  connect(pumPlaPri.P, EPumPla.u[2]) annotation (Line(points={{-191,-199},{-191,
          -162},{-184,-162},{-184,-162.1},{-176,-162.1}}, color={0,0,127}));
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
    annotation (Line(points={{114,-317.9},{71,-317.9},{71,-301}},
                                                             color={0,0,127}));
  connect(EBorFie.u[1], borFie.Q_flow) annotation (Line(points={{-28,-458},{-20,
          -458},{-20,-448},{-13,-448}}, color={0,0,127}));
  connect(switchBoxProsumerWithPumps.PPum, EPumPro.u[4]) annotation (Line(
        points={{-150,10.8333},{-150,287.3},{246,287.3}},
        color={0,0,127}));
  connect(switchBoxProsumerWithPumps1.PPum, EPumPro.u[5]) annotation (Line(
        points={{150,147.167},{150,146},{164,146},{164,290},{246,290},{246,
          285.9}},                                              color={0,0,127}));
  connect(switchBoxProsumerWithPumps2.PPum, EPumPro.u[6]) annotation (Line(
        points={{150,-62.8333},{150,-76},{166,-76},{166,284.5},{246,284.5}},
        color={0,0,127}));
  connect(EHeaPum.y, EEleTot.u[1]) annotation (Line(points={{259.02,268},{266,
          268},{266,282.1},{284,282.1}},
                                      color={0,0,127}));
  connect(EEleTot.y, pri.x[1])
    annotation (Line(points={{297.02,280},{350,280}}, color={0,0,127}));
  connect(borFie.port_a, pumpBHS.port_b)
    annotation (Line(points={{8,-440},{40,-440}}, color={0,127,255}));
  connect(splSup10.port_2, borFie.port_b) annotation (Line(points={{-80,-412},{
          -80,-440},{-12,-440}}, color={0,127,255}));
  connect(pumpBHS.port_a, splSup9.port_2) annotation (Line(points={{60,-440},{
          80,-440},{80,-412}}, color={0,127,255}));
  connect(splSup10.port_3, splSup9.port_3)
    annotation (Line(points={{-70,-402},{70,-402}}, color={0,127,255}));
  connect(pumpBHS.P, EPumDis.u[2]) annotation (Line(points={{39,-431},{18,-431},
          {18,-422},{100,-422},{100,-322.1},{114,-322.1}}, color={0,0,127}));
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
  connect(Tml5.T, TVio.u[5]) annotation (Line(points={{86.6,-92},{308,-92},{308,
          326.64},{324,326.64}},                       color={0,0,127}));
  connect(TVio.y, pri1.x[1])
    annotation (Line(points={{337.02,330},{350,330}}, color={0,0,127}));
  connect(EPumPro.y, EPumTot.u[1]) annotation (Line(points={{259.02,288},{266,
          288},{266,310.8},{284,310.8}}, color={0,0,127}));
  connect(EPumDis.y, EPumTot.u[2]) annotation (Line(points={{127.02,-320},{268,
          -320},{268,308},{284,308}}, color={0,0,127}));
  connect(EPumPla.y, EPumTot.u[3]) annotation (Line(points={{-162.98,-160},{
          -160,-160},{-160,-88},{-278,-88},{-278,328},{276,328},{276,305.2},{
          284,305.2}}, color={0,0,127}));
  connect(EPumTot.y, EEleTot.u[2]) annotation (Line(points={{297.02,308},{300,
          308},{300,294},{276,294},{276,277.9},{284,277.9}}, color={0,0,127}));
  connect(proOff.QPro, EDisPro.u[1]) annotation (Line(points={{-220.714,5.71429},
          {-234,5.71429},{-234,-111.2},{284,-111.2}}, color={0,0,127}));
  connect(proOff.QPro, EDisOff.u[1]) annotation (Line(points={{-220.714,5.71429},
          {-234,5.71429},{-234,-72},{-220,-72}}, color={0,0,127}));
  connect(proApa.QPro, EDisApa.u[1]) annotation (Line(points={{220.714,203.714},
          {248.357,203.714},{248.357,204},{284,204}}, color={0,0,127}));
  connect(proApa.QPro, EDisPro.u[2]) annotation (Line(points={{220.714,203.714},
          {276,203.714},{276,-114},{284,-114}}, color={0,0,127}));
  connect(proHos.QPro, EDisHos.u[1]) annotation (Line(points={{220.714,-8.28571},
          {272,-8.28571},{272,-8},{284,-8}}, color={0,0,127}));
  connect(proHos.QPro, EDisPro.u[3]) annotation (Line(points={{220.714,-8.28571},
          {272,-8.28571},{272,-116.8},{284,-116.8}}, color={0,0,127}));
  connect(proOff.port_b, switchBoxProsumerWithPumps.port_a2) annotation (Line(
        points={{-219.857,-20},{-226,-20},{-226,20},{-172,20},{-172,5},{-159.9,
          5}}, color={0,127,255}));
  connect(switchBoxProsumerWithPumps.port_b2, disPip2.port_a)
    annotation (Line(points={{-140,5},{-80,5},{-80,62}}, color={0,127,255}));
  connect(switchBoxProsumerWithPumps.port_a1, Tml2.port_b) annotation (Line(
        points={{-139.9,-5},{-80,-5},{-80,-88}}, color={0,127,255}));
  connect(massFlowRateInRLTN.port_b, switchBoxProsumerWithPumps1.port_a1)
    annotation (Line(points={{46,238},{82,238},{82,162},{110,162},{110,163},{
          139.9,163}}, color={0,127,255}));
  connect(Tml4.port_a, switchBoxProsumerWithPumps1.port_b2)
    annotation (Line(points={{80,124},{80,153},{140,153}}, color={0,127,255}));
  connect(disPip3.port_b, switchBoxProsumerWithPumps2.port_a1) annotation (Line(
        points={{80,62},{80,-47},{139.9,-47}}, color={0,127,255}));
  connect(switchBoxProsumerWithPumps2.port_b2, Tml5.port_a) annotation (Line(
        points={{140,-57},{122,-57},{122,-58},{80,-58},{80,-86}}, color={0,127,
          255}));
  connect(plant.port_b2, sewBouCon.ports[2]) annotation (Line(points={{-212,-260},
          {-212,-270},{-250,-270},{-250,-272}}, color={0,127,255}));
  connect(splSup2.port_3, senEntFloPlaIn.port_a)
    annotation (Line(points={{-90,-270},{-150,-270}}, color={0,127,255}));
  connect(senEntFloPlaIn.port_b, plant.port_a1) annotation (Line(points={{-170,
          -270},{-200,-270},{-200,-260}}, color={0,127,255}));
  connect(pumPlaPri.port_b, senEntPlaOut.port_a) annotation (Line(points={{-200,
          -200},{-200,-190},{-168,-190}}, color={0,127,255}));
  connect(senEntPlaOut.port_b, splSup1.port_3)
    annotation (Line(points={{-148,-190},{-90,-190}}, color={0,127,255}));
  connect(senEntFloPlaIn.H_flow, gaiEntFlo.u) annotation (Line(points={{-160,
          -259},{-160,-248},{-148,-248}}, color={0,0,127}));
  connect(senEntPlaOut.H_flow, EPlant.u[1]) annotation (Line(points={{-158,-179},
          {-158,-170},{-120,-170},{-120,-218.55},{-114,-218.55}}, color={0,0,
          127}));
  connect(gaiEntFlo.y, EPlant.u[2]) annotation (Line(points={{-125,-248},{-120,
          -248},{-120,-223.45},{-114,-223.45}}, color={0,0,127}));
  connect(disPip8.port_a, senEntBorOut.port_b)
    annotation (Line(points={{-80,-340},{-80,-350}}, color={0,127,255}));
  connect(senEntBorOut.port_a, splSup10.port_1)
    annotation (Line(points={{-80,-370},{-80,-392}}, color={0,127,255}));
  connect(splSup9.port_1, senEntBorIn.port_a)
    annotation (Line(points={{80,-392},{80,-370}}, color={0,127,255}));
  connect(senEntBorIn.port_b, pumpMainRLTN.port_b)
    annotation (Line(points={{80,-350},{80,-300}}, color={0,127,255}));
  connect(senEntBorIn.H_flow, EFroBorFie2.u[1]) annotation (Line(points={{69,
          -360},{-12,-360},{-12,-377.9},{-6,-377.9}}, color={0,0,127}));
  connect(senEntBorOut.H_flow, EFroBorFie2.u[2]) annotation (Line(points={{-69,
          -360},{-16,-360},{-16,-382.1},{-6,-382.1}}, color={0,0,127}));
  annotation (Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-320,-480},{380,360}})),
    experiment(StopTime=31536000, __Dymola_NumberOfIntervals=8760),
    Icon(coordinateSystem(extent={{-320,-480},{380,360}})));
end RN_BaseModel;

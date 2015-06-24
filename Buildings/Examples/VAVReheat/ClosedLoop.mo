within Buildings.Examples.VAVReheat;
model ClosedLoop
  "Variable air volume flow system with terminal reheat and five thermal zones"
  extends Modelica.Icons.Example;
  replaceable package MediumA =
      Buildings.Media.Air;
  package MediumW = Buildings.Media.Water "Medium model for water";

  parameter Modelica.SIunits.Volume VRooCor=2698 "Room volume corridor";
  parameter Modelica.SIunits.Volume VRooSou=568.77 "Room volume south";
  parameter Modelica.SIunits.Volume VRooNor=568.77 "Room volume north";
  parameter Modelica.SIunits.Volume VRooEas=360.08 "Room volume east";
  parameter Modelica.SIunits.Volume VRooWes=360.08 "Room volume west";

  constant Real conv=1.2/3600 "Conversion factor for nominal mass flow rate";
  parameter Modelica.SIunits.MassFlowRate m0_flow_cor=6*VRooCor*conv
    "Design mass flow rate core";
  parameter Modelica.SIunits.MassFlowRate m0_flow_sou=7*VRooSou*conv
    "Design mass flow rate perimeter 1";
  parameter Modelica.SIunits.MassFlowRate m0_flow_eas=10*VRooEas*conv
    "Design mass flow rate perimeter 2";
  parameter Modelica.SIunits.MassFlowRate m0_flow_nor=7*VRooNor*conv
    "Design mass flow rate perimeter 3";
  parameter Modelica.SIunits.MassFlowRate m0_flow_wes=10*VRooWes*conv
    "Design mass flow rate perimeter 4";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=m0_flow_cor +
      m0_flow_sou + m0_flow_eas + m0_flow_nor + m0_flow_wes
    "Nominal mass flow rate";
   parameter Modelica.SIunits.Angle lat=41.98*3.14159/180 "Latitude";
  Fluid.Sources.Outside amb(redeclare package Medium = MediumA, nPorts=2)
    "Ambient conditions"
    annotation (Placement(transformation(extent={{-130,14},{-108,36}})));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM fil(
    m_flow_nominal=m_flow_nominal,
    redeclare package Medium = MediumA,
    dp_nominal=200 + 200 + 100,
    from_dp=false,
    linearized=false) "Filter"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
  Buildings.Fluid.HeatExchangers.DryEffectivenessNTU heaCoi(
    redeclare package Medium1 = MediumA,
    redeclare package Medium2 = MediumW,
    m1_flow_nominal=m_flow_nominal,
    allowFlowReversal2=false,
    m2_flow_nominal=m_flow_nominal*1000*(10 - (-20))/4200/10,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    Q_flow_nominal=m_flow_nominal*1006*(16.7 - 8.5),
    dp1_nominal=0,
    dp2_nominal=0,
    T_a1_nominal=281.65,
    T_a2_nominal=323.15) "Heating coil"
    annotation (Placement(transformation(extent={{98,-56},{118,-36}})));
  Buildings.Fluid.HeatExchangers.WetCoilCounterFlow cooCoi(
    UA_nominal=m_flow_nominal*1000*15/
        Buildings.Fluid.HeatExchangers.BaseClasses.lmtd(
        T_a1=26.2,
        T_b1=12.8,
        T_a2=6,
        T_b2=16),
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumA,
    m1_flow_nominal=m_flow_nominal*1000*15/4200/10,
    m2_flow_nominal=m_flow_nominal,
    dp2_nominal=0,
    dp1_nominal=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Cooling coil"
    annotation (Placement(transformation(extent={{210,-36},{190,-56}})));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM dpSupDuc(
    m_flow_nominal=m_flow_nominal,
    dh=1,
    redeclare package Medium = MediumA,
    dp_nominal=20) "Pressure drop for supply duct"
    annotation (Placement(transformation(extent={{420,-50},{440,-30}})));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM dpRetDuc(
    m_flow_nominal=m_flow_nominal,
    use_dh=false,
    dh=1,
    redeclare package Medium = MediumA,
    dp_nominal=20) "Pressure drop for return duct"
    annotation (Placement(transformation(extent={{440,110},{420,130}})));
  Buildings.Fluid.Movers.SpeedControlled_y fanSup(
    redeclare package Medium = MediumA,
    tau=60,
    dynamicBalance=true,
    per(pressure(V_flow={0, m_flow_nominal/1.2*2}, dp={850,0})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Supply air fan"
    annotation (Placement(transformation(extent={{300,-50},{320,-30}})));
  Buildings.Fluid.Movers.SpeedControlled_y fanRet(
    redeclare package Medium = MediumA,
    tau=60,
    dynamicBalance=true,
    per(pressure(V_flow=m_flow_nominal/1.2*{0, 2}, dp=1.5*110*{2,0})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Return air fan"
    annotation (Placement(transformation(extent={{310,110},{290,130}})));
  Buildings.Fluid.Sources.FixedBoundary sinHea(
    redeclare package Medium = MediumW,
    p=300000,
    T=318.15,
    nPorts=1) "Sink for heating coil" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={90,-120})));
  Buildings.Fluid.Sources.FixedBoundary sinCoo(
    redeclare package Medium = MediumW,
    p=300000,
    T=285.15,
    nPorts=1) "Sink for cooling coil" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={190,-120})));
  Modelica.Blocks.Routing.RealPassThrough TOut(y(
      final quantity="ThermodynamicTemperature",
      final unit="K",
      displayUnit="degC",
      min=0))
    annotation (Placement(transformation(extent={{-300,138},{-280,158}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TSup(redeclare package Medium =
        MediumA, m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{330,-50},{350,-30}})));
  Modelica.Blocks.Sources.Constant TSupSetHea(y(
      final quantity="ThermodynamicTemperature",
      final unit="K",
      displayUnit="degC",
      min=0), k=273.15 + 10) "Supply air temperature setpoint for heating"
    annotation (Placement(transformation(extent={{-100,-170},{-80,-150}})));
  Buildings.Controls.Continuous.LimPID heaCoiCon(
    yMax=1,
    yMin=0,
    Td=60,
    initType=Modelica.Blocks.Types.InitPID.InitialState,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti=600,
    k=0.01) "Controller for heating coil"
    annotation (Placement(transformation(extent={{0,-170},{20,-150}})));
  Buildings.Controls.Continuous.LimPID cooCoiCon(
    reverseAction=true,
    Td=60,
    initType=Modelica.Blocks.Types.InitPID.InitialState,
    yMax=1,
    yMin=0,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    Ti=600,
    k=0.01) "Controller for cooling coil"
    annotation (Placement(transformation(extent={{0,-210},{20,-190}})));
  Buildings.Fluid.Sensors.RelativePressure dpRetFan(redeclare package Medium =
        MediumA) "Pressure difference over return fan" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={320,50})));
  Controls.FanVFD conFanSup(xSet_nominal(displayUnit="Pa") = 410, r_N_min=0.2)
    "Controller for fan"
    annotation (Placement(transformation(extent={{240,0},{260,20}})));
  Buildings.Fluid.Sensors.VolumeFlowRate senSupFlo(redeclare package Medium =
        MediumA, m_flow_nominal=m_flow_nominal)
    "Sensor for supply fan flow rate"
    annotation (Placement(transformation(extent={{360,-50},{380,-30}})));
  Buildings.Controls.SetPoints.OccupancySchedule occSch(occupancy=3600*{6,19})
    "Occupancy schedule"
    annotation (Placement(transformation(extent={{-318,-220},{-298,-200}})));
  Controls.ModeSelector modeSelector
    annotation (Placement(transformation(extent={{-112,-224},{-92,-204}})));
  Controls.ControlBus controlBus
    annotation (Placement(transformation(extent={{-250,-270},{-230,-250}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCoiHeaOut(redeclare package
      Medium = MediumA, m_flow_nominal=m_flow_nominal)
    "Heating coil outlet temperature"
    annotation (Placement(transformation(extent={{134,-50},{154,-30}})));
  Buildings.Utilities.Math.Min min(nin=5) "Computes lowest room temperature"
    annotation (Placement(transformation(extent={{1200,440},{1220,460}})));
  Buildings.Utilities.Math.Average ave(nin=5)
    "Compute average of room temperatures"
    annotation (Placement(transformation(extent={{1200,410},{1220,430}})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear valCoo(
    redeclare package Medium = MediumW,
    CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    m_flow_nominal=m_flow_nominal*1000*15/4200/10,
    dpValve_nominal=6000,
    from_dp=true,
    dpFixed_nominal=6000) "Cooling coil valve"
                                       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={230,-80})));
  Buildings.Fluid.Sources.FixedBoundary souCoo(
    nPorts=1,
    redeclare package Medium = MediumW,
    p=3E5 + 12000,
    T=285.15) "Source for cooling coil" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={230,-120})));
  Controls.Economizer conEco(
    dT=1,
    VOut_flow_min=0.3*m_flow_nominal/1.2,
    Ti=600,
    k=0.1) "Controller for economizer"
    annotation (Placement(transformation(extent={{-80,140},{-60,160}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TRet(redeclare package Medium =
        MediumA, m_flow_nominal=m_flow_nominal) "Return air temperature sensor"
    annotation (Placement(transformation(extent={{100,110},{80,130}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TMix(redeclare package Medium =
        MediumA, m_flow_nominal=m_flow_nominal) "Mixed air temperature sensor"
    annotation (Placement(transformation(extent={{30,-50},{50,-30}})));
  Controls.RoomTemperatureSetpoint TSetRoo
    annotation (Placement(transformation(extent={{-300,-276},{-280,-256}})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear valHea(
    redeclare package Medium = MediumW,
    CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    dpValve_nominal=6000,
    m_flow_nominal=m_flow_nominal*1000*40/4200/10,
    from_dp=true,
    dpFixed_nominal=6000) "Heating coil valve"
                                       annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={130,-80})));
  Buildings.Fluid.Sources.FixedBoundary souHea(
    nPorts=1,
    redeclare package Medium = MediumW,
    p(displayUnit="Pa") = 300000 + 12000,
    T=318.15) "Source for heating coil" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={130,-120})));
  Buildings.Fluid.Actuators.Dampers.MixingBox eco(
    redeclare package Medium = MediumA,
    mOut_flow_nominal=m_flow_nominal,
    mRec_flow_nominal=m_flow_nominal,
    mExh_flow_nominal=m_flow_nominal,
    dpOut_nominal=10,
    dpRec_nominal=10,
    dpExh_nominal=10) "Economizer"
    annotation (Placement(transformation(extent={{-40,66},{14,12}})));
  Buildings.Fluid.Sensors.VolumeFlowRate VOut1(redeclare package Medium =
        MediumA, m_flow_nominal=m_flow_nominal) "Outside air volume flow rate"
    annotation (Placement(transformation(extent={{-80,12},{-58,34}})));
  Controls.DuctStaticPressureSetpoint pSetDuc(
    nin=5,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    pMin=50) "Duct static pressure setpoint"
    annotation (Placement(transformation(extent={{160,0},{180,20}})));
  Buildings.Examples.VAVReheat.ThermalZones.VAVBranch
                                                    cor(
    redeclare package MediumA = MediumA,
    redeclare package MediumW = MediumW,
    m_flow_nominal=m0_flow_cor,
    VRoo=VRooCor) "Zone for core of buildings (azimuth will be neglected)"
    annotation (Placement(transformation(extent={{550,4},{618,72}})));
  Buildings.Examples.VAVReheat.ThermalZones.VAVBranch
                                                    sou(
    redeclare package MediumA = MediumA,
    redeclare package MediumW = MediumW,
    m_flow_nominal=m0_flow_sou,
    VRoo=VRooSou) "South-facing thermal zone"
    annotation (Placement(transformation(extent={{688,2},{760,74}})));
  Buildings.Examples.VAVReheat.ThermalZones.VAVBranch
                                                    eas(
    redeclare package MediumA = MediumA,
    redeclare package MediumW = MediumW,
    m_flow_nominal=m0_flow_eas,
    VRoo=VRooEas) "East-facing thermal zone"
    annotation (Placement(transformation(extent={{826,6},{894,74}})));
  Buildings.Examples.VAVReheat.ThermalZones.VAVBranch
                                                    nor(
    redeclare package MediumA = MediumA,
    redeclare package MediumW = MediumW,
    m_flow_nominal=m0_flow_nor,
    VRoo=VRooNor) "North-facing thermal zone"
    annotation (Placement(transformation(extent={{966,6},{1034,74}})));
  Buildings.Examples.VAVReheat.ThermalZones.VAVBranch
                                                    wes(
    redeclare package MediumA = MediumA,
    redeclare package MediumW = MediumW,
    m_flow_nominal=m0_flow_wes,
    VRoo=VRooWes) "West-facing thermal zone"
    annotation (Placement(transformation(extent={{1104,6},{1172,74}})));
  Controls.FanVFD conFanRet(xSet_nominal(displayUnit="m3/s") = m_flow_nominal/
      1.2, r_N_min=0.2) "Controller for fan"
    annotation (Placement(transformation(extent={{240,140},{260,160}})));
  Buildings.Fluid.Sensors.VolumeFlowRate senRetFlo(redeclare package Medium =
        MediumA, m_flow_nominal=m_flow_nominal)
    "Sensor for return fan flow rate"
    annotation (Placement(transformation(extent={{380,110},{360,130}})));
  Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM splRetRoo1(
    redeclare package Medium = MediumA,
    m_flow_nominal={m_flow_nominal,m_flow_nominal - m0_flow_cor,m0_flow_cor},
    dp_nominal(displayUnit="Pa") = {10,10,10},
    from_dp=false,
    dynamicBalance=true,
    linearized=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Splitter for room return"
    annotation (Placement(transformation(extent={{600,130},{620,110}})));
  Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM splRetSou(
    redeclare package Medium = MediumA,
    m_flow_nominal={m0_flow_sou + m0_flow_eas + m0_flow_nor + m0_flow_wes,
        m0_flow_eas + m0_flow_nor + m0_flow_wes,m0_flow_sou},
    dp_nominal(displayUnit="Pa") = {10,10,10},
    from_dp=false,
    dynamicBalance=true,
    linearized=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Splitter for room return"
    annotation (Placement(transformation(extent={{738,130},{758,110}})));
  Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM splRetEas(
    redeclare package Medium = MediumA,
    m_flow_nominal={m0_flow_eas + m0_flow_nor + m0_flow_wes,m0_flow_nor +
        m0_flow_wes,m0_flow_eas},
    dp_nominal(displayUnit="Pa") = {10,10,10},
    from_dp=false,
    dynamicBalance=true,
    linearized=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Splitter for room return"
    annotation (Placement(transformation(extent={{874,130},{894,110}})));
  Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM splRetNor(
    redeclare package Medium = MediumA,
    m_flow_nominal={m0_flow_nor + m0_flow_wes,m0_flow_wes,m0_flow_nor},
    dp_nominal(displayUnit="Pa") = {10,10,10},
    from_dp=false,
    dynamicBalance=true,
    linearized=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Splitter for room return"
    annotation (Placement(transformation(extent={{1014,130},{1034,110}})));
  Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM splSupRoo1(
    redeclare package Medium = MediumA,
    m_flow_nominal={m_flow_nominal,m_flow_nominal - m0_flow_cor,m0_flow_cor},
    dp_nominal(displayUnit="Pa") = {10,10,10},
    from_dp=true,
    linearized=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Splitter for room supply"
    annotation (Placement(transformation(extent={{574,-30},{594,-50}})));
  Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM splSupSou(
    redeclare package Medium = MediumA,
    m_flow_nominal={m0_flow_sou + m0_flow_eas + m0_flow_nor + m0_flow_wes,
        m0_flow_eas + m0_flow_nor + m0_flow_wes,m0_flow_sou},
    dp_nominal(displayUnit="Pa") = {10,10,10},
    from_dp=true,
    linearized=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Splitter for room supply"
    annotation (Placement(transformation(extent={{714,-30},{734,-50}})));
  Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM splSupEas(
    redeclare package Medium = MediumA,
    m_flow_nominal={m0_flow_eas + m0_flow_nor + m0_flow_wes,m0_flow_nor +
        m0_flow_wes,m0_flow_eas},
    dp_nominal(displayUnit="Pa") = {10,10,10},
    from_dp=true,
    linearized=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Splitter for room supply"
    annotation (Placement(transformation(extent={{850,-30},{870,-50}})));
  Buildings.Fluid.FixedResistances.SplitterFixedResistanceDpM splSupNor(
    redeclare package Medium = MediumA,
    m_flow_nominal={m0_flow_nor + m0_flow_wes,m0_flow_wes,m0_flow_nor},
    dp_nominal(displayUnit="Pa") = {10,10,10},
    from_dp=true,
    linearized=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Splitter for room supply"
    annotation (Placement(transformation(extent={{990,-30},{1010,-50}})));
  Controls.CoolingCoilTemperatureSetpoint TSetCoo "Setpoint for cooling coil"
    annotation (Placement(transformation(extent={{-50,-210},{-30,-190}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    annotation (Placement(transformation(extent={{-390,170},{-370,190}})));
  BoundaryConditions.WeatherData.Bus weaBus "Weather Data Bus"
    annotation (Placement(transformation(extent={{-360,170},{-340,190}})));
  ThermalZones.Floor flo(
    redeclare package Medium = MediumA,
    lat=lat)
    "Model of a floor of the building that is served by this VAV system"
    annotation (Placement(transformation(extent={{800,280},{1128,674}})));
  Modelica.Blocks.Routing.DeMultiplex5 TRooAir
    "Demultiplex for room air temperature"
    annotation (Placement(transformation(extent={{500,80},{520,100}})));

equation
  connect(fil.port_b, heaCoi.port_a1) annotation (Line(
      points={{80,-40},{98,-40}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(TSupSetHea.y, heaCoiCon.u_s) annotation (Line(
      points={{-79,-160},{-2,-160}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fanRet.port_a, dpRetFan.port_b) annotation (Line(
      points={{310,120},{320,120},{320,60}},
      color={0,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  connect(fanSup.port_b, dpRetFan.port_a) annotation (Line(
      points={{320,-40},{320,40}},
      color={0,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  connect(senSupFlo.port_b, dpSupDuc.port_a) annotation (Line(
      points={{380,-40},{420,-40}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(controlBus, modeSelector.cb) annotation (Line(
      points={{-240,-260},{-72,-260},{-72,-207.182},{-108.818,-207.182}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(occSch.tNexOcc, controlBus.dTNexOcc) annotation (Line(
      points={{-297,-204},{-240,-204},{-240,-260}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(TOut.y, controlBus.TOut) annotation (Line(
      points={{-279,148},{-240,148},{-240,-260}},
      color={255,213,170},
      smooth=Smooth.None,
      thickness=0.5),      Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(occSch.occupied, controlBus.occupied) annotation (Line(
      points={{-297,-216},{-240,-216},{-240,-260}},
      color={255,0,255},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(min.y, controlBus.TRooMin) annotation (Line(
      points={{1221,450},{1248,450},{1248,-260},{-240,-260}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash),
                           Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(ave.y, controlBus.TRooAve) annotation (Line(
      points={{1221,420},{1248,420},{1248,-260},{-240,-260}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash),
                           Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(controlBus, conFanSup.controlBus) annotation (Line(
      points={{-240,-260},{280,-260},{280,28},{243,28},{243,18}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(valCoo.port_a, souCoo.ports[1]) annotation (Line(
      points={{230,-90},{230,-110}},
      color={0,127,0},
      smooth=Smooth.None,
      thickness=0.5));
  connect(TRet.T, conEco.TRet) annotation (Line(
      points={{90,131},{90,172},{-92,172},{-92,157.333},{-81.3333,157.333}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(TMix.T, conEco.TMix) annotation (Line(
      points={{40,-29},{40,168},{-90,168},{-90,153.333},{-81.3333,153.333}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(conEco.TSupHeaSet, TSupSetHea.y) annotation (Line(
      points={{-81.3333,145.333},{-144,145.333},{-144,-120},{-60,-120},{-60,
          -160},{-79,-160}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(controlBus, conEco.controlBus) annotation (Line(
      points={{-240,-260},{-240,120},{-76,120},{-76,150.667}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(TSetRoo.controlBus, controlBus) annotation (Line(
      points={{-288,-260},{-240,-260}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(TSup.port_a, fanSup.port_b) annotation (Line(
      points={{330,-40},{320,-40}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(TSup.port_b, senSupFlo.port_a) annotation (Line(
      points={{350,-40},{360,-40}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(fil.port_a, TMix.port_b) annotation (Line(
      points={{60,-40},{50,-40}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(conFanSup.y, fanSup.y) annotation (Line(
      points={{261,10},{310,10},{310,-28}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(cor.controlBus, controlBus) annotation (Line(
      points={{550,20.32},{550,20},{540,20},{540,-160},{480,-160},{480,-260},{
          -240,-260}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(sou.controlBus, controlBus) annotation (Line(
      points={{688,19.28},{688,18},{674,18},{674,-160},{480,-160},{480,-260},{-240,
          -260}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(eas.controlBus, controlBus) annotation (Line(
      points={{826,22.32},{812,22.32},{812,-160},{480,-160},{480,-260},{-240,
          -260}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(nor.controlBus, controlBus) annotation (Line(
      points={{966,22.32},{950,22.32},{950,-160},{480,-160},{480,-260},{-240,
          -260}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(wes.controlBus, controlBus) annotation (Line(
      points={{1104,22.32},{1092,22.32},{1092,-160},{480,-160},{480,-260},{-240,
          -260}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(TCoiHeaOut.T, heaCoiCon.u_m) annotation (Line(
      points={{144,-29},{144,-20},{160,-20},{160,-180},{10,-180},{10,-172}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(souHea.ports[1], valHea.port_a) annotation (Line(
      points={{130,-110},{130,-90}},
      color={0,127,0},
      smooth=Smooth.None,
      thickness=0.5));
  connect(heaCoiCon.y, valHea.y) annotation (Line(
      points={{21,-160},{108,-160},{108,-80},{118,-80}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(valHea.port_b, heaCoi.port_a2) annotation (Line(
      points={{130,-70},{130,-52},{118,-52}},
      color={0,127,0},
      smooth=Smooth.None,
      thickness=0.5));
  connect(heaCoi.port_b2, sinHea.ports[1]) annotation (Line(
      points={{98,-52},{90,-52},{90,-110}},
      color={0,127,0},
      smooth=Smooth.None,
      thickness=0.5));
  connect(cooCoiCon.y, valCoo.y) annotation (Line(
      points={{21,-200},{210,-200},{210,-80},{218,-80}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(eco.port_Exh, amb.ports[1]) annotation (Line(
      points={{-40,55.2},{-100,55.2},{-100,27.2},{-108,27.2}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(amb.ports[2], VOut1.port_a) annotation (Line(
      points={{-108,22.8},{-94,22.8},{-94,23},{-80,23}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(VOut1.port_b, eco.port_Out) annotation (Line(
      points={{-58,23},{-50,23},{-50,22.8},{-40,22.8}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(dpRetFan.p_rel, conFanSup.u_m) annotation (Line(
      points={{311,50},{290,50},{290,-10},{250,-10},{250,-2}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(eco.port_Sup, TMix.port_a) annotation (Line(
      points={{14,22.8},{24,22.8},{24,-40},{30,-40}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(pSetDuc.y, conFanSup.u) annotation (Line(
      points={{181,10},{238,10}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(cor.yDam, pSetDuc.u[1]) annotation (Line(
      points={{620.267,26.6667},{624,26.6667},{624,190},{140,190},{140,8.4},{
          158,8.4}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(sou.yDam, pSetDuc.u[2]) annotation (Line(
      points={{762.4,26},{774,26},{774,190},{140,190},{140,9.2},{158,9.2}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(eas.yDam, pSetDuc.u[3]) annotation (Line(
      points={{896.267,28.6667},{916,28.6667},{916,190},{140,190},{140,10},{158,
          10}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(nor.yDam, pSetDuc.u[4]) annotation (Line(
      points={{1036.27,28.6667},{1060,28.6667},{1060,190},{140,190},{140,10.8},
          {158,10.8}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(wes.yDam, pSetDuc.u[5]) annotation (Line(
      points={{1174.27,28.6667},{1196,28.6667},{1196,190},{140,190},{140,11.6},
          {158,11.6}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(heaCoi.port_b1, TCoiHeaOut.port_a) annotation (Line(
      points={{118,-40},{134,-40}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(controlBus, conFanRet.controlBus) annotation (Line(
      points={{-240,-260},{280,-260},{280,168},{243,168},{243,158}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(senSupFlo.V_flow, conFanRet.u) annotation (Line(
      points={{370,-29},{370,90},{200,90},{200,150},{238,150}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(senRetFlo.port_b, fanRet.port_a) annotation (Line(
      points={{360,120},{310,120}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(senRetFlo.V_flow, conFanRet.u_m) annotation (Line(
      points={{370,131},{370,134},{250,134},{250,138}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(conFanRet.y, fanRet.y) annotation (Line(
      points={{261,150},{300,150},{300,132}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(dpRetDuc.port_b, senRetFlo.port_a) annotation (Line(
      points={{420,120},{380,120}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(TRet.port_b, eco.port_Ret) annotation (Line(
      points={{80,120},{24,120},{24,54},{14,54},{14,55.2}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(TRet.port_a, fanRet.port_b) annotation (Line(
      points={{100,120},{290,120}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splRetRoo1.port_1, dpRetDuc.port_a) annotation (Line(
      points={{600,120},{440,120}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splRetNor.port_1, splRetEas.port_2) annotation (Line(
      points={{1014,120},{894,120}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splRetEas.port_1, splRetSou.port_2) annotation (Line(
      points={{874,120},{758,120}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splRetSou.port_1, splRetRoo1.port_2) annotation (Line(
      points={{738,120},{620,120}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(dpSupDuc.port_b, splSupRoo1.port_1) annotation (Line(
      points={{440,-40},{574,-40}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splSupRoo1.port_3, cor.port_a) annotation (Line(
      points={{584,-30},{584,20.7733}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(splSupRoo1.port_2, splSupSou.port_1) annotation (Line(
      points={{594,-40},{714,-40}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splSupSou.port_3, sou.port_a) annotation (Line(
      points={{724,-30},{724,19.76}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splSupSou.port_2, splSupEas.port_1) annotation (Line(
      points={{734,-40},{850,-40}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splSupEas.port_3, eas.port_a) annotation (Line(
      points={{860,-30},{860,22.7733}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splSupEas.port_2, splSupNor.port_1) annotation (Line(
      points={{870,-40},{990,-40}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splSupNor.port_3, nor.port_a) annotation (Line(
      points={{1000,-30},{1000,22.7733}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splSupNor.port_2, wes.port_a) annotation (Line(
      points={{1010,-40},{1138,-40},{1138,22.7733}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(TCoiHeaOut.port_b, cooCoi.port_a2) annotation (Line(
      points={{154,-40},{190,-40}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(valCoo.port_b, cooCoi.port_a1) annotation (Line(
      points={{230,-70},{230,-52},{210,-52}},
      color={0,127,0},
      smooth=Smooth.None,
      thickness=0.5));
  connect(cooCoi.port_b1, sinCoo.ports[1]) annotation (Line(
      points={{190,-52},{188,-52},{188,-110},{190,-110}},
      color={0,127,0},
      smooth=Smooth.None,
      thickness=0.5));
  connect(TSetCoo.TSet, cooCoiCon.u_s) annotation (Line(
      points={{-29,-200},{-2,-200}},
      color={0,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(TSetCoo.TSet, conEco.TSupCooSet) annotation (Line(
      points={{-29,-200},{-20,-200},{-20,-114},{-136,-114},{-136,141.333},{
          -81.3333,141.333}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(TSupSetHea.y, TSetCoo.TSetHea) annotation (Line(
      points={{-79,-160},{-60,-160},{-60,-200},{-52,-200}},
      color={0,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(modeSelector.cb, TSetCoo.controlBus) annotation (Line(
      points={{-108.818,-207.182},{-72,-207.182},{-72,-208},{-41.8,-208}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(conEco.VOut_flow, VOut1.V_flow) annotation (Line(
      points={{-81.3333,149.333},{-90,149.333},{-90,80},{-69,80},{-69,35.1}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-370,180},{-350,180}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaBus.TDryBul, TOut.u) annotation (Line(
      points={{-350,180},{-326,180},{-326,148},{-302,148}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(amb.weaBus, weaBus) annotation (Line(
      points={{-130,25.22},{-350,25.22},{-350,180}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaBus.TDryBul, pSetDuc.TOut) annotation (Line(
      points={{-350,180},{150,180},{150,18},{158,18}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(cor.port_b, flo.portsCor[1]) annotation (Line(
      points={{584,72},{586,72},{586,252},{784,252},{784,364},{918.08,364},{
          918.08,375.873}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splRetRoo1.port_3, flo.portsCor[2]) annotation (Line(
      points={{610,130},{610,242},{792,242},{792,354},{928,354},{928,375.873},{
          931.2,375.873}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(sou.port_b, flo.portsSou[1]) annotation (Line(
      points={{724,74},{724,228},{918.08,228},{918.08,323.34}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splRetSou.port_3, flo.portsSou[2]) annotation (Line(
      points={{748,130},{750,130},{750,224},{934,224},{934,323.34},{931.2,
          323.34}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(eas.port_b, flo.portsEas[1]) annotation (Line(
      points={{860,74},{860,218},{1078,218},{1078,369.307},{1078.14,369.307}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splRetEas.port_3, flo.portsEas[2]) annotation (Line(
      points={{884,130},{882,130},{882,212},{1091.26,212},{1091.26,369.307}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(nor.port_b, flo.portsNor[1]) annotation (Line(
      points={{1000,74},{1002,74},{1002,412},{918.08,412},{918.08,428.407}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splRetNor.port_3, flo.portsNor[2]) annotation (Line(
      points={{1024,130},{1024,418},{931.2,418},{931.2,428.407}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(wes.port_b, flo.portsWes[1]) annotation (Line(
      points={{1138,74},{1140,74},{1140,254},{839.36,254},{839.36,375.873}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splRetNor.port_2, flo.portsWes[2]) annotation (Line(
      points={{1034,120},{1130,120},{1130,242},{852.48,242},{852.48,375.873}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(weaBus, flo.weaBus) annotation (Line(
      points={{-350,180},{-348,180},{-348,477},{1003.36,477}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flo.TRooAir, min.u) annotation (Line(
      points={{1121.44,450.733},{1164.7,450.733},{1164.7,450},{1198,450}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(flo.TRooAir, ave.u) annotation (Line(
      points={{1121.44,450.733},{1166,450.733},{1166,420},{1198,420}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(TRooAir.y1[1], sou.TRoo) annotation (Line(
      points={{521,98},{660,98},{660,50},{683.2,50}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(TRooAir.y2[1], eas.TRoo) annotation (Line(
      points={{521,94},{808,94},{808,51.3333},{821.467,51.3333}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(TRooAir.y3[1], nor.TRoo) annotation (Line(
      points={{521,90},{950,90},{950,51.3333},{961.467,51.3333}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(TRooAir.y4[1], wes.TRoo) annotation (Line(
      points={{521,86},{1088,86},{1088,51.3333},{1099.47,51.3333}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(TRooAir.y5[1], cor.TRoo) annotation (Line(
      points={{521,82},{530,82},{530,49.3333},{545.467,49.3333}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(TRooAir.u, flo.TRooAir) annotation (Line(
      points={{498,90},{480,90},{480,500},{1164,500},{1164,450.733},{1121.44,
          450.733}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(TSup.T, cooCoiCon.u_m) annotation (Line(
      points={{340,-29},{340,-20},{356,-20},{356,-220},{10,-220},{10,-212}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(cooCoi.port_b2, fanSup.port_a) annotation (Line(
      points={{210,-40},{300,-40}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(conEco.yOA, eco.y) annotation (Line(
      points={{-59.3333,152},{-50,152},{-50,-20},{-13,-20},{-13,6.6}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-400,-400},{
            1400,600}}), graphics),
    Documentation(info="<html>
<p>
This model consist of an HVAC system, a building envelope model and a model
for air flow through building leakage and through open doors based
on wind pressure and flow imbalance of the HVAC system.
</p>
<p>
The HVAC system is a variable air volume (VAV) flow system with economizer
and a heating and cooling coil in the air handler unit. There is also a
reheat coil and an air damper in each of the five zone inlet branches.
The figure below shows the schematic diagram of the HVAC system
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Examples/VAVReheat/vavSchematics.png\" border=\"1\"/>
</p>
<p>
The control is an implementation of the control sequence
<i>VAV 2A2-21232</i> of the Sequences of Operation for
Common HVAC Systems (ASHRAE, 2006). In this control sequence, the
supply fan speed is regulated based on the duct static pressure.
The return fan controller tracks the supply fan air flow rate
reduced by a fixed offset. The duct static pressure is adjusted
so that at least one VAV damper is 90% open. The economizer dampers
are modulated to track the setpoint for the mixed air dry bulb temperature.
Priority is given to maintain a minimum outside air volume flow rate.
In each zone, the VAV damper is adjusted to meet the room temperature
setpoint for cooling, or fully opened during heating.
The room temperature setpoint for heating is tracked by varying
the water flow rate through the reheat coil. There is also a
finite state machine that transitions the mode of operation of
the HVAC system between the modes
<i>occupied</i>, <i>unoccupied off</i>, <i>unoccupied night set back</i>,
<i>unoccupied warm-up</i> and <i>unoccupied pre-cool</i>.
In the VAV model, all air flows are computed based on the
duct static pressure distribution and the performance curves of the fans.
Local loop control is implemented using proportional and proportional-integral
controllers, while the supervisory control is implemented
using a finite state machine.
</p>
<p>
To model the heat transfer through the building envelope,
a model of five interconnected rooms is used.
The five room model is representative of one floor of the
new construction medium office building for Chicago, IL,
as described in the set of DOE Commercial Building Benchmarks
(Deru et al, 2009). There are four perimeter zones and one core zone.
The envelope thermal properties meet ASHRAE Standard 90.1-2004.
The thermal room model computes transient heat conduction through
walls, floors and ceilings and long-wave radiative heat exchange between
surfaces. The convective heat transfer coefficient is computed based
on the temperature difference between the surface and the room air.
There is also a layer-by-layer short-wave radiation,
long-wave radiation, convection and conduction heat transfer model for the
windows. The model is similar to the
Window 5 model and described in TARCOG 2006.
</p>
<p>
Each thermal zone can have air flow from the HVAC system, through leakages of the building envelope (except for the core zone) and through bi-directional air exchange through open doors that connect adjacent zones. The bi-directional air exchange is modeled based on the differences in static pressure between adjacent rooms at a reference height plus the difference in static pressure across the door height as a function of the difference in air density.
There is also wind pressure acting on each facade. The wind pressure is a function
of the wind speed and wind direction. Therefore, infiltration is a function of the
flow imbalance of the HVAC system and of the wind conditions.
</p>
<h4>References</h4>
<p>
ASHRAE.
<i>Sequences of Operation for Common HVAC Systems</i>.
ASHRAE, Atlanta, GA, 2006.
</p>
<p>
Deru M., K. Field, D. Studer, K. Benne, B. Griffith, P. Torcellini,
 M. Halverson, D. Winiarski, B. Liu, M. Rosenberg, J. Huang, M. Yazdanian, and D. Crawley.
<i>DOE commercial building research benchmarks for commercial buildings</i>.
Technical report, U.S. Department of Energy, Energy Efficiency and
Renewable Energy, Office of Building Technologies, Washington, DC, 2009.
</p>
<p>
TARCOG 2006: Carli, Inc., TARCOG: Mathematical models for calculation
of thermal performance of glazing systems with our without
shading devices, Technical Report, Oct. 17, 2006.
</p>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Examples/VAVReheat/ClosedLoop.mos"
        "Simulate and plot"),
    experiment(
      StopTime=172800,
      Tolerance=1e-006));
end ClosedLoop;

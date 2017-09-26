within Buildings.Examples.VAVReheat;
model Guideline36
  "Variable air volume flow system with terminal reheat and five thermal zones"
  import Buildings;
  extends Modelica.Icons.Example;
  replaceable package MediumA =
      Buildings.Media.Air(T_default=293.15);
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

  parameter Modelica.SIunits.Temperature THeaOn=293.15
    "Heating setpoint during on";
  parameter Modelica.SIunits.Temperature THeaOff=285.15
    "Heating setpoint during off";
  parameter Modelica.SIunits.Temperature TCooOn=297.15
    "Cooling setpoint during on";
  parameter Modelica.SIunits.Temperature TCooOff=303.15
    "Cooling setpoint during off";

  Buildings.Fluid.Sources.Outside amb(redeclare package Medium = MediumA, nPorts=2)
    "Ambient conditions"
    annotation (Placement(transformation(extent={{-130,14},{-108,36}})));
  Buildings.Fluid.FixedResistances.PressureDrop fil(
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
  Buildings.Fluid.FixedResistances.PressureDrop dpSupDuc(
    m_flow_nominal=m_flow_nominal,
    redeclare package Medium = MediumA,
    dp_nominal=20) "Pressure drop for supply duct"
    annotation (Placement(transformation(extent={{420,-50},{440,-30}})));
  Buildings.Fluid.FixedResistances.PressureDrop dpRetDuc(
    m_flow_nominal=m_flow_nominal,
    redeclare package Medium = MediumA,
    dp_nominal=20) "Pressure drop for return duct"
    annotation (Placement(transformation(extent={{440,110},{420,130}})));
  Buildings.Fluid.Movers.SpeedControlled_y fanSup(
    redeclare package Medium = MediumA,
    tau=60,
    per(pressure(V_flow={0,m_flow_nominal/1.2*2}, dp={850,0})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Supply air fan"
    annotation (Placement(transformation(extent={{300,-50},{320,-30}})));
  Buildings.Fluid.Movers.SpeedControlled_y fanRet(
    redeclare package Medium = MediumA,
    tau=60,
    per(pressure(V_flow=m_flow_nominal/1.2*{0,2}, dp=1.5*110*{2,0})),
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
  Buildings.Fluid.Sensors.RelativePressure dpRetFan(
      redeclare package Medium = MediumA) "Pressure difference over return fan"
                                            annotation (Placement(
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
    T=279.15) "Source for cooling coil" annotation (Placement(transformation(
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
    annotation (Placement(transformation(extent={{-298,-276},{-278,-256}})));
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
    annotation (Placement(transformation(extent={{570,20},{610,60}})));
  Buildings.Examples.VAVReheat.ThermalZones.VAVBranch
                                                    sou(
    redeclare package MediumA = MediumA,
    redeclare package MediumW = MediumW,
    m_flow_nominal=m0_flow_sou,
    VRoo=VRooSou) "South-facing thermal zone"
    annotation (Placement(transformation(extent={{750,20},{790,60}})));
  Buildings.Examples.VAVReheat.ThermalZones.VAVBranch
                                                    eas(
    redeclare package MediumA = MediumA,
    redeclare package MediumW = MediumW,
    m_flow_nominal=m0_flow_eas,
    VRoo=VRooEas) "East-facing thermal zone"
    annotation (Placement(transformation(extent={{930,20},{970,60}})));
  Buildings.Examples.VAVReheat.ThermalZones.VAVBranch
                                                    nor(
    redeclare package MediumA = MediumA,
    redeclare package MediumW = MediumW,
    m_flow_nominal=m0_flow_nor,
    VRoo=VRooNor) "North-facing thermal zone"
    annotation (Placement(transformation(extent={{1090,20},{1130,60}})));
  Buildings.Examples.VAVReheat.ThermalZones.VAVBranch
                                                    wes(
    redeclare package MediumA = MediumA,
    redeclare package MediumW = MediumW,
    m_flow_nominal=m0_flow_wes,
    VRoo=VRooWes) "West-facing thermal zone"
    annotation (Placement(transformation(extent={{1290,20},{1330,60}})));
  Controls.FanVFD conFanRet(xSet_nominal(displayUnit="m3/s") = m_flow_nominal/
      1.2, r_N_min=0.2) "Controller for fan"
    annotation (Placement(transformation(extent={{240,140},{260,160}})));
  Buildings.Fluid.Sensors.VolumeFlowRate senRetFlo(redeclare package Medium =
        MediumA, m_flow_nominal=m_flow_nominal)
    "Sensor for return fan flow rate"
    annotation (Placement(transformation(extent={{380,110},{360,130}})));
  Buildings.Fluid.FixedResistances.Junction splRetRoo1(
    redeclare package Medium = MediumA,
    m_flow_nominal={m_flow_nominal,m_flow_nominal - m0_flow_cor,m0_flow_cor},
    dp_nominal(displayUnit="Pa") = {10,10,10},
    from_dp=false,
    linearized=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Splitter for room return"
    annotation (Placement(transformation(extent={{600,130},{620,110}})));
  Buildings.Fluid.FixedResistances.Junction splRetSou(
    redeclare package Medium = MediumA,
    m_flow_nominal={m0_flow_sou + m0_flow_eas + m0_flow_nor + m0_flow_wes,
        m0_flow_eas + m0_flow_nor + m0_flow_wes,m0_flow_sou},
    dp_nominal(displayUnit="Pa") = {10,10,10},
    from_dp=false,
    linearized=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Splitter for room return"
    annotation (Placement(transformation(extent={{782,130},{802,110}})));
  Buildings.Fluid.FixedResistances.Junction splRetEas(
    redeclare package Medium = MediumA,
    m_flow_nominal={m0_flow_eas + m0_flow_nor + m0_flow_wes,m0_flow_nor +
        m0_flow_wes,m0_flow_eas},
    dp_nominal(displayUnit="Pa") = {10,10,10},
    from_dp=false,
    linearized=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Splitter for room return"
    annotation (Placement(transformation(extent={{962,130},{982,110}})));
  Buildings.Fluid.FixedResistances.Junction splRetNor(
    redeclare package Medium = MediumA,
    m_flow_nominal={m0_flow_nor + m0_flow_wes,m0_flow_wes,m0_flow_nor},
    dp_nominal(displayUnit="Pa") = {10,10,10},
    from_dp=false,
    linearized=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Splitter for room return"
    annotation (Placement(transformation(extent={{1112,130},{1132,110}})));
  Buildings.Fluid.FixedResistances.Junction splSupRoo1(
    redeclare package Medium = MediumA,
    m_flow_nominal={m_flow_nominal,m_flow_nominal - m0_flow_cor,m0_flow_cor},
    dp_nominal(displayUnit="Pa") = {10,10,10},
    from_dp=true,
    linearized=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Splitter for room supply"
    annotation (Placement(transformation(extent={{570,-30},{590,-50}})));
  Buildings.Fluid.FixedResistances.Junction splSupSou(
    redeclare package Medium = MediumA,
    m_flow_nominal={m0_flow_sou + m0_flow_eas + m0_flow_nor + m0_flow_wes,
        m0_flow_eas + m0_flow_nor + m0_flow_wes,m0_flow_sou},
    dp_nominal(displayUnit="Pa") = {10,10,10},
    from_dp=true,
    linearized=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Splitter for room supply"
    annotation (Placement(transformation(extent={{750,-30},{770,-50}})));
  Buildings.Fluid.FixedResistances.Junction splSupEas(
    redeclare package Medium = MediumA,
    m_flow_nominal={m0_flow_eas + m0_flow_nor + m0_flow_wes,m0_flow_nor +
        m0_flow_wes,m0_flow_eas},
    dp_nominal(displayUnit="Pa") = {10,10,10},
    from_dp=true,
    linearized=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Splitter for room supply"
    annotation (Placement(transformation(extent={{930,-30},{950,-50}})));
  Buildings.Fluid.FixedResistances.Junction splSupNor(
    redeclare package Medium = MediumA,
    m_flow_nominal={m0_flow_nor + m0_flow_wes,m0_flow_wes,m0_flow_nor},
    dp_nominal(displayUnit="Pa") = {10,10,10},
    from_dp=true,
    linearized=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Splitter for room supply"
    annotation (Placement(transformation(extent={{1090,-30},{1110,-50}})));
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
    annotation (Placement(transformation(extent={{772,280},{1100,674}})));
  Modelica.Blocks.Routing.DeMultiplex5 TRooAir
    "Demultiplex for room air temperature"
    annotation (Placement(transformation(extent={{490,160},{510,180}})));

  Buildings.Examples.VAVReheat.Controls.RoomVAVGuideline36
                   conVAVCor "Controller for terminal unit corridor"
    annotation (Placement(transformation(extent={{530,32},{550,52}})));
  Fluid.Sensors.TemperatureTwoPort TSupCor(
    redeclare package Medium = MediumA,
    initType=Modelica.Blocks.Types.Init.InitialState,
    m_flow_nominal=m0_flow_cor) "Supply air temperature" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={580,90})));
  Fluid.Sensors.TemperatureTwoPort TSupSou(
    redeclare package Medium = MediumA,
    initType=Modelica.Blocks.Types.Init.InitialState,
    m_flow_nominal=m0_flow_sou) "Supply air temperature" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={760,90})));
  Fluid.Sensors.TemperatureTwoPort TSupEas(
    redeclare package Medium = MediumA,
    initType=Modelica.Blocks.Types.Init.InitialState,
    m_flow_nominal=m0_flow_eas) "Supply air temperature" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={940,88})));
  Fluid.Sensors.TemperatureTwoPort TSupNor(
    redeclare package Medium = MediumA,
    initType=Modelica.Blocks.Types.Init.InitialState,
    m_flow_nominal=m0_flow_nor) "Supply air temperature" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={1100,92})));
  Fluid.Sensors.TemperatureTwoPort TSupWes(
    redeclare package Medium = MediumA,
    initType=Modelica.Blocks.Types.Init.InitialState,
    m_flow_nominal=m0_flow_wes) "Supply air temperature" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={1302,90})));
  Buildings.Examples.VAVReheat.Controls.RoomVAVGuideline36
                   conVAVSou "Controller for terminal unit south"
    annotation (Placement(transformation(extent={{700,30},{720,50}})));
  Buildings.Examples.VAVReheat.Controls.RoomVAVGuideline36
                   conVAVEas "Controller for terminal unit east"
    annotation (Placement(transformation(extent={{880,30},{900,50}})));
  Buildings.Examples.VAVReheat.Controls.RoomVAVGuideline36
                   conVAVNor "Controller for terminal unit north"
    annotation (Placement(transformation(extent={{1040,30},{1060,50}})));
  Buildings.Examples.VAVReheat.Controls.RoomVAVGuideline36
                   conVAVWes "Controller for terminal unit west"
    annotation (Placement(transformation(extent={{1240,28},{1260,48}})));
  Buildings.Examples.VAVReheat.Controls.AHUGuideline36 conAHU
    annotation (Placement(transformation(extent={{300,290},{340,398}})));
  Buildings.Examples.VAVReheat.Controls.ZoneSetPointsGuideline36 TSetZon1(
    THeaOn=THeaOn,
    THeaOff=THeaOff,
    TCooOff=TCooOff) annotation (Placement(transformation(rotation=0, extent={{
            68,296},{88,316}})));
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
      points={{1221,450},{1400,450},{1400,-260},{-240,-260}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash),
                           Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(ave.y, controlBus.TRooAve) annotation (Line(
      points={{1221,420},{1400,420},{1400,-260},{-240,-260}},
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
      points={{-286,-260},{-240,-260}},
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
      points={{1112,120},{982,120}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splRetEas.port_1, splRetSou.port_2) annotation (Line(
      points={{962,120},{802,120}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splRetSou.port_1, splRetRoo1.port_2) annotation (Line(
      points={{782,120},{620,120}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(dpSupDuc.port_b, splSupRoo1.port_1) annotation (Line(
      points={{440,-40},{570,-40}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splSupRoo1.port_3, cor.port_a) annotation (Line(
      points={{580,-30},{580,20}},
      color={0,127,255},
      thickness=0.5));
  connect(splSupRoo1.port_2, splSupSou.port_1) annotation (Line(
      points={{590,-40},{750,-40}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splSupSou.port_3, sou.port_a) annotation (Line(
      points={{760,-30},{760,20}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splSupSou.port_2, splSupEas.port_1) annotation (Line(
      points={{770,-40},{930,-40}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splSupEas.port_3, eas.port_a) annotation (Line(
      points={{940,-30},{940,20}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splSupEas.port_2, splSupNor.port_1) annotation (Line(
      points={{950,-40},{1090,-40}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splSupNor.port_3, nor.port_a) annotation (Line(
      points={{1100,-30},{1100,20}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splSupNor.port_2, wes.port_a) annotation (Line(
      points={{1110,-40},{1300,-40},{1300,20}},
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
  connect(splRetRoo1.port_3, flo.portsCor[2]) annotation (Line(
      points={{610,130},{610,242},{790,242},{790,354},{930,354},{930,375.873},{
          903.2,375.873}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splRetSou.port_3, flo.portsSou[2]) annotation (Line(
      points={{792,130},{792,226},{926,226},{926,323.34},{903.2,323.34}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splRetEas.port_3, flo.portsEas[2]) annotation (Line(
      points={{972,130},{972,214},{1063.26,214},{1063.26,369.307}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splRetNor.port_3, flo.portsNor[2]) annotation (Line(
      points={{1122,130},{1122,418},{903.2,418},{903.2,428.407}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splRetNor.port_2, flo.portsWes[2]) annotation (Line(
      points={{1132,120},{1312,120},{1312,256},{824.48,256},{824.48,375.873}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(weaBus, flo.weaBus) annotation (Line(
      points={{-350,180},{-348,180},{-348,477},{975.36,477}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flo.TRooAir, min.u) annotation (Line(
      points={{1093.44,450.733},{1164.7,450.733},{1164.7,450},{1198,450}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(flo.TRooAir, ave.u) annotation (Line(
      points={{1093.44,450.733},{1166,450.733},{1166,420},{1198,420}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(TRooAir.u, flo.TRooAir) annotation (Line(
      points={{488,170},{480,170},{480,500},{1164,500},{1164,450.733},{1093.44,
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
  connect(cor.port_b, TSupCor.port_a) annotation (Line(
      points={{580,60},{580,80}},
      color={0,127,255},
      thickness=0.5));
  connect(TSupCor.port_b, flo.portsCor[1]) annotation (Line(
      points={{580,100},{580,250},{784,250},{784,362},{890.08,362},{890.08,
          375.873}},
      color={0,127,255},
      thickness=0.5));

  connect(sou.port_b, TSupSou.port_a) annotation (Line(
      points={{760,60},{760,80}},
      color={0,127,255},
      thickness=0.5));
  connect(eas.port_b, TSupEas.port_a) annotation (Line(
      points={{940,60},{940,78}},
      color={0,127,255},
      thickness=0.5));
  connect(nor.port_b, TSupNor.port_a) annotation (Line(
      points={{1100,60},{1100,82}},
      color={0,127,255},
      thickness=0.5));
  connect(wes.port_b, TSupWes.port_a) annotation (Line(
      points={{1300,60},{1300,80},{1302,80}},
      color={0,127,255},
      thickness=0.5));
  connect(TSupSou.port_b, flo.portsSou[1]) annotation (Line(
      points={{760,100},{760,234},{890.08,234},{890.08,323.34}},
      color={0,127,255},
      thickness=0.5));
  connect(TSupEas.port_b, flo.portsEas[1]) annotation (Line(
      points={{940,98},{940,220},{1050.14,220},{1050.14,369.307}},
      color={0,127,255},
      thickness=0.5));
  connect(TSupNor.port_b, flo.portsNor[1]) annotation (Line(
      points={{1100,102},{1100,414},{890.08,414},{890.08,428.407}},
      color={0,127,255},
      thickness=0.5));
  connect(TSupWes.port_b, flo.portsWes[1]) annotation (Line(
      points={{1302,100},{1302,248},{811.36,248},{811.36,375.873}},
      color={0,127,255},
      thickness=0.5));
  connect(conVAVCor.TRoo, TRooAir.y5[1]) annotation (Line(points={{528,42},{520,
          42},{520,162},{511,162}}, color={0,0,127},
      pattern=LinePattern.Dash));
  connect(conVAVSou.TRoo, TRooAir.y1[1]) annotation (Line(points={{698,40},{690,
          40},{690,36},{680,36},{680,178},{511,178}}, color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TRooAir.y2[1], conVAVEas.TRoo) annotation (Line(points={{511,174},{868,
          174},{868,40},{878,40}}, color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TRooAir.y3[1], conVAVNor.TRoo) annotation (Line(points={{511,170},{1028,
          170},{1028,40},{1038,40}}, color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TRooAir.y4[1], conVAVWes.TRoo) annotation (Line(points={{511,166},{1220,
          166},{1220,38},{1238,38}}, color={0,0,127},
      pattern=LinePattern.Dash));
  connect(conVAVCor.yDam, pSetDuc.u[1]) annotation (Line(points={{551,47.8667},
          {556,47.8667},{556,72},{120,72},{120,8.4},{158,8.4}},
                                                        color={0,0,127}));
  connect(conVAVSou.yDam, pSetDuc.u[2]) annotation (Line(points={{721,45.8667},
          {730,45.8667},{730,72},{120,72},{120,9.2},{158,9.2}},
                                                        color={0,0,127}));
  connect(pSetDuc.u[3], conVAVEas.yDam) annotation (Line(points={{158,10},{130,
          10},{130,10},{120,10},{120,72},{910,72},{910,45.8667},{901,45.8667}},
                                                                      color={0,0,
          127}));
  connect(conVAVNor.yDam, pSetDuc.u[4]) annotation (Line(points={{1061,45.8667},
          {1072,45.8667},{1072,72},{120,72},{120,10},{160,10},{160,10.8},{158,
          10.8}},      color={0,0,127}));
  connect(conVAVCor.TDis, TSupCor.T) annotation (Line(points={{528,39.3333},{
          522,39.3333},{522,34},{514,34},{514,90},{569,90}},
                                                color={0,0,127}));
  connect(TSupSou.T,conVAVSou.TDis)  annotation (Line(points={{749,90},{688,90},
          {688,37.3333},{698,37.3333}},
                              color={0,0,127}));
  connect(TSupEas.T,conVAVEas.TDis)  annotation (Line(points={{929,88},{872,88},
          {872,37.3333},{878,37.3333}},
                              color={0,0,127}));
  connect(TSupNor.T,conVAVNor.TDis)  annotation (Line(points={{1089,92},{1032,
          92},{1032,37.3333},{1038,37.3333}},
                                color={0,0,127}));
  connect(TSupWes.T,conVAVWes.TDis)  annotation (Line(points={{1291,90},{1228,
          90},{1228,35.3333},{1238,35.3333}},
                                color={0,0,127}));
  connect(conVAVWes.yDam, pSetDuc.u[5]) annotation (Line(points={{1261,43.8667},
          {1270,43.8667},{1270,72},{120,72},{120,11.6},{158,11.6}},
                                                           color={0,0,127}));
  connect(cor.yVAV, conVAVCor.yDam) annotation (Line(points={{566,48},{556,48},
          {556,47.8667},{551,47.8667}},
                                 color={0,0,127}));
  connect(cor.yVal, conVAVCor.yVal) annotation (Line(points={{566,32},{560,32},
          {560,41.3333},{551,41.3333}},
                             color={0,0,127}));
  connect(conVAVSou.yDam, sou.yVAV) annotation (Line(points={{721,45.8667},{730,
          45.8667},{730,48},{746,48}},
                              color={0,0,127}));
  connect(conVAVSou.yVal, sou.yVal) annotation (Line(points={{721,39.3333},{
          732.5,39.3333},{732.5,32},{746,32}},
                                color={0,0,127}));
  connect(conVAVEas.yVal, eas.yVal) annotation (Line(points={{901,39.3333},{
          912.5,39.3333},{912.5,32},{926,32}},
                                color={0,0,127}));
  connect(conVAVEas.yDam, eas.yVAV) annotation (Line(points={{901,45.8667},{910,
          45.8667},{910,48},{926,48}},
                              color={0,0,127}));
  connect(conVAVNor.yDam, nor.yVAV) annotation (Line(points={{1061,45.8667},{
          1072.5,45.8667},{1072.5,48},{1086,48}},
                                        color={0,0,127}));
  connect(conVAVNor.yVal, nor.yVal) annotation (Line(points={{1061,39.3333},{
          1072.5,39.3333},{1072.5,32},{1086,32}},
                                  color={0,0,127}));
  connect(conVAVCor.TRooHeaSet, controlBus.TRooSetHea) annotation (Line(points={
          {528,50},{480,50},{480,-260},{-240,-260}}, color={0,0,127}));
  connect(conVAVCor.TRooCooSet, controlBus.TRooSetCoo) annotation (Line(points={{528,
          47.3333},{480,47.3333},{480,-260},{-240,-260}},
                                                     color={0,0,127}));
  connect(conVAVSou.TRooHeaSet, controlBus.TRooSetHea) annotation (Line(points={{698,48},
          {660,48},{660,-260},{-240,-260}},          color={0,0,127}));
  connect(conVAVSou.TRooCooSet, controlBus.TRooSetCoo) annotation (Line(points={{698,
          45.3333},{660,45.3333},{660,-260},{-240,-260}},
                                                     color={0,0,127}));
  connect(conVAVEas.TRooHeaSet, controlBus.TRooSetHea) annotation (Line(points={{878,48},
          {850,48},{850,-260},{-240,-260}},          color={0,0,127}));
  connect(conVAVEas.TRooCooSet, controlBus.TRooSetCoo) annotation (Line(points={{878,
          45.3333},{850,45.3333},{850,-260},{-240,-260}},
                                                     color={0,0,127}));
  connect(conVAVNor.TRooHeaSet, controlBus.TRooSetHea) annotation (Line(points={{1038,48},
          {1020,48},{1020,-260},{-240,-260}},        color={0,0,127}));
  connect(conVAVNor.TRooCooSet, controlBus.TRooSetCoo) annotation (Line(points={{1038,
          45.3333},{1020,45.3333},{1020,-260},{-240,-260}},
                                                     color={0,0,127}));
  connect(conVAVWes.TRooHeaSet, controlBus.TRooSetHea) annotation (Line(points={{1238,46},
          {1202,46},{1202,-260},{-240,-260}},        color={0,0,127}));
  connect(conVAVWes.TRooCooSet, controlBus.TRooSetCoo) annotation (Line(points={{1238,
          43.3333},{1202,43.3333},{1202,-260},{-240,-260}},
                                                     color={0,0,127}));

  connect(conVAVWes.yVal, wes.yVal) annotation (Line(points={{1261,37.3333},{
          1272.5,37.3333},{1272.5,32},{1286,32}},
                                      color={0,0,127}));
  connect(wes.yVAV, conVAVWes.yDam) annotation (Line(points={{1286,48},{1274,48},
          {1274,43.8667},{1261,43.8667}},
                                    color={0,0,127}));
  connect(TSetZon1.uOcc, occSch.occupied) annotation (Line(points={{76,296},{
          -120,296},{-120,290},{-258,290},{-258,-216},{-297,-216}}, color={255,
          0,255}));
  connect(occSch.tNexOcc, TSetZon1.tNexOcc) annotation (Line(points={{-297,-204},
          {-254,-204},{-254,286},{-118,286},{-118,296},{72,296}}, color={0,0,
          127}));
  connect(TSetZon1.TZon, flo.TRooAir) annotation (Line(points={{80,296},{80,500},
          {1164,500},{1164,450.733},{1093.44,450.733}}, color={0,0,127}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-400,-400},{1660,
            600}})),
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
</html>", revisions="<html>
<ul>
<li>
May 19, 2016, by Michael Wetter:<br/>
Changed chilled water supply temperature to <i>6&circ;C</i>.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/509\">#509</a>.
</li>
<li>
April 26, 2016, by Michael Wetter:<br/>
Changed controller for freeze protection as the old implementation closed
the outdoor air damper during summer.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/511\">#511</a>.
</li>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
September 24, 2015 by Michael Wetter:<br/>
Set default temperature for medium to avoid conflicting
start values for alias variables of the temperature
of the building and the ambient air.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/426\">issue 426</a>.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Examples/VAVReheat/ClosedLoop.mos"
        "Simulate and plot"),
    experiment(
      StopTime=172800,
      Tolerance=1e-08));
end Guideline36;

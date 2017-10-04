within Buildings.Examples.VAVReheat.BaseClasses;
partial model PartialOpenLoop
  "Partial model of variable air volume flow system with terminal reheat and five thermal zones"
  replaceable package MediumA = Buildings.Media.Air (T_default=293.15);
  package MediumW = Buildings.Media.Water "Medium model for water";

  constant Integer numZon=5 "Total number of served zones/VAV boxes";

  parameter Modelica.SIunits.Volume VRooCor=2698 "Room volume corridor";
  parameter Modelica.SIunits.Volume VRooSou=568.77 "Room volume south";
  parameter Modelica.SIunits.Volume VRooNor=568.77 "Room volume north";
  parameter Modelica.SIunits.Volume VRooEas=360.08 "Room volume east";
  parameter Modelica.SIunits.Volume VRooWes=360.08 "Room volume west";

  constant Real conv=1.2/3600 "Conversion factor for nominal mass flow rate";
  parameter Modelica.SIunits.MassFlowRate mCor_flow_nominal=6*VRooCor*conv
    "Design mass flow rate core";
  parameter Modelica.SIunits.MassFlowRate mSou_flow_nominal=7*VRooSou*conv
    "Design mass flow rate perimeter 1";
  parameter Modelica.SIunits.MassFlowRate mEas_flow_nominal=10*VRooEas*conv
    "Design mass flow rate perimeter 2";
  parameter Modelica.SIunits.MassFlowRate mNor_flow_nominal=7*VRooNor*conv
    "Design mass flow rate perimeter 3";
  parameter Modelica.SIunits.MassFlowRate mWes_flow_nominal=10*VRooWes*conv
    "Design mass flow rate perimeter 4";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=mCor_flow_nominal +
      mSou_flow_nominal + mEas_flow_nominal + mNor_flow_nominal +
      mWes_flow_nominal "Nominal mass flow rate";
  parameter Modelica.SIunits.Angle lat=41.98*3.14159/180 "Latitude";

  parameter Modelica.SIunits.Temperature THeaOn=293.15
    "Heating setpoint during on";
  parameter Modelica.SIunits.Temperature THeaOff=285.15
    "Heating setpoint during off";
  parameter Modelica.SIunits.Temperature TCooOn=297.15
    "Cooling setpoint during on";
  parameter Modelica.SIunits.Temperature TCooOff=303.15
    "Cooling setpoint during off";

  parameter Boolean allowFlowReversal=true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation (Evaluate=true);

  Buildings.Fluid.Sources.Outside amb(redeclare package Medium = MediumA,
      nPorts=2) "Ambient conditions"
    annotation (Placement(transformation(extent={{-130,14},{-108,36}})));
  Buildings.Fluid.HeatExchangers.DryEffectivenessNTU heaCoi(
    redeclare package Medium1 = MediumA,
    redeclare package Medium2 = MediumW,
    m1_flow_nominal=m_flow_nominal,
    m2_flow_nominal=m_flow_nominal*1000*(10 - (-20))/4200/10,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    Q_flow_nominal=m_flow_nominal*1006*(16.7 - 8.5),
    dp2_nominal=0,
    dp1_nominal=200 + 200 + 100 + 20,
    allowFlowReversal1=allowFlowReversal,
    allowFlowReversal2=false,
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
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal1=false,
    allowFlowReversal2=allowFlowReversal) "Cooling coil"
    annotation (Placement(transformation(extent={{210,-36},{190,-56}})));
  Buildings.Fluid.FixedResistances.PressureDrop dpRetDuc(
    m_flow_nominal=m_flow_nominal,
    redeclare package Medium = MediumA,
    dp_nominal=20,
    allowFlowReversal=allowFlowReversal) "Pressure drop for return duct"
    annotation (Placement(transformation(extent={{400,130},{380,150}})));
  Buildings.Fluid.Movers.SpeedControlled_y fanSup(
    redeclare package Medium = MediumA,
    tau=60,
    per(
      pressure(V_flow={0,m_flow_nominal/1.2*2},
      dp={850,0})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Supply air fan"
    annotation (Placement(transformation(extent={{300,-50},{320,-30}})));
  Buildings.Fluid.Movers.SpeedControlled_y fanRet(
    redeclare package Medium = MediumA,
    tau=60,
    per(
      pressure(V_flow=m_flow_nominal/1.2*{0,2},
      dp=1.5*110*{2,0})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Return air fan"
    annotation (Placement(transformation(extent={{320,130},{300,150}})));

  Controls.FanVFD conFanRet(xSet_nominal(displayUnit="m3/s") = m_flow_nominal/
      1.2, r_N_min=0.1) "Controller for fan"
    annotation (Placement(transformation(extent={{240,160},{260,180}})));

  Buildings.Fluid.Sensors.VolumeFlowRate senSupFlo(
  redeclare package Medium = MediumA,
  m_flow_nominal=m_flow_nominal)
    "Sensor for supply fan flow rate"
    annotation (Placement(transformation(extent={{400,-50},{420,-30}})));

  Buildings.Fluid.Sensors.VolumeFlowRate senRetFlo(
  redeclare package Medium = MediumA,
  m_flow_nominal=m_flow_nominal)
    "Sensor for return fan flow rate"
    annotation (Placement(transformation(extent={{360,130},{340,150}})));

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
    annotation (Placement(transformation(extent={{-300,170},{-280,190}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TSup(
    redeclare package Medium = MediumA,
    m_flow_nominal=m_flow_nominal,
    allowFlowReversal=allowFlowReversal)
    annotation (Placement(transformation(extent={{330,-50},{350,-30}})));
  Buildings.Fluid.Sensors.RelativePressure dpRetFan(redeclare package Medium =
        MediumA) "Pressure difference over return fan" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={320,50})));
  Buildings.Controls.SetPoints.OccupancySchedule occSch(occupancy=3600*{6,19})
    "Occupancy schedule"
    annotation (Placement(transformation(extent={{-318,-220},{-298,-200}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TCoiHeaOut(
    redeclare package Medium = MediumA,
    m_flow_nominal=m_flow_nominal,
    allowFlowReversal=allowFlowReversal) "Heating coil outlet temperature"
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
    dpFixed_nominal=6000) "Cooling coil valve" annotation (Placement(
        transformation(
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
  Buildings.Fluid.Sensors.TemperatureTwoPort TRet(
    redeclare package Medium = MediumA,
    m_flow_nominal=m_flow_nominal,
    allowFlowReversal=allowFlowReversal) "Return air temperature sensor"
    annotation (Placement(transformation(extent={{110,130},{90,150}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TMix(
    redeclare package Medium = MediumA,
    m_flow_nominal=m_flow_nominal,
    allowFlowReversal=allowFlowReversal) "Mixed air temperature sensor"
    annotation (Placement(transformation(extent={{30,-50},{50,-30}})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear valHea(
    redeclare package Medium = MediumW,
    CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    dpValve_nominal=6000,
    m_flow_nominal=m_flow_nominal*1000*40/4200/10,
    from_dp=true,
    dpFixed_nominal=6000) "Heating coil valve" annotation (Placement(
        transformation(
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
  Buildings.Fluid.Sensors.VolumeFlowRate VOut1(redeclare package Medium =
        MediumA, m_flow_nominal=m_flow_nominal) "Outside air volume flow rate"
    annotation (Placement(transformation(extent={{-80,12},{-58,34}})));
  Buildings.Examples.VAVReheat.ThermalZones.VAVBranch cor(
    redeclare package MediumA = MediumA,
    redeclare package MediumW = MediumW,
    m_flow_nominal=mCor_flow_nominal,
    VRoo=VRooCor,
    allowFlowReversal=allowFlowReversal)
    "Zone for core of buildings (azimuth will be neglected)"
    annotation (Placement(transformation(extent={{570,22},{610,62}})));
  Buildings.Examples.VAVReheat.ThermalZones.VAVBranch sou(
    redeclare package MediumA = MediumA,
    redeclare package MediumW = MediumW,
    m_flow_nominal=mSou_flow_nominal,
    VRoo=VRooSou,
    allowFlowReversal=allowFlowReversal) "South-facing thermal zone"
    annotation (Placement(transformation(extent={{750,20},{790,60}})));
  Buildings.Examples.VAVReheat.ThermalZones.VAVBranch eas(
    redeclare package MediumA = MediumA,
    redeclare package MediumW = MediumW,
    m_flow_nominal=mEas_flow_nominal,
    VRoo=VRooEas,
    allowFlowReversal=allowFlowReversal) "East-facing thermal zone"
    annotation (Placement(transformation(extent={{930,20},{970,60}})));
  Buildings.Examples.VAVReheat.ThermalZones.VAVBranch nor(
    redeclare package MediumA = MediumA,
    redeclare package MediumW = MediumW,
    m_flow_nominal=mNor_flow_nominal,
    VRoo=VRooNor,
    allowFlowReversal=allowFlowReversal) "North-facing thermal zone"
    annotation (Placement(transformation(extent={{1090,20},{1130,60}})));
  Buildings.Examples.VAVReheat.ThermalZones.VAVBranch wes(
    redeclare package MediumA = MediumA,
    redeclare package MediumW = MediumW,
    m_flow_nominal=mWes_flow_nominal,
    VRoo=VRooWes,
    allowFlowReversal=allowFlowReversal) "West-facing thermal zone"
    annotation (Placement(transformation(extent={{1290,20},{1330,60}})));
  Buildings.Fluid.FixedResistances.Junction splRetRoo1(
    redeclare package Medium = MediumA,
    m_flow_nominal={m_flow_nominal,m_flow_nominal - mCor_flow_nominal,
        mCor_flow_nominal},
    from_dp=false,
    linearized=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal(displayUnit="Pa") = {0,0,0},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering)
    "Splitter for room return"
    annotation (Placement(transformation(extent={{630,10},{650,-10}})));
  Buildings.Fluid.FixedResistances.Junction splRetSou(
    redeclare package Medium = MediumA,
    m_flow_nominal={mSou_flow_nominal + mEas_flow_nominal + mNor_flow_nominal
         + mWes_flow_nominal,mEas_flow_nominal + mNor_flow_nominal +
        mWes_flow_nominal,mSou_flow_nominal},
    from_dp=false,
    linearized=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal(displayUnit="Pa") = {0,0,0},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering)
    "Splitter for room return"
    annotation (Placement(transformation(extent={{812,10},{832,-10}})));
  Buildings.Fluid.FixedResistances.Junction splRetEas(
    redeclare package Medium = MediumA,
    m_flow_nominal={mEas_flow_nominal + mNor_flow_nominal + mWes_flow_nominal,
        mNor_flow_nominal + mWes_flow_nominal,mEas_flow_nominal},
    from_dp=false,
    linearized=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal(displayUnit="Pa") = {0,0,0},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering)
    "Splitter for room return"
    annotation (Placement(transformation(extent={{992,10},{1012,-10}})));
  Buildings.Fluid.FixedResistances.Junction splRetNor(
    redeclare package Medium = MediumA,
    m_flow_nominal={mNor_flow_nominal + mWes_flow_nominal,mWes_flow_nominal,
        mNor_flow_nominal},
    from_dp=false,
    linearized=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal(displayUnit="Pa") = {0,0,0},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering)
    "Splitter for room return"
    annotation (Placement(transformation(extent={{1142,10},{1162,-10}})));
  Buildings.Fluid.FixedResistances.Junction splSupRoo1(
    redeclare package Medium = MediumA,
    m_flow_nominal={m_flow_nominal,m_flow_nominal - mCor_flow_nominal,
        mCor_flow_nominal},
    from_dp=true,
    linearized=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal(displayUnit="Pa") = {0,0,0},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving)
    "Splitter for room supply"
    annotation (Placement(transformation(extent={{570,-30},{590,-50}})));
  Buildings.Fluid.FixedResistances.Junction splSupSou(
    redeclare package Medium = MediumA,
    m_flow_nominal={mSou_flow_nominal + mEas_flow_nominal + mNor_flow_nominal
         + mWes_flow_nominal,mEas_flow_nominal + mNor_flow_nominal +
        mWes_flow_nominal,mSou_flow_nominal},
    from_dp=true,
    linearized=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal(displayUnit="Pa") = {0,0,0},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving)
    "Splitter for room supply"
    annotation (Placement(transformation(extent={{750,-30},{770,-50}})));
  Buildings.Fluid.FixedResistances.Junction splSupEas(
    redeclare package Medium = MediumA,
    m_flow_nominal={mEas_flow_nominal + mNor_flow_nominal + mWes_flow_nominal,
        mNor_flow_nominal + mWes_flow_nominal,mEas_flow_nominal},
    from_dp=true,
    linearized=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal(displayUnit="Pa") = {0,0,0},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving)
    "Splitter for room supply"
    annotation (Placement(transformation(extent={{930,-30},{950,-50}})));
  Buildings.Fluid.FixedResistances.Junction splSupNor(
    redeclare package Medium = MediumA,
    m_flow_nominal={mNor_flow_nominal + mWes_flow_nominal,mWes_flow_nominal,
        mNor_flow_nominal},
    from_dp=true,
    linearized=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal(displayUnit="Pa") = {0,0,0},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving)
    "Splitter for room supply"
    annotation (Placement(transformation(extent={{1090,-30},{1110,-50}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    annotation (Placement(transformation(extent={{-390,170},{-370,190}})));
  BoundaryConditions.WeatherData.Bus weaBus "Weather Data Bus"
    annotation (Placement(transformation(extent={{-360,170},{-340,190}})));
  ThermalZones.Floor flo(redeclare package Medium = MediumA, lat=lat)
    "Model of a floor of the building that is served by this VAV system"
    annotation (Placement(transformation(extent={{772,396},{1100,616}})));
  Modelica.Blocks.Routing.DeMultiplex5 TRooAir
    "Demultiplex for room air temperature"
    annotation (Placement(transformation(extent={{490,160},{510,180}})));

  Fluid.Sensors.TemperatureTwoPort TSupCor(
    redeclare package Medium = MediumA,
    initType=Modelica.Blocks.Types.Init.InitialState,
    m_flow_nominal=mCor_flow_nominal,
    allowFlowReversal=allowFlowReversal) "Discharge air temperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={580,92})));
  Fluid.Sensors.TemperatureTwoPort TSupSou(
    redeclare package Medium = MediumA,
    initType=Modelica.Blocks.Types.Init.InitialState,
    m_flow_nominal=mSou_flow_nominal,
    allowFlowReversal=allowFlowReversal) "Discharge air temperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={760,92})));
  Fluid.Sensors.TemperatureTwoPort TSupEas(
    redeclare package Medium = MediumA,
    initType=Modelica.Blocks.Types.Init.InitialState,
    m_flow_nominal=mEas_flow_nominal,
    allowFlowReversal=allowFlowReversal) "Discharge air temperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={940,90})));
  Fluid.Sensors.TemperatureTwoPort TSupNor(
    redeclare package Medium = MediumA,
    initType=Modelica.Blocks.Types.Init.InitialState,
    m_flow_nominal=mNor_flow_nominal,
    allowFlowReversal=allowFlowReversal) "Discharge air temperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={1100,94})));
  Fluid.Sensors.TemperatureTwoPort TSupWes(
    redeclare package Medium = MediumA,
    initType=Modelica.Blocks.Types.Init.InitialState,
    m_flow_nominal=mWes_flow_nominal,
    allowFlowReversal=allowFlowReversal) "Discharge air temperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={1300,90})));
  Fluid.Sensors.VolumeFlowRate VSupCor_flow(
    redeclare package Medium = MediumA,
    initType=Modelica.Blocks.Types.Init.InitialState,
    m_flow_nominal=mCor_flow_nominal,
    allowFlowReversal=allowFlowReversal) "Discharge air flow rate" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={580,130})));
  Fluid.Sensors.VolumeFlowRate VSupSou_flow(
    redeclare package Medium = MediumA,
    initType=Modelica.Blocks.Types.Init.InitialState,
    m_flow_nominal=mSou_flow_nominal,
    allowFlowReversal=allowFlowReversal) "Discharge air flow rate" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={760,130})));
  Fluid.Sensors.VolumeFlowRate VSupEas_flow(
    redeclare package Medium = MediumA,
    initType=Modelica.Blocks.Types.Init.InitialState,
    m_flow_nominal=mEas_flow_nominal,
    allowFlowReversal=allowFlowReversal) "Discharge air flow rate" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={940,128})));
  Fluid.Sensors.VolumeFlowRate VSupNor_flow(
    redeclare package Medium = MediumA,
    initType=Modelica.Blocks.Types.Init.InitialState,
    m_flow_nominal=mNor_flow_nominal,
    allowFlowReversal=allowFlowReversal) "Discharge air flow rate" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={1100,132})));
  Fluid.Sensors.VolumeFlowRate VSupWes_flow(
    redeclare package Medium = MediumA,
    initType=Modelica.Blocks.Types.Init.InitialState,
    m_flow_nominal=mWes_flow_nominal,
    allowFlowReversal=allowFlowReversal) "Discharge air flow rate" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={1300,128})));
  IdealEconomizer eco(redeclare package Medium = MediumA, m_flow_nominal=
        m_flow_nominal) "Economizer" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,-46})));
equation
  connect(fanRet.port_a, dpRetFan.port_b) annotation (Line(
      points={{320,140},{320,60}},
      color={0,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  connect(fanSup.port_b, dpRetFan.port_a) annotation (Line(
      points={{320,-40},{320,0},{320,0},{320,40}},
      color={0,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  connect(valCoo.port_a, souCoo.ports[1]) annotation (Line(
      points={{230,-90},{230,-110}},
      color={0,127,0},
      smooth=Smooth.None,
      thickness=0.5));
  connect(TSup.port_a, fanSup.port_b) annotation (Line(
      points={{330,-40},{320,-40}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(souHea.ports[1], valHea.port_a) annotation (Line(
      points={{130,-110},{130,-90}},
      color={0,127,0},
      smooth=Smooth.None,
      thickness=0.5));
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
  connect(amb.ports[1], VOut1.port_a) annotation (Line(
      points={{-108,27.2},{-94,27.2},{-94,23},{-80,23}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(heaCoi.port_b1, TCoiHeaOut.port_a) annotation (Line(
      points={{118,-40},{134,-40}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(TRet.port_a, fanRet.port_b) annotation (Line(
      points={{110,140},{300,140}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splRetRoo1.port_1, dpRetDuc.port_a) annotation (Line(
      points={{630,0},{440,0},{440,140},{400,140}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splRetNor.port_1, splRetEas.port_2) annotation (Line(
      points={{1142,0},{1110,0},{1110,0},{1078,0},{1078,0},{1012,0}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splRetEas.port_1, splRetSou.port_2) annotation (Line(
      points={{992,0},{952,0},{952,0},{912,0},{912,0},{832,0}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splRetSou.port_1, splRetRoo1.port_2) annotation (Line(
      points={{812,0},{650,0}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splSupRoo1.port_3, cor.port_a) annotation (Line(
      points={{580,-30},{580,22}},
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
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-370,180},{-350,180}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaBus.TDryBul, TOut.u) annotation (Line(
      points={{-350,180},{-302,180}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(amb.weaBus, weaBus) annotation (Line(
      points={{-130,25.22},{-350,25.22},{-350,180}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(splRetRoo1.port_3, flo.portsCor[2]) annotation (Line(
      points={{640,10},{640,364},{874,364},{874,472},{898,472},{898,485.222},{
          903.2,485.222}},
      color={0,127,255},
      thickness=0.5));
  connect(splRetSou.port_3, flo.portsSou[2]) annotation (Line(
      points={{822,10},{822,350},{900,350},{900,436.333},{903.2,436.333}},
      color={0,127,255},
      thickness=0.5));
  connect(splRetEas.port_3, flo.portsEas[2]) annotation (Line(
      points={{1002,10},{1002,368},{1063.26,368},{1063.26,479.111}},
      color={0,127,255},
      thickness=0.5));
  connect(splRetNor.port_3, flo.portsNor[2]) annotation (Line(
      points={{1152,10},{1152,446},{903.2,446},{903.2,534.111}},
      color={0,127,255},
      thickness=0.5));
  connect(splRetNor.port_2, flo.portsWes[2]) annotation (Line(
      points={{1162,0},{1342,0},{1342,394},{824.48,394},{824.48,485.222}},
      color={0,127,255},
      thickness=0.5));
  connect(weaBus, flo.weaBus) annotation (Line(
      points={{-350,180},{-348,180},{-348,579.333},{975.36,579.333}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(flo.TRooAir, min.u) annotation (Line(
      points={{1093.44,554.889},{1164.7,554.889},{1164.7,450},{1198,450}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(flo.TRooAir, ave.u) annotation (Line(
      points={{1093.44,554.889},{1166,554.889},{1166,420},{1198,420}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(TRooAir.u, flo.TRooAir) annotation (Line(
      points={{488,170},{480,170},{480,618},{1164,618},{1164,554.889},{1093.44,
          554.889}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(cooCoi.port_b2, fanSup.port_a) annotation (Line(
      points={{210,-40},{300,-40}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(cor.port_b, TSupCor.port_a) annotation (Line(
      points={{580,62},{580,82}},
      color={0,127,255},
      thickness=0.5));

  connect(sou.port_b, TSupSou.port_a) annotation (Line(
      points={{760,60},{760,82}},
      color={0,127,255},
      thickness=0.5));
  connect(eas.port_b, TSupEas.port_a) annotation (Line(
      points={{940,60},{940,80}},
      color={0,127,255},
      thickness=0.5));
  connect(nor.port_b, TSupNor.port_a) annotation (Line(
      points={{1100,60},{1100,84}},
      color={0,127,255},
      thickness=0.5));
  connect(wes.port_b, TSupWes.port_a) annotation (Line(
      points={{1300,60},{1300,80}},
      color={0,127,255},
      thickness=0.5));

  connect(TSupCor.port_b, VSupCor_flow.port_a) annotation (Line(
      points={{580,102},{580,120}},
      color={0,127,255},
      thickness=0.5));
  connect(TSupSou.port_b, VSupSou_flow.port_a) annotation (Line(
      points={{760,102},{760,120}},
      color={0,127,255},
      thickness=0.5));
  connect(TSupEas.port_b, VSupEas_flow.port_a) annotation (Line(
      points={{940,100},{940,100},{940,118}},
      color={0,127,255},
      thickness=0.5));
  connect(TSupNor.port_b, VSupNor_flow.port_a) annotation (Line(
      points={{1100,104},{1100,122}},
      color={0,127,255},
      thickness=0.5));
  connect(TSupWes.port_b, VSupWes_flow.port_a) annotation (Line(
      points={{1300,100},{1300,118}},
      color={0,127,255},
      thickness=0.5));
  connect(VSupCor_flow.port_b, flo.portsCor[1]) annotation (Line(
      points={{580,140},{580,372},{866,372},{866,480},{890.08,480},{890.08,
          485.222}},
      color={0,127,255},
      thickness=0.5));
  connect(VSupSou_flow.port_b, flo.portsSou[1]) annotation (Line(
      points={{760,140},{760,356},{890.08,356},{890.08,436.333}},
      color={0,127,255},
      thickness=0.5));
  connect(VSupEas_flow.port_b, flo.portsEas[1]) annotation (Line(
      points={{940,138},{940,376},{1050.14,376},{1050.14,479.111}},
      color={0,127,255},
      thickness=0.5));
  connect(VSupNor_flow.port_b, flo.portsNor[1]) annotation (Line(
      points={{1100,142},{1100,498},{890.08,498},{890.08,534.111}},
      color={0,127,255},
      thickness=0.5));
  connect(VSupWes_flow.port_b, flo.portsWes[1]) annotation (Line(
      points={{1300,138},{1300,384},{811.36,384},{811.36,485.222}},
      color={0,127,255},
      thickness=0.5));
  connect(TMix.port_b, heaCoi.port_a1) annotation (Line(
      points={{50,-40},{98,-40}},
      color={0,127,255},
      thickness=0.5));
  connect(VOut1.port_b, eco.port_Out) annotation (Line(points={{-58,23},{-40,23},
          {-40,-40},{-20,-40}}, color={0,127,255}));
  connect(eco.port_Sup, TMix.port_a)
    annotation (Line(points={{0,-40},{30,-40}}, color={0,127,255}));
  connect(eco.port_Exh, amb.ports[2]) annotation (Line(points={{-20,-52},{-46,
          -52},{-46,4},{-98,4},{-98,22.8},{-108,22.8}}, color={0,127,255}));
  connect(eco.port_Ret, TRet.port_b) annotation (Line(points={{0,-52},{10,-52},
          {10,140},{90,140}}, color={0,127,255}));
  connect(fanRet.port_a, senRetFlo.port_b)
    annotation (Line(points={{320,140},{340,140}}, color={0,127,255}));
  connect(senRetFlo.port_a, dpRetDuc.port_b)
    annotation (Line(points={{360,140},{380,140}}, color={0,127,255}));
  connect(TSup.port_b, senSupFlo.port_a)
    annotation (Line(points={{350,-40},{400,-40}}, color={0,127,255}));
  connect(senSupFlo.port_b, splSupRoo1.port_1)
    annotation (Line(points={{420,-40},{570,-40}}, color={0,127,255}));
  connect(conFanRet.u_m, senRetFlo.V_flow) annotation (Line(points={{250,158},{
          250,148},{270,148},{270,160},{350,160},{350,151}}, color={0,0,127}));
  connect(senSupFlo.V_flow, conFanRet.u) annotation (Line(points={{410,-29},{
          410,70},{220,70},{220,170},{238,170}}, color={0,0,127}));
  connect(conFanRet.y, fanRet.y)
    annotation (Line(points={{261,170},{310,170},{310,152}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-400,
            -400},{1660,600}})), Documentation(info="<html>
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
September 26, 2017, by Michael Wetter:<br/>
Separated physical model from control to facilitate implementation of alternate control
sequences.
</li>
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
</html>"));
end PartialOpenLoop;

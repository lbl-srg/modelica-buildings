within Buildings.Examples.VAVReheat.BaseClasses;
partial model PartialHVAC
  "Partial model of variable air volume flow system with terminal reheat that serves five thermal zones"

  replaceable package MediumA = Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialCondensingGases "Medium model for air";
  replaceable package MediumW = Buildings.Media.Water "Medium model for water";

  constant Integer numZon=5 "Total number of served VAV boxes";

  parameter Modelica.SIunits.Volume VRooCor
    "Room volume corridor";
  parameter Modelica.SIunits.Volume VRooSou
    "Room volume south";
  parameter Modelica.SIunits.Volume VRooNor
    "Room volume north";
  parameter Modelica.SIunits.Volume VRooEas
    "Room volume east";
  parameter Modelica.SIunits.Volume VRooWes
    "Room volume west";

  parameter Modelica.SIunits.Area AFloCor "Floor area corridor";
  parameter Modelica.SIunits.Area AFloSou "Floor area south";
  parameter Modelica.SIunits.Area AFloNor "Floor area north";
  parameter Modelica.SIunits.Area AFloEas "Floor area east";
  parameter Modelica.SIunits.Area AFloWes "Floor area west";

  final parameter Modelica.SIunits.Area AFlo[numZon]={AFloCor,AFloSou,AFloEas,
      AFloNor,AFloWes} "Floor area of each zone";
  final parameter Modelica.SIunits.Area ATot=sum(AFlo) "Total floor area";

  constant Real conv=1.2/3600 "Conversion factor for nominal mass flow rate";

  parameter Modelica.SIunits.MassFlowRate mCor_flow_nominal
    "Design mass flow rate core";
  parameter Modelica.SIunits.MassFlowRate mSou_flow_nominal
    "Design mass flow rate south";
  parameter Modelica.SIunits.MassFlowRate mEas_flow_nominal
    "Design mass flow rate east";
  parameter Modelica.SIunits.MassFlowRate mNor_flow_nominal
    "Design mass flow rate north";
  parameter Modelica.SIunits.MassFlowRate mWes_flow_nominal
    "Design mass flow rate west";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal "Nominal mass flow rate";

  parameter Modelica.SIunits.MassFlowRate mHeaWat_flow_nominal=m_flow_nominal*1000*
      (10 - (-20))/4200/10 "Nominal water mass flow rate for heating coil in AHU";
  parameter Modelica.SIunits.MassFlowRate mCooWat_flow_nominal=m_flow_nominal*1000*
      15/4200/10 "Nominal water mass flow rate for cooling coil";

  parameter Real ratVFloHea(final unit="1") = 0.3
    "VAV box maximum air flow rate ratio in heating mode";

  parameter Real ratOAFlo_A(final unit="m3/(s.m2)") = 0.3e-3
    "Outdoor airflow rate required per unit area";
  parameter Real ratOAFlo_P = 2.5e-3
    "Outdoor airflow rate required per person";
  parameter Real ratP_A = 5e-2
    "Occupant density";
  parameter Real effZ(final unit="1") = 0.8
    "Zone air distribution effectiveness (limiting value)";
  parameter Real divP(final unit="1") = 0.7
    "Occupant diversity ratio";
  parameter Modelica.SIunits.VolumeFlowRate VCorOA_flow_nominal=
    (ratOAFlo_P * ratP_A + ratOAFlo_A) * AFloCor / effZ
    "Zone outdoor air flow rate";
  parameter Modelica.SIunits.VolumeFlowRate VSouOA_flow_nominal=
    (ratOAFlo_P * ratP_A + ratOAFlo_A) * AFloSou / effZ
    "Zone outdoor air flow rate";
  parameter Modelica.SIunits.VolumeFlowRate VEasOA_flow_nominal=
    (ratOAFlo_P * ratP_A + ratOAFlo_A) * AFloEas / effZ
    "Zone outdoor air flow rate";
  parameter Modelica.SIunits.VolumeFlowRate VNorOA_flow_nominal=
    (ratOAFlo_P * ratP_A + ratOAFlo_A) * AFloNor / effZ
    "Zone outdoor air flow rate";
  parameter Modelica.SIunits.VolumeFlowRate VWesOA_flow_nominal=
    (ratOAFlo_P * ratP_A + ratOAFlo_A) * AFloWes / effZ
    "Zone outdoor air flow rate";
  parameter Modelica.SIunits.VolumeFlowRate Vou_flow_nominal=
    (divP * ratOAFlo_P * ratP_A + ratOAFlo_A) * sum(
      {AFloCor, AFloSou, AFloNor, AFloEas, AFloWes})
    "System uncorrected outdoor air flow rate";
  parameter Real effVen(final unit="1") = if divP < 0.6 then
    0.88 * divP + 0.22 else 0.75
    "System ventilation efficiency";
  parameter Modelica.SIunits.VolumeFlowRate Vot_flow_nominal=
    Vou_flow_nominal / effVen
    "System design outdoor air flow rate";

  parameter Modelica.SIunits.Temperature THeaOn=293.15
    "Heating setpoint during on";
  parameter Modelica.SIunits.Temperature THeaOff=285.15
    "Heating setpoint during off";
  parameter Modelica.SIunits.Temperature TCooOn=297.15
    "Cooling setpoint during on";
  parameter Modelica.SIunits.Temperature TCooOff=303.15
    "Cooling setpoint during off";
  parameter Modelica.SIunits.PressureDifference dpBuiStaSet(min=0) = 12
    "Building static pressure";
  parameter Real yFanMin = 0.1 "Minimum fan speed";

  parameter Modelica.SIunits.Temperature THotWatInl_nominal(
    displayUnit="degC")
    "Reheat coil nominal inlet water temperature";

  parameter Boolean allowFlowReversal=true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation (Evaluate=true);

  Modelica.Fluid.Interfaces.FluidPort_a port_supAir[numZon](redeclare package
      Medium = MediumA)
    "Supply air to thermal zones"
    annotation (Placement(transformation(extent={{1410,150},{1430,170}}),
        iconTransformation(extent={{432,190},{452,210}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_retAir[numZon](redeclare package
      Medium = MediumA)
    "Return air from thermal zones"
    annotation (Placement(transformation(extent={{1410,110},{1430,130}}),
        iconTransformation(extent={{432,20},{452,40}})));

  Modelica.Blocks.Interfaces.RealInput TRoo[numZon](
   each final unit="K",
   each displayUnit="degC")
   "Room temperatures"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-400,320}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-220,180})));

  Buildings.Fluid.Sources.Outside amb(redeclare package Medium = MediumA,
      nPorts=2) "Ambient conditions"
    annotation (Placement(transformation(extent={{-136,-56},{-114,-34}})));

  Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU heaCoi(
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumA,
    m1_flow_nominal=mHeaWat_flow_nominal,
    m2_flow_nominal=m_flow_nominal,
    show_T=true,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    Q_flow_nominal=m_flow_nominal*1006*(16.7 - 4),
    dp1_nominal=3000,
    dp2_nominal=200 + 200 + 100 + 40,
    allowFlowReversal1=false,
    allowFlowReversal2=allowFlowReversal,
    T_a1_nominal=THotWatInl_nominal,
    T_a2_nominal=277.15)
    "Heating coil"
    annotation (Placement(transformation(extent={{118,-36},{98,-56}})));

  Fluid.HeatExchangers.WetCoilEffectivenessNTU cooCoi(
    show_T=true,
    UA_nominal=3*m_flow_nominal*1000*15/
      Buildings.Fluid.HeatExchangers.BaseClasses.lmtd(
      T_a1=26.2,
      T_b1=12.8,
      T_a2=6,
      T_b2=16),
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumA,
    m1_flow_nominal=mCooWat_flow_nominal,
    m2_flow_nominal=m_flow_nominal,
    dp2_nominal=0,
    dp1_nominal=3000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal1=false,
    allowFlowReversal2=allowFlowReversal) "Cooling coil"
    annotation (Placement(transformation(extent={{210,-36},{190,-56}})));
  Buildings.Fluid.FixedResistances.PressureDrop dpRetDuc(
    m_flow_nominal=m_flow_nominal,
    redeclare package Medium = MediumA,
    allowFlowReversal=allowFlowReversal,
    dp_nominal=40) "Pressure drop for return duct"
    annotation (Placement(transformation(extent={{400,130},{380,150}})));
  Buildings.Fluid.Movers.SpeedControlled_y fanSup(
    redeclare package Medium = MediumA,
    per(pressure(V_flow={0,m_flow_nominal/1.2*2}, dp=2*{780 + 10 + dpBuiStaSet,
            0})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Supply air fan"
    annotation (Placement(transformation(extent={{300,-50},{320,-30}})));

  Buildings.Fluid.Sensors.VolumeFlowRate senSupFlo(redeclare package Medium =
        MediumA, m_flow_nominal=m_flow_nominal)
    "Sensor for supply fan flow rate"
    annotation (Placement(transformation(extent={{400,-50},{420,-30}})));

  Buildings.Fluid.Sensors.VolumeFlowRate senRetFlo(redeclare package Medium =
        MediumA, m_flow_nominal=m_flow_nominal)
    "Sensor for return fan flow rate"
    annotation (Placement(transformation(extent={{360,130},{340,150}})));

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
  Buildings.Fluid.Sensors.RelativePressure dpDisSupFan(redeclare package Medium =
        MediumA) "Supply fan static discharge pressure" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={320,0})));
  Buildings.Controls.SetPoints.OccupancySchedule occSch(occupancy=3600*{6,19})
    "Occupancy schedule"
    annotation (Placement(transformation(extent={{-320,-220},{-300,-200}})));
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
  Buildings.Fluid.Sensors.VolumeFlowRate VOut1(redeclare package Medium =
        MediumA, m_flow_nominal=m_flow_nominal) "Outside air volume flow rate"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));

  Buildings.Examples.VAVReheat.BaseClasses.VAVReheatBox cor(
    redeclare package MediumA = MediumA,
    redeclare package MediumW = MediumW,
    m_flow_nominal=mCor_flow_nominal,
    VRoo=VRooCor,
    allowFlowReversal=allowFlowReversal,
    ratVFloHea=ratVFloHea,
    THotWatInl_nominal=THotWatInl_nominal,
    THotWatOut_nominal=THotWatInl_nominal-10,
    TAirInl_nominal=12+273.15,
    QHea_flow_nominal=mCor_flow_nominal*ratVFloHea*cpAir*(32-12))
    "Zone for core of building"
    annotation (Placement(transformation(extent={{570,22},{610,62}})));
  Buildings.Examples.VAVReheat.BaseClasses.VAVReheatBox sou(
    redeclare package MediumA = MediumA,
    redeclare package MediumW = MediumW,
    m_flow_nominal=mSou_flow_nominal,
    VRoo=VRooSou,
    allowFlowReversal=allowFlowReversal,
    ratVFloHea=ratVFloHea,
    THotWatInl_nominal=THotWatInl_nominal,
    THotWatOut_nominal=THotWatInl_nominal-10,
    TAirInl_nominal=12+273.15,
    QHea_flow_nominal=mSou_flow_nominal*ratVFloHea*cpAir*(32-12))
    "South-facing thermal zone"
    annotation (Placement(transformation(extent={{750,20},{790,60}})));
  Buildings.Examples.VAVReheat.BaseClasses.VAVReheatBox eas(
    redeclare package MediumA = MediumA,
    redeclare package MediumW = MediumW,
    m_flow_nominal=mEas_flow_nominal,
    VRoo=VRooEas,
    allowFlowReversal=allowFlowReversal,
    ratVFloHea=ratVFloHea,
    THotWatInl_nominal=THotWatInl_nominal,
    THotWatOut_nominal=THotWatInl_nominal-10,
    TAirInl_nominal=12+273.15,
    QHea_flow_nominal=mEas_flow_nominal*ratVFloHea*cpAir*(32-12))
    "East-facing thermal zone"
    annotation (Placement(transformation(extent={{930,20},{970,60}})));
  Buildings.Examples.VAVReheat.BaseClasses.VAVReheatBox nor(
    redeclare package MediumA = MediumA,
    redeclare package MediumW = MediumW,
    m_flow_nominal=mNor_flow_nominal,
    VRoo=VRooNor,
    allowFlowReversal=allowFlowReversal,
    ratVFloHea=ratVFloHea,
    THotWatInl_nominal=THotWatInl_nominal,
    THotWatOut_nominal=THotWatInl_nominal-10,
    TAirInl_nominal=12+273.15,
    QHea_flow_nominal=mNor_flow_nominal*ratVFloHea*cpAir*(32-12))
    "North-facing thermal zone"
    annotation (Placement(transformation(extent={{1090,20},{1130,60}})));
  Buildings.Examples.VAVReheat.BaseClasses.VAVReheatBox wes(
    redeclare package MediumA = MediumA,
    redeclare package MediumW = MediumW,
    m_flow_nominal=mWes_flow_nominal,
    VRoo=VRooWes,
    allowFlowReversal=allowFlowReversal,
    ratVFloHea=ratVFloHea,
    THotWatInl_nominal=THotWatInl_nominal,
    THotWatOut_nominal=THotWatInl_nominal-10,
    TAirInl_nominal=12+273.15,
    QHea_flow_nominal=mWes_flow_nominal*ratVFloHea*cpAir*(32-12))
    "West-facing thermal zone"
    annotation (Placement(transformation(extent={{1290,20},{1330,60}})));
  Buildings.Fluid.FixedResistances.Junction splRetRoo1(
    redeclare package Medium = MediumA,
    m_flow_nominal={m_flow_nominal,m_flow_nominal - mCor_flow_nominal,
        mCor_flow_nominal},
    from_dp=false,
    linearized=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal(each displayUnit="Pa") = {0,0,0},
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
    dp_nominal(each displayUnit="Pa") = {0,0,0},
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
    dp_nominal(each displayUnit="Pa") = {0,0,0},
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
    dp_nominal(each displayUnit="Pa") = {0,0,0},
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
    dp_nominal(each displayUnit="Pa") = {0,0,0},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving)
    "Splitter for room supply"
    annotation (Placement(transformation(extent={{580,-30},{600,-50}})));
  Buildings.Fluid.FixedResistances.Junction splSupSou(
    redeclare package Medium = MediumA,
    m_flow_nominal={mSou_flow_nominal + mEas_flow_nominal + mNor_flow_nominal
         + mWes_flow_nominal,mEas_flow_nominal + mNor_flow_nominal +
        mWes_flow_nominal,mSou_flow_nominal},
    from_dp=true,
    linearized=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal(each displayUnit="Pa") = {0,0,0},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving)
    "Splitter for room supply"
    annotation (Placement(transformation(extent={{760,-30},{780,-50}})));
  Buildings.Fluid.FixedResistances.Junction splSupEas(
    redeclare package Medium = MediumA,
    m_flow_nominal={mEas_flow_nominal + mNor_flow_nominal + mWes_flow_nominal,
        mNor_flow_nominal + mWes_flow_nominal,mEas_flow_nominal},
    from_dp=true,
    linearized=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal(each displayUnit="Pa") = {0,0,0},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving)
    "Splitter for room supply"
    annotation (Placement(transformation(extent={{940,-30},{960,-50}})));
  Buildings.Fluid.FixedResistances.Junction splSupNor(
    redeclare package Medium = MediumA,
    m_flow_nominal={mNor_flow_nominal + mWes_flow_nominal,mWes_flow_nominal,
        mNor_flow_nominal},
    from_dp=true,
    linearized=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal(each displayUnit="Pa") = {0,0,0},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving)
    "Splitter for room supply"
    annotation (Placement(transformation(extent={{1100,-30},{1120,-50}})));
  BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-330,170},{-310,190}}),
        iconTransformation(extent={{-168,134},{-148,154}})));

  Modelica.Blocks.Routing.DeMultiplex5 TRooAir(
    u(each unit="K",
      each displayUnit="degC")) "Demultiplex for room air temperature"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={490,290})));

  Results res(
    final A=ATot,
    PFan=fanSup.P + 0,
    PPum=pumHeaCoi.P + pumCooCoi.P,
    PHea=heaCoi.Q2_flow + cor.terHea.Q2_flow + nor.terHea.Q2_flow + wes.terHea.Q2_flow + eas.terHea.Q2_flow + sou.terHea.Q2_flow,
    PCooSen=cooCoi.QSen2_flow,
    PCooLat=cooCoi.QLat2_flow) "Results of the simulation";

  Fluid.Actuators.Dampers.Exponential damRet(
    redeclare package Medium = MediumA,
    m_flow_nominal=m_flow_nominal,
    from_dp=false,
    riseTime=15,
    dpDamper_nominal=5,
    dpFixed_nominal=5) "Return air damper"
                        annotation (Placement(transformation(
        origin={0,-10},
        extent={{10,-10},{-10,10}},
        rotation=90)));
  Fluid.Actuators.Dampers.Exponential damOut(
    redeclare package Medium = MediumA,
    m_flow_nominal=m_flow_nominal,
    from_dp=false,
    riseTime=15,
    dpDamper_nominal=5,
    dpFixed_nominal=5) "Outdoor air damper"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Fluid.FixedResistances.Junction splCooSup(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCooWat_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal(each displayUnit="Pa") = {0,0,0},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving) "Flow splitter"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={220,-170})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage valCooCoi(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCooWat_flow_nominal,
    dpValve_nominal=6000,
    dpFixed_nominal=0) "Valve for cooling coil"    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={220,-210})));
  Fluid.FixedResistances.Junction splCooRet(
    redeclare package Medium = MediumW,
    m_flow_nominal=mCooWat_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal(each displayUnit="Pa") = {0,0,0},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving) "Flow splitter"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={180,-170})));
  Fluid.Movers.SpeedControlled_y pumCooCoi(
    redeclare package Medium = MediumW,
    per(pressure(V_flow={0,mCooWat_flow_nominal/1000*2}, dp=2*{3000,0})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Supply air fan"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={180,-120})));
  Fluid.Movers.SpeedControlled_y pumHeaCoi(
    redeclare package Medium = MediumW,
    per(pressure(V_flow={0,mHeaWat_flow_nominal/1000*2}, dp=2*{3000,0})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Pump for heating coil" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={128,-120})));

  Fluid.Actuators.Valves.TwoWayEqualPercentage valHeaCoi(
    redeclare package Medium = MediumW,
    m_flow_nominal=mHeaWat_flow_nominal,
    dpValve_nominal=6000,
    dpFixed_nominal=0) "Valve for heating coil" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={128,-210})));
  Fluid.FixedResistances.Junction splHeaRet(
    redeclare package Medium = MediumW,
    m_flow_nominal=mHeaWat_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal(each displayUnit="Pa") = {0,0,0},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving) "Flow splitter"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={88,-170})));
  Fluid.FixedResistances.Junction splHeaSup(
    redeclare package Medium = MediumW,
    m_flow_nominal=mHeaWat_flow_nominal*{1,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal(each displayUnit="Pa") = {0,0,0},
    portFlowDirection_1=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=if allowFlowReversal then Modelica.Fluid.Types.PortFlowDirection.Bidirectional
         else Modelica.Fluid.Types.PortFlowDirection.Leaving) "Flow splitter"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={128,-170})));


  Modelica.Fluid.Interfaces.FluidPort_a portHeaCoiSup(redeclare package Medium =
        MediumW) "Heating coil loop supply"
    annotation (Placement(transformation(extent={{70,-310},{90,-290}}),
        iconTransformation(extent={{-30,-150},{-10,-130}})));
  Modelica.Fluid.Interfaces.FluidPort_b portHeaCoiRet(redeclare package Medium =
        MediumW) "Heating coil loop return" annotation (Placement(
        transformation(extent={{110,-310},{130,-290}}),
                                                      iconTransformation(extent={{30,-150},
            {50,-130}})));
  Modelica.Fluid.Interfaces.FluidPort_a portHeaTerSup(redeclare package Medium =
        MediumW) "Terminal heat loop supply"
    annotation (Placement(transformation(extent={{450,-310},{470,-290}}),
        iconTransformation(extent={{250,-150},{270,-130}})));
  Modelica.Fluid.Interfaces.FluidPort_b portHeaTerRet(redeclare package Medium =
        MediumW) "Terminal heat loop return" annotation (Placement(
        transformation(extent={{490,-310},{510,-290}}),
                                                      iconTransformation(extent={{310,
            -150},{330,-130}})));
  Modelica.Fluid.Interfaces.FluidPort_a portCooCoiSup(redeclare package Medium =
        MediumW) "Cooling coil loop supply"
    annotation (Placement(transformation(extent={{190,-310},{210,-290}}),
        iconTransformation(extent={{110,-150},{130,-130}})));
  Modelica.Fluid.Interfaces.FluidPort_b portCooCoiRet(redeclare package Medium =
        MediumW)
    "Coolin coil loop return"
    annotation (Placement(transformation(extent={{230,-310},{250,-290}}),
        iconTransformation(extent={{170,-150},{190,-130}})));
protected
  constant Modelica.SIunits.SpecificHeatCapacity cpAir=
    Buildings.Utilities.Psychrometrics.Constants.cpAir
    "Air specific heat capacity";
  constant Modelica.SIunits.SpecificHeatCapacity cpWatLiq=
    Buildings.Utilities.Psychrometrics.Constants.cpWatLiq
    "Water specific heat capacity";
  model Results "Model to store the results of the simulation"
    parameter Modelica.SIunits.Area A "Floor area";
    input Modelica.SIunits.Power PFan "Fan energy";
    input Modelica.SIunits.Power PPum "Pump energy";
    input Modelica.SIunits.Power PHea "Heating energy";
    input Modelica.SIunits.Power PCooSen "Sensible cooling energy";
    input Modelica.SIunits.Power PCooLat "Latent cooling energy";

    Real EFan(
      unit="J/m2",
      start=0,
      nominal=1E5,
      fixed=true) "Fan energy";
    Real EPum(
      unit="J/m2",
      start=0,
      nominal=1E5,
      fixed=true) "Pump energy";
    Real EHea(
      unit="J/m2",
      start=0,
      nominal=1E5,
      fixed=true) "Heating energy";
    Real ECooSen(
      unit="J/m2",
      start=0,
      nominal=1E5,
      fixed=true) "Sensible cooling energy";
    Real ECooLat(
      unit="J/m2",
      start=0,
      nominal=1E5,
      fixed=true) "Latent cooling energy";
    Real ECoo(unit="J/m2") "Total cooling energy";
  equation

    A*der(EFan) = PFan;
    A*der(EPum) = PPum;
    A*der(EHea) = PHea;
    A*der(ECooSen) = PCooSen;
    A*der(ECooLat) = PCooLat;
    ECoo = ECooSen + ECooLat;

  end Results;
equation
  connect(fanSup.port_b, dpDisSupFan.port_a) annotation (Line(
      points={{320,-40},{320,-10}},
      color={0,0,0},
      smooth=Smooth.None,
      pattern=LinePattern.Dot));
  connect(TSup.port_a, fanSup.port_b) annotation (Line(
      points={{330,-40},{320,-40}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(amb.ports[1], VOut1.port_a) annotation (Line(
      points={{-114,-46.1},{-94,-46.1},{-94,-40},{-90,-40}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splRetRoo1.port_1, dpRetDuc.port_a) annotation (Line(
      points={{630,0},{430,0},{430,140},{400,140}},
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
  connect(splSupRoo1.port_3, cor.port_aAir) annotation (Line(
      points={{590,-30},{590,-4},{590,22},{590,22}},
      color={0,127,255},
      thickness=0.5));
  connect(splSupRoo1.port_2, splSupSou.port_1) annotation (Line(
      points={{600,-40},{760,-40}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splSupSou.port_3, sou.port_aAir) annotation (Line(
      points={{770,-30},{770,-6},{770,20},{770,20}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splSupSou.port_2, splSupEas.port_1) annotation (Line(
      points={{780,-40},{940,-40}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splSupEas.port_3, eas.port_aAir) annotation (Line(
      points={{950,-30},{950,-6},{950,20},{950,20}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splSupEas.port_2, splSupNor.port_1) annotation (Line(
      points={{960,-40},{1100,-40}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splSupNor.port_3, nor.port_aAir) annotation (Line(
      points={{1110,-30},{1110,-6},{1110,20},{1110,20}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(splSupNor.port_2, wes.port_aAir) annotation (Line(
      points={{1120,-40},{1310,-40},{1310,20}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(weaBus.TDryBul, TOut.u) annotation (Line(
      points={{-320,180},{-302,180}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(amb.weaBus, weaBus) annotation (Line(
      points={{-136,-44.78},{-320,-44.78},{-320,180}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));

  connect(cooCoi.port_b2, fanSup.port_a) annotation (Line(
      points={{210,-40},{300,-40}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));


  connect(senRetFlo.port_a, dpRetDuc.port_b)
    annotation (Line(points={{360,140},{380,140}}, color={0,127,255}));
  connect(TSup.port_b, senSupFlo.port_a)
    annotation (Line(points={{350,-40},{400,-40}}, color={0,127,255}));
  connect(senSupFlo.port_b, splSupRoo1.port_1)
    annotation (Line(points={{420,-40},{580,-40}}, color={0,127,255}));
  connect(dpDisSupFan.port_b, amb.ports[2]) annotation (Line(
      points={{320,10},{320,14},{-106,14},{-106,-48},{-110,-48},{-110,-43.9},{-114,
          -43.9}},
      color={0,0,0},
      pattern=LinePattern.Dot));
  connect(senRetFlo.port_b, TRet.port_a) annotation (Line(points={{340,140},{
          226,140},{110,140}}, color={0,127,255}));
  connect(TMix.port_b, heaCoi.port_a2) annotation (Line(
      points={{50,-40},{98,-40}},
      color={0,127,255},
      thickness=0.5));
  connect(heaCoi.port_b2, cooCoi.port_a2)
    annotation (Line(
      points={{118,-40},{190,-40}},
      color={0,127,255},
      thickness=0.5));
  connect(VOut1.port_b, damOut.port_a)
    annotation (Line(points={{-70,-40},{-50,-40}}, color={0,127,255}));
  connect(damOut.port_b, TMix.port_a)
    annotation (Line(points={{-30,-40},{30,-40}}, color={0,127,255}));
  connect(damRet.port_a, TRet.port_b)
    annotation (Line(points={{0,0},{0,140},{90,140}}, color={0,127,255}));
  connect(damRet.port_b, TMix.port_a)
    annotation (Line(points={{0,-20},{0,-40},{30,-40}}, color={0,127,255}));
  connect(pumHeaCoi.port_b, heaCoi.port_a1) annotation (Line(points={{128,-110},
          {128,-52},{118,-52}}, color={0,127,255}));
  connect(cooCoi.port_b1,pumCooCoi. port_a) annotation (Line(points={{190,-52},{
          180,-52},{180,-110}}, color={0,127,255}));
  connect(splCooSup.port_2, cooCoi.port_a1) annotation (Line(points={{220,-160},
          {220,-52},{210,-52}}, color={0,127,255}));
  connect(splCooRet.port_3,splCooSup. port_3)
    annotation (Line(points={{190,-170},{210,-170}}, color={0,127,255}));
  connect(pumCooCoi.port_b, splCooRet.port_2)
    annotation (Line(points={{180,-130},{180,-160}}, color={0,127,255}));
  connect(splHeaSup.port_2, pumHeaCoi.port_a)
    annotation (Line(points={{128,-160},{128,-130}}, color={0,127,255}));
  connect(heaCoi.port_b1, splHeaRet.port_2)
    annotation (Line(points={{98,-52},{88,-52},{88,-160}}, color={0,127,255}));
  connect(splHeaRet.port_3, splHeaSup.port_3)
    annotation (Line(points={{98,-170},{118,-170}}, color={0,127,255}));
  connect(sou.port_bAir, port_supAir[1]) annotation (Line(points={{770,60},{770,
          156},{1420,156}}, color={0,127,255}));
  connect(eas.port_bAir, port_supAir[2]) annotation (Line(points={{950,60},{950,
          158},{1420,158}}, color={0,127,255}));
  connect(nor.port_bAir, port_supAir[3]) annotation (Line(points={{1110,60},{1112,
          60},{1112,160},{1420,160}}, color={0,127,255}));
  connect(wes.port_bAir, port_supAir[4]) annotation (Line(points={{1310,60},{1310,
          162},{1420,162}}, color={0,127,255}));
  connect(cor.port_bAir, port_supAir[5]) annotation (Line(points={{590,62},{592,
          62},{592,164},{1420,164}}, color={0,127,255}));
  connect(splRetSou.port_3, port_retAir[1]) annotation (Line(points={{822,10},{822,
          116},{1420,116}}, color={0,127,255}));
  connect(splRetEas.port_3, port_retAir[2]) annotation (Line(points={{1002,10},{
          1002,118},{1420,118}}, color={0,127,255}));
  connect(splRetNor.port_3, port_retAir[3]) annotation (Line(points={{1152,10},{
          1152,120},{1420,120}}, color={0,127,255}));
  connect(splRetNor.port_2, port_retAir[4]) annotation (Line(points={{1162,0},{1360,
          0},{1360,122},{1420,122}}, color={0,127,255}));
  connect(splRetRoo1.port_3, port_retAir[5]) annotation (Line(points={{640,10},{
          640,124},{1420,124}}, color={0,127,255}));
  connect(splHeaSup.port_1, valHeaCoi.port_b)
    annotation (Line(points={{128,-180},{128,-200}}, color={0,127,255}));
  connect(splCooSup.port_1, valCooCoi.port_b)
    annotation (Line(points={{220,-180},{220,-200}}, color={0,127,255}));
  connect(TRooAir.u, TRoo) annotation (Line(points={{478,290},{20,290},{20,320},
          {-400,320}}, color={0,0,127}));
  connect(portHeaCoiSup, valHeaCoi.port_a) annotation (Line(points={{80,-300},{80,
          -262},{128,-262},{128,-220}},    color={0,127,255}));
  connect(portHeaCoiRet, splHeaRet.port_1) annotation (Line(points={{120,-300},
          {120,-240},{88,-240},{88,-180}}, color={0,127,255}));
  connect(portCooCoiSup, valCooCoi.port_a) annotation (Line(points={{200,-300},
          {200,-260},{220,-260},{220,-220}}, color={0,127,255}));
  connect(portCooCoiRet, splCooRet.port_1) annotation (Line(points={{240,-300},
          {240,-240},{180,-240},{180,-180}}, color={0,127,255}));
  connect(portHeaTerSup, cor.port_aHotWat) annotation (Line(points={{460,-300},
          {460,-180},{520,-180},{520,42},{570,42}}, color={0,127,255}));
  connect(portHeaTerSup, sou.port_aHotWat) annotation (Line(points={{460,-300},
          {460,-180},{720,-180},{720,40},{750,40}}, color={0,127,255}));
  connect(portHeaTerSup, eas.port_aHotWat) annotation (Line(points={{460,-300},{
          460,-180},{900,-180},{900,40},{930,40}},  color={0,127,255}));
  connect(portHeaTerSup, nor.port_aHotWat) annotation (Line(points={{460,-300},{
          460,-180},{1060,-180},{1060,40},{1090,40}},  color={0,127,255}));
  connect(portHeaTerRet, cor.port_bHotWat) annotation (Line(points={{500,-300},
          {500,-186},{526,-186},{526,30},{570,30}}, color={0,127,255}));
  connect(portHeaTerRet, sou.port_bHotWat) annotation (Line(points={{500,-300},
          {500,-186},{726,-186},{726,28},{750,28}}, color={0,127,255}));
  connect(portHeaTerRet, eas.port_bHotWat) annotation (Line(points={{500,-300},
          {500,-186},{906,-186},{906,28},{930,28}}, color={0,127,255}));
  connect(portHeaTerRet, nor.port_bHotWat) annotation (Line(points={{500,-300},
          {500,-186},{1066,-186},{1066,28},{1090,28}}, color={0,127,255}));
  connect(portHeaTerSup, wes.port_aHotWat) annotation (Line(points={{460,-300},{
          460,-180},{1270,-180},{1270,40},{1290,40}}, color={0,127,255}));
  connect(portHeaTerRet, wes.port_bHotWat) annotation (Line(points={{500,-300},{
          500,-186},{1278,-186},{1278,28},{1290,28}}, color={0,127,255}));
  annotation (
  Diagram(
    coordinateSystem(
    preserveAspectRatio=false,
    extent={{-380,-300},{1420,360}})),
    Documentation(info="<html>
<p>
This partial model consist of an HVAC system that serves five thermal zones.
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
The control sequences for this HVAC system are added in
the two models that extend this model, namely
<a href=\"modelica://Buildings.Examples.VAVReheat.ASHRAE2006\">
Buildings.Examples.VAVReheat.ASHRAE2006</a>
and
<a href=\"modelica://Buildings.Examples.VAVReheat.Guideline36\">
Buildings.Examples.VAVReheat.Guideline36</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 4, 2021, by Michael Wetter:<br/>
Refactored <a href=\"modelica://Buildings.Examples.VAVReheat\">Buildings.Examples.VAVReheat</a>
and its base classes to separate building from HVAC model.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2652\">issue #2652</a>.
</li>
<li>
September 3, 2021, by Michael Wetter:<br/>
Updated documentation.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2600\">issue #2600</a>.
</li>
<li>
August 24, 2021, by Michael Wetter:<br/>
Changed model to include the hydraulic configurations of the cooling coil,
heating coil and VAV terminal box.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2594\">issue #2594</a>.
</li>
<li>
June 30, 2021, by Antoine Gautier:<br/>
Changed cooling coil model. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2549\">issue #2549</a>.
</li>
<li>
May 6, 2021, by David Blum:<br/>
Change to <code>from_dp=false</code> for all mixing box dampers.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2485\">issue #2485</a>.
</li>
<li>
April 30, 2021, by Michael Wetter:<br/>
Reformulated replaceable class and introduced floor areas in base class
to avoid access of components that are not in the constraining type.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2471\">issue #2471</a>.
</li>
<li>
April 16, 2021, by Michael Wetter:<br/>
Refactored model to implement the economizer dampers directly in
<code>Buildings.Examples.VAVReheat.BaseClasses.PartialHVAC</code> rather than through the
model of a mixing box. Since the version of the Guideline 36 model has no exhaust air damper,
this leads to simpler equations.
<br/> This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2454\">issue #2454</a>.
</li>
<li>
March 11, 2021, by Michael Wetter:<br/>
Set parameter in weather data reader to avoid computation of wet bulb temperature which is need needed for this model.
</li>
<li>
February 03, 2021, by Baptiste Ravache:<br/>
Refactored the sizing of the heating coil in the <code>VAVBranch</code> (renamed <code>VAVReheatBox</code>) class.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2059\">#2024</a>.
</li>
<li>
July 10, 2020, by Antoine Gautier:<br/>
Added design parameters for outdoor air flow.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2019\">#2019</a>
</li>
<li>
November 25, 2019, by Milica Grahovac:<br/>
Declared the floor model as replaceable.
</li>
<li>
September 26, 2017, by Michael Wetter:<br/>
Separated physical model from control to facilitate implementation of alternate control
sequences.
</li>
<li>
May 19, 2016, by Michael Wetter:<br/>
Changed chilled water supply temperature to <i>6&deg;C</i>.
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
    Icon(coordinateSystem(extent={{-200,-140},{440,220}}),graphics={
        Text(
          extent={{56,226},{168,290}},
          textString="%name",
          lineColor={0,0,255}),
        Rectangle(
          extent={{-200,222},{440,-140}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end PartialHVAC;

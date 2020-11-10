within Buildings.Examples.HydronicHeating;
model TwoRoomsWithStorage
  "Model of a hydronic heating system with energy storage"
  extends Modelica.Icons.Example;
 replaceable package MediumA = Buildings.Media.Air(T_default=293.15)
    "Medium model for air";
 replaceable package MediumW = Buildings.Media.Water "Medium model";
 parameter Integer nRoo = 2 "Number of rooms";
 parameter Modelica.SIunits.Volume VRoo = 4*6*3 "Volume of one room";
 parameter Modelica.SIunits.Power Q_flow_nominal = 2200
    "Nominal power of heating plant";
 // Due to the night setback, in which the radiator do not provide heat input into the room,
 // we scale the design power of the radiator loop
 parameter Real scaFacRad = 1.5
    "Scaling factor to scale the power (and mass flow rate) of the radiator loop";
 parameter Modelica.SIunits.Temperature TSup_nominal=273.15 + 50 + 5
    "Nominal supply temperature for radiators";
 parameter Modelica.SIunits.Temperature TRet_nominal=273.15 + 40 + 5
    "Nominal return temperature for radiators";
 parameter Modelica.SIunits.Temperature dTRad_nominal = TSup_nominal-TRet_nominal
    "Nominal temperature difference for radiator loop";
 parameter Modelica.SIunits.Temperature dTBoi_nominal = 20
    "Nominal temperature difference for boiler loop";
 parameter Modelica.SIunits.MassFlowRate mRad_flow_nominal = scaFacRad*Q_flow_nominal/dTRad_nominal/4200
    "Nominal mass flow rate of radiator loop";
 parameter Modelica.SIunits.MassFlowRate mBoi_flow_nominal = scaFacRad*Q_flow_nominal/dTBoi_nominal/4200
    "Nominal mass flow rate of boiler loop";
 parameter Modelica.SIunits.PressureDifference dpPip_nominal = 10000
    "Pressure difference of pipe (without valve)";
 parameter Modelica.SIunits.PressureDifference dpVal_nominal = 1000
    "Pressure difference of valve";
 parameter Modelica.SIunits.PressureDifference dpRoo_nominal = 6000
    "Pressure difference of flow leg that serves a room";
 parameter Modelica.SIunits.PressureDifference dpThrWayVal_nominal = 6000
    "Pressure difference of three-way valve";
 parameter Modelica.SIunits.PressureDifference dp_nominal=
    dpPip_nominal + dpVal_nominal + dpRoo_nominal + dpThrWayVal_nominal
    "Pressure difference of loop";
  // Room model

  Buildings.Fluid.Movers.SpeedControlled_y pumBoi(
    redeclare package Medium = MediumW,
    per(pressure(V_flow=mBoi_flow_nominal/1000*{0.5,1}, dp=(3000 + 2000)*{2,1})),
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Pump for boiler circuit" annotation (Placement(transformation(extent={{-10,
            -10},{10,10}}, origin={70,-170})));

  Buildings.Fluid.Movers.SpeedControlled_y pumRad(
    redeclare package Medium = MediumW,
    per(pressure(V_flow=mRad_flow_nominal/1000*{0,2}, dp=dp_nominal*{2,0})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Pump that serves the radiators" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={220,10})));

  parameter HeatTransfer.Data.OpaqueConstructions.Insulation100Concrete200 matLayExt
    "Construction material for exterior walls"
    annotation (Placement(transformation(extent={{460,560},{480,580}})));
  parameter HeatTransfer.Data.OpaqueConstructions.Brick120 matLayPar
    "Construction material for partition walls"
    annotation (Placement(transformation(extent={{500,560},{520,580}})));
  parameter HeatTransfer.Data.OpaqueConstructions.Generic matLayFlo(
        material={
          HeatTransfer.Data.Solids.Concrete(x=0.2),
          HeatTransfer.Data.Solids.InsulationBoard(x=0.15),
          HeatTransfer.Data.Solids.Concrete(x=0.05)},
        final nLay=3) "Construction material for floor"
    annotation (Placement(transformation(extent={{540,560},{560,580}})));
  parameter HeatTransfer.Data.GlazingSystems.DoubleClearAir13Clear glaSys(
    UFra=2,
    shade=Buildings.HeatTransfer.Data.Shades.Gray(),
    haveInteriorShade=false,
    haveExteriorShade=false) "Data record for the glazing system"
    annotation (Placement(transformation(extent={{580,560},{600,580}})));
  ThermalZones.Detailed.MixedAir roo1(
    redeclare package Medium = MediumA,
    AFlo=6*4,
    hRoo=2.7,
    nConExt=0,
    nConExtWin=2,
    datConExtWin(
      layers={matLayExt, matLayExt},
      A={4*3, 6*3},
      glaSys={glaSys, glaSys},
      wWin={3, 2},
      each hWin=2,
      each fFra=0.1,
      til={Buildings.Types.Tilt.Wall, Buildings.Types.Tilt.Wall},
      azi={Buildings.Types.Azimuth.W, Buildings.Types.Azimuth.S}),
    nConPar=2,
    datConPar(
      layers={matLayFlo, matLayPar},
      A={6*4, 6*3/2},
      til={Buildings.Types.Tilt.Floor, Buildings.Types.Tilt.Wall},
      azi={Buildings.Types.Azimuth.N, Buildings.Types.Azimuth.N}),
    nConBou=0,
    nSurBou=1,
    surBou(
      each A=4*3,
      each absIR=0.9,
      each absSol=0.9,
      each til=Buildings.Types.Tilt.Wall),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nPorts=3,
    linearizeRadiation=true,
    lat=0.73268921998722,
    extConMod=Buildings.HeatTransfer.Types.ExteriorConvection.Fixed)
    "Room model"
    annotation (Placement(transformation(extent={{356,464},{396,504}})));

  ThermalZones.Detailed.MixedAir roo2(
    redeclare package Medium = MediumA,
    AFlo=6*4,
    hRoo=2.7,
    nConExt=0,
    nConExtWin=2,
    datConExtWin(
      layers={matLayExt, matLayExt},
      A={4*3, 6*3},
      glaSys={glaSys, glaSys},
      wWin={2, 2},
      each hWin=2,
      each fFra=0.1,
      til={Buildings.Types.Tilt.Wall, Buildings.Types.Tilt.Wall},
      azi={Buildings.Types.Azimuth.E, Buildings.Types.Azimuth.S}),
    nConPar=2,
    datConPar(
      layers={matLayFlo, matLayPar},
      A={6*4, 6*3/2},
      til={Buildings.Types.Tilt.Floor, Buildings.Types.Tilt.Wall},
      azi={Buildings.Types.Azimuth.N, Buildings.Types.Azimuth.N}),
    nConBou=0,
    nSurBou=1,
    surBou(
      each A=4*3,
      each absIR=0.9,
      each absSol=0.9,
      each til=Buildings.Types.Tilt.Wall),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    linearizeRadiation=true,
    nPorts=3,
    lat=0.73268921998722,
    extConMod=Buildings.HeatTransfer.Types.ExteriorConvection.Fixed)
    "Room model"
    annotation (Placement(transformation(extent={{368,206},{408,246}})));
  Buildings.Fluid.Boilers.BoilerPolynomial boi(
    a={0.9},
    effCur=Buildings.Fluid.Types.EfficiencyCurves.Constant,
    redeclare package Medium = MediumW,
    Q_flow_nominal=Q_flow_nominal,
    m_flow_nominal=mBoi_flow_nominal,
    fue=Buildings.Fluid.Data.Fuels.HeatingOilLowerHeatingValue(),
    dp_nominal=3000 + 2000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=293.15) "Boiler"
    annotation (Placement(transformation(extent={{2,-180},{22,-160}})));
  Buildings.HeatTransfer.Sources.FixedTemperature TAmb(T=288.15)
    "Ambient temperature in boiler room"
    annotation (Placement(transformation(extent={{-40,-150},{-20,-130}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TRoo2
    annotation (Placement(transformation(extent={{480,216},{500,236}})));
  Modelica.Blocks.Sources.Constant pumRadOn(k=1) "Pump on signal"
    annotation (Placement(transformation(extent={{40,100},{60,120}})));
  Controls.Continuous.PIDHysteresisTimer conPum(
    yMax=1,
    Td=60,
    yMin=0.05,
    eOn=0.5,
    k=0.5,
    Ti=15) "Controller for pump"
    annotation (Placement(transformation(extent={{120,60},{140,80}})));
  Buildings.Fluid.Sensors.RelativePressure dpSen(redeclare package Medium =
        MediumW)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={180,10})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val2(
    redeclare package Medium = MediumW,
    dpValve_nominal(displayUnit="Pa") = dpVal_nominal,
    m_flow_nominal=mRad_flow_nominal/nRoo,
    dpFixed_nominal=dpRoo_nominal,
    from_dp=true,
    use_inputFilter=false) "Radiator valve"
    annotation (Placement(transformation(extent={{360,120},{380,140}})));
  Controls.Continuous.LimPID conRoo2(
    yMax=1,
    yMin=0,
    Ti=60,
    Td=60,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    k=0.5) "Controller for room temperature"
    annotation (Placement(transformation(extent={{540,240},{560,260}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TRoo1
    annotation (Placement(transformation(extent={{480,474},{500,494}})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val1(
    redeclare package Medium = MediumW,
    dpValve_nominal(displayUnit="Pa") = dpVal_nominal,
    m_flow_nominal=mRad_flow_nominal/nRoo,
    dpFixed_nominal=dpRoo_nominal,
    from_dp=true,
    use_inputFilter=false) "Radiator valve"
    annotation (Placement(transformation(extent={{360,390},{380,410}})));
  Controls.Continuous.LimPID conRoo1(
    yMax=1,
    yMin=0,
    Ti=60,
    Td=60,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    k=0.5) "Controller for room temperature"
    annotation (Placement(transformation(extent={{540,500},{560,520}})));
  Buildings.Fluid.HeatExchangers.Radiators.RadiatorEN442_2 rad1(
    redeclare package Medium = MediumW,
    Q_flow_nominal=scaFacRad*Q_flow_nominal/nRoo,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_a_nominal=323.15,
    T_b_nominal=313.15) "Radiator"
    annotation (Placement(transformation(extent={{392,390},{412,410}})));
  Buildings.Fluid.HeatExchangers.Radiators.RadiatorEN442_2 rad2(
    redeclare package Medium = MediumW,
    Q_flow_nominal=scaFacRad*Q_flow_nominal/nRoo,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_a_nominal=323.15,
    T_b_nominal=313.15) "Radiator"
    annotation (Placement(transformation(extent={{392,120},{412,140}})));
  Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear thrWayVal(
    redeclare package Medium = MediumW,
    dpValve_nominal=dpThrWayVal_nominal,
    l={0.01,0.01},
    tau=10,
    m_flow_nominal=mRad_flow_nominal,
    dpFixed_nominal={100,0},
    use_inputFilter=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) "Three-way valve"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={220,-40})));
  Controls.Continuous.LimPID conVal(
    yMax=1,
    yMin=0,
    initType=Modelica.Blocks.Types.InitPID.InitialState,
    xi_start=1,
    Td=60,
    k=0.1,
    Ti=120)
    "Controller for pump"
    annotation (Placement(transformation(extent={{140,-50},{160,-30}})));
  Buildings.Fluid.Storage.Stratified tan(
    m_flow_nominal=mRad_flow_nominal,
    dIns=0.3,
    redeclare package Medium = MediumW,
    hTan=2,
    nSeg=5,
    show_T=true,
    VTan=0.2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Storage tank"
    annotation (Placement(transformation(extent={{208,-190},{248,-150}})));

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor tanTemBot
    "Tank temperature"
    annotation (Placement(transformation(extent={{280,-240},{300,-220}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor tanTemTop
    "Tank temperature"
    annotation (Placement(transformation(extent={{284,-180},{304,-160}})));
  Modelica.Blocks.Logical.GreaterThreshold greThr(threshold=TSup_nominal + 5)
    "Check for temperature at the bottom of the tank"
    annotation (Placement(transformation(extent={{400,-240},{420,-220}})));
  Modelica.Blocks.Math.BooleanToReal booToReaPum "Signal converter for pump"
    annotation (Placement(transformation(extent={{420,-130},{400,-110}})));
  Modelica.Blocks.Logical.Greater lesThr
    "Check for temperature at the top of the tank"
    annotation (Placement(transformation(extent={{400,-178},{420,-158}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort temSup(   redeclare package Medium = MediumW,
      m_flow_nominal=mRad_flow_nominal)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={220,40})));
  Buildings.Fluid.Sensors.TemperatureTwoPort temRet(   redeclare package Medium = MediumW,
      m_flow_nominal=mRad_flow_nominal)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={260,40})));
  Buildings.Controls.SetPoints.SupplyReturnTemperatureReset heaCha(
    dTOutHeaBal=0,
    use_TRoo_in=true,
    TSup_nominal=TSup_nominal,
    TRet_nominal=TRet_nominal,
    TOut_nominal=258.15)
    annotation (Placement(transformation(extent={{80,-56},{100,-36}})));
  Controls.SetPoints.OccupancySchedule occSch1(occupancy=3600*{7,8,10,11,11.5,
        15,19,21}) "Occupancy schedule"
    annotation (Placement(transformation(extent={{300,556},{320,576}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{340,550},{360,570}})));
  Modelica.Blocks.Sources.RealExpression occ1(y=1/6/4)
    "Heat gain if occupied in room 1"
    annotation (Placement(transformation(extent={{300,580},{320,600}})));
  Modelica.Blocks.Sources.Constant zer(k=0) "Outputs zero"
    annotation (Placement(transformation(extent={{260,540},{280,560}})));
  Controls.SetPoints.OccupancySchedule occSch2(
      firstEntryOccupied=false, occupancy=3600*{7,10,12,22})
    "Occupancy schedule"
    annotation (Placement(transformation(extent={{300,286},{320,306}})));
  Modelica.Blocks.Logical.Switch switch2
    annotation (Placement(transformation(extent={{340,280},{360,300}})));
  Modelica.Blocks.Sources.RealExpression occ2(y=1/6/4)
    "Heat gain if occupied in room 2"
    annotation (Placement(transformation(extent={{300,310},{320,330}})));
  Controls.SetPoints.OccupancySchedule occSch "Occupancy schedule"
    annotation (Placement(transformation(extent={{480,358},{500,378}})));
  Modelica.Blocks.Logical.Switch swi "Switch to select set point"
    annotation (Placement(transformation(extent={{640,370},{660,390}})));
  Modelica.Blocks.Sources.Constant TRooNig(k=273.15 + 16)
    "Room temperature set point at night"
    annotation (Placement(transformation(extent={{480,330},{500,350}})));
  Modelica.Blocks.Sources.Constant TRooSet(k=273.15 + 21)
    annotation (Placement(transformation(extent={{480,390},{500,410}})));
  Buildings.Utilities.Math.Max maxYVal(nin=2) "Maximum radiator valve position"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Modelica.Blocks.Logical.Hysteresis hysPum(           uLow=0.01, uHigh=0.5)
    "Hysteresis for pump"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Modelica.Blocks.Logical.Switch swiPum "Pump switch"
    annotation (Placement(transformation(extent={{80,60},{100,80}})));
  Modelica.Blocks.Sources.Constant pumRadOff(k=0) "Pump off signal"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "File reader that reads weather data"
    annotation (Placement(transformation(extent={{-80,330},{-60,350}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Bus with weather data"
    annotation (Placement(transformation(extent={{-50,330},{-30,350}})));
  Buildings.Fluid.Sources.Outside out(
    redeclare package Medium = MediumA,
    use_C_in=false,
    nPorts=4) "Outside air conditions"
    annotation (Placement(transformation(extent={{0,470},{20,490}})));
  Buildings.Fluid.FixedResistances.PressureDrop dpFac4(
    from_dp=false,
    redeclare package Medium = MediumA,
    m_flow_nominal=6*4*3*1.2*0.3/3600,
    dp_nominal=10) "Pressure drop at facade" annotation (Placement(
        transformation(extent={{-10,-10},{10,10}}, origin={330,214})));
  HeatTransfer.Conduction.MultiLayer parWal(A=4*3, layers=matLayPar,
    stateAtSurface_a=true,
    stateAtSurface_b=true)
    "Partition wall between the two rooms" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={450,290})));
  Buildings.Fluid.FixedResistances.PressureDrop dpFac1(
    from_dp=false,
    redeclare package Medium = MediumA,
    m_flow_nominal=6*4*3*1.2*0.3/3600,
    dp_nominal=10) "Pressure drop at facade" annotation (Placement(
        transformation(extent={{-10,-10},{10,10}}, origin={330,474})));
  Buildings.Fluid.HeatExchangers.ConstantEffectiveness hex(
    redeclare package Medium1 = MediumA,
    redeclare package Medium2 = MediumA,
    m1_flow_nominal=2*VRoo*1.2*0.3/3600,
    m2_flow_nominal=2*VRoo*1.2*0.3/3600,
    dp1_nominal=100,
    dp2_nominal=100,
    eps=0.9) "Heat recovery"
    annotation (Placement(transformation(extent={{180,478},{200,498}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow fanSup(
    redeclare package Medium = MediumA,
    m_flow_nominal=2*VRoo*1.2*0.37/3600,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    use_inputFilter=false) "Supply air fan"
    annotation (Placement(transformation(extent={{70,490},{90,510}})));
  Modelica.Blocks.Sources.Constant m_flow_out(k=2*VRoo*1.2*0.37/3600)
    "Outside air mass flow rate"
    annotation (Placement(transformation(extent={{0,500},{20,520}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow fanRet(
    redeclare package Medium = MediumA,
    m_flow_nominal=2*VRoo*1.2*0.37/3600,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    use_inputFilter=false) "Return air fan"
    annotation (Placement(transformation(extent={{90,450},{70,470}})));
  Airflow.Multizone.Orifice lea1(redeclare package Medium = MediumA, A=0.01^2)
    "Leakage of facade of room"
    annotation (Placement(transformation(extent={{320,430},{340,450}})));
  Airflow.Multizone.Orifice lea2(redeclare package Medium = MediumA, A=0.01^2)
    "Leakage of facade of room"
    annotation (Placement(transformation(extent={{320,170},{340,190}})));
  Modelica.Blocks.MathBoolean.Or pumOnSig(nu=3) "Signal for pump being on"
    annotation (Placement(transformation(extent={{660,-100},{680,-80}})));
  Modelica.Blocks.Math.BooleanToReal booToReaBoi "Signal converter for boiler"
    annotation (Placement(transformation(extent={{420,-100},{400,-80}})));
  Modelica.Blocks.Math.MatrixGain gai1(K=[35; 70; 30])
    "Gain to convert from occupancy (per person) to radiant, convective and latent heat in [W/m2] "
    annotation (Placement(transformation(extent={{380,550},{400,570}})));
  Modelica.Blocks.Math.MatrixGain gai2(K=[35; 70; 30])
    "Gain to convert from occupancy (per person) to radiant, convective and latent heat in [W/m2] "
    annotation (Placement(transformation(extent={{380,280},{400,300}})));
  Modelica.Blocks.Sources.Constant dTThr(k=1) "Threshold to switch boiler off"
    annotation (Placement(transformation(extent={{310,-210},{330,-190}})));
  Modelica.Blocks.Math.Add add1(k2=-1)
    annotation (Placement(transformation(extent={{350,-186},{370,-166}})));
  Modelica.Blocks.Sources.Constant TRooOff(k=273.15 - 5)
    "Low room temperature set point to switch heating off"
    annotation (Placement(transformation(extent={{600,300},{620,320}})));
  Modelica.Blocks.Logical.Switch swi1 "Switch to select set point"
    annotation (Placement(transformation(extent={{540,380},{560,400}})));
  Modelica.Blocks.Logical.OnOffController onOff(bandwidth=2) "On/off switch"
    annotation (Placement(transformation(extent={{580,334},{600,354}})));
  Modelica.Blocks.Continuous.FirstOrder aveTOut(
    T=24*3600,
    initType=Modelica.Blocks.Types.Init.SteadyState,
    y(unit="K")) "Integrated average of outside temperature"
    annotation (Placement(transformation(extent={{540,300},{560,320}})));
  Modelica.Blocks.Sources.Constant TOutSwi(k=16 + 293.15)
    "Outside air temperature to switch heating on or off"
    annotation (Placement(transformation(extent={{540,340},{560,360}})));
  Buildings.Fluid.Sources.Boundary_pT bou(nPorts=1, redeclare package Medium = MediumW)
    "Fixed boundary condition, needed to provide a pressure in the system"
    annotation (Placement(transformation(extent={{-82,-180},{-62,-160}})));
  Modelica.Blocks.Math.Gain gain(k=1/dp_nominal)
    "Gain used to normalize pressure measurement signal"
    annotation (Placement(transformation(extent={{160,0},{140,20}})));
  Buildings.Fluid.FixedResistances.Junction splVal(
    dp_nominal={dpPip_nominal,0,0},
    m_flow_nominal=mRad_flow_nominal*{1,-1,-1},
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Flow splitter" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={260,-40})));
  Buildings.Fluid.FixedResistances.Junction splVal1(
    m_flow_nominal=mRad_flow_nominal*{1,-1,-1},
    redeclare package Medium = MediumW,
    dp_nominal={0,0,0},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Flow splitter" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={220,130})));
  Buildings.Fluid.FixedResistances.Junction splVal2(
    m_flow_nominal=mRad_flow_nominal*{1,-1,-1},
    redeclare package Medium = MediumW,
    dp_nominal={0,0,0},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Flow splitter" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={260,100})));

  CoolingControl cooCon "Controller for cooling"
    annotation (Placement(transformation(extent={{100,530},{120,550}})));
  Buildings.Fluid.Actuators.Dampers.Exponential damSupByp(
    redeclare package Medium = MediumA,
    m_flow_nominal=2*VRoo*1.2*0.37/3600,
    use_inputFilter=false,
    dpDamper_nominal=0.27)
    "Supply air damper that bypasses the heat recovery"
    annotation (Placement(transformation(extent={{160,510},{180,530}})));
  Buildings.Fluid.HeatExchangers.SensibleCooler_T coo(
    redeclare package Medium = MediumA,
    m_flow_nominal=2*VRoo*1.2*0.37/3600,
    dp_nominal=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
                      "Coil for mechanical cooling"
    annotation (Placement(transformation(extent={{240,500},{260,520}})));
  Modelica.Blocks.Logical.LessThreshold lesThrTRoo(threshold=18 + 273.15)
    "Test to block boiler if room air temperature is sufficiently high"
    annotation (Placement(transformation(extent={{400,-60},{420,-40}})));
  Modelica.Blocks.Logical.And and1
    "Logical test to enable pump and subsequently the boiler"
    annotation (Placement(transformation(extent={{440,-60},{460,-40}})));

  block CoolingControl
    "Controller for the free cooling and the mechanical cooling"
     extends Modelica.Blocks.Icons.Block;

     parameter Modelica.SIunits.Temperature TRooCoo = 25+273.15
      "Set point for mechanical cooling";
     parameter Modelica.SIunits.Temperature TRooFre = 22+273.15
      "Maximum temperature above which free cooling is enabled";
     parameter Modelica.SIunits.Temperature TOutFre = 16+273.15
      "Outside temperature above which free cooling is allowed";
     parameter Modelica.SIunits.TemperatureDifference dT = 1
      "Dead-band for free cooling";
     parameter Real Kp(min=0) = 1 "Proportional band for mechanical cooling";

     Modelica.Blocks.Interfaces.RealInput TRoo(unit="K") "Room air temperature"
       annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
     Modelica.Blocks.Interfaces.RealInput TOut(unit="K")
      "Outside air temperature"
       annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
     Modelica.Blocks.Interfaces.RealOutput TSupCoo
      "Control signal for set point for leaving air temperature of cooling coil"
       annotation (Placement(transformation(extent={{100,50},{120,70}}),
           iconTransformation(extent={{100,50},{120,70}})));
     Modelica.Blocks.Interfaces.RealOutput yF
      "Control signal for free cooling, 1 if free cooling should be provided"
       annotation (Placement(transformation(extent={{100,-10},{120,10}}),
           iconTransformation(extent={{100,-10},{120,10}})));

     Modelica.Blocks.Interfaces.RealOutput yHex
      "Control signal for heat recovery damper"
       annotation (Placement(transformation(extent={{100,-70},{120,-50}}),
           iconTransformation(extent={{100,-70},{120,-50}})));
  initial equation
     yF   = 0;
     yHex = 1;
  algorithm
     when TRoo > TRooFre and TOut > TOutFre and TOut < TRoo - dT then
       yF   := 1;
       yHex := 0;
     elsewhen  TOut < TOutFre-dT or TOut > TRoo then
       yF   := 0;
       yHex := 1;
     end when;
     TSupCoo :=273.15 + Buildings.Utilities.Math.Functions.smoothLimit(
                 x=30 - 20*Kp*(TRoo - TRooCoo),
                 l=10,
                 u=30,
                 deltaX=0.1);

     annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
               {100,100}}), graphics={
           Text(
             extent={{-94,38},{-64,80}},
             lineColor={0,0,255},
             textString="TRoo"),
           Text(
             extent={{-94,-82},{-64,-40}},
             lineColor={0,0,255},
             textString="TOut"),
           Text(
             extent={{66,42},{86,74}},
             lineColor={0,0,255},
             textString="yC"),
           Text(
             extent={{-32,100},{24,124}},
             lineColor={0,0,255},
             textString="%name"),
           Text(
             extent={{66,-16},{86,16}},
             lineColor={0,0,255},
             textString="yF"),
           Text(
             extent={{68,-74},{88,-42}},
             lineColor={0,0,255},
            textString="yHex")}),Documentation(info="<html>
<p>
This block computes a control signal for free cooling and for mechanical cooling.
</p>
</html>", revisions="<html>
<ul>
<li>
February 27, 2015, by Michael Wetter:<br/>
Changed controller to output setpoint for supply air temperature for cooling coil.
</li>
</ul>
</html>"));
  end CoolingControl;
  Buildings.Fluid.Actuators.Dampers.Exponential damHex(
    redeclare package Medium = MediumA,
    m_flow_nominal=2*VRoo*1.2*0.37/3600,
    use_inputFilter=false,
    dpDamper_nominal=0.27)
    "Supply air damper that closes the heat recovery"
    annotation (Placement(transformation(extent={{120,490},{140,510}})));
  Buildings.Fluid.Actuators.Dampers.Exponential damRetByp(
    redeclare package Medium = MediumA,
    m_flow_nominal=2*VRoo*1.2*0.37/3600,
    use_inputFilter=false,
    dpDamper_nominal=0.27)
    "Return air damper that bypasses the heat recovery"
    annotation (Placement(transformation(extent={{180,450},{160,470}})));
  Modelica.StateGraph.InitialStep off "Pump and furnace off"
    annotation (Placement(transformation(extent={{440,-20},{460,0}})));
  Modelica.StateGraph.TransitionWithSignal T1 "Transition to pump on"
    annotation (Placement(transformation(extent={{470,-20},{490,0}})));
  Modelica.StateGraph.StepWithSignal pumOn "Pump on"
    annotation (Placement(transformation(extent={{500,-20},{520,0}})));
  Modelica.StateGraph.Transition T3(enableTimer=true, waitTime=10)
    "Transition to boiler on"
    annotation (Placement(transformation(extent={{530,-20},{550,0}})));
  Modelica.StateGraph.StepWithSignal boiOn "Boiler on"
    annotation (Placement(transformation(extent={{560,-20},{580,0}})));
  Modelica.StateGraph.TransitionWithSignal T2
    "Transition that switches boiler off"
    annotation (Placement(transformation(extent={{590,-20},{610,0}})));
  Modelica.StateGraph.StepWithSignal pumOn2 "Pump on"
    annotation (Placement(transformation(extent={{620,-20},{640,0}})));
  Modelica.StateGraph.Transition T4(enableTimer=true, waitTime=10)
    "Transition to boiler on"
    annotation (Placement(transformation(extent={{650,-20},{670,0}})));
  inner Modelica.StateGraph.StateGraphRoot stateGraphRoot
    "Root of the state graph"
    annotation (Placement(transformation(extent={{380,0},{400,20}})));
equation
  connect(TAmb.port,boi. heatPort) annotation (Line(
      points={{-20,-140},{12,-140},{12,-162.8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pumRad.port_b, dpSen.port_a)
                                     annotation (Line(
      points={{220,20},{180,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dpSen.port_b, pumRad.port_a)
                                     annotation (Line(
      points={{180,0},{220,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(val1.port_b, rad1.port_a) annotation (Line(
      points={{380,400},{392,400}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(val2.port_b, rad2.port_a) annotation (Line(
      points={{380,130},{392,130}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(conRoo1.y, val1.y) annotation (Line(
      points={{561,510},{580,510},{580,420},{370,420},{370,412}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conRoo2.y, val2.y)
                            annotation (Line(
      points={{561,250},{580,250},{580,150},{370,150},{370,142}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pumRad.port_a, thrWayVal.port_2)
                                         annotation (Line(
      points={{220,0},{220,-30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(boi.port_b,pumBoi. port_a) annotation (Line(
      points={{22,-170},{60,-170}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(tan.heaPorVol[1], tanTemTop.port) annotation (Line(
      points={{228,-170.96},{272,-170.96},{272,-170},{284,-170}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(tanTemBot.port, tan.heaPorVol[tan.nSeg]) annotation (Line(
      points={{280,-230},{272,-230},{272,-170},{228,-170}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(temSup.T, conVal.u_m) annotation (Line(
      points={{209,40},{120,40},{120,-60},{150,-60},{150,-52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaCha.TSup, conVal.u_s) annotation (Line(
      points={{101,-40},{138,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tan.port_b, boi.port_a) annotation (Line(
      points={{248,-170},{260,-170},{260,-202},{-28,-202},{-28,-170},{2,-170}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(occSch1.occupied, switch1.u2) annotation (Line(
      points={{321,560},{338,560}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(occ1.y, switch1.u1) annotation (Line(
      points={{321,590},{334,590},{334,568},{338,568}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zer.y, switch1.u3) annotation (Line(
      points={{281,550},{310,550},{310,552},{338,552}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(occSch2.occupied, switch2.u2) annotation (Line(
      points={{321,290},{338,290}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(occ2.y, switch2.u1) annotation (Line(
      points={{321,320},{330,320},{330,298},{338,298}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zer.y, switch2.u3) annotation (Line(
      points={{281,550},{290,550},{290,282},{338,282}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(swi.y, conRoo1.u_s)     annotation (Line(
      points={{661,380},{680,380},{680,540},{520,540},{520,510},{538,510}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(swi.y, conRoo2.u_s)     annotation (Line(
      points={{661,380},{680,380},{680,280},{530,280},{530,250},{538,250}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(maxYVal.y, hysPum.u) annotation (Line(
      points={{21,70},{38,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hysPum.y, swiPum.u2) annotation (Line(
      points={{61,70},{78,70}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(pumRadOn.y, swiPum.u1)
                              annotation (Line(
      points={{61,110},{68,110},{68,78},{78,78}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pumRadOff.y, swiPum.u3)
                                 annotation (Line(
      points={{61,30},{68,30},{68,62},{78,62}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(swiPum.y, conPum.u_s) annotation (Line(
      points={{101,70},{118,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conRoo1.y, maxYVal.u[1]) annotation (Line(
      points={{561,510},{580,510},{580,420},{160,420},{160,240},{-20,240},{-20,
          69},{-2,69}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conRoo2.y, maxYVal.u[2]) annotation (Line(
      points={{561,250},{580,250},{580,150},{160,150},{160,240},{-20,240},{-20,
          71},{-2,71}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conVal.y, thrWayVal.y) annotation (Line(
      points={{161,-40},{208,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(booToReaPum.y, pumBoi.y)
                                annotation (Line(
      points={{399,-120},{70,-120},{70,-158}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(rad1.heatPortCon, roo1.heaPorAir) annotation (Line(
      points={{400,407.2},{400,484},{375,484}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(roo1.heaPorRad, rad1.heatPortRad) annotation (Line(
      points={{375,480.2},{404,480.2},{404,407.2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(roo1.heaPorAir, TRoo1.port) annotation (Line(
      points={{375,484},{480,484}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(weaBus, roo1.weaBus) annotation (Line(
      points={{-40,340},{430,340},{430,502},{393.9,502},{393.9,501.9}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(rad2.heatPortCon, roo2.heaPorAir) annotation (Line(
      points={{400,137.2},{400,226},{387,226}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(rad2.heatPortRad, roo2.heaPorRad) annotation (Line(
      points={{404,137.2},{404,222},{387,222},{387,222.2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(roo2.heaPorAir, TRoo2.port) annotation (Line(
      points={{387,226},{480,226}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(weaBus, roo2.weaBus) annotation (Line(
      points={{-40,340},{430,340},{430,244},{405.9,244},{405.9,243.9}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(roo1.surf_surBou[1], parWal.port_b) annotation (Line(
      points={{372.2,470},{372,470},{372,440},{450,440},{450,300}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(parWal.port_a, roo2.surf_surBou[1]) annotation (Line(
      points={{450,280},{450,160},{384.2,160},{384.2,212}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(roo1.ports[1], dpFac1.port_b) annotation (Line(
      points={{361,471.333},{350,471.333},{350,474},{340,474}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dpFac1.port_a, hex.port_a2) annotation (Line(
      points={{320,474},{266,474},{266,482},{200,482}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dpFac4.port_b, roo2.ports[1]) annotation (Line(
      points={{340,214},{356,214},{356,213.333},{373,213.333}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dpFac4.port_a, hex.port_a2) annotation (Line(
      points={{320,214},{272,214},{272,460},{220,460},{220,482},{200,482}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fanSup.m_flow_in, m_flow_out.y) annotation (Line(
      points={{80,512},{80,516},{80,516},{80,520},{60,520},{60,510},{21,510}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fanRet.port_a, hex.port_b2) annotation (Line(
      points={{90,460},{100,460},{100,482},{180,482}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(out.ports[1], fanSup.port_a)  annotation (Line(
      points={{20,483},{50,483},{50,500},{70,500}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fanRet.port_b, out.ports[2])  annotation (Line(
      points={{70,460},{50,460},{50,481},{20,481}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(m_flow_out.y, fanRet.m_flow_in) annotation (Line(
      points={{21,510},{60,510},{60,476},{80,476},{80,472}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(lea1.port_b, roo1.ports[2]) annotation (Line(
      points={{340,440},{350,440},{350,474},{361,474}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(lea1.port_a, out.ports[3])  annotation (Line(
      points={{320,440},{46,440},{46,479},{20,479}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(lea2.port_b, roo2.ports[2]) annotation (Line(
      points={{340,180},{360,180},{360,216},{373,216}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(lea2.port_a, out.ports[4])  annotation (Line(
      points={{320,180},{266,180},{266,374},{40,374},{40,477},{20,477}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(swi.y, heaCha.TRoo_in)     annotation (Line(
      points={{661,380},{680,380},{680,150},{160,150},{160,240},{-20,240},{-20,
          -52},{78.1,-52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pumRad.port_b, temSup.port_a) annotation (Line(
      points={{220,20},{220,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(booToReaPum.u, pumOnSig.y) annotation (Line(
      points={{422,-120},{690,-120},{690,-90},{681.5,-90}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(weaBus.TDryBul, heaCha.TOut) annotation (Line(
      points={{-40,340},{-40,-40},{78,-40}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaBus, out.weaBus)  annotation (Line(
      points={{-40,340},{-40,480.2},{-4.44089e-16,480.2}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(switch1.y, gai1.u[1]) annotation (Line(
      points={{361,560},{378,560}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gai1.y, roo1.qGai_flow) annotation (Line(
      points={{401,560},{410,560},{410,540},{346,540},{346,494},{346,494},{346,494},
          {354.4,494},{354.4,492}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(switch2.y, gai2.u[1]) annotation (Line(
      points={{361,290},{378,290}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gai2.y, roo2.qGai_flow) annotation (Line(
      points={{401,290},{410,290},{410,260},{350,260},{350,234},{366.4,234}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaCha.TSup, lesThr.u1) annotation (Line(
      points={{101,-40},{110,-40},{110,-128},{380,-128},{380,-168},{398,-168}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(booToReaBoi.y, boi.y) annotation (Line(
      points={{399,-90},{-50,-90},{-50,-162},{-6.66134e-16,-162}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tan.heaPorTop, TAmb.port) annotation (Line(
      points={{232,-155.2},{232,-140},{-20,-140}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TAmb.port, tan.heaPorSid) annotation (Line(
      points={{-20,-140},{239.2,-140},{239.2,-170}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TAmb.port, tan.heaPorBot) annotation (Line(
      points={{-20,-140},{190,-140},{190,-184.8},{232,-184.8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(add1.y, lesThr.u2) annotation (Line(
      points={{371,-176},{398,-176}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tanTemTop.T, add1.u1) annotation (Line(
      points={{304,-170},{348,-170}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dTThr.y, add1.u2) annotation (Line(
      points={{331,-200},{340,-200},{340,-182},{348,-182}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tanTemBot.T, greThr.u) annotation (Line(
      points={{300,-230},{398,-230}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TRooSet.y, swi1.u1) annotation (Line(
      points={{501,400},{510,400},{510,398},{538,398}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(swi1.u2, occSch.occupied) annotation (Line(
      points={{538,390},{510,390},{510,362},{501,362}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(TRooNig.y, swi1.u3) annotation (Line(
      points={{501,340},{520,340},{520,382},{538,382}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(aveTOut.y, onOff.u) annotation (Line(
      points={{561,310},{570,310},{570,338},{578,338}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TOutSwi.y, onOff.reference) annotation (Line(
      points={{561,350},{578,350}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(swi1.y, swi.u1) annotation (Line(
      points={{561,390},{572,390},{572,388},{638,388}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(onOff.y, swi.u2) annotation (Line(
      points={{601,344},{620,344},{620,380},{638,380}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(TRooOff.y, swi.u3) annotation (Line(
      points={{621,310},{630,310},{630,372},{638,372}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaBus.TDryBul, aveTOut.u) annotation (Line(
      points={{-40,340},{468,340},{468,310},{538,310}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus, weaDat.weaBus) annotation (Line(
      points={{-40,340},{-60,340}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(conPum.y, pumRad.y) annotation (Line(
      points={{141,70},{200,70},{200,10},{208,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TRoo1.T, conRoo1.u_m) annotation (Line(
      points={{500,484},{550,484},{550,498}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TRoo2.T, conRoo2.u_m) annotation (Line(
      points={{500,226},{550,226},{550,238}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(bou.ports[1], boi.port_a) annotation (Line(
      points={{-62,-170},{2,-170}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(gain.u, dpSen.p_rel) annotation (Line(
      points={{162,10},{171,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.y, conPum.u_m) annotation (Line(
      points={{139,10},{130,10},{130,58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pumBoi.port_b, tan.port_a) annotation (Line(
      points={{80,-170},{208,-170}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pumBoi.port_b, thrWayVal.port_1) annotation (Line(
      points={{80,-170},{200,-170},{200,-110},{220,-110},{220,-50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(temRet.port_b, splVal.port_1) annotation (Line(
      points={{260,30},{260,-30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(thrWayVal.port_3, splVal.port_3) annotation (Line(
      points={{230,-40},{250,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(splVal.port_2, tan.port_b) annotation (Line(
      points={{260,-50},{260,-170},{248,-170}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(splVal1.port_3, val2.port_a) annotation (Line(
      points={{230,130},{360,130}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(splVal1.port_1, temSup.port_b) annotation (Line(
      points={{220,120},{220,50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(splVal1.port_2, val1.port_a) annotation (Line(
      points={{220,140},{220,400},{360,400}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(temRet.port_a, splVal2.port_1) annotation (Line(
      points={{260,50},{260,90}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(splVal2.port_3, rad2.port_b) annotation (Line(
      points={{270,100},{420,100},{420,130},{412,130}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(splVal2.port_2, rad1.port_b) annotation (Line(
      points={{260,110},{260,380},{420,380},{420,400},{412,400}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(weaBus.TDryBul, cooCon.TOut) annotation (Line(
      points={{-40,340},{-40,534},{98,534}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(TRoo1.T, cooCon.TRoo) annotation (Line(
      points={{500,484},{508,484},{508,530},{250,530},{250,580},{90,580},{90,
          546},{98,546}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fanSup.port_b, damSupByp.port_a)
                                     annotation (Line(
      points={{90,500},{100,500},{100,520},{160,520}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(cooCon.yF, damSupByp.y)
                            annotation (Line(
      points={{121,540},{170,540},{170,532}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hex.port_b1, coo.port_a) annotation (Line(
      points={{200,494},{220,494},{220,510},{240,510}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(damSupByp.port_b, coo.port_a)
                                  annotation (Line(
      points={{180,520},{188,520},{188,510},{240,510}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(coo.port_b, roo1.ports[3]) annotation (Line(
      points={{260,510},{338,510},{338,486},{350,486},{350,476.667},{361,
          476.667}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(coo.port_b, roo2.ports[3]) annotation (Line(
      points={{260,510},{282,510},{282,228},{360,228},{360,218.667},{373,
          218.667}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(lesThr.y, and1.u2) annotation (Line(
      points={{421,-168},{430,-168},{430,-58},{438,-58}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(lesThrTRoo.y, and1.u1) annotation (Line(
      points={{421,-50},{438,-50}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(TRoo1.T, lesThrTRoo.u) annotation (Line(
      points={{500,484},{690,484},{690,40},{340,40},{340,-50},{398,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(damHex.port_b, hex.port_a1) annotation (Line(
      points={{140,500},{170,500},{170,494},{180,494}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(damHex.port_a, fanSup.port_b) annotation (Line(
      points={{120,500},{90,500}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hex.port_a2, damRetByp.port_a) annotation (Line(
      points={{200,482},{220,482},{220,460},{180,460}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(damRetByp.port_b, fanRet.port_a) annotation (Line(
      points={{160,460},{90,460}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(damHex.y, cooCon.yHex) annotation (Line(
      points={{130,512},{130,534},{121,534}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(damRetByp.y, cooCon.yF) annotation (Line(
      points={{170,472},{170,478},{154,478},{154,540},{121,540}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cooCon.TSupCoo, coo.TSet) annotation (Line(
      points={{121,546},{220,546},{220,518},{238,518}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(and1.y, T1.condition) annotation (Line(points={{461,-50},{480,-50},{
          480,-22}},
                color={255,0,255}));
  connect(greThr.y, T2.condition) annotation (Line(points={{421,-230},{452,-230},
          {600,-230},{600,-22}},color={255,0,255}));
  connect(boiOn.active, booToReaBoi.u) annotation (Line(points={{570,-21},{570,
          -90},{422,-90}},
                      color={255,0,255}));
  connect(pumOn2.active, pumOnSig.u[1]) annotation (Line(points={{630,-21},{630,
          -85.3333},{660,-85.3333}},
                           color={255,0,255}));
  connect(boiOn.active, pumOnSig.u[2]) annotation (Line(points={{570,-21},{570,
          -21},{570,-88},{570,-90},{660,-90}},
                                          color={255,0,255}));
  connect(pumOn.active, pumOnSig.u[3]) annotation (Line(points={{510,-21},{510,
          -94.6667},{660,-94.6667}},
                           color={255,0,255}));
  connect(off.outPort[1], T1.inPort)
    annotation (Line(points={{460.5,-10},{468.25,-10},{476,-10}},
                                                               color={0,0,0}));
  connect(T1.outPort, pumOn.inPort[1])
    annotation (Line(points={{481.5,-10},{499,-10}},        color={0,0,0}));
  connect(pumOn.outPort[1], T3.inPort) annotation (Line(points={{520.5,-10},{
          527.25,-10},{536,-10}},    color={0,0,0}));
  connect(T3.outPort, boiOn.inPort[1])
    annotation (Line(points={{541.5,-10},{559,-10}},        color={0,0,0}));
  connect(boiOn.outPort[1], T2.inPort)
    annotation (Line(points={{580.5,-10},{596,-10}},        color={0,0,0}));
  connect(T2.outPort, pumOn2.inPort[1])
    annotation (Line(points={{601.5,-10},{619,-10}},        color={0,0,0}));
  connect(pumOn2.outPort[1], T4.inPort)
    annotation (Line(points={{640.5,-10},{656,-10}},        color={0,0,0}));
  connect(T4.outPort, off.inPort[1]) annotation (Line(points={{661.5,-10},{680,
          -10},{680,20},{420,20},{420,-10},{439,-10}},
                                                color={0,0,0}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-120,
            -260},{700,600}})),
Documentation(info="<html>
<p>
This example demonstrates the implementation of a building that has the following properties:</p>
<p>
There are two rooms. (For simplicity, we only modeled two rooms, but more could be added.)
Each room is modeled using a dynamic model for the heat transfer through the opaque constructions.
The room <code>roo1</code> has a south- and west-facing window, the room <code>roo2</code> has a south- and
east-facing window.
The rooms are modeled as if they were in an intermediate floor, with the same temperature above and below
the room. The rooms share one common wall. The north facing wall is modeled as a partition wall, i.e., both
surfaces have the same boundary conditions.
Weather data are used from Chicago.
</p>
<p>
There is a hydronic heating system with a boiler, a storage tank and a radiator with
a thermostatic valve in each room.
The supply water temperature setpoint
is reset based on the outside temperature. A three-way-valve mixes the water from the tank with
the water from the radiator return. The pump has a variable frequency drive that controls the pump head.
</p>
<p>
A finite state machine is used to switch the boiler and its pump on and off.
The boiler and pump are switched on when the temperature
at the top of the tank is less then 1 Kelvin above the setpoint temperature
for the supply water temperature of the radiator loop.
The boiler and pump are switched off when the temperature at the bottom
of the tank reaches 55 degree Celsius.
The state transition of the finite state machine
is such that first the pump of the boiler is switched on.
Ten seconds later, the boiler will be switched on.
When the tank reaches its temperature, the boiler
is switched off, and ten seconds later, the pump will be switched off.
</p>
<p>
The building has a controlled fresh air supply. A heat recovery ventilator is used to preheat the
outside air.
Each room has a model for the leakage of the facade. If supply and exhaust air are unbalanced, then
the difference in air supply will flow through this leakage model.
</p>
<p>
The hydronic heating system is connected to an expansion vessel.
Some medium models for water compute the density as a function of
temperature, while others assume a constant density.
If the density is modeled as a function of temperature, then the water
volume will increase when heated, and the expansion vessel will
accumulate the added volume. As the water cools, this volume will flow from
the expansion vessel into the hydronic heating system.
If the medium model assumes the density to be constant, then the
expansion vessel provides a reference pressure for the hydronic heating
system.
</p>
<p>
The cooling of the two rooms is controlled using the
temperature of <code>roo1</code>.
The set point for mechanical cooling is <i>25</i> degree Celsius,
with a proportional band of <i>1</i> Kelvin.
</p>
<p>
If the room air temperature is above <i>22</i> degree Celsius,
the free cooling is enabled by opening the bypass damper of the heat
recovery. Free cooling is only allowed if the outside air temperature
is above <i>16</i> degree Celsius and <i>1</i> Kelvin below the
room air temperature.
</p>
<p>
The cooling control is implemented in the model
<a href=\"modelica://Buildings.Examples.HydronicHeating.TwoRoomsWithStorage.CoolingControl\">
Buildings.Examples.HydronicHeating.TwoRoomsWithStorage.CoolingControl</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 6, 2016, by Michael Wetter:<br/>
Replaced <code>Modelica_StateGraph2</code> with <code>Modelica.StateGraph</code>.
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/504\">issue 504</a>.
</li>
<li>
March 1, 2016, by Michael Wetter:<br/>
Removed parameter <code>dynamicBalance</code>.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/484\">#484</a>.
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
<li>
January 12, 2015 by Michael Wetter:<br/>
Made media instances replaceable.
This was done to simplify the numerical benchmarks.
</li>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
October 15, 2013, by Michael Wetter:<br/>
Added free cooling and mechanical cooling.
</li>
<li>
October 14, 2013, by Michael Wetter:<br/>
Corrected wrong pump head for radiator and for boiler pump.
</li>
<li>
March 1, 2013, by Michael Wetter:<br/>
Removed assignment of <code>Kv_SI</code> because this is now a protected parameter.
</li>
<li>
December 6, 2011, by Michael Wetter:<br/>
Added internal heat gains, which were set to zero in the previous version.
</li>
<li>
January 30, 2009, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Examples/HydronicHeating/TwoRoomsWithStorage.mos"
        "Simulate and plot"),
    experiment(StopTime=604800, Tolerance=1e-6));
end TwoRoomsWithStorage;

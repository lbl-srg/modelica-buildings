within Buildings.Examples.HydronicHeating;
model TwoRoomsWithStorage
  "Model of a hydronic heating system with energy storage"
  extends Modelica.Icons.Example;
 replaceable package MediumA = Buildings.Media.Air "Medium model for air";
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
 parameter Modelica.SIunits.Pressure dpPip_nominal = 10000
    "Pressure difference of pipe (without valve)";
 parameter Modelica.SIunits.Pressure dpVal_nominal = 1000
    "Pressure difference of valve";
 parameter Modelica.SIunits.Pressure dpRoo_nominal = 6000
    "Pressure difference of flow leg that serves a room";
 parameter Modelica.SIunits.Pressure dpThrWayVal_nominal = 6000
    "Pressure difference of three-way valve";
 parameter Modelica.SIunits.Pressure dp_nominal=
    dpPip_nominal + dpVal_nominal + dpRoo_nominal + dpThrWayVal_nominal
    "Pressure difference of loop";
  // Room model

  Fluid.Movers.SpeedControlled_y pumBoi(
    redeclare package Medium = MediumW,
    per(pressure(V_flow=mBoi_flow_nominal/1000*{0.5, 1},
                  dp=(3000+2000)*{2,1})),
    dynamicBalance=false)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        origin={70,-120})));

  Fluid.Movers.SpeedControlled_y pumRad(
    redeclare package Medium = MediumW,
    per(pressure(
          V_flow=mRad_flow_nominal/1000*{0,2},
          dp=dp_nominal*{2,0})),
    dynamicBalance=false) "Pump that serves the radiators"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={220,50})));

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
  Rooms.MixedAir roo1(
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
  Rooms.MixedAir roo2(
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
    annotation (Placement(transformation(extent={{2,-130},{22,-110}})));
  Buildings.HeatTransfer.Sources.FixedTemperature TAmb(T=288.15)
    "Ambient temperature in boiler room"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TRoo2
    annotation (Placement(transformation(extent={{480,216},{500,236}})));
  Modelica.Blocks.Sources.Constant pumRadOn(k=1) "Pump on signal"
    annotation (Placement(transformation(extent={{40,140},{60,160}})));
  Controls.Continuous.PIDHysteresisTimer conPum(
    yMax=1,
    Td=60,
    yMin=0.05,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    eOn=0.5,
    k=0.5,
    Ti=15) "Controller for pump"
    annotation (Placement(transformation(extent={{120,100},{140,120}})));
  Buildings.Fluid.Sensors.RelativePressure dpSen(redeclare package Medium =
        MediumW)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={180,50})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage val2(
    redeclare package Medium = MediumW,
    dpValve_nominal(displayUnit="Pa") = dpVal_nominal,
    m_flow_nominal=mRad_flow_nominal/nRoo,
    dpFixed_nominal=dpRoo_nominal,
    from_dp=true) "Radiator valve"
    annotation (Placement(transformation(extent={{360,118},{380,138}})));
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
  Fluid.Actuators.Valves.TwoWayEqualPercentage val1(
    redeclare package Medium = MediumW,
    dpValve_nominal(displayUnit="Pa") = dpVal_nominal,
    m_flow_nominal=mRad_flow_nominal/nRoo,
    dpFixed_nominal=dpRoo_nominal,
    from_dp=true) "Radiator valve"
    annotation (Placement(transformation(extent={{360,390},{380,410}})));
  Controls.Continuous.LimPID conRoo1(
    yMax=1,
    yMin=0,
    Ti=60,
    Td=60,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    k=0.5) "Controller for room temperature"
    annotation (Placement(transformation(extent={{540,500},{560,520}})));
  Fluid.HeatExchangers.Radiators.RadiatorEN442_2 rad1(
    redeclare package Medium = MediumW,
    Q_flow_nominal=scaFacRad*Q_flow_nominal/nRoo,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_a_nominal=323.15,
    T_b_nominal=313.15) "Radiator"
    annotation (Placement(transformation(extent={{392,390},{412,410}})));
  Fluid.HeatExchangers.Radiators.RadiatorEN442_2 rad2(
    redeclare package Medium = MediumW,
    Q_flow_nominal=scaFacRad*Q_flow_nominal/nRoo,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_a_nominal=323.15,
    T_b_nominal=313.15) "Radiator"
    annotation (Placement(transformation(extent={{392,118},{412,138}})));
  Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear thrWayVal(
    redeclare package Medium = MediumW,
    dpValve_nominal=dpThrWayVal_nominal,
    l={0.01,0.01},
    tau=10,
    m_flow_nominal=mRad_flow_nominal,
    dynamicBalance=false,
    dpFixed_nominal={100,0}) "Three-way valve"
                                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={220,0})));
  Controls.Continuous.LimPID conVal(
    yMax=1,
    yMin=0,
    initType=Modelica.Blocks.Types.InitPID.InitialState,
    xi_start=1,
    Td=60,
    k=0.1,
    Ti=120,
    controllerType=Modelica.Blocks.Types.SimpleController.PI)
    "Controller for pump"
    annotation (Placement(transformation(extent={{140,-10},{160,10}})));
  Fluid.Storage.Stratified tan(
    m_flow_nominal=mRad_flow_nominal,
    dIns=0.3,
    redeclare package Medium = MediumW,
    hTan=2,
    nSeg=5,
    show_T=true,
    VTan=0.2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Storage tank"
    annotation (Placement(transformation(extent={{208,-140},{248,-100}})));

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor tanTemBot
    "Tank temperature"
    annotation (Placement(transformation(extent={{280,-190},{300,-170}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor tanTemTop
    "Tank temperature"
    annotation (Placement(transformation(extent={{284,-130},{304,-110}})));
  Modelica.Blocks.Logical.GreaterThreshold greThr(threshold=TSup_nominal + 5)
    annotation (Placement(transformation(extent={{400,-190},{420,-170}})));
  Modelica.Blocks.Math.BooleanToReal booToReaPum "Signal converter for pump"
    annotation (Placement(transformation(extent={{350,-84},{330,-64}})));
  Modelica.Blocks.Logical.Greater lesThr
    annotation (Placement(transformation(extent={{400,-122},{420,-102}})));
  Fluid.Sensors.TemperatureTwoPort temSup(   redeclare package Medium = MediumW,
      m_flow_nominal=mRad_flow_nominal)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={220,80})));
  Fluid.Sensors.TemperatureTwoPort temRet(   redeclare package Medium = MediumW,
      m_flow_nominal=mRad_flow_nominal)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={260,60})));
  Buildings.Controls.SetPoints.HotWaterTemperatureReset heaCha(
    dTOutHeaBal=0,
    use_TRoo_in=true,
    TSup_nominal=TSup_nominal,
    TRet_nominal=TRet_nominal,
    TOut_nominal=258.15)
    annotation (Placement(transformation(extent={{80,-16},{100,4}})));
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
    annotation (Placement(transformation(extent={{0,100},{20,120}})));
  Modelica.Blocks.Logical.Hysteresis hysPum(           uLow=0.01, uHigh=0.5)
    "Hysteresis for pump"
    annotation (Placement(transformation(extent={{40,100},{60,120}})));
  Modelica.Blocks.Logical.Switch swiPum "Pump switch"
    annotation (Placement(transformation(extent={{80,100},{100,120}})));
  Modelica.Blocks.Sources.Constant pumRadOff(k=0) "Pump off signal"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    "File reader that reads weather data"
    annotation (Placement(transformation(extent={{-80,330},{-60,350}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Bus with weather data"
    annotation (Placement(transformation(extent={{-50,330},{-30,350}})));
  Modelica_StateGraph2.Step off(
    nOut=1,
    initialStep=true,
    use_activePort=false,
    nIn=1)
    annotation (Placement(transformation(extent={{476,-4},{484,4}})));
  Modelica_StateGraph2.Transition T1(use_conditionPort=true, use_firePort=false,
    delayedTransition=false)
    annotation (Placement(transformation(extent={{476,-24},{484,-16}})));
  Modelica_StateGraph2.Step pumOn(
    nOut=1,
    use_activePort=true,
    nIn=1) "True if pump is on prior to switching furnace on"
    annotation (Placement(transformation(extent={{476,-44},{484,-36}})));
  Modelica_StateGraph2.Transition T2(
    use_conditionPort=true,
    use_firePort=false,
    delayedTransition=false)
    annotation (Placement(transformation(extent={{476,-104},{484,-96}})));
  Buildings.Fluid.Sources.Outside out(
    redeclare package Medium = MediumA,
    use_C_in=false,
    nPorts=4) "Outside air conditions"
    annotation (Placement(transformation(extent={{0,470},{20,490}})));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM dpFac4(
    from_dp=false,
    redeclare package Medium = MediumA,
    m_flow_nominal=6*4*3*1.2*0.3/3600,
    dp_nominal=10) "Pressure drop at facade"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        origin={330,216})));
  HeatTransfer.Conduction.MultiLayer parWal(A=4*3, layers=matLayPar)
    "Partition wall between the two rooms" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={450,290})));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM dpFac1(
    from_dp=false,
    redeclare package Medium = MediumA,
    m_flow_nominal=6*4*3*1.2*0.3/3600,
    dp_nominal=10) "Pressure drop at facade"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        origin={330,474})));
  Fluid.HeatExchangers.ConstantEffectiveness hex(
    redeclare package Medium1 = MediumA,
    redeclare package Medium2 = MediumA,
    m1_flow_nominal=2*VRoo*1.2*0.3/3600,
    m2_flow_nominal=2*VRoo*1.2*0.3/3600,
    dp1_nominal=100,
    dp2_nominal=100,
    eps=0.9) "Heat recovery"
    annotation (Placement(transformation(extent={{180,478},{200,498}})));
  Fluid.Movers.FlowControlled_m_flow fanSup(
    redeclare package Medium = MediumA,
    dynamicBalance=false,
    m_flow_nominal=2*VRoo*1.2*0.37/3600) "Supply air fan"
    annotation (Placement(transformation(extent={{70,490},{90,510}})));
  Modelica.Blocks.Sources.Constant m_flow_out(k=2*VRoo*1.2*0.37/3600)
    "Outside air mass flow rate"
    annotation (Placement(transformation(extent={{0,500},{20,520}})));
  Fluid.Movers.FlowControlled_m_flow fanRet(
    redeclare package Medium = MediumA,
    dynamicBalance=false,
    m_flow_nominal=2*VRoo*1.2*0.37/3600) "Return air fan"
    annotation (Placement(transformation(extent={{90,450},{70,470}})));
  Airflow.Multizone.Orifice lea1(redeclare package Medium = MediumA, A=0.01^2)
    "Leakage of facade of room"
    annotation (Placement(transformation(extent={{320,430},{340,450}})));
  Airflow.Multizone.Orifice lea2(redeclare package Medium = MediumA, A=0.01^2)
    "Leakage of facade of room"
    annotation (Placement(transformation(extent={{320,170},{340,190}})));
  Modelica_StateGraph2.Transition T3(delayedTransition=true, waitTime=10)
    annotation (Placement(transformation(extent={{476,-64},{484,-56}})));
  Modelica_StateGraph2.Step boiOn(
    nOut=1,
    use_activePort=true,
    nIn=1) "True if boiler is on prior"
    annotation (Placement(transformation(extent={{476,-84},{484,-76}})));
  Modelica_StateGraph2.Step pumOn2(
    nOut=1,
    use_activePort=true,
    nIn=1) "Pump runs for a few seconds after boiler switched off"
    annotation (Placement(transformation(extent={{476,-124},{484,-116}})));
  Modelica_StateGraph2.Transition T4(delayedTransition=true, waitTime=10)
    annotation (Placement(transformation(extent={{476,-144},{484,-136}})));
  Modelica_StateGraph2.Blocks.MathBoolean.Or pumOnSig(nu=3)
    "Signal for pump being on"
    annotation (Placement(transformation(extent={{524,-46},{536,-34}})));
  Modelica.Blocks.Math.BooleanToReal booToReaBoi "Signal converter for boiler"
    annotation (Placement(transformation(extent={{352,-50},{332,-30}})));
  Modelica.Blocks.Math.MatrixGain gai1(K=[35; 70; 30])
    "Gain to convert from occupancy (per person) to radiant, convective and latent heat in [W/m2] "
    annotation (Placement(transformation(extent={{380,550},{400,570}})));
  Modelica.Blocks.Math.MatrixGain gai2(K=[35; 70; 30])
    "Gain to convert from occupancy (per person) to radiant, convective and latent heat in [W/m2] "
    annotation (Placement(transformation(extent={{380,280},{400,300}})));
  Modelica.Blocks.Sources.Constant dTThr(k=1) "Threshold to switch boiler off"
    annotation (Placement(transformation(extent={{310,-160},{330,-140}})));
  Modelica.Blocks.Math.Add add1(k2=-1)
    annotation (Placement(transformation(extent={{350,-130},{370,-110}})));
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
  Fluid.Sources.FixedBoundary bou(nPorts=1, redeclare package Medium = MediumW)
    "Fixed boundary condition, needed to provide a pressure in the system"
    annotation (Placement(transformation(extent={{-82,-130},{-62,-110}})));
  Modelica.Blocks.Math.Gain gain(k=1/dp_nominal)
    "Gain used to normalize pressure measurement signal"
    annotation (Placement(transformation(extent={{160,40},{140,60}})));
  Fluid.FixedResistances.SplitterFixedResistanceDpM splVal(
    dp_nominal={dpPip_nominal,0,0},
    m_flow_nominal=mRad_flow_nominal*{1,-1,-1},
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial)
    "Flow splitter"                                    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={260,0})));
  Fluid.FixedResistances.SplitterFixedResistanceDpM splVal1(
    m_flow_nominal=mRad_flow_nominal*{1,-1,-1},
    redeclare package Medium = MediumW,
    dp_nominal={0,0,0},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial)
    "Flow splitter"                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={220,128})));
  Fluid.FixedResistances.SplitterFixedResistanceDpM splVal2(
    m_flow_nominal=mRad_flow_nominal*{1,-1,-1},
    redeclare package Medium = MediumW,
    dp_nominal={0,0,0},
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial)
    "Flow splitter"                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={260,100})));

  CoolingControl cooCon "Controller for cooling"
    annotation (Placement(transformation(extent={{100,530},{120,550}})));
  Fluid.Actuators.Dampers.Exponential damSupByp(
    redeclare package Medium = MediumA,
    allowFlowReversal=false,
    m_flow_nominal=2*VRoo*1.2*0.37/3600)
    "Supply air damper that bypasses the heat recovery"
    annotation (Placement(transformation(extent={{160,510},{180,530}})));
  Fluid.HeatExchangers.HeaterCooler_T coo(
    redeclare package Medium = MediumA,
    m_flow_nominal=2*VRoo*1.2*0.37/3600,
    dp_nominal=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    Q_flow_maxHeat=0) "Coil for mechanical cooling"
    annotation (Placement(transformation(extent={{240,500},{260,520}})));
  Modelica.Blocks.Logical.LessThreshold lesThrTRoo(threshold=18 + 273.15)
    "Test to block boiler if room air temperature is sufficiently high"
    annotation (Placement(transformation(extent={{400,-20},{420,0}})));
  Modelica.Blocks.Logical.And and1
    "Logical test to enable pump and subsequently the boiler"
    annotation (Placement(transformation(extent={{440,-30},{460,-10}})));

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
  Fluid.Actuators.Dampers.Exponential damHex(
    redeclare package Medium = MediumA,
    allowFlowReversal=false,
    m_flow_nominal=2*VRoo*1.2*0.37/3600)
    "Supply air damper that closes the heat recovery"
    annotation (Placement(transformation(extent={{120,490},{140,510}})));
  Fluid.Actuators.Dampers.Exponential damRetByp(
    redeclare package Medium = MediumA,
    allowFlowReversal=false,
    m_flow_nominal=2*VRoo*1.2*0.37/3600)
    "Return air damper that bypasses the heat recovery"
    annotation (Placement(transformation(extent={{180,450},{160,470}})));
equation
  connect(TAmb.port,boi. heatPort) annotation (Line(
      points={{-20,-90},{12,-90},{12,-112.8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pumRad.port_b, dpSen.port_a)
                                     annotation (Line(
      points={{220,60},{180,60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dpSen.port_b, pumRad.port_a)
                                     annotation (Line(
      points={{180,40},{220,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(val1.port_b, rad1.port_a) annotation (Line(
      points={{380,400},{392,400}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(val2.port_b, rad2.port_a) annotation (Line(
      points={{380,128},{392,128}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(conRoo1.y, val1.y) annotation (Line(
      points={{561,510},{580,510},{580,420},{370,420},{370,412}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conRoo2.y, val2.y)
                            annotation (Line(
      points={{561,250},{580,250},{580,150},{370,150},{370,140}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pumRad.port_a, thrWayVal.port_2)
                                         annotation (Line(
      points={{220,40},{220,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(boi.port_b,pumBoi. port_a) annotation (Line(
      points={{22,-120},{60,-120}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(tan.heaPorVol[1], tanTemTop.port) annotation (Line(
      points={{228,-120.96},{272,-120.96},{272,-120},{284,-120}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(tanTemBot.port, tan.heaPorVol[tan.nSeg]) annotation (Line(
      points={{280,-180},{272,-180},{272,-120},{228,-120}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(temSup.T, conVal.u_m) annotation (Line(
      points={{209,80},{120,80},{120,-20},{150,-20},{150,-12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaCha.TSup, conVal.u_s) annotation (Line(
      points={{101,1.22125e-15},{110.25,1.22125e-15},{110.25,1.88738e-15},{
          119.5,1.88738e-15},{119.5,6.66134e-16},{138,6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tan.port_b, boi.port_a) annotation (Line(
      points={{248,-120},{260,-120},{260,-152},{-28,-152},{-28,-120},{2,-120}},
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
      points={{21,110},{38,110}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hysPum.y, swiPum.u2) annotation (Line(
      points={{61,110},{78,110}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(pumRadOn.y, swiPum.u1)
                              annotation (Line(
      points={{61,150},{68,150},{68,118},{78,118}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pumRadOff.y, swiPum.u3)
                                 annotation (Line(
      points={{61,70},{68,70},{68,102},{78,102}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(swiPum.y, conPum.u_s) annotation (Line(
      points={{101,110},{118,110}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conRoo1.y, maxYVal.u[1]) annotation (Line(
      points={{561,510},{580,510},{580,420},{160,420},{160,240},{-20,240},{-20,
          109},{-2,109}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conRoo2.y, maxYVal.u[2]) annotation (Line(
      points={{561,250},{580,250},{580,150},{160,150},{160,240},{-20,240},{-20,
          111},{-2,111}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conVal.y, thrWayVal.y) annotation (Line(
      points={{161,6.10623e-16},{185.5,6.10623e-16},{185.5,1.4009e-15},{208,
          1.4009e-15}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(booToReaPum.y, pumBoi.y)
                                annotation (Line(
      points={{329,-74},{70,-74},{70,-108}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(off.outPort[1], T1.inPort) annotation (Line(
      points={{480,-4.6},{480,-16}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(greThr.y, T2.conditionPort) annotation (Line(
      points={{421,-180},{460,-180},{460,-100},{475,-100}},
      color={255,0,255},
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
      points={{400,135.2},{400,226},{387,226}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(rad2.heatPortRad, roo2.heaPorRad) annotation (Line(
      points={{404,135.2},{404,222},{387,222},{387,222.2}},
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
      points={{340,216},{356,216},{356,213.333},{373,213.333}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dpFac4.port_a, hex.port_a2) annotation (Line(
      points={{320,216},{272,216},{272,460},{220,460},{220,482},{200,482}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fanSup.m_flow_in, m_flow_out.y) annotation (Line(
      points={{79.8,512},{79.8,516},{80,516},{80,520},{60,520},{60,510},{21,510}},
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
      points={{21,510},{60,510},{60,476},{80.2,476},{80.2,472}},
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
          -12},{78.1,-12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pumRad.port_b, temSup.port_a) annotation (Line(
      points={{220,60},{220,70}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pumOn.outPort[1], T3.inPort) annotation (Line(
      points={{480,-44.6},{480,-56}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(T3.outPort, boiOn.inPort[1]) annotation (Line(
      points={{480,-65},{480,-76}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(boiOn.outPort[1], T2.inPort) annotation (Line(
      points={{480,-84.6},{480,-96}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(T1.outPort, pumOn.inPort[1]) annotation (Line(
      points={{480,-25},{480,-36}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(T2.outPort, pumOn2.inPort[1]) annotation (Line(
      points={{480,-105},{480,-116}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(pumOn2.outPort[1], T4.inPort) annotation (Line(
      points={{480,-124.6},{480,-136}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(T4.outPort, off.inPort[1]) annotation (Line(
      points={{480,-145},{480,-150},{500,-150},{500,12},{480,12},{480,4}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(pumOn.activePort, pumOnSig.u[1]) annotation (Line(
      points={{484.72,-40},{499.36,-40},{499.36,-37.2},{524,-37.2}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(boiOn.activePort, pumOnSig.u[2]) annotation (Line(
      points={{484.72,-80},{506,-80},{506,-40},{524,-40}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(pumOn2.activePort, pumOnSig.u[3]) annotation (Line(
      points={{484.72,-120},{510,-120},{510,-42.8},{524,-42.8}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(boiOn.activePort, booToReaBoi.u) annotation (Line(
      points={{484.72,-80},{560,-80},{560,28},{370,28},{370,-40},{354,-40}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(booToReaPum.u, pumOnSig.y) annotation (Line(
      points={{352,-74},{380,-74},{380,20},{550,20},{550,-40},{537.2,-40}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(weaBus.TDryBul, heaCha.TOut) annotation (Line(
      points={{-40,340},{-40,0},{20,0},{20,1.22125e-15},{78,1.22125e-15}},
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
          {354,494},{354,492}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(switch2.y, gai2.u[1]) annotation (Line(
      points={{361,290},{378,290}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gai2.y, roo2.qGai_flow) annotation (Line(
      points={{401,290},{410,290},{410,260},{350,260},{350,234},{366,234}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaCha.TSup, lesThr.u1) annotation (Line(
      points={{101,1.22125e-15},{110,1.22125e-15},{110,-80},{300,-80},{300,-100},
          {380,-100},{380,-112},{398,-112}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(booToReaBoi.y, boi.y) annotation (Line(
      points={{331,-40},{-50,-40},{-50,-112},{-6.66134e-16,-112}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tan.heaPorTop, TAmb.port) annotation (Line(
      points={{232,-105.2},{232,-90},{-20,-90}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TAmb.port, tan.heaPorSid) annotation (Line(
      points={{-20,-90},{239.2,-90},{239.2,-120}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TAmb.port, tan.heaPorBot) annotation (Line(
      points={{-20,-90},{190,-90},{190,-134.8},{232,-134.8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(add1.y, lesThr.u2) annotation (Line(
      points={{371,-120},{398,-120}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tanTemTop.T, add1.u1) annotation (Line(
      points={{304,-120},{314,-120},{314,-114},{348,-114}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dTThr.y, add1.u2) annotation (Line(
      points={{331,-150},{340,-150},{340,-126},{348,-126}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tanTemBot.T, greThr.u) annotation (Line(
      points={{300,-180},{398,-180}},
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
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus, weaDat.weaBus) annotation (Line(
      points={{-40,340},{-60,340}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(conPum.y, pumRad.y) annotation (Line(
      points={{141,110},{204,110},{204,50},{208,50}},
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
      points={{-62,-120},{2,-120}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(gain.u, dpSen.p_rel) annotation (Line(
      points={{162,50},{168,50},{168,50},{171,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.y, conPum.u_m) annotation (Line(
      points={{139,50},{130,50},{130,98}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pumBoi.port_b, tan.port_a) annotation (Line(
      points={{80,-120},{208,-120}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pumBoi.port_b, thrWayVal.port_1) annotation (Line(
      points={{80,-120},{200,-120},{200,-60},{220,-60},{220,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(temRet.port_b, splVal.port_1) annotation (Line(
      points={{260,50},{260,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(thrWayVal.port_3, splVal.port_3) annotation (Line(
      points={{230,-1.68051e-18},{240,-1.68051e-18},{240,2.33651e-15},{250,
          2.33651e-15}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(splVal.port_2, tan.port_b) annotation (Line(
      points={{260,-10},{260,-120},{248,-120}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(splVal1.port_3, val2.port_a) annotation (Line(
      points={{230,128},{360,128}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(splVal1.port_1, temSup.port_b) annotation (Line(
      points={{220,118},{220,90}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(splVal1.port_2, val1.port_a) annotation (Line(
      points={{220,138},{220,400},{360,400}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(temRet.port_a, splVal2.port_1) annotation (Line(
      points={{260,70},{260,90}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(splVal2.port_3, rad2.port_b) annotation (Line(
      points={{270,100},{420,100},{420,128},{412,128}},
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
      string="%first",
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
      points={{421,-112},{430,-112},{430,-28},{438,-28}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(lesThrTRoo.y, and1.u1) annotation (Line(
      points={{421,-10},{428,-10},{428,-20},{438,-20}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(and1.y, T1.conditionPort) annotation (Line(
      points={{461,-20},{475,-20}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(TRoo1.T, lesThrTRoo.u) annotation (Line(
      points={{500,484},{688,484},{688,42},{388,42},{388,-10},{398,-10}},
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
      points={{121,546},{220,546},{220,516},{238,516}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-120,
            -200},{700,600}}),
                         graphics),
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
    experiment(StopTime=604800, Tolerance=1e-06));
end TwoRoomsWithStorage;

within Buildings.Examples;
model HydronicHeating "Model of a hydronic heating system with energy storage"
  package MediumA = Buildings.Media.GasesConstantDensity.MoistAirUnsaturated
    "Medium model for air";
 package Medium = Buildings.Media.ConstantPropertyLiquidWater "Medium model";

 parameter Integer nRoo = 2 "Number of rooms";
 parameter Modelica.SIunits.Volume VRoo = 4*6*3 "Volume of one room";
 parameter Modelica.SIunits.Power Q_flow_nominal = 2500 "Nominal power";
 parameter Modelica.SIunits.Temperature dT_nominal = 10
    "Nominal temperature difference";
 parameter Modelica.SIunits.MassFlowRate m_flow_nominal = Q_flow_nominal/dT_nominal/4200
    "Nominal mass flow rate";
 parameter Modelica.SIunits.Pressure dpPip_nominal = 10000
    "Pressure difference of pipe (without valve)";
 parameter Modelica.SIunits.Pressure dpVal_nominal = 1000
    "Pressure difference of valve";

 parameter Modelica.SIunits.Pressure dpRoo_nominal = 6000
    "Pressure difference of flow leg that serves a room";
 parameter Modelica.SIunits.Pressure dpThrWayVal_nominal = 6000
    "Pressure difference of three-way valve";
 parameter Modelica.SIunits.Pressure dp_nominal = dpPip_nominal + dpVal_nominal + dpRoo_nominal
    "Pressure difference of loop";

  // Room model
  parameter Buildings.RoomsBeta.Types.ConvectionModel conMod=
    Buildings.RoomsBeta.Types.ConvectionModel.Fixed
    "Convective heat transfer model"
  annotation(Evaluate=true);
  HeatTransfer.Data.OpaqueConstructions.Insulation100Concrete200 matLayExt
    "Construction material for exterior walls"
    annotation (Placement(transformation(extent={{460,560},{480,580}})));
  HeatTransfer.Data.OpaqueConstructions.Brick120 matLayPar
    "Construction material for partition walls"
    annotation (Placement(transformation(extent={{500,560},{520,580}})));
  HeatTransfer.Data.OpaqueConstructions.Generic matLayFlo(
        material={
          HeatTransfer.Data.Solids.Concrete(x=0.2),
          HeatTransfer.Data.Solids.InsulationBoard(x=0.15),
          HeatTransfer.Data.Solids.Concrete(x=0.05)},
        final nLay=3) "Construction material for floor"
    annotation (Placement(transformation(extent={{540,560},{560,580}})));
  HeatTransfer.Data.GlazingSystems.DoubleClearAir13Clear glaSys(
    UFra=2,
    shade=Buildings.HeatTransfer.Data.Shades.Gray(),
    haveInteriorShade=false,
    haveExteriorShade=false) "Data record for the glazing system"
    annotation (Placement(transformation(extent={{580,560},{600,580}})));

  RoomsBeta.MixedAir roo1(
    redeclare package Medium = MediumA,
    AFlo=6*4,
    hRoo=2.7,
    nConExt=0,
    nConExtWin=2,
    datConExtWin(
      layers={matLayExt, matLayExt},
      A={4*3, 6*3},
      glaSys={glaSys, glaSys},
      AWin={3*2, 2*2},
      each fFra=0.1,
      til={Buildings.RoomsBeta.Types.Tilt.Wall, Buildings.RoomsBeta.Types.Tilt.Wall},
      azi={Buildings.RoomsBeta.Types.Azimuth.W, Buildings.RoomsBeta.Types.Azimuth.S},
      each conMod=conMod),
    nConPar=2,
    datConPar(
      layers={matLayFlo, matLayPar},
      A={6*4, 6*3/2},
      til={Buildings.RoomsBeta.Types.Tilt.Floor, Buildings.RoomsBeta.Types.Tilt.Wall},
      azi={Buildings.RoomsBeta.Types.Azimuth.N, Buildings.RoomsBeta.Types.Azimuth.N},
      each conMod=conMod),
    nConBou=0,
    nSurBou=1,
    surBou(
      each A=4*3,
      each epsLW=0.9,
      each epsSW=0.9,
      each til=Buildings.RoomsBeta.Types.Tilt.Wall,
      each conMod=conMod),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nPorts=3,
    lat=0.73268921998722,
    linearizeRadiation=true) "Room model"
    annotation (Placement(transformation(extent={{356,464},{396,504}})));
  RoomsBeta.MixedAir roo2(
    redeclare package Medium = MediumA,
    AFlo=6*4,
    hRoo=2.7,
    nConExt=0,
    nConExtWin=2,
    datConExtWin(
      layers={matLayExt, matLayExt},
      A={4*3, 6*3},
      glaSys={glaSys, glaSys},
      AWin={2*2, 2*2},
      each fFra=0.1,
      til={Buildings.RoomsBeta.Types.Tilt.Wall, Buildings.RoomsBeta.Types.Tilt.Wall},
      azi={Buildings.RoomsBeta.Types.Azimuth.E, Buildings.RoomsBeta.Types.Azimuth.S},
      each conMod=conMod),
    nConPar=2,
    datConPar(
      layers={matLayFlo, matLayPar},
      A={6*4, 6*3/2},
      til={Buildings.RoomsBeta.Types.Tilt.Floor, Buildings.RoomsBeta.Types.Tilt.Wall},
      azi={Buildings.RoomsBeta.Types.Azimuth.N, Buildings.RoomsBeta.Types.Azimuth.N},
      each conMod=conMod),
    nConBou=0,
    nSurBou=1,
    surBou(
      each A=4*3,
      each epsLW=0.9,
      each epsSW=0.9,
      each til=Buildings.RoomsBeta.Types.Tilt.Wall,
      each conMod=conMod),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    lat=0.73268921998722,
    linearizeRadiation=true,
    nPorts=3) "Room model"
    annotation (Placement(transformation(extent={{368,206},{408,246}})));

  Buildings.Fluid.Boilers.BoilerPolynomial boi(
    a={0.9},
    effCur=Buildings.Fluid.Types.EfficiencyCurves.Constant,
    dT_nominal=dT_nominal,
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    dp_nominal=3000,
    T_start=293.15,
    Q_flow_nominal=Q_flow_nominal) "Boiler"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-60,400},{-40,420}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TAmb(T=288.15)
    "Ambient temperature in boiler room"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Fluid.Movers.FlowMachine_y pumRad(
    redeclare package Medium = Medium,
    redeclare function flowCharacteristic =
        Buildings.Fluid.Movers.BaseClasses.Characteristics.linearFlow (
          V_flow_nominal=m_flow_nominal/1000*{0,2}, dp_nominal=dp_nominal*{2,0}),
    m_flow_nominal=m_flow_nominal,
    dynamicBalance=true) "Pump that serves the radiators"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={220,44})));

  Buildings.Fluid.FixedResistances.FixedResistanceDpM resSup(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dpPip_nominal) "Pressure drop of supply and return pipe"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={240,90})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TRoo2
    annotation (Placement(transformation(extent={{460,216},{480,236}})));
  Modelica.Blocks.Sources.Constant dpSet(k=dp_nominal) "Pressure set point"
    annotation (Placement(transformation(extent={{80,200},{100,220}})));
  Controls.Continuous.PIDHysteresisTimer conPum(
    Ti=60,
    yMax=1,
    eOn=1,
    k=0.1,
    Td=60,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    yMin=0.05) "Controller for pump"
    annotation (Placement(transformation(extent={{140,100},{160,120}})));
  Buildings.Fluid.Sensors.RelativePressure dpSen(redeclare package Medium =
        Medium)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={186,44})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage val2(
    redeclare package Medium = Medium,
    dp_nominal(displayUnit="Pa") = dpVal_nominal,
    Kv_SI=m_flow_nominal/nRoo/sqrt(dpVal_nominal),
    m_flow_nominal=m_flow_nominal/nRoo,
    from_dp=false) "Radiator valve"
    annotation (Placement(transformation(extent={{320,118},{340,138}})));
  Controls.Continuous.LimPID conRoo2(
    yMax=1,
    yMin=0,
    Ti=60,
    Td=60,
    k=1,
    controllerType=Modelica.Blocks.Types.SimpleController.P)
    "Controller for room temperature"
    annotation (Placement(transformation(extent={{540,240},{560,260}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TRoo1
    annotation (Placement(transformation(extent={{444,474},{464,494}})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage val1(
    redeclare package Medium = Medium,
    dp_nominal(displayUnit="Pa") = dpVal_nominal,
    Kv_SI=m_flow_nominal/nRoo/sqrt(dpVal_nominal),
    m_flow_nominal=m_flow_nominal/nRoo,
    from_dp=false) "Radiator valve"
    annotation (Placement(transformation(extent={{360,390},{380,410}})));
  Controls.Continuous.LimPID conRoo1(
    yMax=1,
    yMin=0,
    Ti=60,
    Td=60,
    k=1,
    controllerType=Modelica.Blocks.Types.SimpleController.P)
    "Controller for room temperature"
    annotation (Placement(transformation(extent={{540,520},{560,540}})));
  Buildings.Fluid.HeatExchangers.Radiators.RadiatorEN442_2 rad1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal/nRoo,
    dT_nominal=(50 + 30)/2 - 20,
    Q_flow_nominal=2*Q_flow_nominal/nRoo) "Radiator"
    annotation (Placement(transformation(extent={{392,390},{412,410}})));
  Buildings.Fluid.HeatExchangers.Radiators.RadiatorEN442_2 rad2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal/nRoo,
    dT_nominal=(50 + 30)/2 - 20,
    Q_flow_nominal=2*Q_flow_nominal/nRoo) "Radiator"
    annotation (Placement(transformation(extent={{392,118},{412,138}})));
  Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear thrWayVal(
                                            redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal,
    dp_nominal=dpThrWayVal_nominal,
    l={0.01,0.01},
    tau=10,
    dynamicBalance=true) "Three-way valve"
                                     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={220,0})));
  Controls.Continuous.LimPID conVal(
    k=1,
    Ti=60,
    yMax=1,
    yMin=0,
    initType=Modelica.Blocks.Types.InitPID.InitialState,
    xi_start=1,
    controllerType=Modelica.Blocks.Types.SimpleController.P,
    Td=60) "Controller for pump"
    annotation (Placement(transformation(extent={{140,-10},{160,10}})));
  Fluid.Storage.Stratified tan(
    m_flow_nominal=m_flow_nominal,
    dIns=0.3,
    redeclare package Medium = Medium,
    hTan=2,
    nSeg=5,
    show_T=true,
    VTan=0.2) "Storage tank"
    annotation (Placement(transformation(extent={{220,-80},{260,-40}})));
  Fluid.Movers.FlowMachine_y pumBoi(
    redeclare package Medium = Medium,
    allowFlowReversal=false,
    redeclare function flowCharacteristic =
        Buildings.Fluid.Movers.BaseClasses.Characteristics.linearFlow (
          dp_nominal=1.5*5000*{1,2}, V_flow_nominal=2*{
            m_flow_nominal/1000,0.5*m_flow_nominal/1000}),
    m_flow_nominal=2*m_flow_nominal,
    dynamicBalance=true)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={66,-60})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor tanTemBot
    "Tank temperature"
    annotation (Placement(transformation(extent={{286,-84},{306,-64}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor tanTemTop
    "Tank temperature"
    annotation (Placement(transformation(extent={{286,-56},{306,-36}})));
  Modelica.Blocks.Logical.GreaterThreshold greThr(threshold=273.15 + 52)
    annotation (Placement(transformation(extent={{332,-84},{352,-64}})));
  Modelica.Blocks.Math.BooleanToReal booToRea
    annotation (Placement(transformation(extent={{80,10},{60,30}})));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM res3(
    redeclare package Medium = Medium,
    m_flow_nominal=2*m_flow_nominal,
    dp_nominal=2000)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={124,-60})));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM res4(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=100)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={260,-22})));
  Modelica.Blocks.Logical.LessThreshold lesThr(threshold=273.15 + 50)
    annotation (Placement(transformation(extent={{332,-56},{352,-36}})));
  Buildings.Fluid.Sensors.Temperature temSup(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{110,62},{130,82}})));
  Buildings.Fluid.Sensors.Temperature temRet(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{264,62},{284,82}})));
  Buildings.Controls.SetPoints.HotWaterTemperatureReset heaCha(
    dTOutHeaBal=0,
    TSup_nominal=323.15,
    TRet_nominal=313.15,
    TOut_nominal=258.15,
    use_TRoo_in=true)
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  Controls.SetPoints.OccupancySchedule occSch1(occupancy=3600*{7,8,10,11,11.5,
        15,19,21}) "Occupancy schedule"
    annotation (Placement(transformation(extent={{300,556},{320,576}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{360,550},{380,570}})));
  Modelica.Blocks.Sources.RealExpression occ1(y=30/6/4)
    "Heat gain if occupied in room 1"
    annotation (Placement(transformation(extent={{328,558},{348,578}})));
  Modelica.Blocks.Sources.Constant zer(k=0) "Outputs zero"
    annotation (Placement(transformation(extent={{260,540},{280,560}})));
  Controls.SetPoints.OccupancySchedule occSch2(
      firstEntryOccupied=false, occupancy=3600*{7,10,12,22})
    "Occupancy schedule"
    annotation (Placement(transformation(extent={{300,286},{320,306}})));
  Modelica.Blocks.Logical.Switch switch2
    annotation (Placement(transformation(extent={{340,280},{360,300}})));
  Modelica.Blocks.Sources.RealExpression occ2(y=30/6/4)
    "Heat gain if occupied in room 2"
    annotation (Placement(transformation(extent={{300,310},{320,330}})));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM resRoo1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal/nRoo,
    dp_nominal=dpRoo_nominal,
    from_dp=false) "Resistance of pipe leg that serves the room"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={330,400})));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM resRoo2(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal/nRoo,
    dp_nominal=dpRoo_nominal,
    from_dp=false) "Resistance of pipe leg that serves the room"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={290,128})));
  Controls.SetPoints.OccupancySchedule occSch "Occupancy schedule"
    annotation (Placement(transformation(extent={{480,360},{500,380}})));
  Modelica.Blocks.Logical.Switch switch3
    annotation (Placement(transformation(extent={{562,360},{582,380}})));
  Modelica.Blocks.Sources.Constant TRooNig(k=273.15 + 16)
    "Room temperature set point at night"
    annotation (Placement(transformation(extent={{520,330},{540,350}})));
  Modelica.Blocks.Sources.Constant TRooSet(k=273.15 + 21)
    annotation (Placement(transformation(extent={{520,380},{540,400}})));
  Fluid.Storage.ExpansionVessel expVes(redeclare package Medium = Medium, VTot=
        1) "Expansion vessel"
    annotation (Placement(transformation(extent={{-90,-40},{-70,-20}})));
  HeatTransfer.Data.OpaqueConstructions.Generic extWalCon(nLay=2, material={
        insul,brick}) "Record for exterior wall construction"
    annotation (Placement(transformation(extent={{-80,240},{-60,260}})));
  HeatTransfer.Data.Solids.Brick brick(x=0.24, nStaRef=3)
    "Brick for exterior wall"
    annotation (Placement(transformation(extent={{-40,280},{-20,300}})));
  HeatTransfer.Data.Solids.InsulationBoard insul(x=0.2, nStaRef=3)
    "Insulation for exterior wall"
    annotation (Placement(transformation(extent={{-80,280},{-60,300}})));
  Utilities.Math.Max maxYVal(nin=2) "Maximum radiator valve position"
    annotation (Placement(transformation(extent={{40,160},{60,180}})));
  Modelica.Blocks.Logical.Hysteresis hysPum(uHigh=0.1, uLow=0.01)
    "Hysteresis for pump"
    annotation (Placement(transformation(extent={{80,160},{100,180}})));
  Modelica.Blocks.Logical.Switch swiPum "Pump switch"
    annotation (Placement(transformation(extent={{120,160},{140,180}})));
  Modelica.Blocks.Sources.Constant dpSetOff(k=0)
    "Pressure set point to switch pump off"
    annotation (Placement(transformation(extent={{80,120},{100,140}})));
  BoundaryConditions.WeatherData.Reader weaDat(filNam=
        "Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos")
    annotation (Placement(transformation(extent={{-20,350},{0,370}})));
  BoundaryConditions.WeatherData.Bus weaBus
    annotation (Placement(transformation(extent={{10,350},{30,370}})));
  Modelica.Blocks.Continuous.FirstOrder delRadPum(T=10)
    "Delay element for the transient response of the pump"
    annotation (Placement(transformation(extent={{172,74},{192,94}})));
  Modelica_StateGraph2.Step off(
    nOut=1,
    nIn=1,
    initialStep=true,
    use_activePort=false)
    annotation (Placement(transformation(extent={{496,16},{504,24}})));
  Modelica_StateGraph2.Transition T1(use_conditionPort=true, use_firePort=false,
    delayedTransition=true,
    waitTime=1)
    annotation (Placement(transformation(extent={{496,-4},{504,4}})));
  Modelica_StateGraph2.Step on(
    nIn=1,
    nOut=1,
    use_activePort=true)
    annotation (Placement(transformation(extent={{496,-24},{504,-16}})));
  Modelica_StateGraph2.Transition T2(
    use_conditionPort=true,
    use_firePort=false,
    delayedTransition=false)
    annotation (Placement(transformation(extent={{496,-44},{504,-36}})));

  Modelica.Blocks.Routing.Replicator replicator(nout=3)
    annotation (Placement(transformation(extent={{400,550},{420,570}})));
  Fluid.Sources.Boundary_pT exh1(
    redeclare package Medium = MediumA,
    use_T_in=true,
    use_X_in=true,
    use_C_in=false,
    T=293.15,
    nPorts=4) "Reservoir for exhaust air"
    annotation (Placement(transformation(extent={{110,444},{130,464}})));
  Utilities.Psychrometrics.X_pTphi x_pTphi(redeclare package Medium = MediumA)
    "Block to compute water vapor concentration"
    annotation (Placement(transformation(extent={{60,440},{80,460}})));

  Modelica.Blocks.Routing.Replicator replicator1(
                                                nout=3)
    annotation (Placement(transformation(extent={{380,280},{400,300}})));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM dpFac4(
    from_dp=false,
    redeclare package Medium = MediumA,
    m_flow_nominal=6*4*3*1.2*0.3/3600,
    dp_nominal=10) "Pressure drop at facade"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={330,216})));
  HeatTransfer.ConductorMultiLayer parWal(A=4*3, layers=matLayPar)
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
        rotation=0,
        origin={330,474})));
  Fluid.HeatExchangers.ConstantEffectiveness hex(
    redeclare package Medium1 = MediumA,
    redeclare package Medium2 = MediumA,
    m1_flow_nominal=2*VRoo*1.2*0.3/3600,
    m2_flow_nominal=2*VRoo*1.2*0.3/3600,
    dp1_nominal=100,
    dp2_nominal=100,
    eps=0.9) "Heat recovery"
    annotation (Placement(transformation(extent={{200,470},{220,490}})));
  Fluid.Movers.FlowMachine_m_flow fanSup(
    redeclare package Medium = MediumA,
    dynamicBalance=false,
    m_flow_nominal=2*VRoo*1.2*0.37/3600,
    m_flow_max=2*VRoo*1.2*0.37/3600) "Supply air fan"
    annotation (Placement(transformation(extent={{160,490},{180,510}})));
  Modelica.Blocks.Sources.Constant m_flow_out(k=2*VRoo*1.2*0.37/3600)
    "Outside air mass flow rate"
    annotation (Placement(transformation(extent={{80,530},{100,550}})));
  Fluid.Movers.FlowMachine_m_flow fanRet(
    redeclare package Medium = MediumA,
    dynamicBalance=false,
    m_flow_nominal=2*VRoo*1.2*0.37/3600,
    m_flow_max=2*VRoo*1.2*0.37/3600) "Return air fan"
    annotation (Placement(transformation(extent={{180,450},{160,470}})));
  Airflow.Multizone.Orifice lea1(redeclare package Medium = MediumA, A=0.01^2)
    "Leakage of facade of room"
    annotation (Placement(transformation(extent={{320,430},{340,450}})));
  Airflow.Multizone.Orifice lea2(redeclare package Medium = MediumA, A=0.01^2)
    "Leakage of facade of room"
    annotation (Placement(transformation(extent={{320,170},{340,190}})));
equation
  connect(TAmb.port,boi. heatPort) annotation (Line(
      points={{-20,-10},{-10,-10},{-10,-52.8}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pumRad.port_b, dpSen.port_a)
                                     annotation (Line(
      points={{220,54},{186,54}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dpSen.port_b, pumRad.port_a)
                                     annotation (Line(
      points={{186,34},{220,34}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dpSen.p_rel, conPum.u_m) annotation (Line(
      points={{177,44},{150,44},{150,98}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(val1.port_b, rad1.port_a) annotation (Line(
      points={{380,400},{392,400}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(val2.port_b, rad2.port_a) annotation (Line(
      points={{340,128},{392,128}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(conRoo1.y, val1.y) annotation (Line(
      points={{561,530},{580,530},{580,420},{370,420},{370,408}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conRoo2.y, val2.y)
                            annotation (Line(
      points={{561,250},{580,250},{580,150},{330,150},{330,136}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pumRad.port_a, thrWayVal.port_2)
                                         annotation (Line(
      points={{220,34},{220,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(boi.port_b,pumBoi. port_a) annotation (Line(
      points={{5.55112e-16,-60},{56,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(tan.heaPorVol[1], tanTemTop.port) annotation (Line(
      points={{240,-60.96},{272,-60.96},{272,-46},{286,-46}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(tanTemBot.port, tan.heaPorVol[tan.nSeg]) annotation (Line(
      points={{286,-74},{272,-74},{272,-60},{240,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(tanTemBot.T, greThr.u)        annotation (Line(
      points={{306,-74},{330,-74}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pumBoi.port_b, res3.port_a) annotation (Line(
      points={{76,-60},{114,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res4.port_b, tan.port_b) annotation (Line(
      points={{260,-32},{260,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(tanTemTop.T, lesThr.u) annotation (Line(
      points={{306,-46},{330,-46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pumRad.port_b, temSup.port) annotation (Line(
      points={{220,54},{220,60},{120,60},{120,62}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(temSup.T, conVal.u_m) annotation (Line(
      points={{127,72},{134,72},{134,-20},{150,-20},{150,-12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(resSup.port_b, temRet.port)
                                    annotation (Line(
      points={{240,80},{240,60},{274,60},{274,62}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heaCha.TSup, conVal.u_s) annotation (Line(
      points={{81,76},{110,76},{110,6.66134e-16},{138,6.66134e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(booToRea.y,boi. y) annotation (Line(
      points={{59,20},{-50,20},{-50,-52},{-22,-52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tan.port_b, boi.port_a) annotation (Line(
      points={{260,-60},{260,-92},{-28,-92},{-28,-60},{-20,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(tan.port_a, thrWayVal.port_1) annotation (Line(
      points={{220,-60},{220,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res3.port_b, tan.port_a) annotation (Line(
      points={{134,-60},{220,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res4.port_a, resSup.port_b)
                                    annotation (Line(
      points={{260,-12},{260,-6},{240,-6},{240,80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(resSup.port_b, thrWayVal.port_3)
                                         annotation (Line(
      points={{240,80},{240,-1.68051e-18},{230,-1.68051e-18}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(occSch1.occupied, switch1.u2) annotation (Line(
      points={{321,560},{358,560}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(occ1.y, switch1.u1) annotation (Line(
      points={{349,568},{358,568}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(zer.y, switch1.u3) annotation (Line(
      points={{281,550},{340,550},{340,552},{358,552}},
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

  connect(TRooSet.y, switch3.u1) annotation (Line(
      points={{541,390},{550,390},{550,378},{560,378}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(occSch.occupied, switch3.u2) annotation (Line(
      points={{501,364},{530,364},{530,370},{560,370}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(TRooNig.y, switch3.u3) annotation (Line(
      points={{541,340},{548,340},{548,362},{560,362}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(switch3.y, conRoo1.u_s) annotation (Line(
      points={{583,370},{590,370},{590,500},{520,500},{520,530},{538,530}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(switch3.y, conRoo2.u_s) annotation (Line(
      points={{583,370},{590,370},{590,280},{520,280},{520,250},{538,250}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(expVes.port_a, boi.port_a) annotation (Line(
      points={{-80,-40},{-80,-60},{-20,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(maxYVal.y, hysPum.u) annotation (Line(
      points={{61,170},{78,170}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hysPum.y, swiPum.u2) annotation (Line(
      points={{101,170},{118,170}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(dpSet.y, swiPum.u1) annotation (Line(
      points={{101,210},{108,210},{108,178},{118,178}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dpSetOff.y, swiPum.u3) annotation (Line(
      points={{101,130},{108,130},{108,162},{118,162}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(swiPum.y, conPum.u_s) annotation (Line(
      points={{141,170},{148,170},{148,140},{120,140},{120,110},{138,110}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conRoo1.y, maxYVal.u[1]) annotation (Line(
      points={{561,530},{580,530},{580,420},{32,420},{32,169},{38,169}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conRoo2.y, maxYVal.u[2]) annotation (Line(
      points={{561,250},{580,250},{580,150},{160,150},{160,240},{32,240},{32,172},
          {38,172},{38,171}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(conVal.y, thrWayVal.y) annotation (Line(
      points={{161,6.10623e-16},{185.5,6.10623e-16},{185.5,1.15598e-15},{212,
          1.15598e-15}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{5.55112e-16,360},{20,360}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(heaCha.TOut, weaBus.TDryBul) annotation (Line(
      points={{58,76},{38,76},{38,78},{20,78},{20,360}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(conPum.y, delRadPum.u) annotation (Line(
      points={{161,110},{166,110},{166,84},{170,84}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(delRadPum.y, pumRad.y) annotation (Line(
      points={{193,84},{200,84},{200,44},{210,44}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(booToRea.y, pumBoi.y) annotation (Line(
      points={{59,20},{40,20},{40,-40},{66,-40},{66,-50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TRoo2.T, conRoo2.u_m) annotation (Line(
      points={{480,226},{550,226},{550,238}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TRoo1.T, conRoo1.u_m) annotation (Line(
      points={{464,484},{550,484},{550,518}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(resRoo2.port_b, val2.port_a) annotation (Line(
      points={{300,128},{320,128}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(rad2.port_b, resSup.port_a) annotation (Line(
      points={{412,128},{420,128},{420,108},{240,108},{240,100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(resRoo1.port_b, val1.port_a) annotation (Line(
      points={{340,400},{360,400}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(rad1.port_b, resSup.port_a) annotation (Line(
      points={{412,400},{420,400},{420,380},{240,380},{240,100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pumRad.port_b, resRoo2.port_a) annotation (Line(
      points={{220,54},{220,128},{280,128}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(pumRad.port_b, resRoo1.port_a) annotation (Line(
      points={{220,54},{220,400},{320,400}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(off.outPort[1], T1.inPort) annotation (Line(
      points={{500,15.4},{500,4}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(T1.outPort, on.inPort[1]) annotation (Line(
      points={{500,-5},{500,-16}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(on.outPort[1], T2.inPort) annotation (Line(
      points={{500,-24.6},{500,-36}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(T2.outPort, off.inPort[1]) annotation (Line(
      points={{500,-45},{500,-52},{520,-52},{520,38},{500,38},{500,24}},
      color={0,0,0},
      smooth=Smooth.None));
  connect(lesThr.y, T1.conditionPort) annotation (Line(
      points={{353,-46},{360,-46},{360,8.32667e-17},{495,8.32667e-17}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(greThr.y, T2.conditionPort) annotation (Line(
      points={{353,-74},{370,-74},{370,-40},{495,-40}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(on.activePort, booToRea.u) annotation (Line(
      points={{504.72,-20},{540,-20},{540,60},{480,60},{480,20},{82,20}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(switch1.y, replicator.u) annotation (Line(
      points={{381,560},{398,560}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(replicator.y, roo1.qGai_flow) annotation (Line(
      points={{421,560},{430,560},{430,540},{340,540},{340,494},{354,494}},
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
      points={{375,484},{444,484}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(weaBus, roo1.weaBus) annotation (Line(
      points={{20,360},{430,360},{430,502},{393.9,502},{393.9,501.9}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {600,600}}),       graphics),
Documentation(info="<html>
<p>
This example demonstrates the implementation of a building that has the following properties:</p>
<p>
<ul>
<li>
There are two rooms. (For simplicity, we only modeled two rooms, but more could be added.)
Each room is modeled using a dynamic model for the heat transfer through the opaque constructions.
The room <code>roo1</code> has a south- and west-facing window, the room <code>roo2</code> has a south- and 
east-facing window.
The rooms are modeled as if they were in an intermediate floor, with the same temperature above and below 
the room. The rooms share one common wall. The north facing wall is modeled as a partition wall, i.e., both
surfaces have the same boundary conditions.
Weather data are used from Chicago.
</li>
<li>
There is a hydronic heating system with a boiler, a storage tank and a radiator with
a thermostatic valve in each room.
A finite state machine is used to switch the boiler and its pump on and off whenever the tank temperature
is outside a prescribed temperature range. The supply water temperature setpoint
is reset based on the outside temperature. A three-way-valve mixes the water from the tank with
the water from the radiator return. The pump has a variable frequency drive that controls the pump head.
</li>
<li>
The building has a controlled fresh air supply. A heat recovery ventilator is used to preheat the
outside air.
Each room has a model for the leakage of the facade. If supply and exhaust air are unbalanced, then
the difference in air supply will flow through this leakage model.
</li>
</ul>
</p>
<h4>Information for Windows users:</h4>
<p>
This example uses the Radau solver. 
For Dymola 7.4, Microsoft Visual C++ Express 2010 does
not work with the Radau solver.
Microsoft Visual C++ Express is not officialy supported by Dymola 7.4 and it can not link
the model to the Radau solver. 
To avoid this problem, use another compiler, such as Visual C++ 2008. 
</p>
</html>"),Commands(file=
          "HydronicHeating.mos" "run"),
    experiment(
      StopTime=172800,
      Tolerance=1e-006,
      Algorithm="radau"),
    experimentSetupOutput,
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{600,
            600}})));
  connect(weaBus.TDryBul, exh1.T_in) annotation (Line(
      points={{20,360},{20,480},{100,480},{100,458},{108,458}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.pAtm, x_pTphi.p_in) annotation (Line(
      points={{20,360},{20,456},{58,456}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaBus.TDryBul, x_pTphi.T) annotation (Line(
      points={{20,360},{20,450},{58,450}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaBus.relHum, x_pTphi.phi) annotation (Line(
      points={{20,360},{20,444},{58,444}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(x_pTphi.X, exh1.X_in) annotation (Line(
      points={{81,450},{108,450}},
      color={0,0,127},
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
      points={{387,226},{460,226}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(weaBus, roo2.weaBus) annotation (Line(
      points={{20,360},{430,360},{430,244},{405.9,244},{405.9,243.9}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(switch2.y, replicator1.u) annotation (Line(
      points={{361,290},{378,290}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(replicator1.y, roo2.qGai_flow) annotation (Line(
      points={{401,290},{410,290},{410,260},{350,260},{350,236},{366,236}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(roo1.surf_surBou[1], parWal.port_b) annotation (Line(
      points={{372.2,470},{372,470},{372,440},{450,440},{450,300}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(parWal.port_a, roo2.surf_surBou[1]) annotation (Line(
      points={{450,280},{450,160},{384.2,160},{384.2,212}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(hex.port_b1, roo1.ports[1]) annotation (Line(
      points={{220,486},{350,486},{350,474},{358.333,474}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(roo1.ports[2], dpFac1.port_b) annotation (Line(
      points={{361,474},{340,474}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dpFac1.port_a, hex.port_a2) annotation (Line(
      points={{320,474},{220,474}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hex.port_b1, roo2.ports[1]) annotation (Line(
      points={{220,486},{280,486},{280,232},{360,232},{360,216},{370.333,216}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dpFac4.port_b, roo2.ports[2]) annotation (Line(
      points={{340,216},{373,216}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dpFac4.port_a, hex.port_a2) annotation (Line(
      points={{320,216},{274,216},{274,474},{220,474}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fanSup.m_flow_in, m_flow_out.y) annotation (Line(
      points={{165,508.2},{165,540.1},{101,540.1},{101,540}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(fanSup.port_b, hex.port_a1) annotation (Line(
      points={{180,500},{192,500},{192,486},{200,486}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fanRet.port_a, hex.port_b2) annotation (Line(
      points={{180,460},{192,460},{192,474},{200,474}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(exh1.ports[1], fanSup.port_a) annotation (Line(
      points={{130,457},{132,457},{132,458},{140,458},{140,500},{160,500}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(fanRet.port_b, exh1.ports[2]) annotation (Line(
      points={{160,460},{146,460},{146,455},{130,455}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(m_flow_out.y, fanRet.m_flow_in) annotation (Line(
      points={{101,540},{152,540},{152,476},{175,476},{175,468.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(lea1.port_b, roo1.ports[3]) annotation (Line(
      points={{340,440},{350,440},{350,474},{363.667,474}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(lea1.port_a, exh1.ports[3]) annotation (Line(
      points={{320,440},{140,440},{140,450},{130,450},{130,453}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(lea2.port_b, roo2.ports[3]) annotation (Line(
      points={{340,180},{360,180},{360,216},{375.667,216}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(lea2.port_a, exh1.ports[4]) annotation (Line(
      points={{320,180},{268,180},{268,436},{134,436},{134,451},{130,451}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(switch3.y, heaCha.TRoo_in) annotation (Line(
      points={{583,370},{590,370},{590,150},{160,150},{160,240},{32,240},{32,64},
          {58.1,64}},
      color={0,0,127},
      smooth=Smooth.None));
end HydronicHeating;

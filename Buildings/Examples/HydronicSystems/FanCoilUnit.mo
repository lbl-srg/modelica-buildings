within Buildings.Examples.HydronicSystems;
model FanCoilUnit
  "Model of a five zone floor with fan coil units"
  extends Modelica.Icons.Example;

  replaceable package MediumA = Buildings.Media.Air
    "Medium for air";

  replaceable package MediumW = Buildings.Media.Water
    "Medium for hot-water and chilled-water";

  parameter Modelica.Units.SI.Length hRoo=2.74
    "Room height";

  parameter Modelica.Units.SI.Area AFlo=568.77/hRoo
    "Area of each zone";

  parameter Modelica.Units.SI.Volume VRoo=AFlo*hRoo
    "Volume of each zone";

  parameter Modelica.Units.SI.Length wExt=49.91
    "Exterior wall width of each zone";

  parameter HeatTransfer.Types.InteriorConvection intConMod=Buildings.HeatTransfer.Types.InteriorConvection.Temperature
    "Convective heat transfer model for room-facing surfaces of opaque constructions";

  parameter Real winWalRat(
    min=0.01,
    max=0.99) = 0.33
    "Window to wall ratio for exterior walls";

  parameter Modelica.Units.SI.Length hWin=1.5
    "Height of windows";

  parameter Real kInt(min=0, max=1) = 1
    "Gain factor to scale internal heat gain in each zone";

  parameter HeatTransfer.Data.Solids.Plywood matCarTra(
    k=0.11,
    d=544,
    nStaRef=1,
    x=0.215/0.11)
    "Wood for floor"
    annotation (Placement(transformation(extent={{200,190},{220,210}})));

  parameter HeatTransfer.Data.Solids.Plywood matFur(
    x=0.15,
    nStaRef=5)
    "Material for furniture"
    annotation (Placement(transformation(extent={{240,190},{260,210}})));

  parameter HeatTransfer.Data.Solids.Concrete matCon(
    x=0.1,
    k=1.311,
    c=836,
    nStaRef=5)
    "Concrete"
    annotation (Placement(transformation(extent={{200,130},{220,150}})));

  parameter HeatTransfer.Data.Solids.Plywood matWoo(
    x=0.01,
    k=0.11,
    d=544,
    nStaRef=1)
    "Wood for exterior construction"
    annotation (Placement(transformation(extent={{200,100},{220,120}})));

  parameter HeatTransfer.Data.Solids.GypsumBoard matGyp(
    x=0.0127,
    k=0.16,
    c=830,
    d=784,
    nStaRef=2)
    "Gypsum board"
    annotation (Placement(transformation(extent={{200,60},{220,80}})));

  parameter HeatTransfer.Data.Resistances.Carpet matCar
    "Carpet"
    annotation (Placement(transformation(extent={{200,160},{220,180}})));

  parameter HeatTransfer.Data.Solids.Generic matIns(
    x=0.087,
    k=0.049,
    c=836.8,
    d=265,
    nStaRef=5)
    "Steelframe construction with insulation"
    annotation (Placement(transformation(extent={{240,100},{260,120}})));

  parameter HeatTransfer.Data.Solids.GypsumBoard matGyp2(
    x=0.025,
    k=0.16,
    c=830,
    d=784,
    nStaRef=2)
    "Gypsum board"
    annotation (Placement(transformation(extent={{240,60},{260,80}})));

  parameter HeatTransfer.Data.GlazingSystems.DoubleClearAir13Clear glaSys(
    UFra=2,
    shade=Buildings.HeatTransfer.Data.Shades.Gray(),
    haveInteriorShade=false,
    haveExteriorShade=false)
    "Data record for the glazing system"
    annotation (Placement(transformation(extent={{240,160},{260,180}})));

  parameter HeatTransfer.Data.OpaqueConstructions.Generic conExtWal(
    final nLay=3,
    material={matWoo,matIns,matGyp})
    "Exterior construction"
    annotation (Placement(transformation(extent={{208,264},{228,284}})));

  parameter HeatTransfer.Data.OpaqueConstructions.Generic conIntWal(
    final nLay=1,
    material={matGyp2})
    "Interior wall construction"
    annotation (Placement(transformation(extent={{246,264},{266,284}})));

  parameter HeatTransfer.Data.OpaqueConstructions.Generic conFur(
    final nLay=1,
    material={matFur})
    "Construction for internal mass of furniture"
    annotation (Placement(transformation(extent={{246,224},{266,244}})));

  parameter HeatTransfer.Data.OpaqueConstructions.Generic conFlo(
    final nLay=1,
    material={matCon})
    "Floor construction (opa_a is carpet)"
    annotation (Placement(transformation(extent={{208,224},{228,244}})));

  Buildings.Fluid.Sources.Boundary_pT souHea(
    redeclare package Medium = MediumW,
    p(displayUnit="Pa") = 100000 + 3000,
    T=333.15,
    nPorts=1)
    "Source for hot water"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90, origin={70,-230})));

  Buildings.Fluid.Sources.Boundary_pT sinHea(
    redeclare package Medium = MediumW,
    p=100000,
    T=328.15,
    nPorts=1)
    "Sink for hot water"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90, origin={20,-230})));

  Buildings.Fluid.Sources.Boundary_pT sinCoo(
    redeclare package Medium = MediumW,
    p=100000,
    T=288.15,
    nPorts=3)
    "Sink for chilled water"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90, origin={110,-230})));

  Buildings.Fluid.Sources.Boundary_pT souCoo(
    redeclare package Medium = MediumW,
    p(displayUnit="Pa") = 100000 + 3000,
    T=279.15,
    nPorts=3)
    "Source for chilled water"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90, origin={152,-230})));

  Buildings.Fluid.ZoneEquipment.FourPipe fanCoiUni(
    redeclare package MediumA = MediumA,
    redeclare package MediumHW = MediumW,
    redeclare package MediumCHW = MediumW,
    heaCoiTyp=Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.None,
    dpAir_nominal=100,
    mChiWat_flow_nominal=4*0.2984,
    dpChiWatCoi_nominal(displayUnit="Pa") = 1000,
    UACooCoi_nominal=7.5*146.06,
    mAir_flow_nominal=0.21303*2*3)
    "Fan coil unit with no heating coil"
    annotation (Placement(transformation(extent={{0,140},{40,180}})));

  Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnits.Controller conFCU(
    cooCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased,
    heaCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.None,
    final TiCoo=200,
    final heaConTyp=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    final kHea=0.05,
    final TiHea=120,
    final kCooCoi=0.05,
    final TiCooCoi=200,
    final kHeaCoi=0.005,
    final TiHeaCoi=200,
    final TSupSet_max=308.15,
    final TSupSet_min=285.85)
    "Fan coil unit controller"
    annotation (Placement(transformation(extent={{-80,108},{-40,180}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
    computeWetBulbTemperature=false)
    "Weather data reader"
    annotation (Placement(transformation(extent={{-140,270},{-120,290}})));

  Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnits.Controller conFCU1(
    cooCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased,
    heaCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased,
    final TiCoo=200,
    final heaConTyp=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    final kHea=0.05,
    final TiHea=120,
    final kCooCoi=0.05,
    final TiCooCoi=200,
    final kHeaCoi=0.005,
    final TiHeaCoi=90,
    final TSupSet_max=308.15,
    final TSupSet_min=285.85)
    "Fan coil unit controller"
    annotation (Placement(transformation(extent={{-80,-12},{-40,60}})));

  Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnits.Controller conFCU2(
    cooCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased,
    heaCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.Electric,
    final TiCoo=200,
    final heaConTyp=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    final kHea=0.05,
    final TiHea=200,
    final kCooCoi=0.05,
    final TiCooCoi=200,
    final kHeaCoi=0.005,
    final TiHeaCoi=200,
    final TSupSet_max=308.15,
    final TSupSet_min=285.85)
    "Fan coil unit controller"
    annotation (Placement(transformation(extent={{-80,-112},{-40,-40}})));

  MixedAir zon1(nPorts=3)
    "Zone-1"
    annotation (Placement(transformation(extent={{120,140},{170,190}})));

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temAirNoHeaCoi
    "Air temperature sensor"
    annotation (Placement(transformation(extent={{140,210},{160,230}})));

  Modelica.Blocks.Sources.Constant uSha(k=0)
    "Control signal for the shading device"
    annotation (Placement(transformation(extent={{-200,190},{-180,210}})));

  Modelica.Blocks.Routing.Replicator replicator(nout=1)
    annotation (Placement(transformation(extent={{-160,190},{-140,210}})));

  Modelica.Blocks.Sources.CombiTimeTable intGaiFra(
    table=[0,0.05; 8,0.05; 9,0.9; 12,0.9; 12,0.8; 13,0.8; 13,1; 17,1; 19,0.1; 24,
        0.05],
    timeScale=3600,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Fraction of internal heat gain"
    annotation (Placement(transformation(extent={{-240,-230},{-220,-210}})));

  Modelica.Blocks.Math.MatrixGain gai(K=20*[0.4; 0.4; 0.2])
    "Matrix gain to split up heat gain in radiant, convective and latent gain"
    annotation (Placement(transformation(extent={{-200,-230},{-180,-210}})));

  Modelica.Blocks.Math.Gain gaiInt[3](each k=kInt)
    "Gain for internal heat gain amplification for each zone"
    annotation (Placement(transformation(extent={{-140,-190},{-120,-170}})));

  Buildings.Fluid.ZoneEquipment.FourPipe fanCoiUni1(
    redeclare package MediumA = MediumA,
    redeclare package MediumHW = MediumW,
    redeclare package MediumCHW = MediumW,
    mHotWat_flow_nominal=0.75*3.75*0.50946*0.25,
    dpHotWatCoi_nominal(displayUnit="Pa") = 1000,
    dpAir_nominal=100,
    UAHeaCoi_nominal=146.06*2*1.1,
    mChiWat_flow_nominal=0.2984,
    dpChiWatCoi_nominal(displayUnit="Pa") = 1000,
    UACooCoi_nominal=2.25*146.06,
    mAir_flow_nominal=0.21303*2*3)
    "Fan coil unit with hot-water heating coil"
    annotation (Placement(transformation(extent={{20,20},{60,60}})));

  MixedAir zon2(nPorts=3)
    "Zone-2"
    annotation (Placement(transformation(extent={{120,20},{170,70}})));

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temAirNoHeaCoi1
    "Air temperature sensor"
    annotation (Placement(transformation(extent={{230,20},{250,40}})));

  Buildings.Fluid.ZoneEquipment.FourPipe fanCoiUni2(
    redeclare package MediumA = MediumA,
    redeclare package MediumHW = MediumW,
    redeclare package MediumCHW = MediumW,
    heaCoiTyp=Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.Electric,
    dpAir_nominal=100,
    mChiWat_flow_nominal=0.2984,
    dpChiWatCoi_nominal(displayUnit="Pa") = 1000,
    UACooCoi_nominal=2.25*146.06,
    mAir_flow_nominal=0.21303*2*3,
    QHeaCoi_flow_nominal=7795.7)
    "Fan coil unit with electric heating coil"
    annotation (Placement(transformation(extent={{26,-88},{66,-48}})));

  MixedAir zon3(nPorts=3)
    "Zone-3"
    annotation (Placement(transformation(extent={{120,-80},{170,-30}})));

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temAirNoHeaCoi2
    "Air temperature sensor"
    annotation (Placement(transformation(extent={{230,-60},{250,-40}})));

  Buildings.Examples.VAVReheat.BaseClasses.RoomLeakage lea(
    redeclare package Medium = MediumA,
    VRoo=VRoo,
    s=49.91/33.27,
    azi=Buildings.Types.Azimuth.N,
    final use_windPressure=false)
    "Model for air infiltration through the envelope"
    annotation (Placement(transformation(extent={{0,260},{40,300}})));

  model MixedAir = Buildings.ThermalZones.Detailed.MixedAir(
    redeclare package Medium = MediumA,
    AFlo=AFlo,
    hRoo=hRoo,
    nConExt=0,
    nConExtWin=1,
    datConExtWin(
      layers={conExtWal},
      A={wExt*hRoo},
      glaSys={glaSys},
      wWin={winWalRat/hWin*wExt*hRoo},
      each hWin=hWin,
      fFra={0.1},
      til={Buildings.Types.Tilt.Wall},
      azi={Buildings.Types.Azimuth.N}),
    nConPar=2,
    datConPar(
      layers={conFlo,conFur},
      A={AFlo,414.68},
      til={Buildings.Types.Tilt.Floor,Buildings.Types.Tilt.Wall}),
    nConBou=3,
    datConBou(
      layers={conIntWal,conIntWal,conIntWal},
      A={6.47,40.76,6.47}*hRoo,
      til={Buildings.Types.Tilt.Wall,Buildings.Types.Tilt.Wall,Buildings.Types.Tilt.Wall}),
    nSurBou=0,
    intConMod=intConMod,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Thermal zone model";
protected
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant limLev(
    final k=0)
    "Cooling and heating demand limit level"
    annotation (Placement(transformation(extent={{-200,80},{-180,100}})));

  Buildings.Controls.SetPoints.OccupancySchedule occSch(
    final occupancy=3600*{6,19})
    "Occupancy schedule"
    annotation (Placement(transformation(extent={{-200,40},{-180,60}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TOccHeaSetPoi(final k=20 + 273.15)
    "Occupied heating temperature setpoint"
    annotation (Placement(transformation(extent={{-200,10},{-180,30}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TUnOccCooSet(final k=30 + 273.15)
    "Unoccupied cooling temperature setpoint"
    annotation (Placement(transformation(extent={{-200,-70},{-180,-50}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TUnOccHeaSet(final k=12 + 273.15)
    "Unoccupied heating temperature setpoint"
    annotation (Placement(transformation(extent={{-200,-110},{-180,-90}})));

  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr[3](final t=fill(0.05,
        3), final h=fill(0.025, 3))
    "Check if fan speed is above threshold for proven on signal"
    annotation (Placement(transformation(extent={{-200,-150},{-180,-130}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim[3](final t=fill(120, 3))
    "Generate fan proven on signal"
    annotation (Placement(transformation(extent={{-160,-150},{-140,-130}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSetAdj(
    final k=0)
    "Unoccupied cooling  temperature setpoint"
    annotation (Placement(transformation(extent={{-200,120},{-180,140}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant cooWarTim(final k=3600)
    "Cooldown and warm-up time"
    annotation (Placement(transformation(extent={{-200,150},{-180,170}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TOccCooSetPoi(
    final k=24 + 273.15)
    "Occupied cooling temperature setpoint"
    annotation (Placement(transformation(extent={{-200,-40},{-180,-20}})));

  Modelica.Blocks.Math.Gain gaiInt1[3](final k=fill(4.75*kInt, 3))
    "Gain for internal heat gain amplification for zone with no heating coil service"
    annotation (Placement(transformation(extent={{-140,230},{-120,250}})));

equation
  connect(conFCU.yFan, fanCoiUni.uFan) annotation (Line(points={{-38,160},{-20,160},
          {-20,172},{-2,172}},       color={0,0,127}));
  connect(greThr.y, tim.u) annotation (Line(points={{-178,-140},{-162,-140}},
               color={255,0,255}));
  connect(fanCoiUni.TAirSup, conFCU.TSup) annotation (Line(points={{42,152},{66,
          152},{66,224},{-100,224},{-100,142},{-82,142}},   color={0,0,127}));
  connect(uSha.y, replicator.u)
    annotation (Line(points={{-179,200},{-162,200}}, color={0,0,127}));
  connect(replicator.y, zon1.uSha) annotation (Line(points={{-139,200},{100,200},
          {100,187.5},{118,187.5}}, color={0,0,127}));
  connect(weaDat.weaBus, zon1.weaBus) annotation (Line(
      points={{-120,280},{-12,280},{-12,260},{180,260},{180,188},{167.375,188},
          {167.375,187.375}},
      color={255,204,51},
      thickness=0.5));
  connect(zon1.heaPorAir, temAirNoHeaCoi.port) annotation (Line(points={{143.75,
          165},{106,165},{106,220},{140,220}}, color={191,0,0}));
  connect(temAirNoHeaCoi.T, conFCU.TZon) annotation (Line(points={{161,220},{
          188,220},{188,100},{-100,100},{-100,138},{-82,138}},
                                                        color={0,0,127}));
  connect(intGaiFra.y, gai.u) annotation (Line(points={{-219,-220},{-202,-220}},
                                   color={0,0,127}));
  connect(gai.y, gaiInt.u) annotation (Line(points={{-179,-220},{-160,-220},{
          -160,-180},{-142,-180}},
                             color={0,0,127}));
  connect(conFCU1.yFan, fanCoiUni1.uFan) annotation (Line(points={{-38,40},{-20,
          40},{-20,52},{18,52}},
                            color={0,0,127}));
  connect(conFCU1.yCooCoi, fanCoiUni1.uCoo)
    annotation (Line(points={{-38,24},{-14,24},{-14,40},{18,40}},
                                                color={0,0,127}));
  connect(conFCU1.yHeaCoi, fanCoiUni1.uHea) annotation (Line(points={{-38,28},{-20,
          28},{-20,28},{18,28}},color={0,0,127}));
  connect(fanCoiUni1.port_air_b,zon2. ports[1]) annotation (Line(points={{60,36},
          {80,36},{80,30.8333},{126.25,30.8333}},
                                            color={0,127,255}));
  connect(fanCoiUni1.port_air_a,zon2. ports[2]) annotation (Line(points={{60,44},
          {84,44},{84,32.5},{126.25,32.5}},             color={0,127,255}));
  connect(zon2.heaPorAir, temAirNoHeaCoi1.port) annotation (Line(points={{143.75,
          45},{106,45},{106,80},{188,80},{188,30},{230,30}},
                                                    color={191,0,0}));
  connect(conFCU1.TZon, temAirNoHeaCoi1.T) annotation (Line(points={{-82,18},{
          -134,18},{-134,-20},{260,-20},{260,30},{251,30}},
                                                        color={0,0,127}));
  connect(replicator.y,zon2. uSha) annotation (Line(points={{-139,200},{100,200},
          {100,67.5},{118,67.5}},                                      color={0,
          0,127}));
  connect(gaiInt.y,zon2. qGai_flow) annotation (Line(points={{-119,-180},{100,
          -180},{100,55},{118,55}},                        color={0,0,127}));
  connect(weaDat.weaBus,zon2. weaBus) annotation (Line(
      points={{-120,280},{-12,280},{-12,260},{180,260},{180,67.375},{167.375,
          67.375}},
      color={255,204,51},
      thickness=0.5));
  connect(conFCU2.yFan, fanCoiUni2.uFan) annotation (Line(points={{-38,-60},{-20,
          -60},{-20,-56},{24,-56}},color={0,0,127}));
  connect(conFCU2.yCooCoi, fanCoiUni2.uCoo) annotation (Line(points={{-38,-76},
          {-20,-76},{-20,-68},{24,-68}},
                                      color={0,0,127}));
  connect(conFCU2.yHeaCoi, fanCoiUni2.uHea) annotation (Line(points={{-38,-72},{
          -14,-72},{-14,-80},{24,-80}},               color={0,0,127}));
  connect(fanCoiUni2.port_air_a,zon3. ports[1]) annotation (Line(points={{66,-64},
          {76,-64},{76,-69.1667},{126.25,-69.1667}},
                                               color={0,127,255}));
  connect(fanCoiUni2.port_air_b,zon3. ports[2]) annotation (Line(points={{66,-72},
          {84,-72},{84,-67.5},{126.25,-67.5}},
                                           color={0,127,255}));
  connect(zon3.heaPorAir, temAirNoHeaCoi2.port) annotation (Line(points={{143.75,
          -55},{106,-55},{106,-24},{188,-24},{188,-50},{230,-50}}, color={191,0,
          0}));
  connect(gaiInt.y,zon3. qGai_flow) annotation (Line(points={{-119,-180},{100,
          -180},{100,-45},{118,-45}},
        color={0,0,127}));
  connect(conFCU2.TZon, temAirNoHeaCoi2.T) annotation (Line(points={{-82,-82},{
          -92,-82},{-92,-120},{260,-120},{260,-50},{251,-50}},
                                                             color={0,0,127}));
  connect(sinHea.ports[1], fanCoiUni1.port_HW_b) annotation (Line(points={{20,-220},
          {20,12},{26,12},{26,20}},
        color={0,127,255}));
  connect(souHea.ports[1], fanCoiUni1.port_HW_a) annotation (Line(points={{70,-220},
          {70,-194},{8,-194},{8,0},{36,0},{36,20}},
                   color={0,127,255}));
  connect(sinCoo.ports[1], fanCoiUni2.port_CHW_b) annotation (Line(points={{111.333,
          -220},{111.333,-206},{48,-206},{48,-88}},               color={0,127,255}));
  connect(sinCoo.ports[2], fanCoiUni1.port_CHW_b) annotation (Line(points={{110,
          -220},{110,-206},{-8,-206},{-8,-6},{42,-6},{42,20}},
                               color={0,127,255}));
  connect(souCoo.ports[1], fanCoiUni2.port_CHW_a) annotation (Line(points={{153.333,
          -220},{153.333,-204},{152,-204},{152,-186},{58,-186},{58,-88}},
                                                                      color={0,127,
          255}));
  connect(souCoo.ports[2], fanCoiUni1.port_CHW_a) annotation (Line(points={{152,
          -220},{152,-186},{16,-186},{16,-12},{52,-12},{52,20}},
                                   color={0,127,255}));
  connect(weaDat.weaBus,zon3. weaBus) annotation (Line(
      points={{-120,280},{-12,280},{-12,260},{180,260},{180,-34},{167.375,-34},
          {167.375,-32.625}},
      color={255,204,51},
      thickness=0.5));
  connect(fanCoiUni1.TAirSup, conFCU1.TSup) annotation (Line(points={{62,32},{
          76,32},{76,80},{-92,80},{-92,22},{-82,22}},
                                               color={0,0,127}));
  connect(fanCoiUni2.TAirSup, conFCU2.TSup) annotation (Line(points={{68,-76},{
          76,-76},{76,-140},{-100,-140},{-100,-78},{-82,-78}},
                                                          color={0,0,127}));
  connect(cooWarTim.y, conFCU.warUpTim) annotation (Line(points={{-178,160},{
          -140,160},{-140,178},{-82,178}},
                                      color={0,0,127}));
  connect(cooWarTim.y, conFCU.cooDowTim) annotation (Line(points={{-178,160},{
          -140,160},{-140,174},{-82,174}},                color={0,0,127}));
  connect(cooWarTim.y, conFCU1.warUpTim) annotation (Line(points={{-178,160},{
          -140,160},{-140,58},{-82,58}},                         color={0,0,127}));
  connect(cooWarTim.y, conFCU1.cooDowTim) annotation (Line(points={{-178,160},{
          -140,160},{-140,54},{-82,54}},
                     color={0,0,127}));
  connect(TSetAdj.y, conFCU.setAdj) annotation (Line(points={{-178,130},{-158,
          130},{-158,166},{-82,166}},
                                color={0,0,127}));
  connect(TSetAdj.y, conFCU1.setAdj) annotation (Line(points={{-178,130},{-158,
          130},{-158,46},{-82,46}},
                               color={0,0,127}));
  connect(TSetAdj.y, conFCU2.setAdj) annotation (Line(points={{-178,130},{-158,
          130},{-158,-54},{-82,-54}},              color={0,0,127}));
  connect(cooWarTim.y, conFCU2.warUpTim) annotation (Line(points={{-178,160},{
          -140,160},{-140,-42},{-82,-42}},
        color={0,0,127}));
  connect(cooWarTim.y, conFCU2.cooDowTim) annotation (Line(points={{-178,160},{
          -140,160},{-140,-46},{-82,-46}},
        color={0,0,127}));
  connect(limLev.y, conFCU.uCooDemLimLev) annotation (Line(points={{-178,90},{
          -170,90},{-170,150},{-82,150}},
        color={255,127,0}));
  connect(limLev.y, conFCU.uHeaDemLimLev) annotation (Line(points={{-178,90},{
          -170,90},{-170,146},{-82,146}},
        color={255,127,0}));
  connect(limLev.y, conFCU1.uCooDemLimLev) annotation (Line(points={{-178,90},{
          -170,90},{-170,30},{-82,30}},
                                   color={255,127,0}));
  connect(limLev.y, conFCU1.uHeaDemLimLev) annotation (Line(points={{-178,90},{
          -170,90},{-170,26},{-82,26}},              color={255,127,0}));
  connect(limLev.y, conFCU2.uCooDemLimLev) annotation (Line(points={{-178,90},{
          -170,90},{-170,-70},{-82,-70}},              color={255,127,0}));
  connect(limLev.y, conFCU2.uHeaDemLimLev) annotation (Line(points={{-178,90},{
          -170,90},{-170,-74},{-82,-74}},
        color={255,127,0}));
  connect(occSch.tNexOcc, conFCU.tNexOcc) annotation (Line(points={{-179,56},{
          -164,56},{-164,170},{-82,170}},                  color={0,0,127}));
  connect(occSch.tNexOcc, conFCU1.tNexOcc) annotation (Line(points={{-179,56},{
          -164,56},{-164,50},{-82,50}},
                                  color={0,0,127}));
  connect(occSch.tNexOcc, conFCU2.tNexOcc) annotation (Line(points={{-179,56},{
          -164,56},{-164,-50},{-82,-50}},                               color={0,
          0,127}));
  connect(occSch.occupied, conFCU1.u1Occ) annotation (Line(points={{-179,44},{
          -146,44},{-146,34.2},{-82,34.2}},
                                      color={255,0,255}));
  connect(occSch.occupied, conFCU2.u1Occ) annotation (Line(points={{-179,44},{
          -146,44},{-146,-65.8},{-82,-65.8}},               color={255,0,255}));
  connect(occSch.occupied, conFCU.u1Occ) annotation (Line(points={{-179,44},{
          -146,44},{-146,154.2},{-82,154.2}},
                                         color={255,0,255}));
  connect(TOccHeaSetPoi.y, conFCU.TOccHeaSet) annotation (Line(points={{-178,20},
          {-114,20},{-114,134},{-82,134}},                      color={0,0,127}));
  connect(conFCU1.TOccHeaSet, TOccHeaSetPoi.y) annotation (Line(points={{-82,14},
          {-114,14},{-114,20},{-178,20}},                 color={0,0,127}));
  connect(conFCU2.TOccHeaSet, TOccHeaSetPoi.y) annotation (Line(points={{-82,-86},
          {-114,-86},{-114,20},{-178,20}},                     color={0,0,127}));
  connect(TOccCooSetPoi.y, conFCU2.TOccCooSet) annotation (Line(points={{-178,
          -30},{-120,-30},{-120,-90},{-82,-90}},
                                            color={0,0,127}));
  connect(TOccCooSetPoi.y, conFCU1.TOccCooSet) annotation (Line(points={{-178,
          -30},{-120,-30},{-120,10},{-82,10}},
                            color={0,0,127}));
  connect(TOccCooSetPoi.y, conFCU.TOccCooSet) annotation (Line(points={{-178,
          -30},{-120,-30},{-120,130},{-82,130}},                color={0,0,127}));
  connect(TUnOccCooSet.y, conFCU2.TUnoCooSet) annotation (Line(points={{-178,
          -60},{-128,-60},{-128,-98},{-82,-98}},                color={0,0,127}));
  connect(TUnOccCooSet.y, conFCU1.TUnoCooSet) annotation (Line(points={{-178,
          -60},{-128,-60},{-128,2},{-82,2}},
                                        color={0,0,127}));
  connect(TUnOccCooSet.y, conFCU.TUnoCooSet) annotation (Line(points={{-178,-60},
          {-128,-60},{-128,122},{-82,122}},               color={0,0,127}));
  connect(TUnOccHeaSet.y, conFCU2.TUnoHeaSet) annotation (Line(points={{-178,
          -100},{-152,-100},{-152,-94},{-82,-94}},
                                           color={0,0,127}));
  connect(TUnOccHeaSet.y, conFCU1.TUnoHeaSet) annotation (Line(points={{-178,
          -100},{-152,-100},{-152,6},{-82,6}},
                                         color={0,0,127}));
  connect(TUnOccHeaSet.y, conFCU.TUnoHeaSet) annotation (Line(points={{-178,
          -100},{-152,-100},{-152,126},{-82,126}},         color={0,0,127}));
  connect(weaDat.weaBus, lea.weaBus) annotation (Line(
      points={{-120,280},{0,280}},
      color={255,204,51},
      thickness=0.5));
  connect(lea.port_b,zon2. ports[3]) annotation (Line(points={{40,280},{90,280},
          {90,34},{104,34},{104,34.1667},{126.25,34.1667}},
                         color={0,127,255}));
  connect(lea.port_b,zon3. ports[3]) annotation (Line(points={{40,280},{90,280},
          {90,-66},{102,-66},{102,-65.8333},{126.25,-65.8333}},
                                                      color={0,127,255}));
  connect(souCoo.ports[3], fanCoiUni.port_CHW_a) annotation (Line(points={{150.667,
          -220},{150.667,-200},{0,-200},{0,124},{32,124},{32,140}},
                                                 color={0,127,255}));
  connect(sinCoo.ports[3], fanCoiUni.port_CHW_b) annotation (Line(points={{108.667,
          -220},{108.667,-206},{-8,-206},{-8,130},{22,130},{22,140}},
                           color={0,127,255}));
  connect(fanCoiUni.yFan_actual, greThr[1].u) annotation (Line(points={{42,168},
          {60,168},{60,220},{-220,220},{-220,-140},{-202,-140}},
                                                         color={0,0,127}));
  connect(fanCoiUni1.yFan_actual, greThr[2].u) annotation (Line(points={{62,48},
          {70,48},{70,74},{-220,74},{-220,-140},{-202,-140}},
                                                        color={0,0,127}));
  connect(fanCoiUni2.yFan_actual, greThr[3].u) annotation (Line(points={{68,-60},
          {80,-60},{80,-160},{-220,-160},{-220,-140},{-202,-140}},
                  color={0,0,127}));
  connect(tim[1].passed, conFCU.u1Fan) annotation (Line(points={{-138,-148},{
          -108,-148},{-108,114},{-82,114}},
                                     color={255,0,255}));
  connect(tim[2].passed, conFCU1.u1Fan) annotation (Line(points={{-138,-148},{
          -108,-148},{-108,-6},{-82,-6}},
                                     color={255,0,255}));
  connect(tim[3].passed, conFCU2.u1Fan) annotation (Line(points={{-138,-148},{
          -108,-148},{-108,-106},{-82,-106}},
                                         color={255,0,255}));
  connect(fanCoiUni.port_air_b, zon1.ports[1]) annotation (Line(points={{40,156},
          {40,150.833},{126.25,150.833}}, color={0,127,255}));
  connect(fanCoiUni.port_air_a, zon1.ports[2]) annotation (Line(points={{40,164},
          {80,164},{80,152.5},{126.25,152.5}},   color={0,127,255}));
  connect(lea.port_b, zon1.ports[3]) annotation (Line(points={{40,280},{90,280},
          {90,154.167},{126.25,154.167}},                     color={0,127,255}));
  connect(zon1.surf_conBou, zon2.surf_conBou) annotation (Line(points={{152.5,
          145},{152.5,132},{174,132},{174,10},{152.5,10},{152.5,25}},
                                                             color={191,0,0}));
  connect(zon1.surf_conBou, zon3.surf_conBou) annotation (Line(points={{152.5,
          145},{152.5,132},{174,132},{174,-88},{152.5,-88},{152.5,-75}},
                                                                    color={191,0,
          0}));
  connect(gai.y, gaiInt1.u) annotation (Line(points={{-179,-220},{-160,-220},{
          -160,-180},{-224,-180},{-224,240},{-142,240}},
                       color={0,0,127}));
  connect(gaiInt1.y, zon1.qGai_flow) annotation (Line(points={{-119,240},{80,
          240},{80,175},{118,175}},  color={0,0,127}));
  connect(conFCU.yCooCoi, fanCoiUni.uCoo) annotation (Line(points={{-38,144},{
          -14,144},{-14,160},{-2,160}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),       graphics={Text(
          extent={{-110,192},{110,156}},
          textColor={0,0,255},
          textString="%name")}),  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-280,-300},{280,300}})),
Documentation(info="<html>
<p>
This model demonstrates the usage of
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnits.Controller\">
Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnits.Controller</a>,
a controller for four-pipe fan coil units based on the sequences defined
in ASHRAE Guideline 36, 2021.
</p>
<p>
This model consists of
</p>
<ul>
<li>
3 identical thermal zone models with air flow
through building leakage.
</li>
<li>
3 fan-coil units serving each zone.
</li>
<li>
3 fan coil unit controllers that output the supply fan enable signal and speed signal,
the supply air temperature setpoint, the zone air heating and cooling setpoints,
and valve positions for heating and cooling coils.
</li>
</ul>
<p>
The 3 fan coil units each have a supply fan and a chilled-water cooling coil. The
heating coil varies as follows for each instance:
</p>
<ul>
<li>
<code>fanCoiUni</code> has no heating coil.
</li>
<li>
<code>fanCoiUni1</code> has a hot-water heating coil.
</li>
<li>
<code>fanCoiUni2</code> has an electric heating coil.
</li>
</ul>
<p>
The HVAC system switches between occupied, unoccupied, unoccupied warm-up and
unoccupied pre-cool modes. The cooling coil and heating coil output are modulated
to maintain the heating and cooling setpoints. The supply air temperature is modulated
based on the differential between the temperature setpoint and the zone temperature
to avoid unecessary heating and cooling use and avoid extreme temperature fluctuations.
</p>
<p>
See the model <a href=\"modelica://Buildings.Fluid.ZoneEquipment.FourPipe\">
Buildings.Fluid.ZoneEquipment.FourPipe</a> and 
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnits.Controller\">
Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnits.Controller</a> for a
description of the fan coil unit and the controller.
</p>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Examples/HydronicSystems/FanCoilUnit.mos"
        "Simulate and plot"),
    experiment(
      StopTime=86400,
      Tolerance=1e-06));
end FanCoilUnit;

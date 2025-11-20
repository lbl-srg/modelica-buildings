within Buildings.Examples.FanCoils;
model FourPipe
  "Model of a five zone floor with fan coil units"
  extends Modelica.Icons.Example;

  replaceable package MediumA = Buildings.Media.Air
    "Medium for air";

  replaceable package MediumW = Buildings.Media.Water
    "Medium for hot-water and chilled-water";

  parameter Modelica.Units.SI.Length wSou=49.91
    "Length of south facing exterior wall";
  parameter Modelica.Units.SI.Length wNor=40.76
    "Lenght of north facing interior wall";
  parameter Modelica.Units.SI.Length wSid=6.47
    "Length of each of the two side walls";
  parameter Modelica.Units.SI.Length dRoo = sqrt(wSid^2-((wSou-wNor)/2)^2)
    "Room depth";
  parameter Modelica.Units.SI.Length hRoo=2.74
    "Room height";

  parameter Modelica.Units.SI.Area AFlo=(wSou+wNor)/2 * dRoo
    "Floor area";

  parameter Modelica.Units.SI.Volume VRoo=AFlo*hRoo
    "Room volume";

  parameter Real winWalRat(
    min=0.01,
    max=0.99) = 0.33
    "Window to wall ratio for exterior wall";

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
    annotation (Placement(transformation(extent={{300,190},{320,210}})));

  parameter HeatTransfer.Data.Solids.Plywood matFur(
    x=0.15,
    nStaRef=5)
    "Material for furniture"
    annotation (Placement(transformation(extent={{340,190},{360,210}})));

  parameter HeatTransfer.Data.Solids.Concrete matCon(
    x=0.1,
    k=1.311,
    c=836,
    nStaRef=5)
    "Concrete"
    annotation (Placement(transformation(extent={{300,130},{320,150}})));

  parameter HeatTransfer.Data.Solids.Plywood matWoo(
    x=0.01,
    k=0.11,
    d=544,
    nStaRef=1)
    "Wood for exterior construction"
    annotation (Placement(transformation(extent={{300,100},{320,120}})));

  parameter HeatTransfer.Data.Solids.GypsumBoard matGyp(
    x=0.0127,
    k=0.16,
    c=830,
    d=784,
    nStaRef=2)
    "Gypsum board"
    annotation (Placement(transformation(extent={{300,60},{320,80}})));

  parameter HeatTransfer.Data.Resistances.Carpet matCar
    "Carpet"
    annotation (Placement(transformation(extent={{300,160},{320,180}})));

  parameter HeatTransfer.Data.Solids.Generic matIns(
    x=0.087,
    k=0.049,
    c=836.8,
    d=265,
    nStaRef=5)
    "Steelframe construction with insulation"
    annotation (Placement(transformation(extent={{340,100},{360,120}})));

  parameter HeatTransfer.Data.Solids.GypsumBoard matGyp2(
    x=0.025,
    k=0.16,
    c=830,
    d=784,
    nStaRef=2)
    "Gypsum board"
    annotation (Placement(transformation(extent={{340,60},{360,80}})));

  parameter HeatTransfer.Data.GlazingSystems.DoubleClearAir13Clear glaSys(
    UFra=2,
    shade=Buildings.HeatTransfer.Data.Shades.Gray(),
    haveInteriorShade=false,
    haveExteriorShade=false)
    "Data record for the glazing system"
    annotation (Placement(transformation(extent={{340,160},{360,180}})));

  parameter HeatTransfer.Data.OpaqueConstructions.Generic conExtWal(
    nLay=3,
    material={matWoo,matIns,matGyp})
    "Exterior construction"
    annotation (Placement(transformation(extent={{300,260},{320,280}})));

  parameter HeatTransfer.Data.OpaqueConstructions.Generic conIntWal(
    nLay=1,
    material={matGyp2})
    "Interior wall construction"
    annotation (Placement(transformation(extent={{338,260},{358,280}})));

  parameter HeatTransfer.Data.OpaqueConstructions.Generic conFur(
    nLay=1,
    material={matFur})
    "Construction for internal mass of furniture"
    annotation (Placement(transformation(extent={{338,220},{358,240}})));

  parameter HeatTransfer.Data.OpaqueConstructions.Generic conFlo(
    nLay=1,
    material={matCon})
    "Floor construction (opa_a is carpet)"
    annotation (Placement(transformation(extent={{300,220},{320,240}})));

  Buildings.Fluid.Sources.Boundary_pT souHea(
    redeclare package Medium = MediumW,
    p(displayUnit="Pa") = 100000 + 3000,
    T=333.15,
    nPorts=1)
    "Source for hot water"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90, origin={-10,-230})));

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
      rotation=90, origin={78,-230})));

  Buildings.Fluid.ZoneEquipment.FourPipe fanCoiUni1(
    redeclare package MediumA = MediumA,
    redeclare package MediumHW = MediumW,
    redeclare package MediumCHW = MediumW,
    heaCoiTyp=Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.None,
    QCooCoi_flow_nominal=-20000,
    dpAir_nominal=100,
    mCooCoiWat_flow_nominal=4*0.2984,
    dpCooCoiWat_nominal(displayUnit="Pa") = 1000,
    mAir_flow_nominal=0.21303*2*3)
    "Fan coil unit with no heating coil"
    annotation (Placement(transformation(extent={{28,140},{68,180}})));

  Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnits.Controller conFCU1(
    cooCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased,
    heaCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.None,
    cooConTyp=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    kCoo=0.25,
    TiCoo=60,
    heaConTyp=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    kHea=0.05,
    TiHea=120,
    cooCoiConTyp=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    kCooCoi=0.1,
    TiCooCoi=120,
    kHeaCoi=0.005,
    TiHeaCoi=200,
    TSupSet_max=308.15,
    TSupSet_min=285.85)
    "Fan coil unit controller"
    annotation (Placement(transformation(extent={{-80,106},{-40,178}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
    computeWetBulbTemperature=false)
    "Weather data reader"
    annotation (Placement(transformation(extent={{268,178},{248,198}})));

  Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnits.Controller conFCU2(
    cooCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased,
    heaCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased,
    cooConTyp=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    kCoo=0.25,
    TiCoo=60,
    heaConTyp=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    kHea=0.25,
    TiHea=60,
    cooCoiConTyp=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    kCooCoi=0.1,
    TiCooCoi=120,
    heaCoiConTyp=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    kHeaCoi=0.1,
    TiHeaCoi=120,
    TSupSet_max=308.15,
    TSupSet_min=285.85)
    "Fan coil unit controller"
    annotation (Placement(transformation(extent={{-80,-12},{-40,60}})));

  Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnits.Controller conFCU3(
    cooCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased,
    heaCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.Electric,
    cooConTyp=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    kCoo=0.25,
    TiCoo=60,
    heaConTyp=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    kHea=0.1,
    TiHea=120,
    cooCoiConTyp=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    kCooCoi=0.1,
    TiCooCoi=120,
    heaCoiConTyp=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    kHeaCoi=0.025,
    TiHeaCoi=90,
    TSupSet_max=308.15,
    TSupSet_min=285.85)
    "Fan coil unit controller"
    annotation (Placement(transformation(extent={{-80,-112},{-40,-40}})));

  MixedAir zon1(nPorts=2) "Zone-1"
    annotation (Placement(transformation(extent={{120,140},{170,190}})));

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTRooAir1(T(
        displayUnit="degC")) "Air temperature sensor"
    annotation (Placement(transformation(extent={{200,154},{220,174}})));

  Modelica.Blocks.Sources.Constant uSha(k=0)
    "Control signal for the shading device"
    annotation (Placement(transformation(extent={{-200,190},{-180,210}})));

  Modelica.Blocks.Routing.Replicator replicator(nout=1)
    annotation (Placement(transformation(extent={{-160,190},{-140,210}})));

  Modelica.Blocks.Sources.CombiTimeTable intGaiFra(
    table=[
       0,0.05;
       8,0.05;
       9,0.9;
      12,0.9;
      12,0.8;
      13,0.8;
      13,1;
      17,1;
      19,0.1;
      24,0.05],
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

  Buildings.Fluid.ZoneEquipment.FourPipe fanCoiUni2(
    redeclare package MediumA = MediumA,
    redeclare package MediumHW = MediumW,
    redeclare package MediumCHW = MediumW,
    QHeaCoi_flow_nominal=10000,
    QCooCoi_flow_nominal=-20000,
    mHeaCoiWat_flow_nominal=0.75*3.75*0.50946*0.25,
    dpHeaCoiWat_nominal(displayUnit="Pa") = 1000,
    dpAir_nominal=100,
    mCooCoiWat_flow_nominal=4*0.2984,
    dpCooCoiWat_nominal(displayUnit="Pa") = 1000,
    mAir_flow_nominal=0.21303*3*1.5)
    "Fan coil unit with hot-water heating coil"
    annotation (Placement(transformation(extent={{28,20},{68,60}})));

  MixedAir zon2(nPorts=2) "Zone-2"
    annotation (Placement(transformation(extent={{120,20},{170,70}})));

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTRooAir2(T(
        displayUnit="degC")) "Air temperature sensor"
    annotation (Placement(transformation(extent={{200,34},{220,54}})));

  Buildings.Fluid.ZoneEquipment.FourPipe fanCoiUni3(
    redeclare package MediumA = MediumA,
    redeclare package MediumHW = MediumW,
    redeclare package MediumCHW = MediumW,
    heaCoiTyp=Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.Electric,
    QCooCoi_flow_nominal=-20000,
    dpAir_nominal=100,
    mCooCoiWat_flow_nominal=4*0.2984,
    dpCooCoiWat_nominal(displayUnit="Pa") = 1000,
    mAir_flow_nominal=0.21303*1.5*3,
    QHeaCoi_flow_nominal=10000)
    "Fan coil unit with electric heating coil"
    annotation (Placement(transformation(extent={{26,-88},{66,-48}})));

  MixedAir zon3(nPorts=2) "Zone-3"
    annotation (Placement(transformation(extent={{120,-80},{170,-30}})));

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTRooAir3(T(
        displayUnit="degC")) "Air temperature sensor"
    annotation (Placement(transformation(extent={{198,-66},{218,-46}})));

  model MixedAir = Buildings.ThermalZones.Detailed.MixedAir(
    redeclare package Medium = MediumA,
    AFlo=AFlo,
    hRoo=hRoo,
    nConExt=0,
    nConExtWin=1,
    datConExtWin(
      layers={conExtWal},
      A={wSou*hRoo},
      glaSys={glaSys},
      wWin={winWalRat*wSou*hRoo/hWin},
      hWin={hWin},
      fFra={0.1},
      til={Buildings.Types.Tilt.Wall},
      azi={Buildings.Types.Azimuth.N}),
    nConPar=3,
    datConPar(
      layers={conFlo, conIntWal, conFur},
      A={AFlo, (wSid+wNor+wSid)/2 * hRoo, 414.68},
      til={Buildings.Types.Tilt.Floor, Buildings.Types.Tilt.Wall, Buildings.Types.Tilt.Wall}),
    nConBou=0,
    nSurBou=0,
    intConMod=Buildings.HeatTransfer.Types.InteriorConvection.Temperature,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) "Thermal zone model";

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant limLev(
    k=0)
    "Cooling and heating demand limit level"
    annotation (Placement(transformation(extent={{-200,80},{-180,100}})));

  Buildings.Controls.SetPoints.OccupancySchedule occSch(
    occupancy=3600*{6,19})
    "Occupancy schedule"
    annotation (Placement(transformation(extent={{-200,40},{-180,60}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TOccHeaSetPoi(
    k=20 + 273.15)
    "Occupied heating temperature setpoint"
    annotation (Placement(transformation(extent={{-200,10},{-180,30}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TUnOccCooSet(
    k=30 + 273.15)
    "Unoccupied cooling temperature setpoint"
    annotation (Placement(transformation(extent={{-200,-70},{-180,-50}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TUnOccHeaSet(
    k=12 + 273.15)
    "Unoccupied heating temperature setpoint"
    annotation (Placement(transformation(extent={{-200,-110},{-180,-90}})));

  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr[3](
    t=fill(0.05,3),
    h=fill(0.025, 3))
    "Check if fan speed is above threshold for proven on signal"
    annotation (Placement(transformation(extent={{-200,-150},{-180,-130}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim[3](
    t=fill(120, 3))
    "Generate fan proven on signal"
    annotation (Placement(transformation(extent={{-160,-150},{-140,-130}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSetAdj(
    k=0)
    "Unoccupied cooling  temperature setpoint"
    annotation (Placement(transformation(extent={{-200,120},{-180,140}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant cooWarTim(
    k=3600)
    "Cooldown and warm-up time"
    annotation (Placement(transformation(extent={{-200,150},{-180,170}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TOccCooSetPoi(
    k=24 + 273.15)
    "Occupied cooling temperature setpoint"
    annotation (Placement(transformation(extent={{-200,-40},{-180,-20}})));

  Modelica.Blocks.Math.Gain gaiInt1[3](
    k=fill(4.75*kInt, 3))
    "Gain for internal heat gain amplification for zone with no heating coil service"
    annotation (Placement(transformation(extent={{-140,230},{-120,250}})));

equation
  connect(conFCU1.yFan, fanCoiUni1.uFan) annotation (Line(points={{-38,158},{-20,
          158},{-20,172},{26,172}}, color={0,0,127}));
  connect(greThr.y, tim.u) annotation (Line(points={{-178,-140},{-162,-140}},
               color={255,0,255}));
  connect(fanCoiUni1.TAirSup, conFCU1.TSup) annotation (Line(points={{70,152},{82,
          152},{82,224},{-92,224},{-92,140},{-82,140}}, color={0,0,127}));
  connect(uSha.y, replicator.u)
    annotation (Line(points={{-179,200},{-162,200}}, color={0,0,127}));
  connect(replicator.y, zon1.uSha) annotation (Line(points={{-139,200},{100,200},
          {100,187.5},{118,187.5}}, color={0,0,127}));
  connect(weaDat.weaBus, zon1.weaBus) annotation (Line(
      points={{248,188},{167.375,188},{167.375,187.375}},
      color={255,204,51},
      thickness=0.5));
  connect(zon1.heaPorAir, senTRooAir1.port) annotation (Line(points={{143.75,
          165},{144,165},{144,164},{200,164}}, color={191,0,0}));
  connect(senTRooAir1.T, conFCU1.TZon) annotation (Line(points={{221,164},{230,
          164},{230,100},{-130,100},{-130,136},{-82,136}}, color={0,0,127}));
  connect(intGaiFra.y, gai.u) annotation (Line(points={{-219,-220},{-202,-220}},
                                   color={0,0,127}));
  connect(gai.y, gaiInt.u) annotation (Line(points={{-179,-220},{-160,-220},{
          -160,-180},{-142,-180}},
                             color={0,0,127}));
  connect(conFCU2.yFan,fanCoiUni2. uFan) annotation (Line(points={{-38,40},{-20,
          40},{-20,52},{26,52}},
                            color={0,0,127}));
  connect(conFCU2.yCooCoi,fanCoiUni2. uCoo)
    annotation (Line(points={{-38,24},{-14,24},{-14,40},{26,40}},
                                                color={0,0,127}));
  connect(conFCU2.yHeaCoi,fanCoiUni2. uHea) annotation (Line(points={{-38,28},{26,
          28}},                 color={0,0,127}));
  connect(fanCoiUni2.port_air_b,zon2. ports[1]) annotation (Line(points={{68,36},
          {90,36},{90,31.25},{126.25,31.25}},
                                            color={0,127,255}));
  connect(fanCoiUni2.port_air_a,zon2. ports[2]) annotation (Line(points={{68,44},
          {94,44},{94,34},{110,34},{110,33.75},{126.25,33.75}},
                                                        color={0,127,255}));
  connect(zon2.heaPorAir, senTRooAir2.port) annotation (Line(points={{143.75,45},
          {144,45},{144,44},{200,44}}, color={191,0,0}));
  connect(conFCU2.TZon, senTRooAir2.T) annotation (Line(points={{-82,18},{-92,
          18},{-92,-20},{232,-20},{232,44},{221,44}}, color={0,0,127}));
  connect(replicator.y,zon2. uSha) annotation (Line(points={{-139,200},{100,200},
          {100,67.5},{118,67.5}},                                      color={0,
          0,127}));
  connect(gaiInt.y,zon2. qGai_flow) annotation (Line(points={{-119,-180},{100,
          -180},{100,55},{118,55}},                        color={0,0,127}));
  connect(weaDat.weaBus,zon2. weaBus) annotation (Line(
      points={{248,188},{240,188},{240,67.375},{167.375,67.375}},
      color={255,204,51},
      thickness=0.5));
  connect(conFCU3.yFan,fanCoiUni3. uFan) annotation (Line(points={{-38,-60},{-20,
          -60},{-20,-56},{24,-56}},color={0,0,127}));
  connect(conFCU3.yCooCoi,fanCoiUni3. uCoo) annotation (Line(points={{-38,-76},
          {-20,-76},{-20,-68},{24,-68}},
                                      color={0,0,127}));
  connect(conFCU3.yHeaCoi,fanCoiUni3. uHea) annotation (Line(points={{-38,-72},{
          -14,-72},{-14,-80},{24,-80}},               color={0,0,127}));
  connect(zon3.heaPorAir, senTRooAir3.port) annotation (Line(points={{143.75,-55},
          {143.75,-56},{198,-56}}, color={191,0,0}));
  connect(gaiInt.y,zon3. qGai_flow) annotation (Line(points={{-119,-180},{100,
          -180},{100,-45},{118,-45}},
        color={0,0,127}));
  connect(conFCU3.TZon, senTRooAir3.T) annotation (Line(points={{-82,-82},{-124,
          -82},{-124,-120},{232,-120},{232,-56},{219,-56}}, color={0,0,127}));
  connect(sinHea.ports[1],fanCoiUni2. port_HW_b) annotation (Line(points={{20,-220},
          {20,-210},{10,-210},{10,12},{42,12},{42,20}},
        color={0,127,255}));
  connect(souHea.ports[1],fanCoiUni2. port_HW_a) annotation (Line(points={{-10,
          -220},{-10,-210},{8,-210},{8,16},{34,16},{34,20}},
                   color={0,127,255}));
  connect(sinCoo.ports[1],fanCoiUni3. port_CHW_b) annotation (Line(points={{111.333,
          -220},{111.333,-182},{56,-182},{56,-88}},               color={0,127,255}));
  connect(sinCoo.ports[2],fanCoiUni2. port_CHW_b) annotation (Line(points={{110,
          -220},{110,-190},{18,-190},{18,-6},{58,-6},{58,20}},
                               color={0,127,255}));
  connect(souCoo.ports[1],fanCoiUni3. port_CHW_a) annotation (Line(points={{79.3333,
          -220},{79.3333,-186},{48,-186},{48,-87.8}},                 color={0,127,
          255}));
  connect(souCoo.ports[2],fanCoiUni2. port_CHW_a) annotation (Line(points={{78,-220},
          {78,-194},{16,-194},{16,-2},{50,-2},{50,20.2}},
                                   color={0,127,255}));
  connect(weaDat.weaBus,zon3. weaBus) annotation (Line(
      points={{248,188},{240,188},{240,-34},{167.375,-34},{167.375,-32.625}},
      color={255,204,51},
      thickness=0.5));
  connect(fanCoiUni2.TAirSup,conFCU2. TSup) annotation (Line(points={{70,32},{84,
          32},{84,80},{-92,80},{-92,22},{-82,22}},
                                               color={0,0,127}));
  connect(fanCoiUni3.TAirSup,conFCU3. TSup) annotation (Line(points={{68,-76},{
          76,-76},{76,-140},{-100,-140},{-100,-78},{-82,-78}},
                                                          color={0,0,127}));
  connect(cooWarTim.y, conFCU1.warUpTim) annotation (Line(points={{-178,160},{-140,
          160},{-140,176},{-82,176}}, color={0,0,127}));
  connect(cooWarTim.y, conFCU1.cooDowTim) annotation (Line(points={{-178,160},{-140,
          160},{-140,172},{-82,172}}, color={0,0,127}));
  connect(cooWarTim.y,conFCU2. warUpTim) annotation (Line(points={{-178,160},{
          -140,160},{-140,58},{-82,58}},                         color={0,0,127}));
  connect(cooWarTim.y,conFCU2. cooDowTim) annotation (Line(points={{-178,160},{
          -140,160},{-140,54},{-82,54}},
                     color={0,0,127}));
  connect(TSetAdj.y, conFCU1.setAdj) annotation (Line(points={{-178,130},{-158,130},
          {-158,164},{-82,164}}, color={0,0,127}));
  connect(TSetAdj.y,conFCU2. setAdj) annotation (Line(points={{-178,130},{-158,
          130},{-158,46},{-82,46}},
                               color={0,0,127}));
  connect(TSetAdj.y,conFCU3. setAdj) annotation (Line(points={{-178,130},{-158,
          130},{-158,-54},{-82,-54}},              color={0,0,127}));
  connect(cooWarTim.y,conFCU3. warUpTim) annotation (Line(points={{-178,160},{
          -140,160},{-140,-42},{-82,-42}},
        color={0,0,127}));
  connect(cooWarTim.y,conFCU3. cooDowTim) annotation (Line(points={{-178,160},{
          -140,160},{-140,-46},{-82,-46}},
        color={0,0,127}));
  connect(limLev.y, conFCU1.uCooDemLimLev) annotation (Line(points={{-178,90},{-170,
          90},{-170,148},{-82,148}}, color={255,127,0}));
  connect(limLev.y, conFCU1.uHeaDemLimLev) annotation (Line(points={{-178,90},{-170,
          90},{-170,144},{-82,144}}, color={255,127,0}));
  connect(limLev.y,conFCU2. uCooDemLimLev) annotation (Line(points={{-178,90},{
          -170,90},{-170,30},{-82,30}},
                                   color={255,127,0}));
  connect(limLev.y,conFCU2. uHeaDemLimLev) annotation (Line(points={{-178,90},{
          -170,90},{-170,26},{-82,26}},              color={255,127,0}));
  connect(limLev.y,conFCU3. uCooDemLimLev) annotation (Line(points={{-178,90},{
          -170,90},{-170,-70},{-82,-70}},              color={255,127,0}));
  connect(limLev.y,conFCU3. uHeaDemLimLev) annotation (Line(points={{-178,90},{
          -170,90},{-170,-74},{-82,-74}},
        color={255,127,0}));
  connect(occSch.tNexOcc, conFCU1.tNexOcc) annotation (Line(points={{-179,56},{-164,
          56},{-164,168},{-82,168}}, color={0,0,127}));
  connect(occSch.tNexOcc,conFCU2. tNexOcc) annotation (Line(points={{-179,56},{
          -164,56},{-164,50},{-82,50}},
                                  color={0,0,127}));
  connect(occSch.tNexOcc,conFCU3. tNexOcc) annotation (Line(points={{-179,56},{
          -164,56},{-164,-50},{-82,-50}},                               color={0,
          0,127}));
  connect(occSch.occupied,conFCU2. u1Occ) annotation (Line(points={{-179,44},{
          -146,44},{-146,34.2},{-82,34.2}},
                                      color={255,0,255}));
  connect(occSch.occupied,conFCU3. u1Occ) annotation (Line(points={{-179,44},{
          -146,44},{-146,-65.8},{-82,-65.8}},               color={255,0,255}));
  connect(occSch.occupied, conFCU1.u1Occ) annotation (Line(points={{-179,44},{-146,
          44},{-146,152.2},{-82,152.2}}, color={255,0,255}));
  connect(TOccHeaSetPoi.y, conFCU1.TOccHeaSet) annotation (Line(points={{-178,20},
          {-114,20},{-114,132},{-82,132}}, color={0,0,127}));
  connect(conFCU2.TOccHeaSet, TOccHeaSetPoi.y) annotation (Line(points={{-82,14},
          {-114,14},{-114,20},{-178,20}},                 color={0,0,127}));
  connect(conFCU3.TOccHeaSet, TOccHeaSetPoi.y) annotation (Line(points={{-82,-86},
          {-114,-86},{-114,20},{-178,20}},                     color={0,0,127}));
  connect(TOccCooSetPoi.y,conFCU3. TOccCooSet) annotation (Line(points={{-178,
          -30},{-120,-30},{-120,-90},{-82,-90}},
                                            color={0,0,127}));
  connect(TOccCooSetPoi.y,conFCU2. TOccCooSet) annotation (Line(points={{-178,
          -30},{-120,-30},{-120,10},{-82,10}},
                            color={0,0,127}));
  connect(TOccCooSetPoi.y, conFCU1.TOccCooSet) annotation (Line(points={{-178,-30},
          {-120,-30},{-120,128},{-82,128}}, color={0,0,127}));
  connect(TUnOccCooSet.y,conFCU3. TUnoCooSet) annotation (Line(points={{-178,
          -60},{-128,-60},{-128,-98},{-82,-98}},                color={0,0,127}));
  connect(TUnOccCooSet.y,conFCU2. TUnoCooSet) annotation (Line(points={{-178,
          -60},{-128,-60},{-128,2},{-82,2}},
                                        color={0,0,127}));
  connect(TUnOccCooSet.y, conFCU1.TUnoCooSet) annotation (Line(points={{-178,-60},
          {-128,-60},{-128,120},{-82,120}}, color={0,0,127}));
  connect(TUnOccHeaSet.y,conFCU3. TUnoHeaSet) annotation (Line(points={{-178,
          -100},{-152,-100},{-152,-94},{-82,-94}},
                                           color={0,0,127}));
  connect(TUnOccHeaSet.y,conFCU2. TUnoHeaSet) annotation (Line(points={{-178,
          -100},{-152,-100},{-152,6},{-82,6}},
                                         color={0,0,127}));
  connect(TUnOccHeaSet.y, conFCU1.TUnoHeaSet) annotation (Line(points={{-178,-100},
          {-152,-100},{-152,124},{-82,124}}, color={0,0,127}));
  connect(souCoo.ports[3], fanCoiUni1.port_CHW_a) annotation (Line(points={{76.6667,
          -220},{76.6667,-214},{76,-214},{76,-208},{-12,-208},{-12,136},{50,136},
          {50,140.2}},                                              color={0,127,
          255}));
  connect(sinCoo.ports[3], fanCoiUni1.port_CHW_b) annotation (Line(points={{108.667,
          -220},{108.667,-206},{-10,-206},{-10,130},{58,130},{58,140}},
                                                                      color={0,127,
          255}));
  connect(fanCoiUni1.yFan_actual, greThr[1].u) annotation (Line(points={{70,168},
          {76,168},{76,220},{-220,220},{-220,-140},{-202,-140}}, color={0,0,127}));
  connect(fanCoiUni2.yFan_actual, greThr[2].u) annotation (Line(points={{70,48},
          {80,48},{80,74},{-220,74},{-220,-140},{-202,-140}},
                                                        color={0,0,127}));
  connect(fanCoiUni3.yFan_actual, greThr[3].u) annotation (Line(points={{68,-60},
          {80,-60},{80,-160},{-220,-160},{-220,-140},{-202,-140}},
                  color={0,0,127}));
  connect(tim[1].passed, conFCU1.u1Fan) annotation (Line(points={{-138,-148},{-108,
          -148},{-108,112},{-82,112}}, color={255,0,255}));
  connect(tim[2].passed,conFCU2. u1Fan) annotation (Line(points={{-138,-148},{
          -108,-148},{-108,-6},{-82,-6}},
                                     color={255,0,255}));
  connect(tim[3].passed,conFCU3. u1Fan) annotation (Line(points={{-138,-148},{
          -108,-148},{-108,-106},{-82,-106}},
                                         color={255,0,255}));
  connect(fanCoiUni1.port_air_b, zon1.ports[1]) annotation (Line(points={{68,156},
          {68,151.25},{126.25,151.25}}, color={0,127,255}));
  connect(fanCoiUni1.port_air_a, zon1.ports[2]) annotation (Line(points={{68,164},
          {92,164},{92,153.75},{126.25,153.75}}, color={0,127,255}));
  connect(gai.y, gaiInt1.u) annotation (Line(points={{-179,-220},{-160,-220},{
          -160,-180},{-224,-180},{-224,240},{-142,240}},
                       color={0,0,127}));
  connect(gaiInt1.y, zon1.qGai_flow) annotation (Line(points={{-119,240},{108,240},
          {108,176},{114,176},{114,175},{118,175}},
                                     color={0,0,127}));
  connect(conFCU1.yCooCoi, fanCoiUni1.uCoo) annotation (Line(points={{-38,142},{
          -14,142},{-14,160},{26,160}}, color={0,0,127}));
  connect(fanCoiUni3.port_air_b, zon3.ports[1]) annotation (Line(points={{66,-72},
          {96,-72},{96,-68.75},{126.25,-68.75}}, color={0,127,255}));
  connect(fanCoiUni3.port_air_a, zon3.ports[2]) annotation (Line(points={{66,-64},
          {96,-64},{96,-66.25},{126.25,-66.25}}, color={0,127,255}));
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
3 identical thermal zone models with time-varying internal heat gains and interaction
with ambient air through building envelope.
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
description of the fan coil unit and the controller, respectively.
</p>
<p>
The thermal zone is a south-facing thermal zone of the medium office building that is also used
in
<a href=\"modelica://Buildings.Examples.VAVReheat\">Buildings.Examples.VAVReheat</a>,
but here only this one room is modeled, and instanciated three times for the three different fan
coil units.
The external facade is <i>49.91</i> meters long, the north-facing interior wall is
<i>40.76</i> meters, and the room width is <i>4.58</i> meters.
The room height is <i>2.74</i> meters.
</p>
</html>", revisions="<html>
<ul>
<li>
September 23, 2025, by Cerrina Mouchref, Karthik Devaprasad and Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Examples/FanCoils/FourPipe.mos"
        "Simulate and plot"),
    experiment(
      StopTime=86400,
      Tolerance=1e-06));
end FourPipe;

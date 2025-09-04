within Buildings.Examples.HydronicSystems;
model FanCoilUnit
  "Model of a five zone floor with fan coil units"
  extends Modelica.Icons.Example;

  replaceable package MediumA = Buildings.Media.Air(T_default=293.15)
    "Medium for air";

  replaceable package MediumW = Buildings.Media.Water
    "Medium for hot-water and chilled-water";

  Buildings.Fluid.Sources.Boundary_pT souHea(
    redeclare package Medium = MediumW,
    p(displayUnit="Pa") = 100000 + 3000,
    T=333.15,
    nPorts=1)
    "Source for hot water"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90, origin={78,-176})));

  Buildings.Fluid.Sources.Boundary_pT sinHea(
    redeclare package Medium = MediumW,
    p=100000,
    T=328.15,
    nPorts=1)
    "Sink for hot water"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90, origin={48,-174})));

  Buildings.Fluid.Sources.Boundary_pT sinCoo(
    redeclare package Medium = MediumW,
    p=300000,
    T=288.15,
    nPorts=3)
    "Sink for chilled water"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90, origin={110,-174})));

  Buildings.Fluid.Sources.Boundary_pT souCoo(
    redeclare package Medium = MediumW,
    p(displayUnit="Pa") = 300000 + 6000,
    T=279.15,
    nPorts=3)
    "Source for chilled water"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90, origin={140,-174})));

  Buildings.Fluid.ZoneEquipment.FourPipe fanCoiUni(
    redeclare package MediumA = MediumA,
    redeclare package MediumHW = MediumW,
    redeclare package MediumCHW = MediumW,
    heaCoiTyp=Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.None,
    mHotWat_flow_nominal=0.75*3.75*0.50946*0.25,
    dpAir_nominal=100,
    UAHeaCoi_nominal=2.25*146.06*3*1.1,
    mChiWat_flow_nominal=0.2984,
    UACooCoi_nominal=2.25*146.06,
    mAir_flow_nominal=0.21303*2*3,
    QHeaCoi_flow_nominal=7795.7)
    "Fan coil units"
    annotation (Placement(transformation(extent={{-10,86},{30,126}})));

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
    annotation (Placement(transformation(extent={{-62,78},{-22,150}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
    computeWetBulbTemperature=false)
    "Weather data reader"
    annotation (Placement(transformation(extent={{-48,180},{-28,200}})));

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
    annotation (Placement(transformation(extent={{-68,-14},{-28,58}})));

  Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnits.Controller conFCU2(
    cooCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased,
    heaCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.Electric,
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
    annotation (Placement(transformation(extent={{-68,-110},{-28,-38}})));

  parameter Boolean sampleModel = false
    "Set to true to time-sample the model, which can give shorter simulation time if there is already time sampling in the system model"
    annotation (Evaluate=true,Dialog(
      tab="Experimental (may be changed in future releases)"));

  parameter HeatTransfer.Data.Solids.Plywood matCarTra(
    k=0.11,
    d=544,
    nStaRef=1,
    x=0.215/0.11) "Wood for floor"
    annotation (Placement(transformation(extent={{30,262},{50,282}})));
  parameter HeatTransfer.Data.Solids.Plywood matFur(x=0.15, nStaRef=5)
    "Material for furniture"
    annotation (Placement(transformation(extent={{68,262},{88,282}})));
  parameter HeatTransfer.Data.Solids.Concrete matCon(
    x=0.1,
    k=1.311,
    c=836,
    nStaRef=5) "Concrete"
    annotation (Placement(transformation(extent={{68,232},{88,252}})));
  parameter HeatTransfer.Data.Solids.Plywood matWoo(
    x=0.01,
    k=0.11,
    d=544,
    nStaRef=1) "Wood for exterior construction"
    annotation (Placement(transformation(extent={{68,202},{88,222}})));
  parameter HeatTransfer.Data.Solids.GypsumBoard matGyp(
    x=0.0127,
    k=0.16,
    c=830,
    d=784,
    nStaRef=2) "Gypsum board"
    annotation (Placement(transformation(extent={{66,174},{86,194}})));
  parameter HeatTransfer.Data.Resistances.Carpet matCar "Carpet"
    annotation (Placement(transformation(extent={{108,262},{128,282}})));
  parameter HeatTransfer.Data.Solids.Generic matIns(
    x=0.087,
    k=0.049,
    c=836.8,
    d=265,
    nStaRef=5) "Steelframe construction with insulation"
    annotation (Placement(transformation(extent={{108,202},{128,222}})));
  parameter HeatTransfer.Data.Solids.GypsumBoard matGyp2(
    x=0.025,
    k=0.16,
    c=830,
    d=784,
    nStaRef=2) "Gypsum board"
    annotation (Placement(transformation(extent={{106,176},{126,196}})));
  parameter HeatTransfer.Data.GlazingSystems.DoubleClearAir13Clear glaSys(
    UFra=2,
    shade=Buildings.HeatTransfer.Data.Shades.Gray(),
    haveInteriorShade=false,
    haveExteriorShade=false) "Data record for the glazing system"
    annotation (Placement(transformation(extent={{168,264},{188,284}})));
  parameter HeatTransfer.Data.OpaqueConstructions.Generic conExtWal(final nLay=3,
      material={matWoo,matIns,matGyp}) "Exterior construction"
    annotation (Placement(transformation(extent={{208,264},{228,284}})));
  parameter HeatTransfer.Data.OpaqueConstructions.Generic conIntWal(final nLay=1,
      material={matGyp2}) "Interior wall construction"
    annotation (Placement(transformation(extent={{246,264},{266,284}})));
  parameter HeatTransfer.Data.OpaqueConstructions.Generic conFur(final nLay=1,
      material={matFur})
                 "Construction for internal mass of furniture"
    annotation (Placement(transformation(extent={{246,224},{266,244}})));
  parameter HeatTransfer.Data.OpaqueConstructions.Generic conFlo(final nLay=1,
      material={matCon})
                 "Floor construction (opa_a is carpet)"
    annotation (Placement(transformation(extent={{208,224},{228,244}})));

  parameter Modelica.Units.SI.Length hRoo=2.74
    "Room height";
  parameter Modelica.Units.SI.Area AFloNor=568.77/hRoo
    "Area of North zone";
  parameter Modelica.Units.SI.Volume VRooNor=AFloNor*hRoo
    "Volume of North zone";
  parameter Modelica.Units.SI.Length wExtNor=49.91
    "North zone exterior wall width";
  parameter HeatTransfer.Types.InteriorConvection intConMod=Buildings.HeatTransfer.Types.InteriorConvection.Temperature
    "Convective heat transfer model for room-facing surfaces of opaque constructions";
  parameter Real winWalRat(
    min=0.01,
    max=0.99) = 0.33 "Window to wall ratio for exterior walls";
  parameter Modelica.Units.SI.Length hWin=1.5 "Height of windows";

  parameter Real kIntNor(min=0, max=1) = 1
    "Gain factor to scale internal heat gain in north zone";




  ThermalZones.Detailed.MixedAir           nor(
    redeclare package Medium = MediumA,
    AFlo=AFloNor,
    hRoo=hRoo,
    nConExt=0,
    nConExtWin=1,
    datConExtWin(
      layers={conExtWal},
      A={wExtNor*hRoo},
      glaSys={glaSys},
      wWin={winWalRat/hWin*wExtNor*hRoo},
      each hWin=hWin,
      fFra={0.1},
      til={Buildings.Types.Tilt.Wall},
      azi={Buildings.Types.Azimuth.N}),
    nConPar=2,
    datConPar(
      layers={conFlo,conFur},
      A={AFloNor,414.68},
      til={Buildings.Types.Tilt.Floor,Buildings.Types.Tilt.Wall}),
    nConBou=3,
    datConBou(
      layers={conIntWal,conIntWal,conIntWal},
      A={6.47,40.76,6.47}*hRoo,
      til={Buildings.Types.Tilt.Wall,Buildings.Types.Tilt.Wall,Buildings.Types.Tilt.Wall}),
    nSurBou=0,
    intConMod=intConMod,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final sampleModel=sampleModel,
    nPorts=3)                      "North zone"
    annotation (Placement(transformation(extent={{64,84},{110,132}})));

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temAirNoHeaCoi
    "Air temperature sensor"
    annotation (Placement(transformation(extent={{136,90},{148,102}})));
  Modelica.Blocks.Sources.Constant uSha(k=0)
    "Control signal for the shading device"
    annotation (Placement(transformation(extent={{-200,166},{-180,186}})));
  Modelica.Blocks.Routing.Replicator replicator(nout=1)
    annotation (Placement(transformation(extent={{-156,166},{-136,186}})));
  Modelica.Blocks.Sources.CombiTimeTable intGaiFra(
    table=[0,0.05; 8,0.05; 9,0.9; 12,0.9; 12,0.8; 13,0.8; 13,1; 17,1; 19,0.1; 24,
        0.05],
    timeScale=3600,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Fraction of internal heat gain"
    annotation (Placement(transformation(extent={{-164,-168},{-144,-148}})));
  Modelica.Blocks.Math.MatrixGain gai(K=20*[0.4; 0.4; 0.2])
    "Matrix gain to split up heat gain in radiant, convective and latent gain"
    annotation (Placement(transformation(extent={{-116,-166},{-96,-146}})));
  Modelica.Blocks.Math.Gain gaiIntNor[3](each k=kIntNor)
    "Gain for internal heat gain amplification for north zone"
    annotation (Placement(transformation(extent={{-74,-164},{-54,-144}})));
  Fluid.ZoneEquipment.FourPipe fanCoiUni1(
    redeclare package MediumA = MediumA,
    redeclare package MediumHW = MediumW,
    redeclare package MediumCHW = MediumW,
    mHotWat_flow_nominal=0.75*3.75*0.50946*0.25,
    dpAir_nominal=100,
    UAHeaCoi_nominal=2.25*146.06*3*1.1,
    mChiWat_flow_nominal=0.2984,
    UACooCoi_nominal=2.25*146.06,
    mAir_flow_nominal=0.21303*2*3,
    QHeaCoi_flow_nominal=7795.7)
    "Fan coil units"
    annotation (Placement(transformation(extent={{30,2},{70,42}})));

  ThermalZones.Detailed.MixedAir           nor1(
    redeclare package Medium = MediumA,
    AFlo=AFloNor,
    hRoo=hRoo,
    nConExt=0,
    nConExtWin=1,
    datConExtWin(
      layers={conExtWal},
      A={wExtNor*hRoo},
      glaSys={glaSys},
      wWin={winWalRat/hWin*wExtNor*hRoo},
      each hWin=hWin,
      fFra={0.1},
      til={Buildings.Types.Tilt.Wall},
      azi={Buildings.Types.Azimuth.N}),
    nConPar=2,
    datConPar(
      layers={conFlo,conFur},
      A={AFloNor,414.68},
      til={Buildings.Types.Tilt.Floor,Buildings.Types.Tilt.Wall}),
    nConBou=3,
    datConBou(
      layers={conIntWal,conIntWal,conIntWal},
      A={6.47,40.76,6.47}*hRoo,
      til={Buildings.Types.Tilt.Wall,Buildings.Types.Tilt.Wall,Buildings.Types.Tilt.Wall}),
    nSurBou=0,
    nPorts=3,
    intConMod=intConMod,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final sampleModel=sampleModel) "North zone"
    annotation (Placement(transformation(extent={{104,0},{150,48}})));

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temAirNoHeaCoi1
    "Air temperature sensor"
    annotation (Placement(transformation(extent={{176,6},{188,18}})));

  Fluid.ZoneEquipment.FourPipe fanCoiUni2(
    redeclare package MediumA = MediumA,
    redeclare package MediumHW = MediumW,
    redeclare package MediumCHW = MediumW,
    heaCoiTyp=Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.Electric,
    mHotWat_flow_nominal=0.75*3.75*0.50946*0.25,
    dpAir_nominal=100,
    UAHeaCoi_nominal=2.25*146.06*3*1.1,
    mChiWat_flow_nominal=0.2984,
    UACooCoi_nominal=2.25*146.06,
    mAir_flow_nominal=0.21303*2*3,
    QHeaCoi_flow_nominal=7795.7)
    "Fan coil units"
    annotation (Placement(transformation(extent={{26,-88},{66,-48}})));

  ThermalZones.Detailed.MixedAir           nor2(
    redeclare package Medium = MediumA,
    AFlo=AFloNor,
    hRoo=hRoo,
    nConExt=0,
    nConExtWin=1,
    datConExtWin(
      layers={conExtWal},
      A={wExtNor*hRoo},
      glaSys={glaSys},
      wWin={winWalRat/hWin*wExtNor*hRoo},
      each hWin=hWin,
      fFra={0.1},
      til={Buildings.Types.Tilt.Wall},
      azi={Buildings.Types.Azimuth.N}),
    nConPar=2,
    datConPar(
      layers={conFlo,conFur},
      A={AFloNor,414.68},
      til={Buildings.Types.Tilt.Floor,Buildings.Types.Tilt.Wall}),
    nConBou=3,
    datConBou(
      layers={conIntWal,conIntWal,conIntWal},
      A={6.47,40.76,6.47}*hRoo,
      til={Buildings.Types.Tilt.Wall,Buildings.Types.Tilt.Wall,Buildings.Types.Tilt.Wall}),
    nSurBou=0,
    nPorts=3,
    intConMod=intConMod,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final sampleModel=sampleModel) "North zone"
    annotation (Placement(transformation(extent={{98,-94},{144,-46}})));

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temAirNoHeaCoi2
    "Air temperature sensor"
    annotation (Placement(transformation(extent={{166,-78},{178,-66}})));
  VAVReheat.BaseClasses.RoomLeakage                    leaNor(
    redeclare package Medium = MediumA,
    VRoo=VRooNor,
    s=49.91/33.27,
    azi=Buildings.Types.Azimuth.N,
    final use_windPressure=false)
    "Model for air infiltration through the envelope"
    annotation (Placement(transformation(extent={{-6,128},{30,168}})));
protected
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant LimLev(
    final k=0)
    "Cooling and heating demand limit level"
    annotation (Placement(transformation(extent={{-200,70},{-180,90}})));

  Buildings.Controls.SetPoints.OccupancySchedule occSch(
    final occupancy=3600*{6,19})
    "Occupancy schedule"
    annotation (Placement(transformation(extent={{-200,30},{-180,50}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TOccHeaSetPoi(final k=20 + 273.15)
    "Occupied heating temperature setpoint"
    annotation (Placement(transformation(extent={{-202,-4},{-182,16}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TUnOccCooSet(final k=30 + 273.15)
    "Unoccupied cooling temperature setpoint"
    annotation (Placement(transformation(extent={{-200,-80},{-180,-60}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TUnOccHeaSet(final k=12 + 273.15)
    "Unoccupied heating temperature setpoint"
    annotation (Placement(transformation(extent={{-200,-110},{-180,-90}})));

  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr[3](final t=fill(0.01,
        3), final h=fill(0.005, 3))
    "Check if fan speed is above threshold for proven on signal"
    annotation (Placement(transformation(extent={{-200,-140},{-180,-120}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim[3](final t=fill(120, 3))
    "Generate fan proven on signal"
    annotation (Placement(transformation(extent={{-160,-140},{-140,-120}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSetAdj(
    final k=0)
    "Unoccupied cooling  temperature setpoint"
    annotation (Placement(transformation(extent={{-200,100},{-180,120}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant cooWarTim(final k=3600)
    "Cooldown and warm-up time"
    annotation (Placement(transformation(extent={{-200,130},{-180,150}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TOccCooSetPoi(
    final k=24 + 273.15)
    "Occupied cooling temperature setpoint"
    annotation (Placement(transformation(extent={{-200,-50},{-180,-30}})));


equation
  connect(conFCU.yFan, fanCoiUni.uFan) annotation (Line(points={{-20,130},{-20,112},
          {-12,112}},                color={0,0,127}));
  connect(conFCU.yCooCoi, fanCoiUni.uCoo) annotation (Line(points={{-20,114},{-20,
          106},{-12,106}},  color={0,0,127}));
  connect(greThr.y, tim.u) annotation (Line(points={{-178,-130},{-162,-130}},
               color={255,0,255}));
  connect(fanCoiUni.TAirSup, conFCU.TSup) annotation (Line(points={{32,98},{40,98},
          {40,138},{-80,138},{-80,112},{-64,112}},          color={0,0,127}));
  connect(uSha.y, replicator.u)
    annotation (Line(points={{-179,176},{-158,176}}, color={0,0,127}));
  connect(replicator.y, nor.uSha) annotation (Line(points={{-135,176},{-54,176},
          {-54,162},{56,162},{56,129.6},{62.16,129.6}}, color={0,0,127}));
  connect(weaDat.weaBus, nor.weaBus) annotation (Line(
      points={{-28,190},{60,190},{60,138},{107.585,138},{107.585,129.48}},
      color={255,204,51},
      thickness=0.5));
  connect(nor.heaPorAir, temAirNoHeaCoi.port) annotation (Line(points={{85.85,108},
          {58,108},{58,78},{130,78},{130,96},{136,96}}, color={191,0,0}));
  connect(temAirNoHeaCoi.T, conFCU.TZon) annotation (Line(points={{148.6,96},{152,
          96},{152,74},{-102,74},{-102,108},{-64,108}}, color={0,0,127}));
  connect(intGaiFra.y, gai.u) annotation (Line(points={{-143,-158},{-126,-158},{
          -126,-156},{-118,-156}}, color={0,0,127}));
  connect(gai.y, gaiIntNor.u) annotation (Line(points={{-95,-156},{-84,-156},{-84,
          -154},{-76,-154}}, color={0,0,127}));
  connect(gaiIntNor.y, nor.qGai_flow) annotation (Line(points={{-53,-154},{-18,-154},
          {-18,76},{44,76},{44,112},{58,112},{58,117.6},{62.16,117.6}}, color={0,
          0,127}));
  connect(conFCU1.yFan, fanCoiUni1.uFan) annotation (Line(points={{-26,38},{20,38},
          {20,28},{28,28}}, color={0,0,127}));
  connect(conFCU1.yCooCoi, fanCoiUni1.uCoo)
    annotation (Line(points={{-26,22},{28,22}}, color={0,0,127}));
  connect(conFCU1.yHeaCoi, fanCoiUni1.uHea) annotation (Line(points={{-26,26},{14,
          26},{14,16},{28,16}}, color={0,0,127}));
  connect(fanCoiUni1.port_Air_b, nor1.ports[1]) annotation (Line(points={{70,18},
          {98,18},{98,10.4},{109.75,10.4}}, color={0,127,255}));
  connect(fanCoiUni1.port_Air_a, nor1.ports[2]) annotation (Line(points={{70,26},
          {94,26},{94,18},{98,18},{98,12},{109.75,12}}, color={0,127,255}));
  connect(nor1.heaPorAir, temAirNoHeaCoi1.port) annotation (Line(points={{125.85,
          24},{154,24},{154,10},{176,10},{176,12}}, color={191,0,0}));
  connect(conFCU1.TZon, temAirNoHeaCoi1.T) annotation (Line(points={{-70,16},{-78,
          16},{-78,-20},{194,-20},{194,12},{188.6,12}}, color={0,0,127}));
  connect(replicator.y, nor1.uSha) annotation (Line(points={{-135,176},{-54,176},
          {-54,162},{56,162},{56,50},{98,50},{98,45.6},{102.16,45.6}}, color={0,
          0,127}));
  connect(gaiIntNor.y, nor1.qGai_flow) annotation (Line(points={{-53,-154},{-18,
          -154},{-18,76},{96,76},{96,33.6},{102.16,33.6}}, color={0,0,127}));
  connect(weaDat.weaBus, nor1.weaBus) annotation (Line(
      points={{-28,190},{0,190},{0,164},{60,164},{60,138},{156,138},{156,45.48},
          {147.585,45.48}},
      color={255,204,51},
      thickness=0.5));
  connect(conFCU2.yFan, fanCoiUni2.uFan) annotation (Line(points={{-26,-58},{14,
          -58},{14,-62},{24,-62}}, color={0,0,127}));
  connect(conFCU2.yCooCoi, fanCoiUni2.uCoo) annotation (Line(points={{-26,-74},{
          14,-74},{14,-68},{24,-68}}, color={0,0,127}));
  connect(conFCU2.yHeaCoi, fanCoiUni2.uHea) annotation (Line(points={{-26,-70},{
          8,-70},{8,-76},{16,-76},{16,-74},{24,-74}}, color={0,0,127}));
  connect(fanCoiUni2.port_Air_a, nor2.ports[1]) annotation (Line(points={{66,-64},
          {92,-64},{92,-83.6},{103.75,-83.6}}, color={0,127,255}));
  connect(fanCoiUni2.port_Air_b, nor2.ports[2]) annotation (Line(points={{66,-72},
          {92,-72},{92,-82},{103.75,-82}}, color={0,127,255}));
  connect(nor2.heaPorAir, temAirNoHeaCoi2.port) annotation (Line(points={{119.85,
          -70},{148,-70},{148,-74},{160,-74},{160,-72},{166,-72}}, color={191,0,
          0}));
  connect(replicator.y[1], nor2.uSha[1]) annotation (Line(points={{-135,176},{-54,
          176},{-54,162},{56,162},{56,50},{90,50},{90,-48.4},{96.16,-48.4}},
        color={0,0,127}));
  connect(gaiIntNor.y, nor2.qGai_flow) annotation (Line(points={{-53,-154},{-18,
          -154},{-18,76},{96,76},{96,-40},{88,-40},{88,-60.4},{96.16,-60.4}},
        color={0,0,127}));
  connect(conFCU2.TZon, temAirNoHeaCoi2.T) annotation (Line(points={{-70,-80},{-78,
          -80},{-78,-116},{184,-116},{184,-72},{178.6,-72}}, color={0,0,127}));
  connect(sinHea.ports[1], fanCoiUni1.port_HW_b) annotation (Line(points={{48,-164},
          {48,-162},{50,-162},{50,-154},{-4,-154},{-4,-22},{36,-22},{36,2}},
        color={0,127,255}));
  connect(souHea.ports[1], fanCoiUni1.port_HW_a) annotation (Line(points={{78,-166},
          {78,-164},{80,-164},{80,-160},{6,-160},{6,-24},{38,-24},{38,-4},{46,
          -4},{46,2}},
                   color={0,127,255}));
  connect(sinCoo.ports[1], fanCoiUni2.port_CHW_b) annotation (Line(points={{111.333,
          -164},{111.333,-158},{12,-158},{12,-98},{48,-98},{48,-88}},
                                                                  color={0,127,255}));
  connect(sinCoo.ports[2], fanCoiUni1.port_CHW_b) annotation (Line(points={{110,
          -164},{110,-162},{112,-162},{112,-158},{12,-158},{12,-26},{40,-26},{
          40,-6},{52,-6},{52,2}},
                               color={0,127,255}));
  connect(souCoo.ports[1], fanCoiUni2.port_CHW_a) annotation (Line(points={{141.333,
          -164},{141.333,-158},{138,-158},{138,-100},{58,-100},{58,-88}},
                                                                      color={0,127,
          255}));
  connect(souCoo.ports[2], fanCoiUni1.port_CHW_a) annotation (Line(points={{140,
          -164},{140,-162},{142,-162},{142,-158},{138,-158},{138,-100},{78,-100},
          {78,-4},{62,-4},{62,2}}, color={0,127,255}));
  connect(weaDat.weaBus, nor2.weaBus) annotation (Line(
      points={{-28,190},{4,190},{4,170},{64,170},{64,144},{160,144},{160,28},{
          200,28},{200,-48.52},{141.585,-48.52}},
      color={255,204,51},
      thickness=0.5));
  connect(fanCoiUni1.TAirSup, conFCU1.TSup) annotation (Line(points={{72,14},{78,
          14},{78,64},{4,64},{4,20},{-70,20}}, color={0,0,127}));
  connect(fanCoiUni2.TAirSup, conFCU2.TSup) annotation (Line(points={{68,-76},{76,
          -76},{76,-118},{-80,-118},{-80,-76},{-70,-76}}, color={0,0,127}));
  connect(cooWarTim.y, conFCU.warUpTim) annotation (Line(points={{-178,140},{-114,
          140},{-114,148},{-64,148}}, color={0,0,127}));
  connect(cooWarTim.y, conFCU.cooDowTim) annotation (Line(points={{-178,140},{-114,
          140},{-114,148},{-72,148},{-72,144},{-64,144}}, color={0,0,127}));
  connect(cooWarTim.y, conFCU1.warUpTim) annotation (Line(points={{-178,140},{-114,
          140},{-114,102},{-76,102},{-76,64},{-70,64},{-70,56}}, color={0,0,127}));
  connect(cooWarTim.y, conFCU1.cooDowTim) annotation (Line(points={{-178,140},{-114,
          140},{-114,102},{-76,102},{-76,64},{-80,64},{-80,56},{-78,56},{-78,52},
          {-70,52}}, color={0,0,127}));
  connect(TSetAdj.y, conFCU.setAdj) annotation (Line(points={{-178,110},{-76,110},
          {-76,136},{-64,136}}, color={0,0,127}));
  connect(TSetAdj.y, conFCU1.setAdj) annotation (Line(points={{-178,110},{-116,110},
          {-116,44},{-70,44}}, color={0,0,127}));
  connect(TSetAdj.y, conFCU2.setAdj) annotation (Line(points={{-178,110},{-116,110},
          {-116,44},{-84,44},{-84,-52},{-70,-52}}, color={0,0,127}));
  connect(cooWarTim.y, conFCU2.warUpTim) annotation (Line(points={{-178,140},{-114,
          140},{-114,102},{-76,102},{-76,64},{-80,64},{-80,56},{-84,56},{-84,46},
          {-86,46},{-86,-54},{-80,-54},{-80,-50},{-78,-50},{-78,-40},{-70,-40}},
        color={0,0,127}));
  connect(cooWarTim.y, conFCU2.cooDowTim) annotation (Line(points={{-178,140},{-114,
          140},{-114,102},{-76,102},{-76,64},{-80,64},{-80,56},{-84,56},{-84,46},
          {-86,46},{-86,-54},{-80,-54},{-80,-50},{-78,-50},{-78,-44},{-70,-44}},
        color={0,0,127}));
  connect(LimLev.y, conFCU.uCooDemLimLev) annotation (Line(points={{-178,80},{-162,
          80},{-162,120},{-104,120},{-104,106},{-74,106},{-74,120},{-64,120}},
        color={255,127,0}));
  connect(LimLev.y, conFCU.uHeaDemLimLev) annotation (Line(points={{-178,80},{-162,
          80},{-162,120},{-104,120},{-104,106},{-74,106},{-74,116},{-64,116}},
        color={255,127,0}));
  connect(LimLev.y, conFCU1.uCooDemLimLev) annotation (Line(points={{-178,80},{-124,
          80},{-124,28},{-70,28}}, color={255,127,0}));
  connect(LimLev.y, conFCU1.uHeaDemLimLev) annotation (Line(points={{-178,80},{-124,
          80},{-124,28},{-78,28},{-78,24},{-70,24}}, color={255,127,0}));
  connect(LimLev.y, conFCU2.uCooDemLimLev) annotation (Line(points={{-178,80},{-124,
          80},{-124,28},{-90,28},{-90,-68},{-70,-68}}, color={255,127,0}));
  connect(LimLev.y, conFCU2.uHeaDemLimLev) annotation (Line(points={{-178,80},{-124,
          80},{-124,28},{-90,28},{-90,-68},{-78,-68},{-78,-72},{-70,-72}},
        color={255,127,0}));
  connect(occSch.tNexOcc, conFCU.tNexOcc) annotation (Line(points={{-179,46},{-122,
          46},{-122,122},{-110,122},{-110,140},{-64,140}}, color={0,0,127}));
  connect(occSch.tNexOcc, conFCU1.tNexOcc) annotation (Line(points={{-179,46},{-90,
          46},{-90,48},{-70,48}}, color={0,0,127}));
  connect(occSch.tNexOcc, conFCU2.tNexOcc) annotation (Line(points={{-179,46},{-90,
          46},{-90,48},{-78,48},{-78,30},{-80,30},{-80,-48},{-70,-48}}, color={0,
          0,127}));
  connect(occSch.occupied, conFCU1.u1Occ) annotation (Line(points={{-179,34},{-80,
          34},{-80,32.2},{-70,32.2}}, color={255,0,255}));
  connect(occSch.occupied, conFCU2.u1Occ) annotation (Line(points={{-179,34},{-96,
          34},{-96,-72},{-82,-72},{-82,-63.8},{-70,-63.8}}, color={255,0,255}));
  connect(occSch.occupied, conFCU.u1Occ) annotation (Line(points={{-179,34},{-126,
          34},{-126,124.2},{-64,124.2}}, color={255,0,255}));
  connect(TOccHeaSetPoi.y, conFCU.TOccHeaSet) annotation (Line(points={{-180,6},
          {-120,6},{-120,112},{-106,112},{-106,104},{-64,104}}, color={0,0,127}));
  connect(conFCU1.TOccHeaSet, TOccHeaSetPoi.y) annotation (Line(points={{-70,12},
          {-82,12},{-82,58},{-120,58},{-120,6},{-180,6}}, color={0,0,127}));
  connect(conFCU2.TOccHeaSet, TOccHeaSetPoi.y) annotation (Line(points={{-70,-84},
          {-102,-84},{-102,-38},{-124,-38},{-124,6},{-180,6}}, color={0,0,127}));
  connect(TOccCooSetPoi.y, conFCU2.TOccCooSet) annotation (Line(points={{-178,-40},
          {-124,-40},{-124,-88},{-70,-88}}, color={0,0,127}));
  connect(TOccCooSetPoi.y, conFCU1.TOccCooSet) annotation (Line(points={{-178,-40},
          {-124,-40},{-124,-88},{-82,-88},{-82,-74},{-80,-74},{-80,-56},{-82,-56},
          {-82,8},{-70,8}}, color={0,0,127}));
  connect(TOccCooSetPoi.y, conFCU.TOccCooSet) annotation (Line(points={{-178,-40},
          {-104,-40},{-104,42},{-118,42},{-118,100},{-64,100}}, color={0,0,127}));
  connect(TUnOccCooSet.y, conFCU2.TUnoCooSet) annotation (Line(points={{-178,-70},
          {-104,-70},{-104,-86},{-84,-86},{-84,-96},{-70,-96}}, color={0,0,127}));
  connect(TUnOccCooSet.y, conFCU1.TUnoCooSet) annotation (Line(points={{-178,-70},
          {-124,-70},{-124,0},{-70,0}}, color={0,0,127}));
  connect(TUnOccCooSet.y, conFCU.TUnoCooSet) annotation (Line(points={{-178,-70},
          {-124,-70},{-124,0},{-92,0},{-92,92},{-64,92}}, color={0,0,127}));
  connect(TUnOccHeaSet.y, conFCU2.TUnoHeaSet) annotation (Line(points={{-178,-100},
          {-82,-100},{-82,-92},{-70,-92}}, color={0,0,127}));
  connect(TUnOccHeaSet.y, conFCU1.TUnoHeaSet) annotation (Line(points={{-178,-100},
          {-124,-100},{-124,4},{-70,4}}, color={0,0,127}));
  connect(TUnOccHeaSet.y, conFCU.TUnoHeaSet) annotation (Line(points={{-178,-100},
          {-124,-100},{-124,4},{-94,4},{-94,96},{-64,96}}, color={0,0,127}));
  connect(weaDat.weaBus, leaNor.weaBus) annotation (Line(
      points={{-28,190},{-12,190},{-12,148},{-6,148}},
      color={255,204,51},
      thickness=0.5));
  connect(leaNor.port_b, nor1.ports[3]) annotation (Line(points={{30,148},{54,
          148},{54,48},{88,48},{88,26},{94,26},{94,18},{98,18},{98,13.6},{
          109.75,13.6}}, color={0,127,255}));
  connect(leaNor.port_b, nor2.ports[3]) annotation (Line(points={{30,148},{64,
          148},{64,-82},{103.75,-82},{103.75,-80.4}}, color={0,127,255}));
  connect(souCoo.ports[3], fanCoiUni.port_CHW_a) annotation (Line(points={{
          138.667,-164},{138.667,-39},{22,-39},{22,86}}, color={0,127,255}));
  connect(sinCoo.ports[3], fanCoiUni.port_CHW_b) annotation (Line(points={{
          108.667,-164},{108.667,-158},{12,-158},{12,-26},{4,-26},{4,18},{8,18},
          {8,70},{12,70},{12,86}}, color={0,127,255}));
  connect(fanCoiUni.yFan_actual, greThr[1].u) annotation (Line(points={{32,114},
          {-136,114},{-136,104},{-202,104},{-202,-130}}, color={0,0,127}));
  connect(fanCoiUni1.yFan_actual, greThr[2].u) annotation (Line(points={{72,30},
          {-138,30},{-138,-18},{-202,-18},{-202,-130}}, color={0,0,127}));
  connect(fanCoiUni2.yFan_actual, greThr[3].u) annotation (Line(points={{68,-60},
          {80,-60},{80,-122},{-16,-122},{-16,-176},{-212,-176},{-212,-130},{
          -202,-130}}, color={0,0,127}));
  connect(tim[1].passed, conFCU.u1Fan) annotation (Line(points={{-138,-138},{
          -110,-138},{-110,84},{-64,84}}, color={255,0,255}));
  connect(tim[2].passed, conFCU1.u1Fan) annotation (Line(points={{-138,-138},{
          -110,-138},{-110,-8},{-70,-8}}, color={255,0,255}));
  connect(tim[3].passed, conFCU2.u1Fan) annotation (Line(points={{-138,-138},{
          -110,-138},{-110,-104},{-70,-104}}, color={255,0,255}));
  connect(fanCoiUni.port_Air_b, nor.ports[1]) annotation (Line(points={{30,102},
          {36,102},{36,94.4},{69.75,94.4}}, color={0,127,255}));
  connect(fanCoiUni.port_Air_a, nor.ports[2]) annotation (Line(points={{30,110},
          {42,110},{42,96},{69.75,96}}, color={0,127,255}));
  connect(leaNor.port_b, nor.ports[3]) annotation (Line(points={{30,148},{54,
          148},{54,97.6},{69.75,97.6}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),       graphics={Text(
          extent={{-110,192},{110,156}},
          textColor={0,0,255},
          textString="%name")}),  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-220,-160},{220,160}})),
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
a 5-zone building thermal model with considerations for a building envelope model
and air flow through building leakage and through open doors.
</li>
<li>
a fan-coil unit that consists of a supply fan, an electric or hot-water heating
coil, and a chilled-water cooling coil.
</li>
<li>
The fan coil unit controller outputs the supply fan enable signal and speed signal,
the supply air temperature setpoint, the zone air heating and cooling setpoints,
and valve positions for heating and cooling coils.
</li>
</ul>
<p>
The HVAC system switches between occupied, unoccupied, unoccupied warm-up and
unoccupied pre-cool modes. The cooling coil and heating coil valves are modulated
to maintain the heating and cooling setpoints. The supply air temperature is modulated
based on the differential between the temperature setpoint and the zone temperature
to avoid unecessary heating and cooling use and avoid extreme temperature fluctuations.
</p>
<p>
See the model <a href=\"modelica://Buildings.Fluid.ZoneEquipment.FourPipe\">
Buildings.Fluid.ZoneEquipment.FourPipe</a> and 
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnits.Controller\">
Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnits.Controller</a> for the 
description of the fan coil unit and the controller, and see the model 
<a href=\"modelica://Buildings.Examples.VAVReheat.BaseClasses.Floor\">
Buildings.Examples.VAVReheat.BaseClasses.Floor</a>
for the description of the building envelope.
</p>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Examples/HydronicSystems/FanCoilUnit.mos"
        "Simulate and plot"),
    experiment(StopTime=86400, Tolerance=1e-06));
end FanCoilUnit;

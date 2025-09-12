within Buildings.Examples;
model FanCoilUnit "Fan Coil Unit"

  extends Modelica.Icons.Example;

  replaceable package MediumA = Buildings.Media.Air(T_default=293.15)
    "Medium for air";

  replaceable package MediumW = Buildings.Media.Water
    "Medium for hot-water and chilled-water";

  Buildings.Fluid.Sources.Boundary_pT souHea(
    redeclare package Medium = MediumW,
    p(displayUnit="Pa") = 300000 + 6000,
    T=333.15,
    nPorts=5)
    "Source for hot water"
    annotation (Placement(transformation(
      extent={{-9,-9},{9,9}},
      rotation=90,
      origin={37,-127})));

  Buildings.Fluid.Sources.Boundary_pT sinHea(
    redeclare package Medium = MediumW,
    p=300000,
    T=328.15,
    nPorts=5)
    "Sink for hot water"
    annotation (Placement(transformation(
      extent={{-9,-9},{9,9}},
      rotation=90,
      origin={11,-127})));

  Buildings.Fluid.Sources.Boundary_pT sinCoo(
    redeclare package Medium = MediumW,
    p=300000,
    T=288.15,
    nPorts=5)
    "Sink for chilled water"
    annotation (Placement(transformation(
        extent={{-9,-9},{9,9}},
        rotation=90,
        origin={63,-127})));

  Buildings.Fluid.Sources.Boundary_pT souCoo(
    redeclare package Medium = MediumW,
    p(displayUnit="Pa") = 300000 + 6000,
    T=279.15,
    nPorts=5)
    "Source for chilled water"
    annotation (Placement(transformation(extent={{-9,-9},{9,9}},
      rotation=90,origin={89,-127})));

  Buildings.Fluid.ZoneEquipment.FourPipe fanCoiUni(
    redeclare package MediumA = MediumA,
    redeclare package MediumHW = MediumW,
    redeclare package MediumCHW = MediumW,
    mHotWat_flow_nominal={0.21805,5*0.53883,0.33281,5*0.50946,0.33236},
    dpAir_nominal=fill(100, 5),
    UAHeaCoi_nominal={2.25*146.06,2.25*146.06,2.25*146.06,2.25*146.06,2.25*
        146.06},
    mChiWat_flow_nominal={0.23106,0.30892,0.18797,0.2984,0.18781},
    UACooCoi_nominal={2.25*146.06,2.25*146.06,2.25*146.06,2.25*146.06,2.25*
        146.06},
    mAir_flow_nominal=2*{0.9,0.222,0.1337,1.5*0.21303,1.5*0.137},
    QHeaCoi_flow_nominal={6036.5,8070.45,4910.71,7795.7,4906.52})
    "Fan coil units"
    annotation (Placement(transformation(extent={{14,90},{34,110}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
    computeWetBulbTemperature=false)
    "Weather data reader"
    annotation (Placement(transformation(extent={{-70,136},{-50,156}})));

  Buildings.Fluid.ZoneEquipment.FourPipe fanCoiUni1(
    redeclare package MediumA = MediumA,
    redeclare package MediumHW = MediumW,
    redeclare package MediumCHW = MediumW,
    mHotWat_flow_nominal={0.21805,5*0.53883,0.33281,5*0.50946,0.33236},
    dpAir_nominal=fill(100, 5),
    UAHeaCoi_nominal={2.25*146.06,2.25*146.06,2.25*146.06,2.25*146.06,2.25*
        146.06},
    mChiWat_flow_nominal={0.23106,0.30892,0.18797,0.2984,0.18781},
    UACooCoi_nominal={2.25*146.06,2.25*146.06,2.25*146.06,2.25*146.06,2.25*
        146.06},
    mAir_flow_nominal=2*{0.9,0.222,0.1337,1.5*0.21303,1.5*0.137},
    QHeaCoi_flow_nominal={6036.5,8070.45,4910.71,7795.7,4906.52})
    "Fan coil units"
    annotation (Placement(transformation(extent={{14,-4},{34,16}})));
  Buildings.Fluid.ZoneEquipment.FourPipe fanCoiUni2(
    redeclare package MediumA = MediumA,
    redeclare package MediumHW = MediumW,
    redeclare package MediumCHW = MediumW,
    mHotWat_flow_nominal={0.21805,5*0.53883,0.33281,5*0.50946,0.33236},
    dpAir_nominal=fill(100, 5),
    UAHeaCoi_nominal={2.25*146.06,2.25*146.06,2.25*146.06,2.25*146.06,2.25*
        146.06},
    mChiWat_flow_nominal={0.23106,0.30892,0.18797,0.2984,0.18781},
    UACooCoi_nominal={2.25*146.06,2.25*146.06,2.25*146.06,2.25*146.06,2.25*
        146.06},
    mAir_flow_nominal=2*{0.9,0.222,0.1337,1.5*0.21303,1.5*0.137},
    QHeaCoi_flow_nominal={6036.5,8070.45,4910.71,7795.7,4906.52})
    "Fan coil units"
    annotation (Placement(transformation(extent={{18,-82},{38,-62}})));
  Controls.OBC.ASHRAE.G36.FanCoilUnits.Controller conFCU1(
    cooCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased,
    heaCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.None,
    final TiCoo=fill(200, 5),
    final TiHea=fill(200, 5),
    kCooCoi=fill(0.05, 5),
    final TiCooCoi=fill(200, 5),
    kHeaCoi=fill(0.05, 5),
    final TiHeaCoi=fill(200, 5),
    each TSupSet_max=308.15,
    each TSupSet_min=285.85) "Fan coil unit controller"
    annotation (Placement(transformation(extent={{-40,-24},{0,36}})));
  Controls.OBC.ASHRAE.G36.FanCoilUnits.Controller conFCU2(
    cooCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.CoolingCoil.WaterBased,
    heaCoi=Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.None,
    final TiCoo=fill(200, 5),
    final TiHea=fill(200, 5),
    kCooCoi=fill(0.05, 5),
    final TiCooCoi=fill(200, 5),
    kHeaCoi=fill(0.05, 5),
    final TiHeaCoi=fill(200, 5),
    each TSupSet_max=308.15,
    each TSupSet_min=285.85) "Fan coil unit controller"
    annotation (Placement(transformation(extent={{-38,-98},{2,-38}})));
  BoundaryConditions.WeatherData.Bus weaBus "Weather bus"
    annotation (Placement(transformation(extent={{4,146},{24,166}}),
        iconTransformation(extent={{200,210},{220,230}})));
  VAVReheat.BaseClasses.RoomLeakage lea(
    s=27.69/18.46,
    redeclare package Medium = Medium,
    VRoo=VRooNor,
    azi=Buildings.Types.Azimuth.N,
    final use_windPressure=use_windPressure)
    "Model for air infiltration through the envelope"
    annotation (Placement(transformation(extent={{24,130},{42,148}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temAirNoHeaCoi
    "Air temperature sensor"
    annotation (Placement(transformation(extent={{146,84},{158,96}})));
  parameter HeatTransfer.Data.Solids.GypsumBoard matGyp(
    x=0.0127,
    k=0.16,
    c=830,
    d=784,
    nStaRef=2) "Gypsum board"
    annotation (Placement(transformation(extent={{42,184},{62,204}})));
  parameter HeatTransfer.Data.Solids.GypsumBoard matGyp2(
    x=0.025,
    k=0.16,
    c=830,
    d=784,
    nStaRef=2) "Gypsum board"
    annotation (Placement(transformation(extent={{82,186},{102,206}})));
  parameter HeatTransfer.Data.Solids.Generic matIns(
    x=0.087,
    k=0.049,
    c=836.8,
    d=265,
    nStaRef=5) "Steelframe construction with insulation"
    annotation (Placement(transformation(extent={{84,212},{104,232}})));
  parameter HeatTransfer.Data.Solids.Plywood matWoo(
    x=0.01,
    k=0.11,
    d=544,
    nStaRef=1) "Wood for exterior construction"
    annotation (Placement(transformation(extent={{44,212},{64,232}})));
  parameter HeatTransfer.Data.Solids.Concrete matCon(
    x=0.1,
    k=1.311,
    c=836,
    nStaRef=5) "Concrete"
    annotation (Placement(transformation(extent={{44,242},{64,262}})));
  parameter HeatTransfer.Data.Solids.Plywood matFur(x=0.15, nStaRef=5)
    "Material for furniture"
    annotation (Placement(transformation(extent={{44,272},{64,292}})));
  parameter HeatTransfer.Data.Solids.Plywood matCarTra(
    k=0.11,
    d=544,
    nStaRef=1,
    x=0.215/0.11) "Wood for floor"
    annotation (Placement(transformation(extent={{6,272},{26,292}})));
  parameter HeatTransfer.Data.Resistances.Carpet matCar "Carpet"
    annotation (Placement(transformation(extent={{84,272},{104,292}})));
  parameter HeatTransfer.Data.GlazingSystems.DoubleClearAir13Clear glaSys(
    UFra=2,
    shade=Buildings.HeatTransfer.Data.Shades.Gray(),
    haveInteriorShade=false,
    haveExteriorShade=false) "Data record for the glazing system"
    annotation (Placement(transformation(extent={{144,274},{164,294}})));
  parameter HeatTransfer.Data.OpaqueConstructions.Generic conFlo(final nLay=1,
      material={matCon})
                 "Floor construction (opa_a is carpet)"
    annotation (Placement(transformation(extent={{184,234},{204,254}})));
  parameter HeatTransfer.Data.OpaqueConstructions.Generic conExtWal(final nLay=
        3, material={matWoo,matIns,matGyp})
                                       "Exterior construction"
    annotation (Placement(transformation(extent={{184,274},{204,294}})));
  parameter HeatTransfer.Data.OpaqueConstructions.Generic conIntWal(final nLay=
        1, material={matGyp2})
                          "Interior wall construction"
    annotation (Placement(transformation(extent={{222,274},{242,294}})));
  parameter HeatTransfer.Data.OpaqueConstructions.Generic conFur(final nLay=1,
      material={matFur})
                 "Construction for internal mass of furniture"
    annotation (Placement(transformation(extent={{222,234},{242,254}})));
  Modelica.Blocks.Sources.Constant uSha(k=0)
    "Control signal for the shading device"
    annotation (Placement(transformation(extent={{-158,158},{-138,178}})));
  Modelica.Blocks.Routing.Replicator replicator(nout=1)
    annotation (Placement(transformation(extent={{-116,172},{-96,192}})));
  Modelica.Blocks.Math.Gain gaiIntNor[3](each k=kIntNor)
    "Gain for internal heat gain amplification for north zone"
    annotation (Placement(transformation(extent={{-64,-170},{-44,-150}})));
  Modelica.Blocks.Math.MatrixGain gai(K=20*[0.4; 0.4; 0.2])
    "Matrix gain to split up heat gain in radiant, convective and latent gain"
    annotation (Placement(transformation(extent={{-106,-172},{-86,-152}})));
  Modelica.Blocks.Sources.CombiTimeTable intGaiFra(
    table=[0,0.05; 8,0.05; 9,0.9; 12,0.9; 12,0.8; 13,0.8; 13,1; 17,1; 19,0.1;
        24,0.05],
    timeScale=3600,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Fraction of internal heat gain"
    annotation (Placement(transformation(extent={{-154,-174},{-134,-154}})));
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
    nPorts=3,
    intConMod=intConMod,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final sampleModel=sampleModel) "North zone"
    annotation (Placement(transformation(extent={{76,84},{106,114}})));

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
    annotation (Placement(transformation(extent={{78,8},{108,38}})));

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temAirNoHeaCoi1
    "Air temperature sensor"
    annotation (Placement(transformation(extent={{150,6},{162,18}})));
protected
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant LimLev(
    final k=0)
    "Cooling and heating demand limit level"
    annotation (Placement(transformation(extent={{-158,54},{-138,74}})));

  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep(
    final nout=5)
    "Scalar replicator for demand limit level"
    annotation (Placement(transformation(extent={{-130,54},{-110,74}})));

  Buildings.Controls.SetPoints.OccupancySchedule occSch(
    final occupancy=3600*{6,19})
    "Occupancy schedule"
    annotation (Placement(transformation(extent={{-158,18},{-138,38}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TOccSetPoi(
    final k=23 + 273.15)
    "Occupied temperature setpoint"
    annotation (Placement(transformation(extent={{-156,-30},{-136,-10}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TUnOccCooSet(
    final k=25 + 273.15)
    "Unoccupied cooling temperature setpoint"
    annotation (Placement(transformation(extent={{-154,-64},{-134,-44}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TUnOccHeaSet(
    final k=21 + 273.15)
    "Unoccupied heating temperature setpoint"
    annotation (Placement(transformation(extent={{-152,-98},{-132,-78}})));

  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr[5](final t=fill(0.01,
        5), final h=fill(0.005, 5))
    "Check if fan speed is above threshold for proven on signal"
    annotation (Placement(transformation(extent={{-152,-130},{-132,-110}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim[5](
    final t=fill(120, 5))
    "Generate fan proven on signal"
    annotation (Placement(transformation(extent={{-120,-126},{-100,-106}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep2(
    final nout=5)
    "Scalar replicator for temperature setpoint adjustment"
    annotation (Placement(transformation(extent={{-128,88},{-108,108}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep3(
    final nout=5)
    "Scalar replicator for time to next occupancy"
    annotation (Placement(transformation(extent={{-116,26},{-96,46}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep4(
    final nout=5)
    "Scalar replicator for occupied setpoint temperature"
    annotation (Placement(transformation(extent={{-124,-30},{-104,-10}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep5(
    final nout=5)
    "Scalar replicator for unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-120,-62},{-100,-42}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep6(
    final nout=5)
    "Scalar replicator for unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{-118,-92},{-98,-72}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSetAdj(
    final k=0)
    "Unoccupied cooling  temperature setpoint"
    annotation (Placement(transformation(extent={{-158,86},{-138,106}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant cooWarTim(
    final k=0)
    "Cooldown and warm-up time"
    annotation (Placement(transformation(extent={{-158,120},{-138,140}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep1(
    final nout=5)
    "Scalar replicator for cool-down and warm-up time"
    annotation (Placement(transformation(extent={{-126,120},{-106,140}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep1(
    final nout=5)
    "Scalar replicator for occupancy"
    annotation (Placement(transformation(extent={{-126,0},{-106,20}})));

equation
  connect(cooWarTim.y, reaScaRep1.u) annotation (Line(points={{-136,130},{-128,
          130}},                     color={0,0,127}));
  connect(greThr.y, tim.u) annotation (Line(points={{-130,-120},{-126,-120},{
          -126,-116},{-122,-116}},
               color={255,0,255}));
  connect(occSch.tNexOcc, reaScaRep3.u) annotation (Line(points={{-137,34},{
          -126,34},{-126,36},{-118,36}},      color={0,0,127}));
  connect(occSch.occupied, booScaRep1.u) annotation (Line(points={{-137,22},{
          -134,22},{-134,16},{-128,16},{-128,10}},
                                     color={255,0,255}));
  connect(TOccSetPoi.y, reaScaRep4.u) annotation (Line(points={{-134,-20},{-126,
          -20}},                           color={0,0,127}));
  connect(TUnOccCooSet.y, reaScaRep5.u)
    annotation (Line(points={{-132,-54},{-132,-52},{-122,-52}},
                                                        color={0,0,127}));
  connect(TUnOccHeaSet.y, reaScaRep6.u) annotation (Line(points={{-130,-88},{
          -120,-88},{-120,-82}},   color={0,0,127}));

  connect(LimLev.y, intScaRep.u)
    annotation (Line(points={{-136,64},{-132,64}},     color={255,127,0}));
  connect(sinHea.ports, fanCoiUni.port_HW_b) annotation (Line(points={{11,-118},
          {11,-54},{8,-54},{8,86},{17,86},{17,90}},              color={0,127,
          255}));
  connect(fanCoiUni.port_HW_a, souHea.ports) annotation (Line(points={{22,90},{
          22,64},{40,64},{40,38},{54,38},{54,-122},{37,-122},{37,-118}},
                                      color={0,127,255}));
  connect(fanCoiUni.port_CHW_a, souCoo.ports) annotation (Line(points={{30,90},
          {30,68},{34,68},{34,46},{89,46},{89,-118}},
                                       color={0,127,255}));
  connect(fanCoiUni.port_CHW_b, sinCoo.ports) annotation (Line(points={{25,90},
          {25,64},{26,64},{26,38},{63,38},{63,-118}},
                                       color={0,127,255}));
  connect(fanCoiUni.yFan_actual, greThr.u) annotation (Line(points={{35,104},{
          44,104},{44,56},{-60,56},{-60,-134},{-158,-134},{-158,-120},{-154,
          -120}},                                                color={0,0,127}));
  connect(TSetAdj.y, reaScaRep2.u)
    annotation (Line(points={{-136,96},{-136,98},{-130,98}},
                                                     color={0,0,127}));
  connect(reaScaRep1.y[1], conFCU1.warUpTim) annotation (Line(points={{-104,
          129.2},{-80,129.2},{-80,120},{-54,120},{-54,94},{-62,94},{-62,38},{
          -42,38},{-42,34.3333}}, color={0,0,127}));
  connect(reaScaRep1.y[1], conFCU1.cooDowTim) annotation (Line(points={{-104,
          129.2},{-80,129.2},{-80,120},{-54,120},{-54,94},{-62,94},{-62,38},{
          -42,38},{-42,31}}, color={0,0,127}));
  connect(reaScaRep1.y[1], conFCU2.warUpTim) annotation (Line(points={{-104,
          129.2},{-80,129.2},{-80,120},{-54,120},{-54,94},{-62,94},{-62,38},{
          -54,38},{-54,-38},{-48,-38},{-48,-36},{-40,-36},{-40,-39.6667}},
        color={0,0,127}));
  connect(reaScaRep1.y[1], conFCU2.cooDowTim) annotation (Line(points={{-104,
          129.2},{-80,129.2},{-80,120},{-54,120},{-54,94},{-62,94},{-62,38},{
          -54,38},{-54,-38},{-48,-38},{-48,-43},{-40,-43}}, color={0,0,127}));
  connect(reaScaRep3.y[1], conFCU1.tNexOcc) annotation (Line(points={{-94,35.2},
          {-58,35.2},{-58,27.6667},{-42,27.6667}}, color={0,0,127}));
  connect(reaScaRep3.y[1], conFCU2.tNexOcc) annotation (Line(points={{-94,35.2},
          {-58,35.2},{-58,-42},{-50,-42},{-50,-46.3333},{-40,-46.3333}}, color=
          {0,0,127}));
  connect(reaScaRep2.y[1], conFCU1.setAdj) annotation (Line(points={{-106,97.2},
          {-76,97.2},{-76,24.3333},{-42,24.3333}}, color={0,0,127}));
  connect(reaScaRep2.y[1], conFCU2.setAdj) annotation (Line(points={{-106,97.2},
          {-76,97.2},{-76,24},{-56,24},{-56,-48},{-48,-48},{-48,-49.6667},{-40,
          -49.6667}}, color={0,0,127}));
  connect(booScaRep1.y[1], conFCU1.u1Occ) annotation (Line(points={{-104,9.2},{
          -76,9.2},{-76,14.5},{-42,14.5}}, color={255,0,255}));
  connect(booScaRep1.y[1], conFCU2.u1Occ) annotation (Line(points={{-104,9.2},{
          -76,9.2},{-76,14},{-62,14},{-62,-59.5},{-40,-59.5}}, color={255,0,255}));
  connect(intScaRep.y[1], conFCU1.uCooDemLimLev) annotation (Line(points={{-108,
          63.2},{-76,63.2},{-76,11},{-42,11}}, color={255,127,0}));
  connect(intScaRep.y[1], conFCU1.uHeaDemLimLev) annotation (Line(points={{-108,
          63.2},{-76,63.2},{-76,12},{-48,12},{-48,7.66667},{-42,7.66667}},
        color={255,127,0}));
  connect(intScaRep.y[1], conFCU2.uCooDemLimLev) annotation (Line(points={{-108,
          63.2},{-86,63.2},{-86,-62},{-40,-62},{-40,-63}}, color={255,127,0}));
  connect(intScaRep.y[1], conFCU2.uHeaDemLimLev) annotation (Line(points={{-108,
          63.2},{-86,63.2},{-86,-62},{-48,-62},{-48,-66.3333},{-40,-66.3333}},
        color={255,127,0}));
  connect(conFCU1.TSup, fanCoiUni1.TAirSup) annotation (Line(points={{-42,
          4.33333},{-68,4.33333},{-68,-64},{-50,-64},{-50,-106},{48,-106},{48,
          -12},{35,-12},{35,2}},  color={0,0,127}));
  connect(fanCoiUni2.TAirSup, conFCU2.TSup) annotation (Line(points={{39,-76},{
          39,-88},{8,-88},{8,-104},{-48,-104},{-48,-69.6667},{-40,-69.6667}},
        color={0,0,127}));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-50,146},{-44,146},{-44,156},{14,156}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(weaBus, lea.weaBus) annotation (Line(
      points={{14,156},{14,139},{24,139}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus, nor.weaBus) annotation (Line(
      points={{14,156},{60,156},{60,150},{104.425,150},{104.425,112.425}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(nor.heaPorAir, temAirNoHeaCoi.port) annotation (Line(points={{90.25,
          99},{116,99},{116,84},{142,84},{142,90},{146,90}}, color={191,0,0}));
  connect(fanCoiUni.port_Air_a, nor.ports[1]) annotation (Line(points={{34,102},
          {70,102},{70,90.5},{79.75,90.5}}, color={0,127,255}));
  connect(fanCoiUni.port_Air_b, nor.ports[2]) annotation (Line(points={{34,98},
          {40,98},{40,102},{70,102},{70,90},{79.75,90},{79.75,91.5}}, color={0,
          127,255}));
  connect(uSha.y, replicator.u)
    annotation (Line(points={{-137,168},{-126,168},{-126,182},{-118,182}},
                                                     color={0,0,127}));
  connect(replicator.y[1], nor.uSha[1]) annotation (Line(points={{-95,182},{-40,
          182},{-40,180},{6,180},{6,116},{66,116},{66,112.5},{74.8,112.5}},
        color={0,0,127}));
  connect(intGaiFra.y, gai.u) annotation (Line(points={{-133,-164},{-116,-164},
          {-116,-162},{-108,-162}}, color={0,0,127}));
  connect(gai.y, gaiIntNor.u) annotation (Line(points={{-85,-162},{-74,-162},{
          -74,-160},{-66,-160}}, color={0,0,127}));
  connect(gaiIntNor.y, nor.qGai_flow) annotation (Line(points={{-43,-160},{104,
          -160},{104,78},{66,78},{66,105},{74.8,105}}, color={0,0,127}));
  connect(lea.port_b, nor.ports[3]) annotation (Line(points={{42,139},{42,140},
          {72,140},{72,142},{70,142},{70,90},{79.75,90},{79.75,92.5}}, color={0,
          127,255}));
  connect(fanCoiUni1.port_Air_a, nor1.ports[1]) annotation (Line(points={{34,8},
          {72,8},{72,14.5},{81.75,14.5}}, color={0,127,255}));
  connect(fanCoiUni1.port_Air_b, nor1.ports[2]) annotation (Line(points={{34,4},
          {52,4},{52,8},{72,8},{72,14},{81.75,14},{81.75,15.5}}, color={0,127,255}));
  connect(lea.port_b, nor1.ports[3]) annotation (Line(points={{42,139},{70,139},
          {70,14},{81.75,14},{81.75,16.5}}, color={0,127,255}));
  connect(replicator.y, nor1.uSha) annotation (Line(points={{-95,182},{-90,182},
          {-90,164},{-38,164},{-38,138},{18,138},{18,118},{64,118},{64,44},{72,44},
          {72,36.5},{76.8,36.5}}, color={0,0,127}));
  connect(gaiIntNor.y, nor1.qGai_flow) annotation (Line(points={{-43,-160},{-38,
          -160},{-38,-112},{66,-112},{66,16},{72,16},{72,29},{76.8,29}}, color={
          0,0,127}));
  connect(nor1.heaPorAir, temAirNoHeaCoi1.port) annotation (Line(points={{92.25,
          23},{92,23},{92,44},{144,44},{144,12},{150,12}}, color={191,0,0}));
  connect(weaBus, nor1.weaBus) annotation (Line(
      points={{14,156},{60,156},{60,150},{104,150},{104,120},{124,120},{124,46},
          {100,46},{100,56},{114,56},{114,36.425},{106.425,36.425}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(temAirNoHeaCoi1.T, conFCU1.TZon) annotation (Line(points={{162.6,12},{
          58,12},{58,-30},{-48,-30},{-48,1},{-42,1}}, color={0,0,127}));
  connect(conFCU1.yFan, fanCoiUni1.uFan) annotation (Line(points={{2,19.3333},{
          2,42},{13,42},{13,9}},
                               color={0,0,127}));
  connect(conFCU1.yCooCoi, fanCoiUni1.uCoo)
    annotation (Line(points={{2,6},{13,6}}, color={0,0,127}));
  connect(conFCU1.yCooCoi, fanCoiUni1.uHea)
    annotation (Line(points={{2,6},{8,6},{8,3},{13,3}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Text(
          extent={{-110,192},{110,156}},
          textColor={0,0,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-140},{160,
            160}})),
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
See the model <a href=\"modelica://Buildings.Examples.HydronicSystems.BaseClasses.FourPipe\">
Buildings.Examples.HydronicSystems.BaseClasses.FourPipe</a> and 
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
    experiment(
      StopTime=86400,
      Tolerance=1e-06));
end FanCoilUnit;

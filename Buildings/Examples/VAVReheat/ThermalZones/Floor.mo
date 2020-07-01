within Buildings.Examples.VAVReheat.ThermalZones;
model Floor "Model of a floor of the building"
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium model for air" annotation (choicesAllMatching=true);

  parameter Boolean use_windPressure=true
    "Set to true to enable wind pressure";

  parameter HeatTransfer.Types.InteriorConvection intConMod=Buildings.HeatTransfer.Types.InteriorConvection.Temperature
    "Convective heat transfer model for room-facing surfaces of opaque constructions";
  parameter Modelica.SIunits.Angle lat "Latitude";
  parameter Real winWalRat(
    min=0.01,
    max=0.99) = 0.33 "Window to wall ratio for exterior walls";
  parameter Modelica.SIunits.Length hWin = 1.5 "Height of windows";
  parameter HeatTransfer.Data.Solids.Plywood matFur(x=0.15, nStaRef=5)
    "Material for furniture"
    annotation (Placement(transformation(extent={{140,460},{160,480}})));
  parameter HeatTransfer.Data.Resistances.Carpet matCar "Carpet"
    annotation (Placement(transformation(extent={{180,460},{200,480}})));
  parameter HeatTransfer.Data.Solids.Concrete matCon(
    x=0.1,
    k=1.311,
    c=836,
    nStaRef=5) "Concrete"
    annotation (Placement(transformation(extent={{140,430},{160,450}})));
  parameter HeatTransfer.Data.Solids.Plywood matWoo(
    x=0.01,
    k=0.11,
    d=544,
    nStaRef=1) "Wood for exterior construction"
    annotation (Placement(transformation(extent={{140,400},{160,420}})));
  parameter HeatTransfer.Data.Solids.Generic matIns(
    x=0.087,
    k=0.049,
    c=836.8,
    d=265,
    nStaRef=5) "Steelframe construction with insulation"
    annotation (Placement(transformation(extent={{180,400},{200,420}})));
  parameter HeatTransfer.Data.Solids.GypsumBoard matGyp(
    x=0.0127,
    k=0.16,
    c=830,
    d=784,
    nStaRef=2) "Gypsum board"
    annotation (Placement(transformation(extent={{138,372},{158,392}})));
  parameter HeatTransfer.Data.Solids.GypsumBoard matGyp2(
    x=0.025,
    k=0.16,
    c=830,
    d=784,
    nStaRef=2) "Gypsum board"
    annotation (Placement(transformation(extent={{178,372},{198,392}})));
  parameter HeatTransfer.Data.OpaqueConstructions.Generic conExtWal(final nLay=3,
      material={matWoo,matIns,matGyp}) "Exterior construction"
    annotation (Placement(transformation(extent={{280,460},{300,480}})));
  parameter HeatTransfer.Data.OpaqueConstructions.Generic conIntWal(final nLay=1,
      material={matGyp2}) "Interior wall construction"
    annotation (Placement(transformation(extent={{320,460},{340,480}})));
  parameter HeatTransfer.Data.OpaqueConstructions.Generic conFlo(final nLay=1, material={
        matCon}) "Floor construction (opa_a is carpet)"
    annotation (Placement(transformation(extent={{280,420},{300,440}})));
  parameter HeatTransfer.Data.OpaqueConstructions.Generic conFur(final nLay=1, material={
        matFur}) "Construction for internal mass of furniture"
    annotation (Placement(transformation(extent={{320,420},{340,440}})));
  parameter HeatTransfer.Data.Solids.Plywood matCarTra(
    k=0.11,
    d=544,
    nStaRef=1,
    x=0.215/0.11) "Wood for floor"
    annotation (Placement(transformation(extent={{102,460},{122,480}})));
  parameter HeatTransfer.Data.GlazingSystems.DoubleClearAir13Clear glaSys(
    UFra=2,
    shade=Buildings.HeatTransfer.Data.Shades.Gray(),
    haveInteriorShade=false,
    haveExteriorShade=false) "Data record for the glazing system"
    annotation (Placement(transformation(extent={{240,460},{260,480}})));
  parameter Real kIntNor(min=0, max=1) = 1
    "Gain factor to scale internal heat gain in north zone";
  constant Modelica.SIunits.Height hRoo=2.74 "Room height";

  parameter Boolean sampleModel = false
    "Set to true to time-sample the model, which can give shorter simulation time if there is already time sampling in the system model"
    annotation (
      Evaluate=true,
      Dialog(tab="Experimental (may be changed in future releases)"));

  Buildings.ThermalZones.Detailed.MixedAir sou(
    redeclare package Medium = Medium,
    lat=lat,
    AFlo=568.77/hRoo,
    hRoo=hRoo,
    nConExt=0,
    nConExtWin=1,
    datConExtWin(
      layers={conExtWal},
      A={49.91*hRoo},
      glaSys={glaSys},
      wWin={winWalRat/hWin*49.91*hRoo},
      each hWin=hWin,
      fFra={0.1},
      til={Buildings.Types.Tilt.Wall},
      azi={Buildings.Types.Azimuth.S}),
    nConPar=2,
    datConPar(
      layers={conFlo,conFur},
      A={568.77/hRoo,414.68},
      til={Buildings.Types.Tilt.Floor,Buildings.Types.Tilt.Wall}),
    nConBou=3,
    datConBou(
      layers={conIntWal,conIntWal,conIntWal},
      A={6.47,40.76,6.47}*hRoo,
      til={Buildings.Types.Tilt.Wall, Buildings.Types.Tilt.Wall, Buildings.Types.Tilt.Wall}),
    nSurBou=0,
    nPorts=5,
    intConMod=intConMod,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final sampleModel=sampleModel) "South zone"
    annotation (Placement(transformation(extent={{144,-44},{184,-4}})));
  Buildings.ThermalZones.Detailed.MixedAir eas(
    redeclare package Medium = Medium,
    lat=lat,
    AFlo=360.0785/hRoo,
    hRoo=hRoo,
    nConExt=0,
    nConExtWin=1,
    datConExtWin(
      layers={conExtWal},
      A={33.27*hRoo},
      glaSys={glaSys},
      wWin={winWalRat/hWin*33.27*hRoo},
      each hWin=hWin,
      fFra={0.1},
      til={Buildings.Types.Tilt.Wall},
      azi={Buildings.Types.Azimuth.E}),
    nConPar=2,
    datConPar(
      layers={conFlo,conFur},
      A={360.0785/hRoo,262.52},
      til={Buildings.Types.Tilt.Floor,Buildings.Types.Tilt.Wall}),
    nConBou=1,
    datConBou(
      layers={conIntWal},
      A={24.13}*hRoo,
      til={Buildings.Types.Tilt.Wall}),
    nSurBou=2,
    surBou(
      each A=6.47*hRoo,
      each absIR=0.9,
      each absSol=0.9,
      til={Buildings.Types.Tilt.Wall, Buildings.Types.Tilt.Wall}),
    nPorts=5,
    intConMod=intConMod,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final sampleModel=sampleModel) "East zone"
    annotation (Placement(transformation(extent={{304,56},{344,96}})));
  Buildings.ThermalZones.Detailed.MixedAir nor(
    redeclare package Medium = Medium,
    lat=lat,
    AFlo=568.77/hRoo,
    hRoo=hRoo,
    nConExt=0,
    nConExtWin=1,
    datConExtWin(
      layers={conExtWal},
      A={49.91*hRoo},
      glaSys={glaSys},
      wWin={winWalRat/hWin*49.91*hRoo},
      each hWin=hWin,
      fFra={0.1},
      til={Buildings.Types.Tilt.Wall},
      azi={Buildings.Types.Azimuth.N}),
    nConPar=2,
    datConPar(
      layers={conFlo,conFur},
      A={568.77/hRoo,414.68},
      til={Buildings.Types.Tilt.Floor,Buildings.Types.Tilt.Wall}),
    nConBou=3,
    datConBou(
      layers={conIntWal,conIntWal,conIntWal},
      A={6.47,40.76,6.47}*hRoo,
      til={Buildings.Types.Tilt.Wall, Buildings.Types.Tilt.Wall, Buildings.Types.Tilt.Wall}),
    nSurBou=0,
    nPorts=5,
    intConMod=intConMod,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final sampleModel=sampleModel) "North zone"
    annotation (Placement(transformation(extent={{144,116},{184,156}})));
  Buildings.ThermalZones.Detailed.MixedAir wes(
    redeclare package Medium = Medium,
    lat=lat,
    AFlo=360.0785/hRoo,
    hRoo=hRoo,
    nConExt=0,
    nConExtWin=1,
    datConExtWin(
      layers={conExtWal},
      A={33.27*hRoo},
      glaSys={glaSys},
      wWin={winWalRat/hWin*33.27*hRoo},
      each hWin=hWin,
      fFra={0.1},
      til={Buildings.Types.Tilt.Wall},
      azi={Buildings.Types.Azimuth.W}),
    nConPar=2,
    datConPar(
      layers={conFlo,conFur},
      A={360.0785/hRoo,262.52},
      til={Buildings.Types.Tilt.Floor,Buildings.Types.Tilt.Wall}),
    nConBou=1,
    datConBou(
      layers={conIntWal},
      A={24.13}*hRoo,
      til={Buildings.Types.Tilt.Wall}),
    nSurBou=2,
    surBou(
      each A=6.47*hRoo,
      each absIR=0.9,
      each absSol=0.9,
      til={Buildings.Types.Tilt.Wall, Buildings.Types.Tilt.Wall}),
    nPorts=5,
    intConMod=intConMod,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final sampleModel=sampleModel) "West zone"
    annotation (Placement(transformation(extent={{12,36},{52,76}})));
  Buildings.ThermalZones.Detailed.MixedAir cor(
    redeclare package Medium = Medium,
    lat=lat,
    AFlo=2698/hRoo,
    hRoo=hRoo,
    nConExt=0,
    nConExtWin=0,
    nConPar=2,
    datConPar(
      layers={conFlo,conFur},
      A={2698/hRoo,1967.01},
      til={Buildings.Types.Tilt.Floor,Buildings.Types.Tilt.Wall}),
    nConBou=0,
    nSurBou=4,
    surBou(
      A={40.76,24.13,40.76,24.13}*hRoo,
      each absIR=0.9,
      each absSol=0.9,
      til={Buildings.Types.Tilt.Wall, Buildings.Types.Tilt.Wall, Buildings.Types.Tilt.Wall, Buildings.Types.Tilt.Wall}),
    nPorts=11,
    intConMod=intConMod,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final sampleModel=sampleModel) "Core zone"
    annotation (Placement(transformation(extent={{144,36},{184,76}})));
  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b portsSou[2](
      redeclare package Medium = Medium) "Fluid inlets and outlets"
    annotation (Placement(transformation(extent={{70,-42},{110,-26}})));
  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b portsEas[2](
      redeclare package Medium = Medium) "Fluid inlets and outlets"
    annotation (Placement(transformation(extent={{314,28},{354,44}})));
  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b portsNor[2](
      redeclare package Medium = Medium) "Fluid inlets and outlets"
    annotation (Placement(transformation(extent={{70,118},{110,134}})));
  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b portsWes[2](
      redeclare package Medium = Medium) "Fluid inlets and outlets"
    annotation (Placement(transformation(extent={{-50,38},{-10,54}})));
  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b portsCor[2](
      redeclare package Medium = Medium) "Fluid inlets and outlets"
    annotation (Placement(transformation(extent={{70,38},{110,54}})));
  Modelica.Blocks.Math.MatrixGain gai(K=20*[0.4; 0.4; 0.2])
    "Matrix gain to split up heat gain in radiant, convective and latent gain"
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
  Modelica.Blocks.Sources.Constant uSha(k=0)
    "Control signal for the shading device"
    annotation (Placement(transformation(extent={{-80,170},{-60,190}})));
  Modelica.Blocks.Routing.Replicator replicator(nout=1)
    annotation (Placement(transformation(extent={{-40,170},{-20,190}})));
  BoundaryConditions.WeatherData.Bus weaBus "Weather bus"
    annotation (Placement(transformation(extent={{200,190},{220,210}})));
  RoomLeakage leaSou(redeclare package Medium = Medium, VRoo=568.77,
    s=49.91/33.27,
    azi=Buildings.Types.Azimuth.S,
    final use_windPressure=use_windPressure)
    "Model for air infiltration through the envelope"
    annotation (Placement(transformation(extent={{-58,380},{-22,420}})));
  RoomLeakage leaEas(redeclare package Medium = Medium, VRoo=360.0785,
    s=33.27/49.91,
    azi=Buildings.Types.Azimuth.E,
    final use_windPressure=use_windPressure)
    "Model for air infiltration through the envelope"
    annotation (Placement(transformation(extent={{-58,340},{-22,380}})));
  RoomLeakage leaNor(redeclare package Medium = Medium, VRoo=568.77,
    s=49.91/33.27,
    azi=Buildings.Types.Azimuth.N,
    final use_windPressure=use_windPressure)
    "Model for air infiltration through the envelope"
    annotation (Placement(transformation(extent={{-56,300},{-20,340}})));
  RoomLeakage leaWes(redeclare package Medium = Medium, VRoo=360.0785,
    s=33.27/49.91,
    azi=Buildings.Types.Azimuth.W,
    final use_windPressure=use_windPressure)
    "Model for air infiltration through the envelope"
    annotation (Placement(transformation(extent={{-56,260},{-20,300}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temAirSou
    "Air temperature sensor"
    annotation (Placement(transformation(extent={{290,340},{310,360}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temAirEas
    "Air temperature sensor"
    annotation (Placement(transformation(extent={{292,310},{312,330}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temAirNor
    "Air temperature sensor"
    annotation (Placement(transformation(extent={{292,280},{312,300}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temAirWes
    "Air temperature sensor"
    annotation (Placement(transformation(extent={{292,248},{312,268}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temAirPer5
    "Air temperature sensor"
    annotation (Placement(transformation(extent={{294,218},{314,238}})));
  Modelica.Blocks.Routing.Multiplex5 multiplex5_1
    annotation (Placement(transformation(extent={{340,280},{360,300}})));
  Modelica.Blocks.Interfaces.RealOutput TRooAir[5](
    each unit="K",
    each displayUnit="degC") "Room air temperatures"
    annotation (Placement(transformation(extent={{380,150},{400,170}}),
        iconTransformation(extent={{380,150},{400,170}})));
  Airflow.Multizone.DoorDiscretizedOpen opeSouCor(redeclare package Medium =
        Medium, wOpe=10,
    forceErrorControlOnFlow=false)
                         "Opening between perimeter1 and core"
    annotation (Placement(transformation(extent={{84,0},{104,20}})));
  Airflow.Multizone.DoorDiscretizedOpen opeEasCor(redeclare package Medium =
        Medium, wOpe=10,
    forceErrorControlOnFlow=false)
                         "Opening between perimeter2 and core"
    annotation (Placement(transformation(extent={{250,38},{270,58}})));
  Airflow.Multizone.DoorDiscretizedOpen opeNorCor(redeclare package Medium =
        Medium, wOpe=10,
    forceErrorControlOnFlow=false)
                         "Opening between perimeter3 and core"
    annotation (Placement(transformation(extent={{80,74},{100,94}})));
  Airflow.Multizone.DoorDiscretizedOpen opeWesCor(redeclare package Medium =
        Medium, wOpe=10,
    forceErrorControlOnFlow=false)
                         "Opening between perimeter3 and core"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Modelica.Blocks.Sources.CombiTimeTable intGaiFra(
    table=[0,0.05;
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
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));
  Buildings.Fluid.Sensors.RelativePressure senRelPre(redeclare package Medium = Medium)
    "Building pressure measurement"
    annotation (Placement(transformation(extent={{60,240},{40,260}})));
  Buildings.Fluid.Sources.Outside out(nPorts=1, redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-58,240},{-38,260}})));
  Modelica.Blocks.Interfaces.RealOutput p_rel
    "Relative pressure signal of building static pressure" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-170,220})));

  Modelica.Blocks.Math.Gain gaiIntNor[3](each k=kIntNor)
    "Gain for internal heat gain amplification for north zone"
    annotation (Placement(transformation(extent={{-60,134},{-40,154}})));
  Modelica.Blocks.Math.Gain gaiIntSou[3](each k=2 - kIntNor)
    "Gain to change the internal heat gain for south"
    annotation (Placement(transformation(extent={{-60,-38},{-40,-18}})));
equation
  connect(sou.surf_conBou[1], wes.surf_surBou[2]) annotation (Line(
      points={{170,-40.6667},{170,-54},{62,-54},{62,20},{28.2,20},{28.2,42.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sou.surf_conBou[2], cor.surf_surBou[1]) annotation (Line(
      points={{170,-40},{170,-54},{200,-54},{200,20},{160.2,20},{160.2,41.25}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sou.surf_conBou[3], eas.surf_surBou[1]) annotation (Line(
      points={{170,-39.3333},{170,-54},{320.2,-54},{320.2,61.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(eas.surf_conBou[1], cor.surf_surBou[2]) annotation (Line(
      points={{330,60},{330,20},{160.2,20},{160.2,41.75}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(eas.surf_surBou[2], nor.surf_conBou[1]) annotation (Line(
      points={{320.2,62.5},{320.2,24},{220,24},{220,100},{170,100},{170,119.333}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(nor.surf_conBou[2], cor.surf_surBou[3]) annotation (Line(
      points={{170,120},{170,100},{200,100},{200,26},{160.2,26},{160.2,42.25}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(nor.surf_conBou[3], wes.surf_surBou[1]) annotation (Line(
      points={{170,120.667},{170,100},{60,100},{60,20},{28.2,20},{28.2,41.5}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(wes.surf_conBou[1], cor.surf_surBou[4]) annotation (Line(
      points={{38,40},{38,30},{160.2,30},{160.2,42.75}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(uSha.y, replicator.u) annotation (Line(
      points={{-59,180},{-42,180}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(replicator.y, nor.uSha) annotation (Line(
      points={{-19,180},{130,180},{130,154},{142.4,154}},
      color={0,0,127},
      pattern=LinePattern.Dash,
      smooth=Smooth.None));
  connect(replicator.y, wes.uSha) annotation (Line(
      points={{-19,180},{-6,180},{-6,74},{10.4,74}},
      color={0,0,127},
      pattern=LinePattern.Dash,
      smooth=Smooth.None));
  connect(replicator.y, eas.uSha) annotation (Line(
      points={{-19,180},{232,180},{232,94},{302.4,94}},
      color={0,0,127},
      pattern=LinePattern.Dash,
      smooth=Smooth.None));
  connect(replicator.y, sou.uSha) annotation (Line(
      points={{-19,180},{130,180},{130,-6},{142.4,-6}},
      color={0,0,127},
      pattern=LinePattern.Dash,
      smooth=Smooth.None));
  connect(replicator.y, cor.uSha) annotation (Line(
      points={{-19,180},{130,180},{130,74},{142.4,74}},
      color={0,0,127},
      pattern=LinePattern.Dash,
      smooth=Smooth.None));
  connect(gai.y, cor.qGai_flow)          annotation (Line(
      points={{-79,110},{120,110},{120,64},{142.4,64}},
      color={0,0,127},
      pattern=LinePattern.Dash,
      smooth=Smooth.None));
  connect(gai.y, eas.qGai_flow)          annotation (Line(
      points={{-79,110},{226,110},{226,84},{302.4,84}},
      color={0,0,127},
      pattern=LinePattern.Dash,
      smooth=Smooth.None));
  connect(gai.y, wes.qGai_flow)          annotation (Line(
      points={{-79,110},{-14,110},{-14,64},{10.4,64}},
      color={0,0,127},
      pattern=LinePattern.Dash,
      smooth=Smooth.None));
  connect(sou.weaBus, weaBus) annotation (Line(
      points={{181.9,-6.1},{181.9,8},{210,8},{210,200}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(eas.weaBus, weaBus) annotation (Line(
      points={{341.9,93.9},{341.9,120},{210,120},{210,200}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(nor.weaBus, weaBus) annotation (Line(
      points={{181.9,153.9},{182,160},{182,168},{210,168},{210,200}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(wes.weaBus, weaBus) annotation (Line(
      points={{49.9,73.9},{49.9,168},{210,168},{210,200}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(cor.weaBus, weaBus) annotation (Line(
      points={{181.9,73.9},{181.9,90},{210,90},{210,200}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaBus, leaSou.weaBus) annotation (Line(
      points={{210,200},{-80,200},{-80,400},{-58,400}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaBus, leaEas.weaBus) annotation (Line(
      points={{210,200},{-80,200},{-80,360},{-58,360}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaBus, leaNor.weaBus) annotation (Line(
      points={{210,200},{-80,200},{-80,320},{-56,320}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaBus, leaWes.weaBus) annotation (Line(
      points={{210,200},{-80,200},{-80,280},{-56,280}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(multiplex5_1.y, TRooAir) annotation (Line(
      points={{361,290},{372,290},{372,160},{390,160}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(temAirSou.T, multiplex5_1.u1[1]) annotation (Line(
      points={{310,350},{328,350},{328,300},{338,300}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(temAirEas.T, multiplex5_1.u2[1]) annotation (Line(
      points={{312,320},{324,320},{324,295},{338,295}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(temAirNor.T, multiplex5_1.u3[1]) annotation (Line(
      points={{312,290},{338,290}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(temAirWes.T, multiplex5_1.u4[1]) annotation (Line(
      points={{312,258},{324,258},{324,285},{338,285}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(temAirPer5.T, multiplex5_1.u5[1]) annotation (Line(
      points={{314,228},{322,228},{322,228},{332,228},{332,280},{338,280}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(sou.heaPorAir, temAirSou.port) annotation (Line(
      points={{163,-24},{224,-24},{224,100},{264,100},{264,350},{290,350}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(eas.heaPorAir, temAirEas.port) annotation (Line(
      points={{323,76},{286,76},{286,320},{292,320}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(nor.heaPorAir, temAirNor.port) annotation (Line(
      points={{163,136},{164,136},{164,290},{292,290}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(wes.heaPorAir, temAirWes.port) annotation (Line(
      points={{31,56},{70,56},{70,114},{186,114},{186,258},{292,258}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(cor.heaPorAir, temAirPer5.port) annotation (Line(
      points={{163,56},{162,56},{162,228},{294,228}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sou.ports[1], portsSou[1]) annotation (Line(
      points={{149,-37.2},{114,-37.2},{114,-34},{80,-34}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou.ports[2], portsSou[2]) annotation (Line(
      points={{149,-35.6},{124,-35.6},{124,-34},{100,-34}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(eas.ports[1], portsEas[1]) annotation (Line(
      points={{309,62.8},{300,62.8},{300,36},{324,36}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(eas.ports[2], portsEas[2]) annotation (Line(
      points={{309,64.4},{300,64.4},{300,36},{344,36}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(nor.ports[1], portsNor[1]) annotation (Line(
      points={{149,122.8},{114,122.8},{114,126},{80,126}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(nor.ports[2], portsNor[2]) annotation (Line(
      points={{149,124.4},{124,124.4},{124,126},{100,126}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(wes.ports[1], portsWes[1]) annotation (Line(
      points={{17,42.8},{-12,42.8},{-12,46},{-40,46}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(wes.ports[2], portsWes[2]) annotation (Line(
      points={{17,44.4},{-2,44.4},{-2,46},{-20,46}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(cor.ports[1], portsCor[1]) annotation (Line(
      points={{149,42.3636},{114,42.3636},{114,46},{80,46}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(cor.ports[2], portsCor[2]) annotation (Line(
      points={{149,43.0909},{124,43.0909},{124,46},{100,46}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(leaSou.port_b, sou.ports[3]) annotation (Line(
      points={{-22,400},{-2,400},{-2,-72},{134,-72},{134,-34},{149,-34}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(leaEas.port_b, eas.ports[3]) annotation (Line(
      points={{-22,360},{246,360},{246,66},{309,66}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(leaNor.port_b, nor.ports[3]) annotation (Line(
      points={{-20,320},{138,320},{138,126},{149,126}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(leaWes.port_b, wes.ports[3]) annotation (Line(
      points={{-20,280},{2,280},{2,46},{17,46}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(opeSouCor.port_b1, cor.ports[3]) annotation (Line(
      points={{104,16},{116,16},{116,43.8182},{149,43.8182}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(opeSouCor.port_a2, cor.ports[4]) annotation (Line(
      points={{104,4},{116,4},{116,44.5455},{149,44.5455}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(opeSouCor.port_a1, sou.ports[4]) annotation (Line(
      points={{84,16},{74,16},{74,-20},{134,-20},{134,-32.4},{149,-32.4}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(opeSouCor.port_b2, sou.ports[5]) annotation (Line(
      points={{84,4},{74,4},{74,-20},{134,-20},{134,-30.8},{149,-30.8}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(opeEasCor.port_b1, eas.ports[4]) annotation (Line(
      points={{270,54},{290,54},{290,67.6},{309,67.6}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(opeEasCor.port_a2, eas.ports[5]) annotation (Line(
      points={{270,42},{290,42},{290,69.2},{309,69.2}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(opeEasCor.port_a1, cor.ports[5]) annotation (Line(
      points={{250,54},{190,54},{190,34},{142,34},{142,45.2727},{149,45.2727}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(opeEasCor.port_b2, cor.ports[6]) annotation (Line(
      points={{250,42},{190,42},{190,34},{142,34},{142,46},{149,46}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(opeNorCor.port_b1, nor.ports[4]) annotation (Line(
      points={{100,90},{124,90},{124,127.6},{149,127.6}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(opeNorCor.port_a2, nor.ports[5]) annotation (Line(
      points={{100,78},{124,78},{124,129.2},{149,129.2}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(opeNorCor.port_a1, cor.ports[7]) annotation (Line(
      points={{80,90},{76,90},{76,60},{142,60},{142,46.7273},{149,46.7273}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(opeNorCor.port_b2, cor.ports[8]) annotation (Line(
      points={{80,78},{76,78},{76,60},{142,60},{142,47.4545},{149,47.4545}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(opeWesCor.port_b1, cor.ports[9]) annotation (Line(
      points={{40,-4},{56,-4},{56,34},{116,34},{116,48.1818},{149,48.1818}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(opeWesCor.port_a2, cor.ports[10]) annotation (Line(
      points={{40,-16},{56,-16},{56,34},{116,34},{116,48.9091},{149,48.9091}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(opeWesCor.port_a1, wes.ports[4]) annotation (Line(
      points={{20,-4},{2,-4},{2,47.6},{17,47.6}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(opeWesCor.port_b2, wes.ports[5]) annotation (Line(
      points={{20,-16},{2,-16},{2,49.2},{17,49.2}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(intGaiFra.y, gai.u) annotation (Line(
      points={{-119,110},{-102,110}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(cor.ports[11], senRelPre.port_a) annotation (Line(
      points={{149,49.6364},{110,49.6364},{110,250},{60,250}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(out.weaBus, weaBus) annotation (Line(
      points={{-58,250.2},{-70,250.2},{-70,250},{-80,250},{-80,200},{210,200}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(out.ports[1], senRelPre.port_b) annotation (Line(
      points={{-38,250},{40,250}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(senRelPre.p_rel, p_rel) annotation (Line(
      points={{50,241},{50,220},{-170,220}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(gai.y, gaiIntNor.u) annotation (Line(
      points={{-79,110},{-68,110},{-68,144},{-62,144}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(gaiIntNor.y, nor.qGai_flow) annotation (Line(
      points={{-39,144},{142.4,144}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(gai.y, gaiIntSou.u) annotation (Line(
      points={{-79,110},{-68,110},{-68,-28},{-62,-28}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(gaiIntSou.y, sou.qGai_flow) annotation (Line(
      points={{-39,-28},{68,-28},{68,-16},{142.4,-16}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-160,-100},
            {400,500}},
        initialScale=0.1)),     Icon(coordinateSystem(
          preserveAspectRatio=true, extent={{-160,-100},{400,500}}), graphics={
        Rectangle(
          extent={{-80,-80},{380,180}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,160},{360,-60}},
          pattern=LinePattern.None,
          lineColor={117,148,176},
          fillColor={170,213,255},
          fillPattern=FillPattern.Sphere),
        Rectangle(
          extent={{0,-80},{294,-60}},
          lineColor={95,95,95},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,-74},{294,-66}},
          lineColor={95,95,95},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{8,8},{294,100}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{20,88},{280,22}},
          pattern=LinePattern.None,
          lineColor={117,148,176},
          fillColor={170,213,255},
          fillPattern=FillPattern.Sphere),
        Polygon(
          points={{-56,170},{20,94},{12,88},{-62,162},{-56,170}},
          smooth=Smooth.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{290,16},{366,-60},{358,-66},{284,8},{290,16}},
          smooth=Smooth.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{284,96},{360,168},{368,162},{292,90},{284,96}},
          smooth=Smooth.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-80,120},{-60,-20}},
          lineColor={95,95,95},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-74,120},{-66,-20}},
          lineColor={95,95,95},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-64,-56},{18,22},{26,16},{-58,-64},{-64,-56}},
          smooth=Smooth.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{360,122},{380,-18}},
          lineColor={95,95,95},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{366,122},{374,-18}},
          lineColor={95,95,95},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{2,170},{296,178}},
          lineColor={95,95,95},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{2,160},{296,180}},
          lineColor={95,95,95},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{2,166},{296,174}},
          lineColor={95,95,95},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-84,234},{-62,200}},
          lineColor={0,0,255},
          textString="dP")}),
    Documentation(revisions="<html>
<ul>
<li>
May 1, 2013, by Michael Wetter:<br/>
Declared the parameter record to be a parameter, as declaring its elements
to be parameters does not imply that the whole record has the variability of a parameter.
</li>
<li>
January 23, 2020, by Milica Grahovac:<br/>
Updated core zone geometry parameters related to 
room heat and mass balance.
</li>
</ul>
</html>", info="<html>
<p>
Model of a floor that consists
of five thermal zones that are representative of one floor of the
new construction medium office building for Chicago, IL,
as described in the set of DOE Commercial Building Benchmarks.
There are four perimeter zones and one core zone.
The envelope thermal properties meet ASHRAE Standard 90.1-2004.
</p>
</html>"));
end Floor;

within Buildings.Experimental.RadiantControl.Validation;
model ConPluLoc_Perim_Room
  "2nd part of the system model, consisting of the room with heat transfer and a radiator"
  extends Modelica.Icons.Example;
  replaceable package MediumA =
      Buildings.Media.Air;

//-------------------------Step 2: Water as medium-------------------------//
  replaceable package MediumW =
      Buildings.Media.Water "Medium model";
      //--------------------------------------Radiant Control Parameters-----------------------------------//
    final parameter Real TAirHiLim(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="Temperature")=297.6
    "Air temperature high limit above which heating is locked out";
   final parameter Real TAirLoLim(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="Temperature")=293.15
    "Air temperature low limit below which heating is locked out";
     final parameter Real TempWaLoSet(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="Temperature")=285.9
    "Lower limit for chilled water return temperature, below which cooling is locked out";
   final parameter Real TimeCHW(min=0,
    final unit="s",
    final displayUnit="s",
    final quantity="Time")=1800 "Time for which cooling is locked out if CHW return is too cold";
   final parameter Real TimHea(min=0,
    final unit="s",
    final displayUnit="s",
    final quantity="Time") = 3600 "Time for which heating is locked out after cooling concludes";
  final parameter Real TimCoo(min=0,
    final unit="s",
    final displayUnit="s",
    final quantity="Time") = 3600 "Time for which cooling is locked out after heating concludes";
   final parameter Real TemDeaRel(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=2.22 "Difference from slab temp setpoint required to trigger heating or cooling during occupied hours";
  final parameter Real TemDeaNor(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=0.28
                                           "Difference from slab temp setpoint required to trigger heating or cooling during unoccpied hours";
  final parameter Real LastOcc(min=0,max=24)=16 "Last occupied hour";
  final parameter Boolean OffTru=true "True: both heating and cooling signals turn off when slab setpoint is within deadband";
//------------------------Step 4: Design conditions------------------------//
  parameter Buildings.Fluid.Data.Pipes.PEX_RADTEST pipe;
  parameter HeatTransfer.Data.OpaqueConstructions.Generic layers(nLay=3, material={
        Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.1,
        k=2.31,
        c=832,
        d=2322,
        nSta=5),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.05,
        k=0.04,
        c=1400,
        d=10),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.1,
        k=2.31,
        c=832,
        d=2322)})
        "Material layers from surface a to b (8cm concrete, 5 cm insulation, 20 cm reinforced concrete)";
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal = 4000
    "Nominal heat flow rate of water in slab";
  parameter Modelica.SIunits.Temperature TRadSup_nominal = 273.15+40
    "Slab nominal heating supply water temperature, 105 F";
  parameter Modelica.SIunits.Temperature TRadRet_nominal = 273.15+35
    "Slab nominal heating return water temperature,heating 95 F";
  parameter Modelica.SIunits.MassFlowRate mRad_flow_nominal=
    Q_flow_nominal/4200/(TRadSup_nominal-TRadRet_nominal)
    "Radiator nominal mass flow rate";
  parameter Modelica.SIunits.Temperature TRadCold_nominal = 273.15+10;
  parameter Modelica.SIunits.Area A=45;
//------------------------------------------------------------------------//
  parameter Modelica.SIunits.Volume V=5*9*3 "Room volume";
  parameter Modelica.SIunits.MassFlowRate mA_flow_nominal = V*1.2*6/3600
    "Nominal mass flow rate";
  parameter Modelica.SIunits.HeatFlowRate QRooInt_flow = 100
    "Internal heat gains of the room";

  Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab           sla1(
    m_flow_nominal=mRad_flow_nominal,
    redeclare package Medium = MediumW,
    layers=layers,
    iLayPip=1,
    pipe=pipe,
    sysTyp=Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.SystemType.Floor,
    disPip=0.2,
    linearizeFlowResistance=false,
    A=A,
    from_dp=true) "Slabe with embedded pipes"
    annotation (Placement(transformation(extent={{-4,2},{16,22}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TBel(T=293.15)
    "Radiant temperature below the slab"
    annotation (Placement(transformation(extent={{62,-60},{82,-40}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor conBel1(G=20*A)
    "Combined convection and radiation resistance below the slab"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Fluid.Sources.Boundary_pT souCold(
    redeclare package Medium = MediumW,
    T=TRadCold_nominal,
    nPorts=1) "WaterTempandFlow_CoolingControl_CHWSource"
                                                        annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-16,-290})));
Fluid.Movers.FlowControlled_m_flow pumCold(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=TRadCold_nominal,
    allowFlowReversal=false,
    m_flow_nominal=mRad_flow_nominal,
    addPowerToMedium=false) "CoolingPump" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-12,-58})));
  Fluid.Actuators.Valves.TwoWayPressureIndependent valCold(
    redeclare package Medium = MediumW,
    m_flow_nominal=mRad_flow_nominal,
    dpValve_nominal=100,
    show_T=true) "CoolingValve"
    annotation (Placement(transformation(extent={{-22,-174},{-2,-154}})));
Fluid.Movers.FlowControlled_m_flow           pumHot(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=mRad_flow_nominal,
    addPowerToMedium=false) "HeatingPump"
      annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-174,-80})));
  Fluid.Actuators.Valves.TwoWayPressureIndependent valHot(
  redeclare package Medium = MediumW,
    allowFlowReversal=false,
    m_flow_nominal=mRad_flow_nominal,
    dpValve_nominal=100) "HeatingValve"
    annotation (Placement(transformation(extent={{-188,-178},{-168,-158}})));
  Fluid.Sources.Boundary_pT           sou(
    redeclare package Medium = MediumW,
    T=TRadSup_nominal,
    nPorts=1) "WaterTempandFlow_HeatingControl_HHWSource"
                                        annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-172,-292})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaHtgValveOn
    "WaterTempandFlow_HeatingControl_HeatingValveController"
    annotation (Placement(transformation(extent={{-260,-122},{-240,-102}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaHtgPump(realTrue=
        mRad_flow_nominal)
    "WaterTempandFlow_HeatingControl_HeatingPumpController"
    annotation (Placement(transformation(extent={{-260,-80},{-240,-60}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaClgPump(realTrue=
        mRad_flow_nominal)
    "WaterTempandFlow_CoolingControl_CoolingPumpController"
    annotation (Placement(transformation(extent={{-62,-100},{-42,-80}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaClgValve
    "WaterTempandFlow_CoolingControl_CoolingValveController"
    annotation (Placement(transformation(extent={{-62,-140},{-42,-120}})));
  Fluid.Sensors.TemperatureTwoPort           temSup(redeclare package Medium =
        MediumW, m_flow_nominal=mRad_flow_nominal) "Supply water temperature"
                                          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-32,-8})));
  Fluid.Sensors.TemperatureTwoPort temRet(redeclare package Medium = MediumW,
      m_flow_nominal=mRad_flow_nominal) "Return Water Temperature" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={52,-2})));
  Fluid.Sensors.TemperatureTwoPort temHeating(redeclare package Medium =
        MediumW, m_flow_nominal=mRad_flow_nominal,
    transferHeat=false) "HeatingTemperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-188,-8})));
  Fluid.Sensors.TemperatureTwoPort temCooling(redeclare package Medium =
        MediumW, m_flow_nominal=mRad_flow_nominal,
    T_start=TRadCold_nominal,
    transferHeat=true,
    TAmb=TRadCold_nominal)                         "CoolingTemperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-90,-40})));
  Fluid.Sensors.TemperatureTwoPort temHeatingSoutoValve(redeclare package
      Medium = MediumW, m_flow_nominal=mRad_flow_nominal) "HeatingTemperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-178,-198})));
  Fluid.Sensors.TemperatureTwoPort temHeatingValtoSlab(redeclare package Medium =
        MediumW, m_flow_nominal=mRad_flow_nominal) "HeatingTemperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-174,-124})));
  Fluid.Sensors.TemperatureTwoPort temCoolingSoutoVal(redeclare package Medium =
        MediumW, m_flow_nominal=mRad_flow_nominal) "CoolingTemperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-28,-194})));
  Fluid.Sensors.TemperatureTwoPort temCoolingValtoPump(redeclare package Medium =
        MediumW, m_flow_nominal=mRad_flow_nominal) "CoolingTemperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-10,-112})));
  Fluid.FixedResistances.Junction           mix2(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Entering,
    verifyFlowReversal=true,
    dp_nominal={0,-200,0},
    m_flow_nominal={mRad_flow_nominal,-mRad_flow_nominal,mRad_flow_nominal})
    "Mixer" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-90,10})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat1(filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data reader"
    annotation (Placement(transformation(extent={{172,294},{192,314}})));
  BoundaryConditions.WeatherData.Bus weaBus1
    annotation (Placement(transformation(extent={{270,298},{290,318}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSlabTop
    "SlabTopTemp" annotation (Placement(transformation(extent={{10,-10},{-10,10}},
          origin={-72,44})));
  Fluid.Sources.Boundary_pT
    airOut1(          redeclare package Medium = MediumA, nPorts=1)
                                                     "Air outlet for X3A"
    annotation (Placement(transformation(extent={{10,238},{30,258}})));

  Fluid.Sensors.TemperatureTwoPort temRoom(
    redeclare package Medium = MediumA,
    m_flow_nominal=mRad_flow_nominal,
    transferHeat=false) "HeatingTemperature" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={72,230})));
  Modelica.Blocks.Sources.CombiTimeTable airCon(
    table=[0,0.001,293.15; 28800,0.05,293.15; 64800,0.001,293.15; 86400,0.001,293.15],
    tableOnFile=false,
    tableName="airCon",
    fileName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/ThermalZones/Detailed/FLEXLAB/Rooms/Examples/X3AWithRadiantFloor.txt"),
    columns=2:3,
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    timeScale=1) "Inlet air conditions (y[1] = m_flow, y[4] = T)"
    annotation (Placement(transformation(extent={{-62,280},{-42,300}})));

  Fluid.Sources.MassFlowSource_T           airIn(
    use_m_flow_in=true,
    use_T_in=true,
    redeclare package Medium = MediumA,
    nPorts=1) "Inlet air conditions (from AHU) for X3A"
    annotation (Placement(transformation(extent={{12,276},{32,296}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TOut2
    "Outside temperature"
    annotation (Placement(transformation(extent={{212,190},{232,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant InteriorSetpoint1(k=294)
    annotation (Placement(transformation(extent={{198,232},{242,276}})));
  ThermalZones.Detailed.FLEXLAB.Rooms.X3A.TestCell_Radiant testCell_Radiant(
    nSurBou=1,
    lat=0.73268921998722,
    hRoo=3,
    nPorts=3,
    redeclare package Medium = MediumA)
    annotation (Placement(transformation(extent={{82,300},{122,340}})));
  Modelica.Blocks.Sources.CombiTimeTable intGai2(
    table=[0,1.05729426,1.25089426,0; 3600,1.05729426,1.25089426,0; 7200,1.05729426,
        1.25089426,0; 10800,1.05729426,1.25089426,0; 14400,1.05729426,1.25089426,
        0; 18000,1.05729426,1.25089426,0; 21600,1.121827593,1.509027593,0; 25200,
        1.548281766,1.882174238,0.330986667; 28800,1.977743414,2.979420831,0.661973333;
        32400,5.734675369,8.73970762,3.144373333; 36000,5.734675369,8.73970762,3.144373333;
        39600,5.734675369,8.73970762,3.144373333; 43200,5.734675369,8.73970762,3.144373333;
        46800,4.496245967,7.501278218,1.654933333; 50400,5.734675369,8.73970762,
        3.144373333; 54000,5.734675369,8.73970762,3.144373333; 57600,5.734675369,
        8.73970762,3.144373333; 61200,5.734675369,8.73970762,3.144373333; 64800,
        2.714734464,4.384196826,0.99296; 68400,1.770876747,2.772554164,0.330986667;
        72000,1.770876747,2.772554164,0.330986667; 75600,1.659579257,2.327364201,
        0.330986667; 79200,1.659579257,2.327364201,0.330986667; 82800,1.444848433,
        1.778740905,0.165493333; 86400,1.389199687,1.556145923,0.165493333],
    tableOnFile=false,
    columns=2:4,
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    timeScale=1,
    startTime=0)
    "Internal gain heat flow (Radiant = 1, Convective = 2, Latent = 3)"
    annotation (Placement(transformation(extent={{40,300},{60,320}})));
  Modelica.Blocks.Sources.CombiTimeTable shaPos2(table=[0,1; 86400,1],
      tableOnFile=false) "Position of the shade"
    annotation (Placement(transformation(extent={{38,340},{58,360}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor conBel2(G=0.2)
    "Combined convection and radiation resistance below the slab"
    annotation (Placement(transformation(extent={{118,252},{138,272}})));
  Modelica.Blocks.Sources.BooleanConstant NightFlushLockout(k=false)
    "WaterTempandFlow_HeatingControl_Lockout_NightFlush- PLACEHOLDER"
    annotation (Placement(transformation(extent={{-478,-140},{-458,-120}})));
  Fluid.Sources.Boundary_pT           sin(nPorts=1, redeclare package Medium =
        MediumW)
    "Sink for mass flow rate"           annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={156,4})));
  Experimental.RadiantControl.ControlPlusLockouts controlPlusLockouts(
    TAirHiSet=TAirHiLim,
    TAirLoSet=TAirLoLim,
    TWaLoSet=TempWaLoSet,
    TiCHW=TimeCHW,
    TiHea=TimHea,
    TiCoo=TimCoo,
    TDeaRel=TemDeaRel,
    TDeaNor=TemDeaNor,
    k=LastOcc,
    off_within_deadband=OffTru)
    annotation (Placement(transformation(extent={{-400,-100},{-380,-80}})));
  SlabTempSignal.SlabSetPerim slabSetPerim
    annotation (Placement(transformation(extent={{-520,-60},{-500,-40}})));
  SlabTempSignal.Validation.BaseClasses.ForecastHighChicago forecastHighChicago
    annotation (Placement(transformation(extent={{-586,-64},{-566,-44}})));
equation
  connect(TBel.port, conBel1.port_a) annotation (Line(points={{82,-50},{20,-50}},
                                color={191,0,0}));
  connect(conBel1.port_b, sla1.surf_b)
    annotation (Line(points={{40,-50},{10,-50},{10,2}}, color={191,0,0}));

  connect(booToReaHtgPump.y,pumHot. m_flow_in) annotation (Line(points={{-238,
          -70},{-238,-80},{-186,-80}},       color={0,0,127}));
  connect(booToReaClgPump.y, pumCold.m_flow_in) annotation (Line(points={{-40,-90},
          {-38,-90},{-38,-58},{-24,-58}}, color={0,0,127}));
  connect(booToReaClgValve.y, valCold.y) annotation (Line(points={{-40,-130},{
          -30,-130},{-30,-152},{-12,-152}},
                                      color={0,0,127}));
  connect(temSup.port_b, sla1.port_a) annotation (Line(points={{-32,2},{-18,2},{
          -18,12},{-4,12}}, color={0,127,255}));
  connect(sla1.port_b, temRet.port_a) annotation (Line(points={{16,12},{28,12},
          {28,-12},{52,-12}},color={0,127,255}));
  connect(pumHot.port_b, temHeating.port_a) annotation (Line(points={{-174,-70},
          {-174,-52},{-188,-52},{-188,-18}},
                                  color={0,127,255}));
  connect(pumCold.port_b, temCooling.port_a) annotation (Line(points={{-12,-48},
          {-90,-48},{-90,-50}}, color={0,127,255}));
  connect(sou.ports[1], temHeatingSoutoValve.port_a) annotation (Line(points={{-172,
          -282},{-176,-282},{-176,-208},{-178,-208}}, color={0,127,255}));
  connect(temHeatingSoutoValve.port_b, valHot.port_a) annotation (Line(points={{
          -178,-188},{-194,-188},{-194,-168},{-188,-168}}, color={0,127,255}));
  connect(valHot.port_b, temHeatingValtoSlab.port_a) annotation (Line(points={{-168,
          -168},{-172,-168},{-172,-134},{-174,-134}}, color={0,127,255}));
  connect(temHeatingValtoSlab.port_b,pumHot. port_a)
    annotation (Line(points={{-174,-114},{-174,-90}}, color={0,127,255}));
  connect(souCold.ports[1], temCoolingSoutoVal.port_a) annotation (Line(points={{-16,
          -280},{-24,-280},{-24,-204},{-28,-204}},      color={0,127,255}));
  connect(temCoolingSoutoVal.port_b, valCold.port_a) annotation (Line(points={{-28,
          -184},{-28,-164},{-22,-164}}, color={0,127,255}));
  connect(valCold.port_b, temCoolingValtoPump.port_a) annotation (Line(points={{
          -2,-164},{-6,-164},{-6,-122},{-10,-122}}, color={0,127,255}));
  connect(temCoolingValtoPump.port_b, pumCold.port_a) annotation (Line(points={{-10,
          -102},{-12,-102},{-12,-68}},               color={0,127,255}));
  connect(weaDat1.weaBus, weaBus1.TDryBul) annotation (Line(
      points={{192,304},{238,304},{238,308},{280,308}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(airCon.y[1], airIn.m_flow_in) annotation (Line(points={{-41,290},{-14,
          290},{-14,294},{10,294}}, color={0,0,127}));
  connect(airCon.y[2], airIn.T_in) annotation (Line(points={{-41,290},{10,290}},
                               color={0,0,127}));
  connect(InteriorSetpoint1.y, TOut2.T) annotation (Line(points={{246.4,254},{
          256,254},{256,200},{210,200}},
                                     color={0,0,127}));
  connect(airIn.ports[1], testCell_Radiant.ports[1]) annotation (Line(points={{32,286},
          {62,286},{62,307.333},{87,307.333}},
                                            color={0,127,255}));
  connect(testCell_Radiant.ports[2], temRoom.port_a) annotation (Line(points={{87,310},
          {87,300},{98,300},{98,220},{72,220}},
                                              color={0,127,255}));
  connect(temRoom.port_b, airOut1.ports[1]) annotation (Line(points={{72,240},{
          60,240},{60,248},{30,248}}, color={0,127,255}));
  connect(intGai2.y, testCell_Radiant.qGai_flow) annotation (Line(points={{61,310},
          {58,310},{58,328},{80.4,328}}, color={0,0,127}));
  connect(shaPos2.y[1], testCell_Radiant.uSha[1]) annotation (Line(points={{59,350},
          {62,350},{62,338},{80.4,338}}, color={0,0,127}));
  connect(weaDat1.weaBus, testCell_Radiant.weaBus) annotation (Line(
      points={{192,304},{154,304},{154,337.9},{119.9,337.9}},
      color={255,204,51},
      thickness=0.5));
  connect(sla1.surf_a, testCell_Radiant.surf_surBou[1]) annotation (Line(points=
         {{10,22},{54,22},{54,306},{98.2,306}}, color={191,0,0}));
  connect(sla1.surf_a, temSlabTop.port) annotation (Line(points={{10,22},{-22,22},
          {-22,44},{-62,44}}, color={191,0,0}));
  connect(temCooling.port_b, mix2.port_3) annotation (Line(points={{-90,-30},{-108,
          -30},{-108,10},{-100,10}}, color={0,127,255}));
  connect(temHeating.port_b, mix2.port_1) annotation (Line(points={{-188,2},{
          -188,20},{-90,20}},     color={0,127,255}));
  connect(TOut2.port, conBel2.port_a)
    annotation (Line(points={{232,200},{118,200},{118,262}}, color={191,0,0}));
  connect(conBel2.port_b, testCell_Radiant.surf_conBou[1]) annotation (Line(
        points={{138,262},{138,304},{108,304}},           color={191,0,0}));
  connect(booToReaHtgValveOn.y, valHot.y) annotation (Line(points={{-238,-112},
          {-208,-112},{-208,-156},{-178,-156}}, color={0,0,127}));
  connect(mix2.port_2, temSup.port_a) annotation (Line(points={{-90,
          -3.55271e-15},{-62,-3.55271e-15},{-62,-18},{-32,-18}}, color={0,127,
          255}));
  connect(temRet.port_b, sin.ports[1]) annotation (Line(points={{52,8},{104,8},{
          104,14},{156,14}}, color={0,127,255}));
  connect(controlPlusLockouts.htgSig, booToReaHtgPump.u) annotation (Line(
        points={{-380,-85.6},{-316,-85.6},{-316,-70},{-262,-70}}, color={255,0,
          255}));
  connect(controlPlusLockouts.htgSig, booToReaHtgValveOn.u) annotation (Line(
        points={{-380,-85.6},{-316,-85.6},{-316,-112},{-262,-112}}, color={255,
          0,255}));
  connect(controlPlusLockouts.clgSig, booToReaClgPump.u) annotation (Line(
        points={{-380,-93},{-366,-93},{-366,-320},{-100,-320},{-100,-90},{-64,-90}},
        color={255,0,255}));
  connect(controlPlusLockouts.clgSig, booToReaClgValve.u) annotation (Line(
        points={{-380,-93},{-366,-93},{-366,-320},{-100,-320},{-100,-130},{-64,
          -130}}, color={255,0,255}));
  connect(NightFlushLockout.y, controlPlusLockouts.nitFluSig) annotation (Line(
        points={{-457,-130},{-430,-130},{-430,-90},{-401.818,-90}}, color={255,
          0,255}));
  connect(temRet.T, controlPlusLockouts.TWaRet) annotation (Line(points={{41,-2},
          {41,230},{-462,230},{-462,-98},{-401.818,-98}},
                                                      color={0,0,127}));
  connect(temRoom.T, controlPlusLockouts.TRooAir) annotation (Line(points={{61,230},
          {-464,230},{-464,-94},{-401.818,-94}}, color={0,0,127}));
  connect(temSlabTop.T, controlPlusLockouts.TSla) annotation (Line(points={{-82,44},
          {-464,44},{-464,-82},{-401.818,-82}}, color={0,0,127}));
  connect(forecastHighChicago.TForecastHigh, slabSetPerim.TFor) annotation (
      Line(points={{-564,-53.8},{-556,-53.8},{-556,-56},{-540,-56},{-540,-50},{
          -520,-50}},                                                  color={0,
          0,127}));
  connect(slabSetPerim.TSlaSetPer, controlPlusLockouts.TSlaSet) annotation (
      Line(points={{-498.182,-50},{-468,-50},{-468,-86},{-401.818,-86}},
                                                                     color={0,0,
          127}));
  annotation (Documentation(info="<html>
<p>
This models a radiant slab serving a perimeter zone as per current control scheme. 
</p>
</html>"),
    experiment(Tolerance=1e-6, StopTime=31536000),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
         graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-36,58},{64,-2},{-36,-62},{-36,58}})}),
    Diagram(coordinateSystem(extent={{-600,-380},{300,380}})));
end ConPluLoc_Perim_Room;

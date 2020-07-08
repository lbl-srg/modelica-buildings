within Buildings.Examples.Tutorial.Boiler;
model System2_RadTest_0605_Interior_v18FINAL
  "2nd part of the system model, consisting of the room with heat transfer and a radiator"
  extends Modelica.Icons.Example;
  replaceable package MediumA =
      Buildings.Media.Air;

//-------------------------Step 2: Water as medium-------------------------//
  replaceable package MediumW =
      Buildings.Media.Water "Medium model";
//-------------------------------------------------------------------------//

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
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable timTab(
      extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.Periodic,
      smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    table=[-6,0; 8,QRooInt_flow; 18,0],
      timeScale=3600) "Time table for internal heat gain"
    annotation (Placement(transformation(extent={{-80,292},{-60,312}})));

  Buildings.Controls.SetPoints.Table tabSlab(table=[274.8166667,302.5944444; 274.8167222,
        300.9277778; 280.3722222,300.9277778; 280.3727778,300.9277778; 285.9277778,
        300.9277778; 285.9283333,298.7055556; 291.4833333,298.7055556; 291.4838889,
        296.4833333; 292.5944444,296.4833333; 292.5945,296.4833333; 293.15,296.4833333;
        293.1500556,295.9277778; 295.3722222,295.9277778; 295.3722778,295.3722222;
        295.9277778,295.3722222; 295.9278333,292.5944444; 299.8166667,292.5944444;
        299.8172222,291.4833333; 302.5944444,291.4833333])
    "SlabSetpointLookupTable"
    annotation (Placement(transformation(extent={{-596,256},{-638,298}})));
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
    annotation (Placement(transformation(extent={{76,-148},{96,-128}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor conBel1(G=20*A)
    "Combined convection and radiation resistance below the slab"
    annotation (Placement(transformation(extent={{14,-112},{34,-92}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSlabSurface
    "Room temperature" annotation (Placement(transformation(extent={{10,-10},{-10,
            10}}, origin={-164,180})));
  Fluid.Sources.Boundary_pT souCold(
    redeclare package Medium = MediumW,
    T=TRadCold_nominal,
    nPorts=1) "WaterTempandFlow_CoolingControl_CHWSource"
                                                        annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-18,-296})));
Fluid.Movers.FlowControlled_m_flow pumCold(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=TRadCold_nominal,
    allowFlowReversal=false,
    m_flow_nominal=mRad_flow_nominal,
    addPowerToMedium=false) "CoolingPump" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-14,-70})));
  Fluid.Actuators.Valves.TwoWayPressureIndependent valCold(
    redeclare package Medium = MediumW,
    m_flow_nominal=mRad_flow_nominal,
    dpValve_nominal=100,
    show_T=true) "CoolingValve"
    annotation (Placement(transformation(extent={{-22,-174},{-2,-154}})));
  Fluid.Storage.ExpansionVessel exp(redeclare package Medium = MediumW,
      V_start=1) "Mass Sink"
    annotation (Placement(transformation(extent={{76,-14},{96,6}})));
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
        origin={-174,-314})));
  Modelica.Blocks.Discrete.ZeroOrderHold zeroOrderHold(samplePeriod=86400,
      startTime=0) "SlabSetpointHold"
    annotation (Placement(transformation(extent={{-650,208},{-630,228}})));
  Modelica.Blocks.Math.Add add "Error_DiffBtwnSlabSetpointandSlabTemp"
    annotation (Placement(transformation(extent={{-620,114},{-600,134}})));
  Buildings.Controls.OBC.CDL.Continuous.ChangeSign chaSig
    "SlabSetpoint_ChangeSign"
    annotation (Placement(transformation(extent={{-814,140},{-794,160}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conPOS(k=1.11)
    "Alarm_Error_ThresholdtoTriggerAlarm"
    annotation (Placement(transformation(extent={{-774,-134},{-754,-114}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaHtgValveOn
    "WaterTempandFlow_HeatingControl_HeatingValveController"
    annotation (Placement(transformation(extent={{-256,-122},{-236,-102}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaHtgPump(realTrue=
        mRad_flow_nominal)
    "WaterTempandFlow_HeatingControl_HeatingPumpController"
    annotation (Placement(transformation(extent={{-258,-86},{-238,-66}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaClgPump(realTrue=
        mRad_flow_nominal)
    "WaterTempandFlow_CoolingControl_CoolingPumpController"
    annotation (Placement(transformation(extent={{-66,-92},{-46,-72}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaClgValve
    "WaterTempandFlow_CoolingControl_CoolingValveController"
    annotation (Placement(transformation(extent={{-62,-128},{-42,-108}})));
  Fluid.Sensors.TemperatureTwoPort           temSup(redeclare package Medium =
        MediumW, m_flow_nominal=mRad_flow_nominal) "Supply water temperature"
                                          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-32,-8})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "WaterTempandFlow_HeatingControl_NegateHysteresis"
    annotation (Placement(transformation(extent={{-390,-12},{-370,8}})));
  Fluid.Sensors.TemperatureTwoPort temRet(redeclare package Medium = MediumW,
      m_flow_nominal=mRad_flow_nominal) "Return Water Temperature" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,-10})));
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
  Fluid.Sensors.TemperatureTwoPort temHeatingValtoSlab(redeclare package Medium
      = MediumW, m_flow_nominal=mRad_flow_nominal) "HeatingTemperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-174,-124})));
  Fluid.Sensors.TemperatureTwoPort temCoolingSoutoVal(redeclare package Medium
      = MediumW, m_flow_nominal=mRad_flow_nominal) "CoolingTemperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-28,-194})));
  Fluid.Sensors.TemperatureTwoPort temCoolingValtoPump(redeclare package Medium
      = MediumW, m_flow_nominal=mRad_flow_nominal) "CoolingTemperature"
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
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(uLow=-0.28, uHigh=0.28)
    "SlabSetpointTightDeadband"
    annotation (Placement(transformation(extent={{-470,66},{-450,86}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater gre1
    "WaterTempandFlow_HeatingControl_Lockout_RoomAirTemp- if room air temp above 76 F, lock out heating"
    annotation (Placement(transformation(extent={{204,-166},{224,-146}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant HighT(k=297.6)
    "WaterTempandFlow_HeatingControl_Lockout_RoomAirTemp_ThreshholdHigh"
    annotation (Placement(transformation(extent={{146,-200},{166,-180}})));
  Buildings.Controls.OBC.CDL.Continuous.Less les1
    "WaterTempandFlow_CoolingControl_Lockout_RoomAirTemp- if room air temp < 68 F, lock out cooling"
    annotation (Placement(transformation(extent={{218,-278},{238,-258}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant LowAirT(k=293.15)
    "WaterTempandFlow_CoolingControl_Lockout_RoomAirTemp_ThresholdLow"
    annotation (Placement(transformation(extent={{144,-306},{164,-286}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    "WaterTempandFlow_HeatingControl_Lockout_RoomAirTemp_Not"
    annotation (Placement(transformation(extent={{246,-162},{266,-142}})));
  Buildings.Controls.OBC.CDL.Logical.Not not3
    "WaterTempandFlow_CoolingControl_Lockout_RoomAirTemp_Not"
    annotation (Placement(transformation(extent={{264,-280},{284,-260}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant LockoutTime(k=3600)
    "WaterTempandFlow_PreventHysteresis- one hour"
    annotation (Placement(transformation(extent={{-172,-380},{-152,-360}})));
  Buildings.Controls.OBC.CDL.Logical.And3 and3
    "WaterTempandFlow_HeatingControl_FinalControlSignal"
    annotation (Placement(transformation(extent={{-316,-100},{-296,-80}})));
  Buildings.Controls.OBC.CDL.Logical.And3 and1
    "WaterTempandFlow_CoolingControl_Signal"
    annotation (Placement(transformation(extent={{-120,-110},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater gre2Cold
    "WaterTempandFlow_HeatingControl_PreventHysteresis_checks if cooling valve has been closed for at least an hour"
    annotation (Placement(transformation(extent={{-84,-306},{-64,-286}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater gre3Hot
    "WaterTempandFlow_CoolingControl_PreventHysteresis_checks if heating valve has been closed for at least an hour"
    annotation (Placement(transformation(extent={{-264,-238},{-244,-218}})));
  Buildings.Controls.Continuous.OffTimer offTimCold
    "WaterTempandFlow_HeatingControl_PreventHysteresis-records time since heating valve closed"
    annotation (Placement(transformation(extent={{-118,-248},{-98,-228}})));
  Buildings.Controls.Continuous.OffTimer offTimHot
    "WaterTempandFlow_CoolingControl_PreventHysteresis_records time since heating valve closed"
    annotation (Placement(transformation(extent={{-302,-234},{-282,-214}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwiHot
    "WaterTempandFlow_CoolingControl_PreventHysteresis- once simulation has been running for one hour, enables hysteresis prevention"
    annotation (Placement(transformation(extent={{-442,-178},{-422,-158}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant
    annotation (Placement(transformation(extent={{-480,-244},{-460,-224}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater gre4
    "WaterTempandFlow_PreventHysteresis- check if simulation has been running for at least one hour: if not, no hysteresis lockouts"
    annotation (Placement(transformation(extent={{-518,-262},{-498,-242}})));
  Utilities.Time.ModelTime modTim
    annotation (Placement(transformation(extent={{-692,-280},{-672,-260}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwiCold
    "WaterTempandFlow_HeatingControl_PreventHysteresis- once simulation has been running for one hour, enables hysteresis prevention"
    annotation (Placement(transformation(extent={{-322,-284},{-302,-264}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant1
    annotation (Placement(transformation(extent={{-376,-318},{-356,-298}})));
  Modelica.Blocks.Math.RealToBoolean realToBooleanCold(threshold=0.02)
    "andFlow_HeatingControl_ValveSignalOutput- true if cooling valve is open"
    annotation (Placement(transformation(extent={{2,-250},{22,-230}})));
  Modelica.Blocks.Math.RealToBoolean realToBooleanHot(threshold=0.02)
    "WaterTempandFlow_CoolingControl_PreventHysteresis_ValveSignalOutput- true if heating valve is open"
    annotation (Placement(transformation(extent={{-226,-210},{-206,-190}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre
    "WaterTempandFlow_CoolingControl_PreventHysteresis_breaks loop"
    annotation (Placement(transformation(extent={{-278,-198},{-258,-178}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre1
    "WaterTempandFlow_HeatingControl_PreventHysteresis_breaks loop"
    annotation (Placement(transformation(extent={{-106,-194},{-86,-174}})));
  Buildings.Controls.OBC.CDL.Logical.Not not4
    "WaterTempandFlow_ZonalValveControl_HeatingOff"
    annotation (Placement(transformation(extent={{-278,-46},{-258,-26}})));
  Buildings.Controls.OBC.CDL.Logical.Not not5
    "WaterTempandFlow_ZonalValveControl_CoolingOff"
    annotation (Placement(transformation(extent={{-136,-66},{-116,-46}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "WaterTempandFlow_ZonalValveControl_ValveSignal if heating and cooling are both off, valve closes"
    annotation (Placement(transformation(extent={{-240,18},{-220,38}})));
  Fluid.Actuators.Valves.TwoWayPressureIndependent valSlab(
    redeclare package Medium = MediumW,
    m_flow_nominal=mRad_flow_nominal,
    dpValve_nominal=100,
    show_T=true)
    annotation (Placement(transformation(extent={{-72,-26},{-52,-6}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaSlabValve(realTrue=
        0, realFalse=1) "WaterTempandFlow_ZonalValveControl_SingalOutput"
    annotation (Placement(transformation(extent={{-180,30},{-160,50}})));
  Buildings.Controls.SetPoints.Table ForecastHigh(table=[86400,273.75; 172800,272.55;
        259200,269.85; 345600,262.05; 432000,260.35; 518400,264.85; 604800,274.85;
        691200,275.35; 777600,277.55; 864000,277.05; 950400,268.15; 1036800,270.35;
        1123200,275.95; 1209600,283.15; 1296000,284.85; 1382400,280.35; 1468800,
        275.35; 1555200,274.85; 1641600,285.35; 1728000,276.45; 1814400,277.05;
        1900800,275.95; 1987200,275.95; 2073600,266.45; 2160000,258.15; 2246400,
        265.35; 2332800,266.45; 2419200,267.55; 2505600,272.05; 2592000,268.15;
        2678400,272.55; 2764800,272.55; 2851200,272.55; 2937600,261.45; 3024000,
        263.75; 3110400,264.25; 3196800,269.25; 3283200,278.15; 3369600,281.45;
        3456000,287.05; 3542400,279.85; 3628800,275.35; 3715200,272.05; 3801600,
        268.75; 3888000,269.85; 3974400,276.45; 4060800,279.85; 4147200,273.15;
        4233600,272.55; 4320000,275.35; 4406400,284.85; 4492800,287.55; 4579200,
        283.75; 4665600,277.55; 4752000,274.85; 4838400,273.15; 4924800,275.95;
        5011200,279.25; 5097600,278.15; 5184000,274.85; 5270400,283.15; 5356800,
        270.95; 5443200,274.85; 5529600,279.85; 5616000,284.25; 5702400,284.85;
        5788800,289.85; 5875200,283.75; 5961600,282.55; 6048000,276.45; 6134400,
        282.05; 6220800,282.05; 6307200,283.15; 6393600,275.35; 6480000,280.35;
        6566400,290.35; 6652800,278.75; 6739200,281.45; 6825600,280.95; 6912000,
        279.85; 6998400,278.15; 7084800,279.85; 7171200,290.95; 7257600,294.25;
        7344000,288.15; 7430400,286.45; 7516800,276.45; 7603200,280.95; 7689600,
        277.55; 7776000,279.85; 7862400,277.55; 7948800,275.35; 8035200,278.15;
        8121600,279.25; 8208000,282.55; 8294400,284.25; 8380800,283.15; 8467200,
        290.95; 8553600,297.05; 8640000,292.05; 8726400,289.85; 8812800,297.55;
        8899200,304.25; 8985600,303.75; 9072000,302.05; 9158400,304.25; 9244800,
        292.55; 9331200,281.45; 9417600,278.75; 9504000,279.25; 9590400,288.75;
        9676800,295.95; 9763200,285.35; 9849600,283.75; 9936000,284.85; 10022400,
        288.15; 10108800,289.25; 10195200,288.15; 10281600,289.85; 10368000,297.05;
        10454400,297.55; 10540800,303.15; 10627200,303.75; 10713600,295.95; 10800000,
        286.45; 10886400,285.35; 10972800,290.95; 11059200,295.35; 11145600,291.45;
        11232000,290.35; 11318400,293.15; 11404800,288.15; 11491200,289.25; 11577600,
        289.85; 11664000,286.45; 11750400,289.25; 11836800,292.05; 11923200,296.45;
        12009600,300.35; 12096000,300.95; 12182400,297.05; 12268800,298.15; 12355200,
        300.35; 12441600,295.95; 12528000,302.55; 12614400,302.55; 12700800,300.35;
        12787200,302.55; 12873600,298.15; 12960000,298.15; 13046400,298.15; 13132800,
        302.05; 13219200,303.75; 13305600,294.25; 13392000,305.35; 13478400,299.85;
        13564800,306.45; 13651200,299.85; 13737600,296.45; 13824000,298.75; 13910400,
        295.35; 13996800,295.95; 14083200,303.15; 14169600,304.85; 14256000,304.25;
        14342400,298.15; 14428800,292.05; 14515200,302.05; 14601600,305.35; 14688000,
        303.75; 14774400,297.55; 14860800,288.15; 14947200,293.75; 15033600,299.85;
        15120000,303.75; 15206400,303.75; 15292800,303.15; 15379200,299.85; 15465600,
        300.35; 15552000,292.05; 15638400,297.05; 15724800,297.55; 15811200,303.75;
        15897600,305.95; 15984000,305.95; 16070400,302.05; 16156800,301.45; 16243200,
        296.45; 16329600,297.55; 16416000,298.75; 16502400,300.95; 16588800,302.05;
        16675200,298.15; 16761600,305.35; 16848000,306.45; 16934400,307.05; 17020800,
        307.05; 17107200,308.15; 17193600,302.55; 17280000,300.95; 17366400,302.55;
        17452800,304.25; 17539200,305.35; 17625600,303.15; 17712000,300.95; 17798400,
        304.85; 17884800,303.15; 17971200,300.95; 18057600,302.55; 18144000,304.85;
        18230400,300.95; 18316800,302.55; 18403200,304.85; 18489600,304.25; 18576000,
        303.15; 18662400,294.85; 18748800,294.85; 18835200,298.15; 18921600,300.35;
        19008000,301.45; 19094400,299.85; 19180800,301.45; 19267200,301.45; 19353600,
        298.75; 19440000,297.55; 19526400,296.45; 19612800,298.75; 19699200,298.15;
        19785600,299.25; 19872000,302.05; 19958400,303.75; 20044800,302.05; 20131200,
        295.95; 20217600,295.95; 20304000,298.15; 20390400,299.85; 20476800,301.45;
        20563200,301.45; 20649600,302.55; 20736000,300.95; 20822400,301.45; 20908800,
        298.75; 20995200,293.75; 21081600,295.35; 21168000,302.05; 21254400,304.25;
        21340800,303.15; 21427200,297.05; 21513600,299.85; 21600000,299.25; 21686400,
        299.85; 21772800,300.35; 21859200,299.25; 21945600,293.75; 22032000,297.05;
        22118400,299.25; 22204800,295.35; 22291200,294.85; 22377600,293.15; 22464000,
        294.85; 22550400,289.85; 22636800,289.25; 22723200,294.25; 22809600,297.55;
        22896000,293.75; 22982400,293.75; 23068800,302.05; 23155200,304.85; 23241600,
        300.35; 23328000,292.05; 23414400,292.05; 23500800,292.55; 23587200,295.95;
        23673600,292.55; 23760000,289.85; 23846400,288.75; 23932800,286.45; 24019200,
        285.35; 24105600,287.55; 24192000,295.95; 24278400,289.85; 24364800,289.85;
        24451200,289.85; 24537600,289.85; 24624000,283.15; 24710400,283.75; 24796800,
        285.35; 24883200,287.05; 24969600,288.15; 25056000,288.75; 25142400,295.95;
        25228800,299.25; 25315200,295.95; 25401600,284.25; 25488000,286.45; 25574400,
        289.25; 25660800,285.35; 25747200,290.35; 25833600,286.45; 25920000,287.55;
        26006400,293.75; 26092800,286.45; 26179200,288.75; 26265600,294.85; 26352000,
        294.25; 26438400,288.15; 26524800,286.45; 26611200,288.15; 26697600,287.55;
        26784000,290.35; 26870400,291.45; 26956800,276.45; 27043200,277.05; 27129600,
        275.95; 27216000,277.55; 27302400,284.85; 27388800,288.75; 27475200,284.85;
        27561600,280.35; 27648000,279.25; 27734400,280.95; 27820800,288.15; 27907200,
        275.35; 27993600,277.05; 28080000,276.45; 28166400,277.05; 28252800,273.15;
        28339200,265.95; 28425600,270.95; 28512000,268.15; 28598400,273.75; 28684800,
        276.25; 28771200,281.45; 28857600,274.85; 28944000,277.55; 29030400,277.05;
        29116800,276.45; 29203200,280.35; 29289600,284.25; 29376000,276.45; 29462400,
        271.45; 29548800,272.55; 29635200,273.15; 29721600,275.35; 29808000,275.35;
        29894400,273.75; 29980800,267.55; 30067200,267.55; 30153600,268.15; 30240000,
        267.55; 30326400,265.35; 30412800,267.55; 30499200,273.75; 30585600,273.75;
        30672000,272.55; 30758400,271.45; 30844800,274.25; 30931200,274.25; 31017600,
        272.55; 31104000,270.95; 31190400,265.35; 31276800,271.45; 31363200,275.95;
        31449600,275.95]) "ForecastHighLookupTable"
    annotation (Placement(transformation(extent={{-310,234},{-352,276}})));
  Utilities.Time.ModelTime modTim1 "ForecastHighModelTimer"
    annotation (Placement(transformation(extent={{-242,282},{-222,302}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat1(filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data reader"
    annotation (Placement(transformation(extent={{172,294},{192,314}})));
  BoundaryConditions.WeatherData.Bus weaBus1
    annotation (Placement(transformation(extent={{270,298},{290,318}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSlabTop
    "SlabTopTemp" annotation (Placement(transformation(extent={{10,-10},{-10,10}},
          origin={-64,38})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(period=86400,
      startTime=0) "ForecastHighPulse_MidnightforMax"
    annotation (Placement(transformation(extent={{-486,234},{-466,254}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam
    "ForecastHighSampler"
    annotation (Placement(transformation(extent={{-490,292},{-470,312}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysRelax(uLow=-2.22, uHigh=2.22)
    "SlabSetpointRelaxedDeadband"
    annotation (Placement(transformation(extent={{-472,28},{-452,48}})));
  Modelica.Blocks.Logical.LogicalSwitch logicalSwitch
    "SlabSetpoint- switches between occupied and unoccupied based on time of day"
    annotation (Placement(transformation(extent={{-422,64},{-402,84}})));
  Modelica.Blocks.Sources.BooleanPulse booleanPulse(width=75, period=86400)
    "SlabSetpoint 1 if slab needs to meet occupied setpoint within tight deadband, 0 if looser deadband (after occupied hours)"
    annotation (Placement(transformation(extent={{-674,42},{-654,62}})));
  Buildings.Controls.OBC.CDL.Continuous.Less les2
    "WaterTempandFlow_CoolingControl_Lockout_CHWReturn- lock out cooling for 30 minutes if CHW return < 55 F"
    annotation (Placement(transformation(extent={{222,-56},{242,-36}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant LockoutCHW(k=285.9)
    "WaterTempandFlow_CoolingControl_Lockout_CHWReturn"
    annotation (Placement(transformation(extent={{172,-78},{192,-58}})));
  Buildings.Controls.OBC.CDL.Logical.TrueHoldWithReset truHol(duration=1800)
    "WaterTempandFlow_CoolingControl_Lockout_CHWReturn- hold signal for 30 mins"
    annotation (Placement(transformation(extent={{252,-56},{272,-36}})));
  Buildings.Controls.OBC.CDL.Logical.Not not6
    "WaterTempandFlow_CoolingControl_Lockout_CHWReturn_Not"
    annotation (Placement(transformation(extent={{286,-56},{306,-36}})));
  Buildings.Controls.OBC.CDL.Logical.And and4
    "WaterTempandFlow_HeatingControl_Lockout_Signal"
    annotation (Placement(transformation(extent={{-422,-98},{-402,-78}})));
  Buildings.Controls.OBC.CDL.Logical.And and5
    "WaterTempandFlow_CoolingControl_Lockout_FinalSignal"
    annotation (Placement(transformation(extent={{-142,-146},{-122,-126}})));
  Modelica.Blocks.Sources.BooleanConstant NightFlushLockout
    "WaterTempandFlow_HeatingControl_Lockout_NightFlush- PLACEHOLDER"
    annotation (Placement(transformation(extent={{-536,-84},{-516,-64}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs
    "Alarm_Error- absolute value of difference between slab setpoint and slab temp"
    annotation (Placement(transformation(extent={{-772,-104},{-752,-84}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqual greEqu
    "Alarm_Error_TestifAboveThreshhold"
    annotation (Placement(transformation(extent={{-716,-118},{-696,-98}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    "Alarm_Switch integrated function from constant zero to constant one if error is above threshhold"
    annotation (Placement(transformation(extent={{-642,-118},{-622,-98}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant ConZero(k=0)
    "Alarm_ErrorIntegral_ConstantZero"
    annotation (Placement(transformation(extent={{-686,-158},{-666,-138}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant ConOne(k=1)
    "Alarm_ErrorIntegral_ConstantOne"
    annotation (Placement(transformation(extent={{-676,-78},{-656,-58}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqual greEqALARM
    "Alarm- true if error has been > 2F for more than 4 hours, otherwise false"
    annotation (Placement(transformation(extent={{-566,-118},{-546,-98}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant ConOne1(k=14400)
    "Alarm_Constant- 4hours in seconds for error test"
    annotation (Placement(transformation(extent={{-608,-182},{-588,-162}})));
  Buildings.Controls.OBC.CDL.Logical.Not not7
    "Alarm_Zero out integral if error is below threshhold"
    annotation (Placement(transformation(extent={{-668,-204},{-648,-184}})));
  Buildings.Controls.OBC.CDL.Continuous.IntegratorWithReset intWitRes(reset=
        Buildings.Controls.OBC.CDL.Types.Reset.Parameter)
    "Alarm_Find integral of how long error has been above threshold, reset to zero if error goes below 2 F threshhold"
    annotation (Placement(transformation(extent={{-604,-116},{-584,-96}})));
  Fluid.Sources.Boundary_pT
    airOut1(          redeclare package Medium = MediumA, nPorts=1)
                                                     "Air outlet for X3A"
    annotation (Placement(transformation(extent={{48,90},{68,110}})));
  Modelica.Blocks.Sources.CombiTimeTable shaPos1(table=[0,1; 86400,1],
      tableOnFile=false) "Position of the shade"
    annotation (Placement(transformation(extent={{10,190},{30,210}})));

  Fluid.Sensors.TemperatureTwoPort temRoom(
    redeclare package Medium = MediumA,
    m_flow_nominal=mRad_flow_nominal,
    transferHeat=false) "HeatingTemperature" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={170,172})));
  Modelica.Blocks.Sources.CombiTimeTable airCon(
    table=[0,0.001,293.15; 28800,0.05,293.15; 64800,0.001,293.15; 86400,0.001,293.15],
    tableOnFile=false,
    tableName="airCon",
    fileName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/ThermalZones/Detailed/FLEXLAB/Rooms/Examples/X3AWithRadiantFloor.txt"),
    columns=2:3,
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    timeScale=1) "Inlet air conditions (y[1] = m_flow, y[4] = T)"
    annotation (Placement(transformation(extent={{-58,242},{-38,262}})));

  Fluid.Sources.MassFlowSource_T           airIn(
    use_m_flow_in=true,
    use_T_in=true,
    redeclare package Medium = MediumA,
    nPorts=1) "Inlet air conditions (from AHU) for X3A"
    annotation (Placement(transformation(extent={{0,262},{20,282}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TOut2
    "Outside temperature"
    annotation (Placement(transformation(extent={{264,214},{284,234}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant InteriorSetpoint1(k=294)
    annotation (Placement(transformation(extent={{206,230},{250,274}})));
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
    annotation (Placement(transformation(extent={{14,306},{34,326}})));
  Modelica.Blocks.Sources.CombiTimeTable shaPos2(table=[0,1; 86400,1],
      tableOnFile=false) "Position of the shade"
    annotation (Placement(transformation(extent={{8,332},{28,352}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor conBel2(G=0.2)
    "Combined convection and radiation resistance below the slab"
    annotation (Placement(transformation(extent={{118,252},{138,272}})));
  ThermalZones.Detailed.FLEXLAB.Rooms.X3A.TestCell_Radiant_Interior
    testCell_Radiant_Interior(
    nConExtWin=0,
    nConBou=5,
    lat=0.72954762733363,     nPorts=2,
    redeclare package Medium = MediumA)
    annotation (Placement(transformation(extent={{98,300},{138,340}})));
  Controls.OBC.CDL.Continuous.Sources.Constant InteriorSetpoint(k=294)
    annotation (Placement(transformation(extent={{-866,262},{-846,282}})));
equation
  connect(sla1.surf_a, temSlabSurface.port) annotation (Line(points={{10,22},{-154,
          22},{-154,180}},              color={191,0,0}));
  connect(TBel.port, conBel1.port_a) annotation (Line(points={{96,-138},{52,-138},
          {52,-102},{14,-102}}, color={191,0,0}));
  connect(conBel1.port_b, sla1.surf_b)
    annotation (Line(points={{34,-102},{10,-102},{10,2}},
                                                        color={191,0,0}));

  connect(tabSlab.y, zeroOrderHold.u) annotation (Line(points={{-640.1,277},{-640.1,
          338},{-706,338},{-706,226},{-708,226},{-708,218},{-706,218},{-706,212},
          {-652,212},{-652,218}},     color={0,0,127}));
  connect(chaSig.y, add.u2) annotation (Line(points={{-792,150},{-758,150},{-758,
          118},{-622,118}},      color={0,0,127}));

  connect(booToReaHtgValveOn.y, valHot.y) annotation (Line(points={{-234,-112},{
          -206,-112},{-206,-156},{-178,-156}}, color={0,0,127}));
  connect(booToReaHtgPump.y,pumHot. m_flow_in) annotation (Line(points={{-236,
          -76},{-212,-76},{-212,-80},{-186,-80}},
                                             color={0,0,127}));
  connect(booToReaClgPump.y, pumCold.m_flow_in) annotation (Line(points={{-44,-82},
          {-38,-82},{-38,-70},{-26,-70}}, color={0,0,127}));
  connect(booToReaClgValve.y, valCold.y) annotation (Line(points={{-40,-118},{-30,
          -118},{-30,-152},{-12,-152}},
                                      color={0,0,127}));
  connect(temSup.port_b, sla1.port_a) annotation (Line(points={{-32,2},{-18,2},{
          -18,12},{-4,12}}, color={0,127,255}));
  connect(sla1.port_b, temRet.port_a) annotation (Line(points={{16,12},{28,12},{
          28,-20},{40,-20}}, color={0,127,255}));
  connect(temRet.port_b, exp.port_a) annotation (Line(points={{40,0},{64,0},{64,
          -14},{86,-14}}, color={0,127,255}));
  connect(pumHot.port_b, temHeating.port_a) annotation (Line(points={{-174,-70},
          {-174,-52},{-192,-52},{-192,-32},{-190,-32},{-190,-18},{-188,-18}},
                                  color={0,127,255}));
  connect(pumCold.port_b, temCooling.port_a) annotation (Line(points={{-14,-60},
          {-90,-60},{-90,-50}}, color={0,127,255}));
  connect(sou.ports[1], temHeatingSoutoValve.port_a) annotation (Line(points={{-174,
          -304},{-176,-304},{-176,-208},{-178,-208}}, color={0,127,255}));
  connect(temHeatingSoutoValve.port_b, valHot.port_a) annotation (Line(points={{
          -178,-188},{-194,-188},{-194,-168},{-188,-168}}, color={0,127,255}));
  connect(valHot.port_b, temHeatingValtoSlab.port_a) annotation (Line(points={{-168,
          -168},{-172,-168},{-172,-134},{-174,-134}}, color={0,127,255}));
  connect(temHeatingValtoSlab.port_b,pumHot. port_a)
    annotation (Line(points={{-174,-114},{-174,-90}}, color={0,127,255}));
  connect(souCold.ports[1], temCoolingSoutoVal.port_a) annotation (Line(points={
          {-18,-286},{-24,-286},{-24,-204},{-28,-204}}, color={0,127,255}));
  connect(temCoolingSoutoVal.port_b, valCold.port_a) annotation (Line(points={{-28,
          -184},{-28,-164},{-22,-164}}, color={0,127,255}));
  connect(valCold.port_b, temCoolingValtoPump.port_a) annotation (Line(points={{
          -2,-164},{-6,-164},{-6,-122},{-10,-122}}, color={0,127,255}));
  connect(temCoolingValtoPump.port_b, pumCold.port_a) annotation (Line(points={{
          -10,-102},{-12,-102},{-12,-80},{-14,-80}}, color={0,127,255}));
  connect(add.y, hys.u) annotation (Line(points={{-599,124},{-528,124},{-528,76},
          {-472,76}}, color={0,0,127}));
  connect(HighT.y, gre1.u2) annotation (Line(points={{168,-190},{184,-190},{184,
          -164},{202,-164}}, color={0,0,127}));
  connect(LowAirT.y, les1.u2) annotation (Line(points={{166,-296},{192,-296},{192,
          -276},{216,-276}}, color={0,0,127}));
  connect(gre1.y, not2.u) annotation (Line(points={{226,-156},{234,-156},{234,-152},
          {244,-152}}, color={255,0,255}));
  connect(les1.y, not3.u) annotation (Line(points={{240,-268},{252,-268},{252,-270},
          {262,-270}}, color={255,0,255}));
  connect(and1.y, booToReaClgPump.u) annotation (Line(points={{-98,-100},{-84,-100},
          {-84,-82},{-68,-82}}, color={255,0,255}));
  connect(and1.y, booToReaClgValve.u) annotation (Line(points={{-98,-100},{-80,-100},
          {-80,-118},{-64,-118}}, color={255,0,255}));
  connect(and3.y, booToReaHtgPump.u) annotation (Line(points={{-294,-90},{-278,-90},
          {-278,-76},{-260,-76}}, color={255,0,255}));
  connect(and3.y, booToReaHtgValveOn.u) annotation (Line(points={{-294,-90},{-276,
          -90},{-276,-112},{-258,-112}}, color={255,0,255}));
  connect(not1.y, and3.u1) annotation (Line(points={{-368,-2},{-344,-2},{-344,-82},
          {-318,-82}}, color={255,0,255}));
  connect(LockoutTime.y, gre2Cold.u2) annotation (Line(points={{-150,-370},{-150,
          -316},{-86,-316},{-86,-304}}, color={0,0,127}));
  connect(LockoutTime.y, gre3Hot.u2) annotation (Line(points={{-150,-370},{-216,
          -370},{-216,-254},{-266,-254},{-266,-236}}, color={0,0,127}));
  connect(offTimHot.y, gre3Hot.u1) annotation (Line(points={{-281,-224},{-281,-228},
          {-266,-228}}, color={0,0,127}));
  connect(LockoutTime.y, gre4.u2) annotation (Line(points={{-150,-370},{-562,-370},
          {-562,-260},{-520,-260}}, color={0,0,127}));
  connect(modTim.y, gre4.u1) annotation (Line(points={{-671,-270},{-604,-270},{-604,
          -252},{-520,-252}}, color={0,0,127}));
  connect(gre4.y, logSwiHot.u2) annotation (Line(points={{-496,-252},{-496,-196},
          {-526,-196},{-526,-190},{-444,-190},{-444,-168}}, color={255,0,255}));
  connect(gre4.y, logSwiCold.u2) annotation (Line(points={{-496,-252},{-410,-252},
          {-410,-274},{-324,-274}}, color={255,0,255}));
  connect(booleanConstant.y, logSwiHot.u3) annotation (Line(points={{-459,-234},
          {-459,-213},{-444,-213},{-444,-176}}, color={255,0,255}));
  connect(gre3Hot.y, logSwiHot.u1) annotation (Line(points={{-242,-228},{-242,-366},
          {-546,-366},{-546,-160},{-444,-160}}, color={255,0,255}));
  connect(booleanConstant1.y, logSwiCold.u3) annotation (Line(points={{-355,-308},
          {-342,-308},{-342,-282},{-324,-282}}, color={255,0,255}));
  connect(gre2Cold.y, logSwiCold.u1) annotation (Line(points={{-62,-296},{-58,-296},
          {-58,-396},{-388,-396},{-388,-266},{-324,-266}}, color={255,0,255}));
  connect(valCold.y, realToBooleanCold.u) annotation (Line(points={{-12,-152},{
          -12,-240},{0,-240}}, color={0,0,127}));
  connect(valHot.y, realToBooleanHot.u) annotation (Line(points={{-178,-156},{-212,
          -156},{-212,-178},{-228,-178},{-228,-200}}, color={0,0,127}));
  connect(logSwiCold.y, and3.u3) annotation (Line(points={{-300,-274},{-310,-274},
          {-310,-98},{-318,-98}}, color={255,0,255}));
  connect(logSwiHot.y, and1.u3) annotation (Line(points={{-420,-168},{-148,-168},
          {-148,-108},{-122,-108}}, color={255,0,255}));
  connect(offTimCold.y, gre2Cold.u1) annotation (Line(points={{-97,-238},{-92,-238},
          {-92,-296},{-86,-296}}, color={0,0,127}));
  connect(realToBooleanHot.y, pre.u) annotation (Line(points={{-205,-200},{-205,
          -222},{-244,-222},{-244,-172},{-286,-172},{-286,-188},{-280,-188}},
        color={255,0,255}));
  connect(pre.y, offTimHot.u) annotation (Line(points={{-256,-188},{-256,-208},
          {-316,-208},{-316,-224},{-304,-224}}, color={255,0,255}));
  connect(realToBooleanCold.y, pre1.u) annotation (Line(points={{23,-240},{26,-240},
          {26,-272},{-68,-272},{-68,-154},{-108,-154},{-108,-184}}, color={255,
          0,255}));
  connect(pre1.y, offTimCold.u) annotation (Line(points={{-84,-184},{-84,-214},
          {-128,-214},{-128,-238},{-120,-238}}, color={255,0,255}));
  connect(and3.y, not4.u) annotation (Line(points={{-294,-90},{-292,-90},{-292,-36},
          {-280,-36}},      color={255,0,255}));
  connect(and1.y, not5.u) annotation (Line(points={{-98,-100},{-98,-78},{-138,
          -78},{-138,-56}}, color={255,0,255}));
  connect(not4.y, and2.u1) annotation (Line(points={{-256,-36},{-256,2},{-242,2},
          {-242,28}}, color={255,0,255}));
  connect(not5.y, and2.u2) annotation (Line(points={{-114,-56},{-210,-56},{-210,
          6},{-242,6},{-242,20}}, color={255,0,255}));
  connect(mix2.port_2, valSlab.port_a)
    annotation (Line(points={{-90,0},{-72,0},{-72,-16}}, color={0,127,255}));
  connect(valSlab.port_b, temSup.port_a) annotation (Line(points={{-52,-16},{
          -46,-16},{-46,-18},{-32,-18}}, color={0,127,255}));
  connect(and2.y, booToReaSlabValve.u) annotation (Line(points={{-218,28},{-200,
          28},{-200,40},{-182,40}}, color={255,0,255}));
  connect(booToReaSlabValve.y, valSlab.y) annotation (Line(points={{-158,40},{-132,
          40},{-132,-4},{-62,-4}},      color={0,0,127}));
  connect(modTim1.y, ForecastHigh.u) annotation (Line(points={{-221,292},{-260,292},
          {-260,255},{-305.8,255}}, color={0,0,127}));
  connect(weaDat1.weaBus, weaBus1.TDryBul) annotation (Line(
      points={{192,304},{238,304},{238,308},{280,308}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(temSlabTop.T, add.u1) annotation (Line(points={{-74,38},{-186,38},{-186,
          172},{-622,172},{-622,130}}, color={0,0,127}));
  connect(ForecastHigh.y, triSam.u) annotation (Line(points={{-354.1,255},{-428,
          255},{-428,334},{-496,334},{-496,302},{-492,302}}, color={0,0,127}));
  connect(booPul1.y, triSam.trigger) annotation (Line(points={{-464,244},{-474,244},
          {-474,290.2},{-480,290.2}}, color={255,0,255}));
  connect(triSam.y, tabSlab.u) annotation (Line(points={{-468,302},{-462,302},{-462,
          277},{-591.8,277}}, color={0,0,127}));
  connect(hys.y, logicalSwitch.u1) annotation (Line(points={{-448,76},{-438,76},
          {-438,82},{-424,82}}, color={255,0,255}));
  connect(logicalSwitch.y, not1.u) annotation (Line(points={{-401,74},{-401,35},
          {-392,35},{-392,-2}}, color={255,0,255}));
  connect(logicalSwitch.y, and1.u1) annotation (Line(points={{-401,74},{-140.5,74},
          {-140.5,-92},{-122,-92}}, color={255,0,255}));
  connect(hysRelax.y, logicalSwitch.u3) annotation (Line(points={{-450,38},{-438,
          38},{-438,66},{-424,66}}, color={255,0,255}));
  connect(add.y, hysRelax.u) annotation (Line(points={{-599,124},{-536,124},{-536,
          38},{-474,38}}, color={0,0,127}));
  connect(booleanPulse.y, logicalSwitch.u2) annotation (Line(points={{-653,52},{
          -540,52},{-540,74},{-424,74}}, color={255,0,255}));
  connect(LockoutCHW.y, les2.u2) annotation (Line(points={{194,-68},{208,-68},{208,
          -54},{220,-54}}, color={0,0,127}));
  connect(temRet.T, les2.u1) annotation (Line(points={{29,-10},{124,-10},{124,-46},
          {220,-46}}, color={0,0,127}));
  connect(les2.y, truHol.u)
    annotation (Line(points={{244,-46},{250,-46}}, color={255,0,255}));
  connect(truHol.y, not6.u)
    annotation (Line(points={{274,-46},{284,-46}}, color={255,0,255}));
  connect(not3.y, and5.u2) annotation (Line(points={{286,-270},{294,-270},{294,-388},
          {-144,-388},{-144,-144}}, color={255,0,255}));
  connect(and5.y, and1.u2) annotation (Line(points={{-120,-136},{-118,-136},{-118,
          -100},{-122,-100}}, color={255,0,255}));
  connect(not6.y, and5.u1) annotation (Line(points={{308,-46},{316,-46},{316,-392},
          {-144,-392},{-144,-136}}, color={255,0,255}));
  connect(not2.y, and4.u2) annotation (Line(points={{268,-152},{310,-152},{310,-348},
          {-506,-348},{-506,-96},{-424,-96}}, color={255,0,255}));
  connect(NightFlushLockout.y, and4.u1) annotation (Line(points={{-515,-74},{-470,
          -74},{-470,-88},{-424,-88}}, color={255,0,255}));
  connect(and4.y, and3.u2) annotation (Line(points={{-400,-88},{-362,-88},{-362,
          -90},{-318,-90}}, color={255,0,255}));
  connect(add.y, abs.u) annotation (Line(points={{-599,124},{-788,124},{-788,-94},
          {-774,-94}}, color={0,0,127}));
  connect(abs.y, greEqu.u1) annotation (Line(points={{-750,-94},{-734,-94},{-734,
          -108},{-718,-108}}, color={0,0,127}));
  connect(conPOS.y, greEqu.u2) annotation (Line(points={{-752,-124},{-736,-124},
          {-736,-116},{-718,-116}}, color={0,0,127}));
  connect(greEqu.y, swi.u2)
    annotation (Line(points={{-694,-108},{-644,-108}}, color={255,0,255}));
  connect(ConZero.y, swi.u3) annotation (Line(points={{-664,-148},{-656,-148},{-656,
          -116},{-644,-116}}, color={0,0,127}));
  connect(ConOne.y, swi.u1) annotation (Line(points={{-654,-68},{-650,-68},{-650,
          -100},{-644,-100}}, color={0,0,127}));
  connect(ConOne1.y, greEqALARM.u2) annotation (Line(points={{-586,-172},{-578,-172},
          {-578,-116},{-568,-116}}, color={0,0,127}));
  connect(greEqu.y, not7.u) annotation (Line(points={{-694,-108},{-694,-154},{-670,
          -154},{-670,-194}}, color={255,0,255}));
  connect(not7.y, intWitRes.trigger) annotation (Line(points={{-646,-194},{-620,
          -194},{-620,-118},{-594,-118}}, color={255,0,255}));
  connect(swi.y, intWitRes.u) annotation (Line(points={{-620,-108},{-614,-108},{
          -614,-106},{-606,-106}}, color={0,0,127}));
  connect(intWitRes.y, greEqALARM.u1) annotation (Line(points={{-582,-106},{-574,
          -106},{-574,-108},{-568,-108}}, color={0,0,127}));
  connect(temRoom.T, gre1.u1) annotation (Line(points={{159,172},{146,172},{146,
          -156},{202,-156}}, color={0,0,127}));
  connect(temRoom.T, les1.u1) annotation (Line(points={{159,172},{98,172},{98,-268},
          {216,-268}}, color={0,0,127}));
  connect(airCon.y[1], airIn.m_flow_in) annotation (Line(points={{-37,252},{-14,
          252},{-14,280},{-2,280}}, color={0,0,127}));
  connect(airCon.y[2], airIn.T_in) annotation (Line(points={{-37,252},{-14,252},
          {-14,276},{-2,276}}, color={0,0,127}));
  connect(InteriorSetpoint1.y, TOut2.T) annotation (Line(points={{254.4,252},{256,
          252},{256,224},{262,224}}, color={0,0,127}));
  connect(temRoom.port_b, airOut1.ports[1]) annotation (Line(points={{170,182},{
          88,182},{88,100},{68,100}}, color={0,127,255}));
  connect(sla1.surf_a, temSlabTop.port) annotation (Line(points={{10,22},{-22,22},
          {-22,38},{-54,38}}, color={191,0,0}));
  connect(temCooling.port_b, mix2.port_3) annotation (Line(points={{-90,-30},{-108,
          -30},{-108,10},{-100,10}}, color={0,127,255}));
  connect(temHeating.port_b, mix2.port_1) annotation (Line(points={{-188,2},{-140,
          2},{-140,20},{-90,20}}, color={0,127,255}));
  connect(TOut2.port, conBel2.port_a)
    annotation (Line(points={{284,224},{118,224},{118,262}}, color={191,0,0}));
  connect(conBel2.port_b, testCell_Radiant_Interior.surf_conBou[1]) annotation (
     Line(points={{138,262},{132,262},{132,303.2},{124,303.2}},
                                                            color={191,0,0}));
  connect(sla1.surf_a, testCell_Radiant_Interior.surf_surBou[1]) annotation (
      Line(points={{10,22},{62,22},{62,306},{114.2,306}}, color={191,0,0}));
  connect(airIn.ports[1], testCell_Radiant_Interior.ports[1]) annotation (Line(
        points={{20,272},{62,272},{62,308},{103,308}}, color={0,127,255}));
  connect(testCell_Radiant_Interior.ports[2], temRoom.port_a) annotation (Line(
        points={{103,312},{103,178},{170,178},{170,162}}, color={0,127,255}));
  connect(intGai2.y, testCell_Radiant_Interior.qGai_flow) annotation (Line(
        points={{35,316},{64,316},{64,328},{96.4,328}}, color={0,0,127}));
  connect(sla1.surf_a, testCell_Radiant_Interior.heaPorRad) annotation (Line(
        points={{10,22},{64,22},{64,316.2},{117,316.2}}, color={191,0,0}));
  connect(InteriorSetpoint.y, chaSig.u) annotation (Line(points={{-844,272},{-830,
          272},{-830,150},{-816,150}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
This models a radiant slab as per current control scheme. 
</p>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true,
            extent={{-940,-400},{800,360}})),
    __Dymola_Commands(file=
     "modelica://Buildings/Resources/Scripts/Dymola/Examples/Tutorial/Boiler/System2_RadTest_0605_Exterior_v18.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=31536000),
    Icon(coordinateSystem(extent={{-940,-400},{800,360}})));
end System2_RadTest_0605_Interior_v18FINAL;

within Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.Validation;
model ControlPlusLockoutPerimeter
  "Radiant slab serving perimeter zone with heating and cooling sources, pumps, and valves"
  extends Modelica.Icons.Example;
  replaceable package MediumA =
      Buildings.Media.Air "Air medium";

//-------------------------Step 2: Water as medium-------------------------//
  replaceable package MediumW =
      Buildings.Media.Water "Medium model";
      //--------------------------------------Radiant Control Parameters-----------------------------------//
    final parameter Real TZonHigLim(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="Temperature")=297.6
    "Air temperature high limit above which heating is locked out";
   final parameter Real TZonLowLim(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="Temperature")=293.15
    "Air temperature low limit below which heating is locked out";
     final parameter Real TemWaLoSet(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="Temperature")=285.9
    "Lower limit for chilled water return temperature, below which cooling is locked out";
   final parameter Real TimCHW(min=0,
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
  final parameter Real LasOcc(min=0,max=24)=16 "Last occupied hour";
  final parameter Boolean OffTru=true "True: both heating and cooling signals turn off when slab setpoint is within deadband";
//------------------------Step 4: Design conditions------------------------//
  parameter Buildings.Fluid.Data.Pipes.PEX_RADTEST pipe
    "Pipe";
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
  parameter Real Q_flow_nominal(
    final min=0,
    final unit="J/s",
    final quantity="HeatFlowRate") = 4000
    "Nominal heat flow rate of water in slab";
  parameter Real TRadSup_nominal(
    final unit="K",
    final displayUnit="K",
    final quantity="ThermodynamicTemperature") = 273.15+40
    "Slab nominal heating supply water temperature, 105 F";
  parameter Real TRadRet_nominal(
    final unit="K",
    final displayUnit="K",
    final quantity="ThermodynamicTemperature") = 273.15+35
    "Slab nominal heating return water temperature,heating 95 F";
  parameter Real mRad_flow_nominal(
    final min=0,
    final unit="kg/s",
    final quantity="MassFlowRate")=
    Q_flow_nominal/4200/(TRadSup_nominal-TRadRet_nominal)
    "Radiator nominal mass flow rate";
  parameter Real TRadCol_nominal(
    final unit="K",
    final displayUnit="K",
    final quantity="ThermodynamicTemperature") = 273.15+10
    "Radiator nominal temperature";
  parameter Real A(
    final min=0,
    final unit="m2",
    final quantity="Area")= 45 "Area";
//------------------------------------------------------------------------//
  parameter Real V(
    final min=0,
    final unit="m3",
    final quantity="Volume")=5*9*3 "Room volume";

  parameter Real mA_flow_nominal(
    final min=0,
    final unit="kg/s",
    final quantity="MassFlowRate") = V*1.2*6/3600
    "Nominal mass flow rate";
  parameter Real QRooInt_flow(
    final min=0,
    final unit="J/s",
    final quantity="HeatFlowRate") = 100
    "Internal heat gains of the room";

  Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab           sla1(
    steadyStateInitial=true,
    T_a_start=288.15,
    T_b_start=288.15,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=mRad_flow_nominal,
    redeclare package Medium = MediumW,
    layers=layers,
    iLayPip=1,
    pipe=pipe,
    sysTyp=Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.SystemType.Floor,
    disPip=0.2,
    A=A)          "Slabe with embedded pipes"
    annotation (Placement(transformation(extent={{-4,2},{16,22}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TBel(T=293.15)
    "Radiant temperature below the slab"
    annotation (Placement(transformation(extent={{82,-98},{102,-78}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor conBel1(G=20*A)
    "Combined convection and radiation resistance below the slab"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Fluid.Sources.Boundary_pT souCol(
    redeclare package Medium = MediumW,
    T=TRadCol_nominal,
    nPorts=1) "Chilled water source" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-16,-290})));
Fluid.Movers.FlowControlled_m_flow pumCol(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    T_start=TRadCol_nominal,
    allowFlowReversal=false,
    m_flow_nominal=mRad_flow_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true)
                            "Chilled water pump" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-12,-58})));
  Fluid.Actuators.Valves.TwoWayPressureIndependent valCol(
    redeclare package Medium = MediumW,
    m_flow_nominal=mRad_flow_nominal,
    dpValve_nominal=100,
    show_T=true) "Chilled water valve"
    annotation (Placement(transformation(extent={{-22,-174},{-2,-154}})));
Fluid.Movers.FlowControlled_m_flow           pumHot(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=mRad_flow_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    m_flow_start=0.01)      "Hot water pump"
      annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-174,-80})));
  Fluid.Actuators.Valves.TwoWayPressureIndependent valHot(
  redeclare package Medium = MediumW,
    allowFlowReversal=false,
    m_flow_nominal=mRad_flow_nominal,
    dpValve_nominal=100) "Hot water valve"
    annotation (Placement(transformation(extent={{-188,-178},{-168,-158}})));
  Fluid.Sources.Boundary_pT souHot(
    redeclare package Medium = MediumW,
    T=TRadSup_nominal,
    nPorts=1) "Heating hot water source" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-172,-292})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaHtgVal
    "Heating valve controller"
    annotation (Placement(transformation(extent={{-260,-122},{-240,-102}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaHtgPum(realTrue=
        mRad_flow_nominal, realFalse=0.001*mRad_flow_nominal)
                           "Heating pump controller"
    annotation (Placement(transformation(extent={{-260,-80},{-240,-60}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaClgPum(realTrue=
        mRad_flow_nominal, realFalse=0.001*mRad_flow_nominal)
                           "Cooling pump controller"
    annotation (Placement(transformation(extent={{-62,-100},{-42,-80}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaClgVal
    "Cooling valve controller"
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
  Fluid.Sensors.TemperatureTwoPort temHea(
    redeclare package Medium = MediumW,
    m_flow_nominal=mRad_flow_nominal,
    transferHeat=false) "HeatingTemperature" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-188,-8})));
  Fluid.Sensors.TemperatureTwoPort temCoo(
    redeclare package Medium = MediumW,
    m_flow_nominal=mRad_flow_nominal,
    T_start=TRadCol_nominal,
    transferHeat=true,
    TAmb=TRadCol_nominal) "CoolingTemperature" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-90,-40})));
  Fluid.Sensors.TemperatureTwoPort temHeaSou(redeclare package Medium = MediumW,
      m_flow_nominal=mRad_flow_nominal) "HeatingTemperature" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-178,-198})));
  Fluid.Sensors.TemperatureTwoPort temHeaValSla(redeclare package Medium =
        MediumW, m_flow_nominal=mRad_flow_nominal) "HeatingTemperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-174,-124})));
  Fluid.Sensors.TemperatureTwoPort temCooSou(redeclare package Medium = MediumW,
      m_flow_nominal=mRad_flow_nominal) "CoolingTemperature" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-28,-194})));
  Fluid.Sensors.TemperatureTwoPort temCooValSla(redeclare package Medium =
        MediumW, m_flow_nominal=mRad_flow_nominal) "CoolingTemperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-10,-112})));
  Fluid.FixedResistances.Junction           mix2(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Entering,
    verifyFlowReversal=true,
    dp_nominal={1,-200,1},
    m_flow_nominal={mRad_flow_nominal,-mRad_flow_nominal,mRad_flow_nominal})
    "Mixer" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-90,10})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat1(filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data reader"
    annotation (Placement(transformation(extent={{184,340},{204,360}})));
  BoundaryConditions.WeatherData.Bus weaBus1 "Weather bus"
    annotation (Placement(transformation(extent={{270,298},{290,318}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSlaTop
    "Temperature at the top of the slab" annotation (Placement(transformation(
          extent={{10,-10},{-10,10}}, origin={-72,44})));
  Fluid.Sources.Boundary_pT
    airOut1(          redeclare package Medium = MediumA, nPorts=1)
                                                     "Air outlet for X3A"
    annotation (Placement(transformation(extent={{0,244},{20,264}})));

  Fluid.Sensors.TemperatureTwoPort temRoo(
    redeclare package Medium = MediumA,
    m_flow_nominal=mRad_flow_nominal,
    transferHeat=false) "HeatingTemperature" annotation (Placement(
        transformation(
        extent={{-9,-20},{9,20}},
        rotation=90,
        origin={84,241})));
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
    annotation (Placement(transformation(extent={{0,280},{20,300}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TOut2
    "Outside temperature"
    annotation (Placement(transformation(extent={{210,166},{230,186}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TIntSet(k=294)
    "Indoor temperature of adjacent conditioned spaces"
    annotation (Placement(transformation(extent={{198,232},{242,276}})));
  Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3A.TestCellRadiantExterior radExt(
    nSurBou=1,
    hRoo=3,
    steadyStateWindow=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    nPorts=2,
    redeclare package Medium = MediumA) "Radiant exterior test cell"
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
    annotation (Placement(transformation(extent={{0,320},{20,340}})));
  Modelica.Blocks.Sources.CombiTimeTable shaPos2(table=[0,1; 86400,1],
      tableOnFile=false) "Position of the shade"
    annotation (Placement(transformation(extent={{38,340},{58,360}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor conBel2(G=0.2)
    "Combined convection and radiation resistance below the slab"
    annotation (Placement(transformation(extent={{122,252},{142,272}})));
  Fluid.Sources.Boundary_pT           sin(nPorts=1, redeclare package Medium =
        MediumW)
    "Sink for mass flow rate"           annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={156,4})));
  Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.ControlPlusLockouts conPluLoc(
    TZonHigSet=TZonHigLim,
    TZonLowSet=TZonLowLim,
    TWatSetLow=TemWaLoSet,
    cooLocDurWatTem=TimCHW,
    heaLocDurAftCoo=TimHea,
    cooLocDurAftHea=TimCoo,
    TDeaRel=TemDeaRel,
    TDeaNor=TemDeaNor,
    k=LasOcc,
    offWitDea=OffTru) "Control plus lockouts"
    annotation (Placement(transformation(extent={{-400,-100},{-380,-80}})));
  SlabTemperatureSignal.SlabSetpointPerimeter slaSetPer "Slab setpoint "
    annotation (Placement(transformation(extent={{-520,-60},{-500,-40}})));
  SlabTemperatureSignal.Validation.BaseClasses.ForecastHighChicago forHiChi
    "Forecast high temperature"
    annotation (Placement(transformation(extent={{-586,-64},{-566,-44}})));
  Controls.OBC.CDL.Logical.Sources.Constant uNigFlu(k=false)
    "Night flush signal- constantly false"
    annotation (Placement(transformation(extent={{-482,-140},{-462,-120}})));
equation
  connect(TBel.port, conBel1.port_a) annotation (Line(points={{102,-88},{128,
          -88},{128,-118},{12,-118},{12,-48},{20,-48},{20,-50}},
                                color={191,0,0}));
  connect(conBel1.port_b, sla1.surf_b)
    annotation (Line(points={{40,-50},{54,-50},{54,-24},{10,-24},{10,2}},
                                                        color={191,0,0}));

  connect(booToReaHtgPum.y, pumHot.m_flow_in) annotation (Line(points={{-238,-70},
          {-238,-80},{-186,-80}}, color={0,0,127}));
  connect(booToReaClgPum.y, pumCol.m_flow_in) annotation (Line(points={{-40,-90},
          {-38,-90},{-38,-58},{-24,-58}}, color={0,0,127}));
  connect(booToReaClgVal.y, valCol.y) annotation (Line(points={{-40,-130},{-30,
          -130},{-30,-152},{-12,-152}}, color={0,0,127}));
  connect(temSup.port_b, sla1.port_a) annotation (Line(points={{-32,2},{-18,2},{
          -18,12},{-4,12}}, color={0,127,255}));
  connect(sla1.port_b, temRet.port_a) annotation (Line(points={{16,12},{28,12},
          {28,-12},{52,-12}},color={0,127,255}));
  connect(pumHot.port_b, temHea.port_a) annotation (Line(points={{-174,-70},{-174,
          -52},{-188,-52},{-188,-18}}, color={0,127,255}));
  connect(pumCol.port_b, temCoo.port_a) annotation (Line(points={{-12,-48},{-90,
          -48},{-90,-50}}, color={0,127,255}));
  connect(souHot.ports[1], temHeaSou.port_a) annotation (Line(points={{-172,-282},
          {-176,-282},{-176,-208},{-178,-208}}, color={0,127,255}));
  connect(temHeaSou.port_b, valHot.port_a) annotation (Line(points={{-178,-188},
          {-194,-188},{-194,-168},{-188,-168}}, color={0,127,255}));
  connect(valHot.port_b, temHeaValSla.port_a) annotation (Line(points={{-168,-168},
          {-172,-168},{-172,-134},{-174,-134}}, color={0,127,255}));
  connect(temHeaValSla.port_b, pumHot.port_a)
    annotation (Line(points={{-174,-114},{-174,-90}}, color={0,127,255}));
  connect(souCol.ports[1], temCooSou.port_a) annotation (Line(points={{-16,-280},
          {-24,-280},{-24,-204},{-28,-204}}, color={0,127,255}));
  connect(temCooSou.port_b, valCol.port_a) annotation (Line(points={{-28,-184},
          {-28,-164},{-22,-164}}, color={0,127,255}));
  connect(valCol.port_b, temCooValSla.port_a) annotation (Line(points={{-2,-164},
          {-6,-164},{-6,-122},{-10,-122}}, color={0,127,255}));
  connect(temCooValSla.port_b, pumCol.port_a) annotation (Line(points={{-10,-102},
          {-12,-102},{-12,-68}}, color={0,127,255}));
  connect(weaDat1.weaBus, weaBus1.TDryBul) annotation (Line(
      points={{204,350},{248,350},{248,308},{280,308}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(airCon.y[1], airIn.m_flow_in) annotation (Line(points={{-41,290},{-14,
          290},{-14,298},{-2,298}}, color={0,0,127}));
  connect(airCon.y[2], airIn.T_in) annotation (Line(points={{-41,290},{-14,290},
          {-14,294},{-2,294}}, color={0,0,127}));
  connect(airIn.ports[1], radExt.ports[1]) annotation (Line(points={{20,290},{
          60,290},{60,308},{87,308}}, color={0,127,255}));
  connect(temRoo.port_b, airOut1.ports[1]) annotation (Line(points={{84,250},{
          60,250},{60,254},{20,254}}, color={0,127,255}));
  connect(intGai2.y, radExt.qGai_flow) annotation (Line(points={{21,330},{58,
          330},{58,328},{80.4,328}}, color={0,0,127}));
  connect(shaPos2.y[1], radExt.uSha[1]) annotation (Line(points={{59,350},{62,
          350},{62,338},{80.4,338}}, color={0,0,127}));
  connect(sla1.surf_a, radExt.surf_surBou[1]) annotation (Line(points={{10,22},
          {54,22},{54,306},{98.2,306}}, color={191,0,0}));
  connect(sla1.surf_a, temSlaTop.port) annotation (Line(points={{10,22},{-22,22},
          {-22,44},{-62,44}}, color={191,0,0}));
  connect(temCoo.port_b, mix2.port_3) annotation (Line(points={{-90,-30},{-108,
          -30},{-108,10},{-100,10}}, color={0,127,255}));
  connect(temHea.port_b, mix2.port_1)
    annotation (Line(points={{-188,2},{-188,20},{-90,20}}, color={0,127,255}));
  connect(conBel2.port_b, radExt.surf_conBou[1])
    annotation (Line(points={{142,262},{156,262},{156,294},{106,294},{106,302},
          {108,302},{108,304}},                              color={191,0,0}));
  connect(booToReaHtgVal.y, valHot.y) annotation (Line(points={{-238,-112},{-208,
          -112},{-208,-156},{-178,-156}}, color={0,0,127}));
  connect(mix2.port_2, temSup.port_a) annotation (Line(points={{-90,
          -3.55271e-15},{-62,-3.55271e-15},{-62,-18},{-32,-18}}, color={0,127,
          255}));
  connect(temRet.port_b, sin.ports[1]) annotation (Line(points={{52,8},{104,8},{
          104,14},{156,14}}, color={0,127,255}));
  connect(conPluLoc.yHea, booToReaHtgPum.u) annotation (Line(points={{-378,-85.6},
          {-316,-85.6},{-316,-70},{-262,-70}}, color={255,0,255}));
  connect(conPluLoc.yHea, booToReaHtgVal.u) annotation (Line(points={{-378,-85.6},
          {-316,-85.6},{-316,-112},{-262,-112}}, color={255,0,255}));
  connect(conPluLoc.yCoo, booToReaClgPum.u) annotation (Line(points={{-378,-93},
          {-366,-93},{-366,-320},{-100,-320},{-100,-90},{-64,-90}}, color={255,
          0,255}));
  connect(conPluLoc.yCoo, booToReaClgVal.u) annotation (Line(points={{-378,-93},
          {-366,-93},{-366,-320},{-100,-320},{-100,-130},{-64,-130}}, color={
          255,0,255}));
  connect(temRet.T, conPluLoc.TSlaWatRet) annotation (Line(points={{41,-2},{41,230},
          {-462,230},{-462,-98},{-402,-98}}, color={0,0,127}));
  connect(temRoo.T, conPluLoc.TRooAir) annotation (Line(points={{62,241},{-464,
          241},{-464,-94},{-402,-94}}, color={0,0,127}));
  connect(temSlaTop.T, conPluLoc.TSla) annotation (Line(points={{-82,44},{-464,44},
          {-464,-82},{-402,-82}}, color={0,0,127}));
  connect(forHiChi.TForHigChi, slaSetPer.TFor) annotation (Line(points={{-564,-53.8},
          {-556,-53.8},{-556,-56},{-540,-56},{-540,-50},{-522,-50}}, color={0,0,
          127}));
  connect(slaSetPer.TSlaSetPer, conPluLoc.TSlaSet) annotation (Line(points={{-498,
          -50},{-468,-50},{-468,-86},{-402,-86}}, color={0,0,127}));
  connect(radExt.ports[2], temRoo.port_a) annotation (Line(points={{87,312},{80,
          312},{80,260},{100,260},{100,232},{84,232}}, color={0,127,255}));
  connect(uNigFlu.y, conPluLoc.uNigFlu) annotation (Line(points={{-460,-130},
          {-432,-130},{-432,-90},{-402,-90}}, color={255,0,255}));
  connect(TIntSet.y, TOut2.T) annotation (Line(points={{246.4,254},{270,254},{
          270,138},{198,138},{198,176},{208,176}}, color={0,0,127}));
  connect(TOut2.port, conBel2.port_a) annotation (Line(points={{230,176},{248,
          176},{248,202},{112,202},{112,262},{122,262}}, color={191,0,0}));
  connect(weaDat1.weaBus, weaBus1.lat) annotation (Line(
      points={{204,350},{248,350},{248,308},{280,308}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(weaDat1.weaBus, radExt.weaBus) annotation (Line(
      points={{204,350},{214,350},{214,322},{119.9,322},{119.9,337.9}},
      color={255,204,51},
      thickness=0.5));
  annotation (Documentation(info="<html>
<p>
This models a radiant slab serving a perimeter zone as per current control scheme.
The slab is controlled to a daily setpoint based on forecast high outdoor air temperature, 
as specified in the Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.SlabTempSignal block. 
Slab control follows the control scheme specified in the (<a href=\"modelica://Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.ControlPlusLockouts\">
Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.ControlPlusLockouts</a>) block.
</p>
<p> 
The zone is 5 meters by 9 meters in floor area and is 3 meters in height. The zone has two exposed walls, each with windows: one oriented south, and the other oriented west. 
The remaining walls are exposed to a constant-temperature boundary condition that is set to ~70<code>degF</code> to approximate interior conditions.
The room is modeled with standard office internal gains - 0.6 W/SF lighting (20% radiative, 80% convective), 0.6 W/SF plug loads (50% radiative, 50% convective) , and 2 occupants, with the corresponding heat gains of:
93 W/person sensible (50% radiative and 50% convective) and 74 W/person latent. Gains are modeled with ASHRAE standard schedules for lighting, plug loads, and occupancy, respectively. 
</p>
<p>
During occupied hours, the room receives ventilation air at approximately code minimum rate (~90 cfm). During unoccupied hours, the room receives a negligible amount of air.
</p>
<p>
Chilled water and hot water are provided to the slab by constant temperature flow sources, at 10C (cooling) and 40 C (heating). 
</p>
</html>", revisions="<html>
<ul>
<li>
October 6, 2020, by Fiona Woods:<br/>
First implementation.
</li>
</ul>
</html>"), experiment(Tolerance=1e-6, StartTime=0, StopTime=31536000),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/RadiantSystems/CoolingAndHeating/Validation/ControlPlusLockoutPerimeter.mos" "Simulate and plot"),
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
end ControlPlusLockoutPerimeter;

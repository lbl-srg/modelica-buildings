within Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.Validation;
model ControlPlusLockoutCore
  "Radiant slab serving core zone with heating and cooling sources, pumps, and valves"
  extends Modelica.Icons.Example;
  //-------------------------Media-------------------------//
  replaceable package MediumA =
      Buildings.Media.Air
      "Air medium";

  replaceable package MediumW =
      Buildings.Media.Water "Medium model";
 //-------------------------Radiant Control Parameters-------------------------//
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
   final parameter Real cooLocDurWatTem(min=0,
    final unit="s",
    final displayUnit="s",
    final quantity="Time")=1800 "Time for which cooling is locked out if CHW return is too cold";
   final parameter Real heaLocDurAftCoo(min=0,
    final unit="s",
    final displayUnit="s",
    final quantity="Time") = 3600 "Time for which heating is locked out after cooling concludes";
  final parameter Real cooLocDurAftHea(min=0,
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
  final parameter Real LasOcc(
    final min=0,
    final max=24)=16 "Last occupied hour";
  final parameter Boolean OffTru=true "True: both heating and cooling signals turn off when slab setpoint is within deadband";
//-------------------------Slab and Fluid Parameters-------------------------//
  parameter Buildings.Fluid.Data.Pipes.PEX_RADTEST pipe "Pipe";
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
        "Material layers from surface a to b (10cm concrete, 5 cm insulation, 10 cm reinforced concrete)";
  parameter Real Q_flow_nominal(
    final min=0,
    final unit="J/s",
    final quantity="HeatFlowRate") = 4000
    "Nominal heat flow rate of water in slab";
  parameter Real TRadSup_nominal(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="ThermodynamicTemperature") = 273.15+40
    "Slab nominal heating supply water temperature, 105 F";
  parameter Real TRadRet_nominal(min=0,
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
  parameter Real TRadCol_nominal(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="ThermodynamicTemperature") = 273.15+10
    "Radiator nominal temperature";
  parameter Real A(
    final min=0,
    final unit="m2",
    final quantity="Area")=45 "Area";
  //---------------------------------Room Parameters---------------------------------------//
  parameter Real V(
    final min=0,
    final unit="m3",
    final quantity="Volume")= 5*9*3 "Room volume";

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
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    T_start(fixed=true, start=293.15),
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
    annotation (Placement(transformation(extent={{62,-118},{82,-98}})));
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
    m_flow_start=0.1)       "Heating hot water pump"
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
  Fluid.Sources.Boundary_pT souHea(
    redeclare package Medium = MediumW,
    T=TRadSup_nominal,
    nPorts=1) "Heating hot water source" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-172,-292})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaHtgVal
    "Heating hot water valve controller"
    annotation (Placement(transformation(extent={{-260,-122},{-240,-102}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaHtgPum(realTrue=
        mRad_flow_nominal, realFalse=0.001*mRad_flow_nominal)
                           "Heating hot water pump controller"
    annotation (Placement(transformation(extent={{-260,-80},{-240,-60}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaClgPum(realTrue=
        mRad_flow_nominal, realFalse=0.001*mRad_flow_nominal)
                           "Chilled water pump controller"
    annotation (Placement(transformation(extent={{-62,-100},{-42,-80}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaClgVal
    "Chilled water valve controller"
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
    transferHeat=false) "Heating hot water temperature" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-188,-8})));
  Fluid.Sensors.TemperatureTwoPort temCoo(
    redeclare package Medium = MediumW,
    m_flow_nominal=mRad_flow_nominal,
    T_start=TRadCol_nominal,
    transferHeat=true,
    TAmb=TRadCol_nominal) "Chilled water temperature" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-90,-40})));
  Fluid.Sensors.TemperatureTwoPort temHeaSou(redeclare package Medium = MediumW,
      m_flow_nominal=mRad_flow_nominal)
    "Heating hot water temperature between source and valve" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-178,-198})));
  Fluid.Sensors.TemperatureTwoPort temHeatingValSla(redeclare package Medium =
        MediumW, m_flow_nominal=mRad_flow_nominal)
    "Heating hot water temperature between valve and slab" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-174,-124})));
  Fluid.Sensors.TemperatureTwoPort temCooSouVal(redeclare package Medium =
        MediumW, m_flow_nominal=mRad_flow_nominal)
    "Chilled water temperature between source and valve" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-28,-194})));
  Fluid.Sensors.TemperatureTwoPort temCoolingValtoPump(redeclare package
      Medium =
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
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSlaTop
    "Temperature at top of slab" annotation (Placement(transformation(extent={{10,
            -10},{-10,10}}, origin={-72,44})));

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
    cooLocDurWatTem=cooLocDurWatTem,
    heaLocDurAftCoo=heaLocDurAftCoo,
    cooLocDurAftHea=cooLocDurAftHea,
    TDeaRel=TemDeaRel,
    TDeaNor=TemDeaNor,
    k=LasOcc,
    offWitDea=OffTru) "Control plus lockouts"
    annotation (Placement(transformation(extent={{-400,-100},{-380,-80}})));
  Fluid.Sources.Boundary_pT
    airOut2(redeclare package Medium = MediumA, nPorts=1)
                                                     "Air outlet for X3A"
    annotation (Placement(transformation(extent={{-64,182},{-44,202}})));
  Modelica.Blocks.Sources.CombiTimeTable shaPos1(table=[0,1; 86400,1],
      tableOnFile=false) "Position of the shade"
    annotation (Placement(transformation(extent={{-312,222},{-292,242}})));
  Fluid.Sensors.TemperatureTwoPort temRoo(
    redeclare package Medium = MediumA,
    m_flow_nominal=mRad_flow_nominal,
    transferHeat=false) "Room air temperature" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-152,204})));
  Modelica.Blocks.Sources.CombiTimeTable airCon1(
    table=[0,0.001,293.15; 28800,0.05,293.15; 64800,0.001,293.15; 86400,0.001,293.15],
    tableOnFile=false,
    tableName="airCon",
    fileName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/ThermalZones/Detailed/FLEXLAB/Rooms/Examples/X3AWithRadiantFloor.txt"),
    columns=2:3,
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    timeScale=1) "Inlet air conditions (y[1] = m_flow, y[4] = T)"
    annotation (Placement(transformation(extent={{-380,274},{-360,294}})));

  Fluid.Sources.MassFlowSource_T           airIn1(
    use_m_flow_in=true,
    use_T_in=true,
    redeclare package Medium = MediumA,
    nPorts=1) "Inlet air conditions (from AHU) for X3A"
    annotation (Placement(transformation(extent={{-322,294},{-302,314}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TOut1
    "Outside temperature"
    annotation (Placement(transformation(extent={{-178,240},{-158,260}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TIntSet2(k=294)
    "Interior temperature (models adjacent conditioned spaces)"
    annotation (Placement(transformation(extent={{-140,298},{-96,342}})));
  Modelica.Blocks.Sources.CombiTimeTable intGai1(
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
    annotation (Placement(transformation(extent={{-308,338},{-288,358}})));
  Modelica.Blocks.Sources.CombiTimeTable shaPos3(table=[0,1; 86400,1],
      tableOnFile=false) "Position of the shade"
    annotation (Placement(transformation(extent={{-314,364},{-294,384}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor conBel3(G=0.2)
    "Combined convection and radiation resistance below the slab"
    annotation (Placement(transformation(extent={{-182,280},{-162,300}})));
  Buildings.ThermalZones.Detailed.FLEXLAB.Rooms.X3A.TestCellRadiantInterior radInt(
    nConExtWin=0,
    nConBou=5,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyStateInitial,
    nPorts=2,
    redeclare package Medium = MediumA) "Radiant interior test cell"
    annotation (Placement(transformation(extent={{-224,332},{-184,372}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TIntSet1(k=294.3)
    "Interior setpoint"
    annotation (Placement(transformation(extent={{-546,-92},{-502,-48}})));
  Controls.OBC.CDL.Logical.Sources.Constant uNigFlu(k=false)
    "Night flush signal- constantly false"
    annotation (Placement(transformation(extent={{-480,-138},{-460,-118}})));
equation
  connect(TBel.port, conBel1.port_a) annotation (Line(points={{82,-108},{104,
          -108},{104,-86},{12,-86},{12,-50},{20,-50}},
                                color={191,0,0}));
  connect(conBel1.port_b, sla1.surf_b)
    annotation (Line(points={{40,-50},{50,-50},{50,-48},{58,-48},{58,-24},{10,
          -24},{10,2}},                                 color={191,0,0}));

  connect(booToReaHtgPum.y, pumHot.m_flow_in) annotation (Line(points={{-238,-70},
          {-238,-80},{-186,-80}}, color={0,0,127}));
  connect(booToReaClgPum.y, pumCol.m_flow_in) annotation (Line(points={{-40,-90},
          {-38,-90},{-38,-58},{-24,-58}}, color={0,0,127}));
  connect(booToReaClgVal.y, valCol.y) annotation (Line(points={{-40,-130},{-30,-130},
          {-30,-152},{-12,-152}}, color={0,0,127}));
  connect(temSup.port_b, sla1.port_a) annotation (Line(points={{-32,2},{-18,2},{
          -18,12},{-4,12}}, color={0,127,255}));
  connect(sla1.port_b, temRet.port_a) annotation (Line(points={{16,12},{28,12},
          {28,-12},{52,-12}},color={0,127,255}));
  connect(pumHot.port_b, temHea.port_a) annotation (Line(points={{-174,-70},{-174,
          -52},{-188,-52},{-188,-18}}, color={0,127,255}));
  connect(pumCol.port_b, temCoo.port_a) annotation (Line(points={{-12,-48},{-90,
          -48},{-90,-50}}, color={0,127,255}));
  connect(souHea.ports[1], temHeaSou.port_a) annotation (Line(points={{-172,-282},
          {-176,-282},{-176,-208},{-178,-208}}, color={0,127,255}));
  connect(temHeaSou.port_b, valHot.port_a) annotation (Line(points={{-178,-188},
          {-194,-188},{-194,-168},{-188,-168}}, color={0,127,255}));
  connect(valHot.port_b, temHeatingValSla.port_a) annotation (Line(points={{-168,
          -168},{-172,-168},{-172,-134},{-174,-134}}, color={0,127,255}));
  connect(temHeatingValSla.port_b, pumHot.port_a)
    annotation (Line(points={{-174,-114},{-174,-90}}, color={0,127,255}));
  connect(souCol.ports[1], temCooSouVal.port_a) annotation (Line(points={{-16,-280},
          {-24,-280},{-24,-204},{-28,-204}}, color={0,127,255}));
  connect(temCooSouVal.port_b, valCol.port_a) annotation (Line(points={{-28,-184},
          {-28,-164},{-22,-164}}, color={0,127,255}));
  connect(valCol.port_b, temCoolingValtoPump.port_a) annotation (Line(points={{-2,
          -164},{-6,-164},{-6,-122},{-10,-122}}, color={0,127,255}));
  connect(temCoolingValtoPump.port_b, pumCol.port_a) annotation (Line(points={{-10,
          -102},{-12,-102},{-12,-68}}, color={0,127,255}));
  connect(sla1.surf_a, temSlaTop.port) annotation (Line(points={{10,22},{-22,22},
          {-22,44},{-62,44}}, color={191,0,0}));
  connect(temCoo.port_b, mix2.port_3) annotation (Line(points={{-90,-30},{-108,-30},
          {-108,10},{-100,10}}, color={0,127,255}));
  connect(temHea.port_b, mix2.port_1)
    annotation (Line(points={{-188,2},{-188,20},{-90,20}}, color={0,127,255}));
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
          {-366,-93},{-366,-320},{-100,-320},{-100,-90},{-64,-90}}, color={255,0,
          255}));
  connect(conPluLoc.yCoo, booToReaClgVal.u) annotation (Line(points={{-378,-93},
          {-366,-93},{-366,-320},{-100,-320},{-100,-130},{-64,-130}}, color={255,
          0,255}));
  connect(temRet.T, conPluLoc.TSlaWatRet) annotation (Line(points={{41,-2},{41,230},
          {-478,230},{-478,-98},{-402,-98}}, color={0,0,127}));
  connect(temSlaTop.T, conPluLoc.TSla) annotation (Line(points={{-82,44},{-476,44},
          {-476,-82},{-402,-82}}, color={0,0,127}));
  connect(airCon1.y[1], airIn1.m_flow_in) annotation (Line(points={{-359,284},{-336,
          284},{-336,312},{-324,312}}, color={0,0,127}));
  connect(airCon1.y[2], airIn1.T_in) annotation (Line(points={{-359,284},{-336,284},
          {-336,308},{-324,308}}, color={0,0,127}));
  connect(TIntSet2.y, TOut1.T) annotation (Line(points={{-91.6,320},{-52,320},{
          -52,272},{-196,272},{-196,250},{-180,250}},
                           color={0,0,127}));
  connect(temRoo.port_b, airOut2.ports[1]) annotation (Line(points={{-152,214},{
          -152,224},{-18,224},{-18,192},{-44,192}}, color={0,127,255}));
  connect(conBel3.port_b, radInt.surf_conBou[1]) annotation (Line(points={{-162,
          290},{-148,290},{-148,335.2},{-198,335.2}},
                                           color={191,0,0}));
  connect(sla1.surf_a, radInt.surf_surBou[1]) annotation (Line(points={{10,22},{
          -260,22},{-260,338},{-207.8,338}}, color={191,0,0}));
  connect(airIn1.ports[1], radInt.ports[1]) annotation (Line(points={{-302,304},
          {-260,304},{-260,340},{-219,340}}, color={0,127,255}));
  connect(radInt.ports[2], temRoo.port_a) annotation (Line(points={{-219,344},{-230,
          344},{-230,168},{-152,168},{-152,194}}, color={0,127,255}));
  connect(intGai1.y, radInt.qGai_flow) annotation (Line(points={{-287,348},{-258,
          348},{-258,360},{-225.6,360}}, color={0,0,127}));
  connect(temRoo.T, conPluLoc.TRooAir) annotation (Line(points={{-163,204},{-270,
          204},{-270,228},{-480,228},{-480,-94},{-402,-94}}, color={0,0,127}));
  connect(TIntSet1.y, conPluLoc.TSlaSet) annotation (Line(points={{-497.6,-70},{
          -449.8,-70},{-449.8,-86},{-402,-86}}, color={0,0,127}));
  connect(uNigFlu.y, conPluLoc.uNigFlu) annotation (Line(points={{-458,-128},
          {-431,-128},{-431,-90},{-402,-90}}, color={255,0,255}));
  connect(TOut1.port, conBel3.port_a) annotation (Line(points={{-158,250},{-136,
          250},{-136,234},{-216,234},{-216,290},{-182,290}}, color={191,0,0}));
  annotation (Documentation(info="<html>
<p>
This models a radiant slab serving a core zone. 
The slab is controlled to 70F year round, following the control scheme specified in the 
(<a href=\"modelica://Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.ControlPlusLockouts\">Buildings.Controls.OBC.RadiantSystems.CoolingAndHeating.ControlPlusLockouts</a>) block.  
</p>
<p>
The zone is 5 meters by 9 meters in floor area and is 3 meters in height.
All walls are exposed to a constant-temperature boundary condition that is set to ~70<code>defF</code> to approximate interior conditions. The corresponding heat gains are:</p>
<ul>
<li> Standard office internal gains - 0.6 W/SF lighting (20% radiative, 80% convective), 0.6 W/SF plug loads (50% radiative, 50% convective)</li>
<li> 2 occupants (93 W/person sensible (50% radiative and 50% convective) and 74 W/person latent) 
</li>
</ul>
<p>
Gains are modeled with ASHRAE standard schedules for lighting, plug loads, and occupancy, respectively.
During occupied hours, the room receives ventilation air at approximately code minimum rate (~90 cfm). 
During unoccupied hours, the room receives a negligible amount of air.
</p>
<p>
Chilled water and hot water are provided to the slab by constant temperature flow sources, at 10<code>degC</code> (cooling) and 40<code>degC</code> (heating). 
</p>
</html>", revisions="<html>
<ul>
<li>
October 6, 2020, by Fiona Woods:<br/>
First implementation.
</li>
</ul>
</html>"),
   experiment(Tolerance=1e-6,  StartTime=0, StopTime=31536000),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/RadiantSystems/CoolingAndHeating/Validation/ControlPlusLockoutCore.mos" "Simulate and plot"),
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
    Diagram(coordinateSystem(extent={{-560,-380},{180,420}})));
end ControlPlusLockoutCore;

within Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump.Validation;
model HeatingMode
  "Validation model for heating mode operation of packaged terminal heat pump"
  extends Modelica.Icons.Example;

  replaceable package MediumA = Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialCondensingGases
    "Medium model for air";

  parameter Modelica.Units.SI.PressureDifference dpAir_nominal=75
    "Pressure drop at m_flow_nominal";

  parameter Modelica.Units.SI.PressureDifference dpDX_nominal=75
    "Pressure drop at m_flow_nominal";

  parameter Modelica.Units.SI.Time averagingTimestep = 3600
    "Time-step used to average out Modelica results for comparison with EPlus results. Same val;ue is also applied to unit delay shift on EPlus power value";

  parameter Modelica.Units.SI.Time delayTimestep = 3600
    "Time-step used to unit delay shift on EPlus power value";

  parameter Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.CoilHeatTransfer datHeaCoi(
    is_CooCoi=false,
    sta={
      Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.Stage(
        spe=1800/60,
        nomVal=
          Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=7144.01,
          COP_nominal=2.75,
          SHR_nominal=1,
          m_flow_nominal=0.5075,
          TEvaIn_nominal=273.15 + 6,
          TConIn_nominal=273.15 + 21),
        perCur=
          Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Examples.PerformanceCurves.DXHeating_Curve_II())},
    nSta=1)
    "Heating coil data"
    annotation (Placement(transformation(extent={{60,90},{80,110}})));

  parameter
    Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.CoolingCoil datCooCoi(
    sta={
      Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.Stage(
        spe=1800,
        nomVal=
          Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-7144.01,
          COP_nominal=3.0,
          SHR_nominal=0.8,
          m_flow_nominal=0.5075),
        perCur=
          Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.PerformanceCurve(
          capFunT={0.942587793,0.009543347,0.00068377,-0.011042676,0.000005249,-0.00000972},
          capFunFF={0.8,0.2,0},
          EIRFunT={0.342414409,0.034885008,-0.0006237,0.004977216,0.000437951,-0.000728028},
          EIRFunFF={1.1552,-0.1808,0.0256},
          TConInMin=273.15 + 18,
          TConInMax=273.15 + 46.11,
          TEvaInMin=273.15 + 12.78,
          TEvaInMax=273.15 + 23.89,
          ffMin=0.875,
          ffMax=1.125))},
    nSta=1)
    "Cooling coil data"
    annotation (Placement(transformation(extent={{30,90},{50,110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant damPos(
    final k=0.2)
    "Outdoor air damper position"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));

  Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump.PackagedTerminalHeatPump
    pthp(
    final QSup_flow_nominal=5600.34,
    final dpCooDX_nominal= 0,
    final dpHeaDX_nominal= 0,
    final dpSupHea_nominal= 0,
    SupHeaCoi(
      final tau=3600),
    redeclare package MediumA = MediumA,
    final mAirOut_flow_nominal=0.5075,
    final mAir_flow_nominal=0.5075,
    final dpAir_nominal= dpAir_nominal,
    datHeaCoi=datHeaCoi,
    redeclare
      Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump.Validation.Data.FanData
      fanPer,
    datCooCoi=datCooCoi,
    datDef=datDef)
    "Packaged terminal heat pump instance"
    annotation (Placement(transformation(extent={{-16,-26},{24,14}})));

  Modelica.Blocks.Sources.CombiTimeTable datRea(
    final tableOnFile=true,
    final fileName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Fluid/ZoneEquipment/PackagedTerminalHeatPump/HeatingMode/1ZonePTHP.dat"),
    final columns=2:32,
    final tableName="EnergyPlus",
    final smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments)
    "Reader for energy plus reference results"
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));

  Buildings.Controls.OBC.CDL.Continuous.AddParameter K2C[4](
    final p=fill(273.15,4))
    "Convert temperature from Celsius to Kelvin "
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));

  Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump.Controls.CyclingFanCyclingCoil
    conCycFanCycCoi(
    final heaCoiTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.HeaSou.heaPum,
    final cooCoiTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.CooSou.heaPum,
    final tFanEna=60,
    final dTHys=0.1)
    "Cycling fan-cycling coil controller"
    annotation (Placement(transformation(extent={{-80,-78},{-60,-50}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ava(
    final k=true)
    "Availability signal"
    annotation (Placement(transformation(extent={{-130,-60},{-110,-40}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fanOpeMod(
    final k=false)
    "Fan operating mode"
    annotation (Placement(transformation(extent={{-130,-90},{-110,-70}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis fanProOn(
    final uLow=0.04,
    final uHigh=0.05)
    "Check if fan is proven on based off of measured fan speed"
    annotation (Placement(transformation(extent={{34,0},{54,20}})));

  inner Buildings.ThermalZones.EnergyPlus_9_6_0.Building building(
    idfName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Fluid/ZoneEquipment/PackagedTerminalHeatPump/HeatingMode/1ZonePTHP.idf"),
    epwName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw"),
    weaName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Building instance for thermal zone"
    annotation (Placement(transformation(extent={{-20,120},{0,140}})));

  Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone zon(
    zoneName="West Zone",
    redeclare package Medium = MediumA,
    final nPorts=2)
    "Thermal zone model"
    annotation (Placement(transformation(extent={{58,30},{98,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con[3](
    final k=fill(0, 3))
    "Zero signal for internal thermal loads"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));

  Modelica.Blocks.Math.Mean powFanMod(
    final f=1/averagingTimestep)
    "Average out Modelica results over time"
    annotation (Placement(transformation(extent={{156,-140},{176,-120}})));

  Modelica.Blocks.Sources.RealExpression realExpression1(
    final y=pthp.fan.P)
    "Fan power consumption (Modelica)"
    annotation (Placement(transformation(extent={{120,-140},{140,-120}})));

  Modelica.Blocks.Sources.RealExpression realExpression2(
    final y=pthp.fan.m_flow)
    "Fan mass flow rate (Modelica)"
    annotation (Placement(transformation(extent={{120,120},{140,140}})));

  Modelica.Blocks.Math.Mean m_flowFan(
    final f=1/averagingTimestep)
    "Average out Modelica results over time"
    annotation (Placement(transformation(extent={{156,120},{176,140}})));

  Modelica.Blocks.Sources.RealExpression realExpression3(
    final y=pthp.TAirLvg.T-273.15)
    "Leaving air temperature (Modelica)"
    annotation (Placement(transformation(extent={{120,84},{140,104}})));

  Modelica.Blocks.Math.Mean TAirLvgMod(
    final f=1/averagingTimestep)
    "Average out Modelica results over time"
    annotation (Placement(transformation(extent={{156,84},{176,104}})));

  Modelica.Blocks.Sources.RealExpression realExpression4(
    final y=pthp.TAirMix.T-273.15)
    "Mixed air temperature (Modelica)"
    annotation (Placement(transformation(extent={{120,56},{140,76}})));

  Modelica.Blocks.Math.Mean TAirMixMod(
    final f=1/averagingTimestep)
    "Average out Modelica results over time"
    annotation (Placement(transformation(extent={{156,56},{176,76}})));

  Modelica.Blocks.Math.Mean QHeaCoiMod(
    final f=1/averagingTimestep)
    "Average out Modelica results over time"
    annotation (Placement(transformation(extent={{156,26},{176,46}})));

  Modelica.Blocks.Sources.RealExpression realExpression5(
    final y=pthp.HeaCoi.QSen_flow)
    "Heating coil heat transfer rate (Modelica)"
    annotation (Placement(transformation(extent={{120,26},{140,46}})));

  Modelica.Blocks.Sources.RealExpression realExpression6(
    final y=zon.TAir - 273.15)
    "Zone air temperature (Modelica)"
    annotation (Placement(transformation(extent={{120,-30},{140,-10}})));

  Modelica.Blocks.Math.Mean TZonAirMod(
    final f=1/averagingTimestep)
    "Average out Modelica results over time"
    annotation (Placement(transformation(extent={{156,-30},{176,-10}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay TZonAirEP(
    final samplePeriod=delayTimestep)
    "Unit delay on EnergyPlus results"
    annotation (Placement(transformation(extent={{234,-30},{254,-10}})));

  Modelica.Blocks.Sources.RealExpression realExpression7(
    final y=datRea.y[28])
    "Zone air temperature (EnergyPlus)"
    annotation (Placement(transformation(extent={{200,-30},{220,-10}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay m_flowFanEP(
    final samplePeriod=delayTimestep)
    "Unit delay on EnergyPlus results"
    annotation (Placement(transformation(extent={{234,120},{254,140}})));

  Modelica.Blocks.Sources.RealExpression realExpression9(
    final y=datRea.y[30])
    "Fan mass flow rate (EnergyPlus)"
    annotation (Placement(transformation(extent={{200,120},{220,140}})));

  Modelica.Blocks.Sources.RealExpression realExpression12(
    final y=datRea.y[6])
    "Heating coil heat transfer rate (EnergyPlus)"
    annotation (Placement(transformation(extent={{200,28},{220,48}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay QHeaCoiEP(
    final samplePeriod=delayTimestep)
    "Unit delay on EnergyPlus results"
    annotation (Placement(transformation(extent={{234,28},{254,48}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay TAirLvgEP(
    final samplePeriod=delayTimestep)
    "Unit delay on EnergyPlus results"
    annotation (Placement(transformation(extent={{234,84},{254,104}})));

  Modelica.Blocks.Sources.RealExpression realExpression14(
    final y=datRea.y[23])
    "Leaving air temperature (EnergyPlus)"
    annotation (Placement(transformation(extent={{200,84},{220,104}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay TAirMixEP(
    final samplePeriod=delayTimestep)
    "Unit delay on EnergyPlus results"
    annotation (Placement(transformation(extent={{234,56},{254,76}})));

  Modelica.Blocks.Sources.RealExpression realExpression15(
    final y=datRea.y[20])
    "Mixed air temperature (EnergyPlus)"
    annotation (Placement(transformation(extent={{200,56},{220,76}})));

  Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump.Controls.SupplementalHeating
    conSupHea(
    final k=0.1)
    "Supplementary heating controller"
    annotation (Placement(transformation(extent={{-84,-12},{-60,12}})));

  Buildings.BoundaryConditions.WeatherData.Bus weaBus
    "Weather bus"
    annotation (Placement(transformation(extent={{18,110},{58,150}}),
      iconTransformation(extent={{-168,170},{-148,190}})));

  Modelica.Blocks.Routing.RealPassThrough TOut
    "Outdoor air drybulb temperature"
    annotation (Placement(transformation(extent={{62,120},{82,140}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay powHeaCoiEP(
    final samplePeriod=delayTimestep)
    "Unit delay on EnergyPlus results"
    annotation (Placement(transformation(extent={{234,-60},{254,-40}})));

  Modelica.Blocks.Sources.RealExpression realExpression16(
    final y=datRea.y[7])
    "Heating coil power consumption (EnergyPlus)"
    annotation (Placement(transformation(extent={{200,-60},{220,-40}})));

  Modelica.Blocks.Math.Mean powHeaCoiMod(
    final f=1/averagingTimestep)
    "Average out Modelica results over time"
    annotation (Placement(transformation(extent={{156,-62},{176,-42}})));

  Modelica.Blocks.Sources.RealExpression realExpression17(
    final y=pthp.HeaCoi.P)
    "Heating coil power consumption (Modelica)"
    annotation (Placement(transformation(extent={{120,-62},{140,-42}})));

  Modelica.Blocks.Sources.RealExpression realExpression10(
    final y=pthp.CooCoi.P)
    "Cooling coil power consumption (Modelica)"
    annotation (Placement(transformation(extent={{120,-116},{140,-96}})));

  Modelica.Blocks.Math.Mean powCooCoiMod(
    final f=1/averagingTimestep)
    "Average out Modelica results over time"
    annotation (Placement(transformation(extent={{156,-116},{176,-96}})));

  Modelica.Blocks.Sources.RealExpression realExpression11(
    final y=datRea.y[4])
    "Cooling coil power consumption"
    annotation (Placement(transformation(extent={{200,-114},{220,-94}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay powCooCoiEP(
    final samplePeriod=delayTimestep)
    "Unit delay on EnergyPlus results"
    annotation (Placement(transformation(extent={{234,-114},{254,-94}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay powFanEP(
    final samplePeriod=delayTimestep)
    "Unit delay on EnergyPlus results"
    annotation (Placement(transformation(extent={{234,-140},{254,-120}})));

  Modelica.Blocks.Sources.RealExpression realExpression18(
    final y=datRea.y[29])
    "Fan power consumption (EnergyPlus)"
    annotation (Placement(transformation(extent={{200,-140},{220,-120}})));

  Modelica.Blocks.Sources.RealExpression realExpression19(
    final y=pthp.SupHeaCoi.Q_flow)
    "Heat transferred to airloop by supplementary heating coil"
    annotation (Placement(transformation(extent={{-40,-140},{-20,-120}})));

  Modelica.Blocks.Math.Mean powSupHeaMod(
    final f=1/averagingTimestep)
    "Average out Modelica results over time"
    annotation (Placement(transformation(extent={{0,-140},{20,-120}})));

  Modelica.Blocks.Sources.RealExpression realExpression20(
    final y=datRea.y[10])
    "Heat transferred by supplementary heating coil (EnergyPlus)"
    annotation (Placement(transformation(extent={{40,-140},{60,-120}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay powSupHeaEP(
    final samplePeriod=delayTimestep)
    "Unit delay on EnergyPlus results"
    annotation (Placement(transformation(extent={{80,-140},{100,-120}})));

  Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Examples.PerformanceCurves.DXHeating_DefrostCurve
    datDef(
    final defOpe=Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Types.DefrostOperation.resistive,
    final defTri=Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Types.DefrostTimeMethods.timed,
    final tDefRun=0.1666,
    final QDefResCap=10500,
    final QCraCap=200)
    "Defrost data"
    annotation (Placement(transformation(extent={{-20,94},{0,114}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Convert fan enable signal to real value"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));

equation
  connect(ava.y, conCycFanCycCoi.uAva) annotation (Line(points={{-108,-50},{
          -100,-50},{-100,-68},{-82,-68}},      color={255,0,255}));
  connect(fanOpeMod.y, conCycFanCycCoi.fanOpeMod) annotation (Line(points={{-108,
          -80},{-100,-80},{-100,-72},{-82,-72}},           color={255,0,255}));
  connect(pthp.yFan_actual, fanProOn.u) annotation (Line(points={{25,10},{32,10}},
                            color={0,0,127}));
  connect(datRea.y[20], K2C[1].u) annotation (Line(points={{-99,90},{-82,90}},
                         color={0,0,127}));
  connect(datRea.y[26], K2C[2].u) annotation (Line(points={{-99,90},{-82,90}},
                         color={0,0,127}));
  connect(datRea.y[27], K2C[3].u) annotation (Line(points={{-99,90},{-82,90}},
                         color={0,0,127}));
  connect(datRea.y[28], K2C[4].u) annotation (Line(points={{-99,90},{-82,90}},
                         color={0,0,127}));
  connect(conCycFanCycCoi.THeaSet, K2C[2].y) annotation (Line(points={{-82,-64},
          {-96,-64},{-96,34},{-42,34},{-42,90},{-58,90}},        color={0,0,127}));
  connect(K2C[3].y, conCycFanCycCoi.TCooSet) annotation (Line(points={{-58,90},{
          -46,90},{-46,36},{-98,36},{-98,-60},{-82,-60}},             color={0,0,
          127}));
  connect(pthp.port_Air_a2, zon.ports[1])
    annotation (Line(points={{24,-2},{76,-2},{76,30.9}},
                                                       color={0,127,255}));
  connect(pthp.port_Air_b2, zon.ports[2])
    annotation (Line(points={{24,-10},{80,-10},{80,30.9}},
                                                         color={0,127,255}));
  connect(con.y, zon.qGai_flow) annotation (Line(points={{22,40},{40,40},{40,60},
          {56,60}}, color={0,0,127}));
  connect(zon.TAir, conCycFanCycCoi.TZon) annotation (Line(points={{99,68},{108,
          68},{108,-98},{-100,-98},{-100,-56},{-82,-56}},           color={0,0,127}));
  connect(pthp.TAirSup, conCycFanCycCoi.TSup) annotation (Line(points={{25,4},{
          30,4},{30,-88},{-96,-88},{-96,-76},{-82,-76}},        color={0,0,127}));
  connect(realExpression1.y,powFanMod. u)
    annotation (Line(points={{141,-130},{154,-130}},
                                                 color={0,0,127}));
  connect(realExpression2.y, m_flowFan.u)
    annotation (Line(points={{141,130},{154,130}},
                                                 color={0,0,127}));
  connect(realExpression3.y, TAirLvgMod.u)
    annotation (Line(points={{141,94},{154,94}},
                                               color={0,0,127}));
  connect(realExpression4.y, TAirMixMod.u)
    annotation (Line(points={{141,66},{154,66}},   color={0,0,127}));
  connect(realExpression5.y,QHeaCoiMod. u)
    annotation (Line(points={{141,36},{154,36}},   color={0,0,127}));
  connect(realExpression6.y, TZonAirMod.u)
    annotation (Line(points={{141,-20},{154,-20}}, color={0,0,127}));
  connect(damPos.y,pthp. uEco) annotation (Line(points={{-98,50},{-58,50},{-58,12},
          {-18,12}}, color={0,0,127}));
  connect(realExpression7.y, TZonAirEP.u)
    annotation (Line(points={{221,-20},{232,-20}}, color={0,0,127}));
  connect(realExpression9.y, m_flowFanEP.u)
    annotation (Line(points={{221,130},{232,130}},
                                                 color={0,0,127}));
  connect(realExpression12.y, QHeaCoiEP.u)
    annotation (Line(points={{221,38},{232,38}}, color={0,0,127}));

  connect(conCycFanCycCoi.yCooEna,pthp. uCooEna) annotation (Line(points={{-58,-54},
          {-28,-54},{-28,-15.8},{-18,-15.8}},                color={255,0,255}));
  connect(fanProOn.y, conCycFanCycCoi.uFan) annotation (Line(points={{56,10},{
          60,10},{60,-94},{-102,-94},{-102,-52},{-82,-52}},        color={255,0,
          255}));
  connect(realExpression14.y, TAirLvgEP.u)
    annotation (Line(points={{221,94},{232,94}}, color={0,0,127}));
  connect(realExpression15.y, TAirMixEP.u)
    annotation (Line(points={{221,66},{232,66}}, color={0,0,127}));
  connect(conSupHea.ySupHea,pthp. uSupHea) annotation (Line(points={{-57.6,2.4},
          {-40,2.4},{-40,-20},{-18,-20}},     color={0,0,127}));
  connect(zon.TAir, conSupHea.TZon) annotation (Line(points={{99,68},{108,68},{108,
          -98},{-100,-98},{-100,4.8},{-86.4,4.8}},color={0,0,127}));
  connect(conSupHea.TSetHea, K2C[2].y) annotation (Line(points={{-86.4,9.6},{-94,
          9.6},{-94,32},{-38,32},{-38,90},{-58,90}},            color={0,0,127}));
  connect(building.weaBus,pthp. weaBus) annotation (Line(
      points={{0,130},{14,130},{14,66},{-11.8,66},{-11.8,12}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus, building.weaBus) annotation (Line(
      points={{38,130},{0,130}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(weaBus.TDryBul, TOut.u) annotation (Line(
      points={{38,130},{60,130}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(TOut.y, conSupHea.TOut) annotation (Line(points={{83,130},{100,130},{100,
          86},{-36,86},{-36,30},{-92,30},{-92,0},{-86.4,0}},
        color={0,0,127}));
  connect(realExpression16.y, powHeaCoiEP.u)
    annotation (Line(points={{221,-50},{232,-50}}, color={0,0,127}));
  connect(realExpression17.y, powHeaCoiMod.u)
    annotation (Line(points={{141,-52},{154,-52}}, color={0,0,127}));
  connect(realExpression10.y, powCooCoiMod.u)
    annotation (Line(points={{141,-106},{154,-106}}, color={0,0,127}));
  connect(realExpression11.y, powCooCoiEP.u)
    annotation (Line(points={{221,-104},{232,-104}}, color={0,0,127}));
  connect(realExpression18.y, powFanEP.u)
    annotation (Line(points={{221,-130},{232,-130}}, color={0,0,127}));
  connect(conSupHea.yHeaEna,pthp. uHeaEna) annotation (Line(points={{-57.6,-2.4},
          {-42,-2.4},{-42,-24},{-30,-24},{-30,-23.8},{-18,-23.8}},
                                             color={255,0,255}));
  connect(conCycFanCycCoi.yHeaEna, conSupHea.uHeaEna) annotation (Line(points={{-58,-58},
          {-56,-58},{-56,-20},{-92,-20},{-92,-9.6},{-86.4,-9.6}},
                color={255,0,255}));
  connect(realExpression19.y, powSupHeaMod.u)
    annotation (Line(points={{-19,-130},{-2,-130}}, color={0,0,127}));
  connect(realExpression20.y, powSupHeaEP.u)
    annotation (Line(points={{61,-130},{78,-130}}, color={0,0,127}));
  connect(conCycFanCycCoi.yHeaMod, conSupHea.uHeaMod) annotation (Line(points={{-58,-77},
          {-50,-77},{-50,-24},{-88,-24},{-88,-4.8},{-86.4,-4.8}},
                      color={255,0,255}));
  connect(conCycFanCycCoi.yFan, booToRea.u) annotation (Line(points={{-58,-74},
          {-48,-74},{-48,-70},{-42,-70}}, color={255,0,255}));
  connect(booToRea.y,pthp. uFan) annotation (Line(points={{-18,-70},{-10,-70},{
          -10,-40},{-34,-40},{-34,4},{-18,4}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{260,
            140}}), graphics={Polygon(points={{-48,-16},{-48,-16}}, lineColor={28,
              108,200})}),
    experiment(
      Tolerance=1e-06),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/ZoneEquipment/PackagedTerminalHeatPump/Validation/HeatingMode.mos"
        "Simulate and plot"),
    Documentation(info="<html>
    <p>
    This is an example model for the PTHP system model under heating mode 
    with a cycling fan cycling coil (AUTO Fan) controller and a supplementary 
    heating controller. It consists of: </p>
<ul>
<li>
an instance of the PTHP system model <code>fanCoiUni</code>. 
</li>
<li>
thermal zone model <code>zon</code> of class 
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone\">
Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone</a>. 
</li>
<li>
PTHP controller <code>cycFanCycCoi</code> of class 
<a href=\"modelica://Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump.Controls.CyclingFanCyclingCoil\">
Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump.Controls.CyclingFanCyclingCoil</a>. 
</li>
<li>
zone temperature setpoint controller <code>TZonSet</code>. 
</li>
</ul>
<p>The simulation model provides a closed-loop example of <code>PTHP</code> that 
is operated by <code>cycFanCycCoi</code> and regulates the zone temperature in 
<code>zon</code> at the setpoint generated by <code>TZonSet</code>. 
</p>
</html>
", revisions="<html>
    <ul>
    <li>
    April 10, 2023, by Xing Lu and Karthik Devaprasad:<br/>
    First implementation.
    </li>
    </ul>
    </html>"));
end HeatingMode;

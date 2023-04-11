within Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump.Validation;
model CoolingMode
  "Validation model for cooling mode operation of packaged terminal heat pump"
  extends Modelica.Icons.Example;

  replaceable package MediumA = Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialCondensingGases
    "Medium model for air";

  parameter Modelica.Units.SI.PressureDifference dpAir_nominal=75
    "Pressure drop at m_flow_nominal";

  parameter Modelica.Units.SI.PressureDifference dpDX_nominal=75
    "Pressure drop at m_flow_nominal";

  parameter Modelica.Units.SI.Time averagingTimestep = 3600
    "Time-step used to average out Modelica results for comparison with EPlus 
    results. Same value is also applied to unit delay shift on EPlus power value";

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
    final fileName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Fluid/ZoneEquipment/PackagedTerminalHeatPump/CoolingMode/1ZonePTHP.dat"),
    final columns=2:32,
    final tableName="EnergyPlus",
    final smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments)
    "Reader for EnergyPlus reference results"
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));

  Buildings.Controls.OBC.CDL.Continuous.AddParameter K2C[4](
    final p=fill(273.15,4))
    "Convert temperature from Celsius to Kelvin "
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));

  Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump.Controls.CyclingFanCyclingCoil
    conCycFanCycCoi(
    final heaCoiTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.HeaSou.ele,
    final cooCoiTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.CooSou.heaPum,
    final tFanEna=60,
    final dTHys=0.1)
    "Cycling fan-cycling coil controller"
    annotation (Placement(transformation(extent={{-86,-78},{-66,-50}})));

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
    idfName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Fluid/ZoneEquipment/PackagedTerminalHeatPump/CoolingMode/1ZonePTHP.idf"),
    epwName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw"),
    weaName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Building instance for thermal zone"
    annotation (Placement(transformation(extent={{-20,120},{0,140}})));

  Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone zon(
    final zoneName="West Zone",
    redeclare package Medium = MediumA,
    final T_start=295.15,
    final nPorts=2)
    "Thermal zone model"
    annotation (Placement(transformation(extent={{58,30},{98,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con[3](
    final k=fill(0, 3)) "Constant zero source for internal heat gains"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));

  Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump.Controls.SupplementalHeating conSupHea(
    final k=0.1)
    "Supplementary heating controller"
    annotation (Placement(transformation(extent={{-80,-14},{-60,6}})));

  Buildings.BoundaryConditions.WeatherData.Bus weaBus
    "Weather bus"
    annotation (Placement(transformation(extent={{18,110},{58,150}}),
      iconTransformation(extent={{-168,170},{-148,190}})));

  Modelica.Blocks.Routing.RealPassThrough TOut
    "Outdoor air drybulb temperature"
    annotation (Placement(transformation(extent={{60,120},{80,140}})));

  Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Examples.PerformanceCurves.DXHeating_DefrostCurve
    datDef(
    final defOpe=Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Types.DefrostOperation.resistive,
    final defTri=Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Types.DefrostTimeMethods.timed,
    final tDefRun=0.1666,
    final QDefResCap=10500,
    final QCraCap=200)
    "Defrost data"
    annotation (Placement(transformation(extent={{-20,92},{0,112}})));

  Modelica.Blocks.Math.Mean powFanMod(
    final f=1/averagingTimestep)
    "Average out Modelica results over time"
    annotation (Placement(transformation(extent={{156,-142},{176,-122}})));

  Modelica.Blocks.Sources.RealExpression realExpression1(
    final y=pthp.fan.P)
    "Fan power consumption (Modelica)"
    annotation (Placement(transformation(extent={{120,-142},{140,-122}})));

  Modelica.Blocks.Sources.RealExpression realExpression2(
    final y=pthp.fan.m_flow)
    "Fan mass flow rate (Modelica)"
    annotation (Placement(transformation(extent={{120,118},{140,138}})));

  Modelica.Blocks.Math.Mean m_flowFan(
    final f=1/averagingTimestep)
    "Average out Modelica results over time"
    annotation (Placement(transformation(extent={{156,118},{176,138}})));

  Modelica.Blocks.Sources.RealExpression realExpression3(
    final y=pthp.TAirLvg.T - 273.15)
    "Leaving air temperature (Modelica)"
    annotation (Placement(transformation(extent={{120,82},{140,102}})));

  Modelica.Blocks.Math.Mean TAirLvgMod(
    final f=1/averagingTimestep)
    "Average out Modelica results over time"
    annotation (Placement(transformation(extent={{156,82},{176,102}})));

  Modelica.Blocks.Sources.RealExpression realExpression4(
    final y=pthp.TAirMix.T - 273.15)
    "Mixed air temperature (Modelica)"
    annotation (Placement(transformation(extent={{120,54},{140,74}})));

  Modelica.Blocks.Math.Mean TAirMixMod(
    final f=1/averagingTimestep)
    "Average out Modelica results over time"
    annotation (Placement(transformation(extent={{156,54},{176,74}})));

  Modelica.Blocks.Math.Mean QHeaCoiMod(
    final f=1/averagingTimestep)
    "Average out Modelica results over time"
    annotation (Placement(transformation(extent={{156,24},{176,44}})));

  Modelica.Blocks.Sources.RealExpression realExpression5(
    final y=pthp.HeaCoi.QSen_flow)
    "Heating coil heat transfer rate (Modelica)"
    annotation (Placement(transformation(extent={{120,24},{140,44}})));

  Modelica.Blocks.Sources.RealExpression realExpression6(
    final y=zon.TAir - 273.15)
    "Zone air temperature (Modelica)"
    annotation (Placement(transformation(extent={{120,-32},{140,-12}})));

  Modelica.Blocks.Math.Mean TZonAirMod(
    final f=1/averagingTimestep)
    "Average out Modelica results over time"
    annotation (Placement(transformation(extent={{156,-32},{176,-12}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay TZonAirEP(
    final samplePeriod=delayTimestep)
    "Unit delay on EnergyPlus results"
    annotation (Placement(transformation(extent={{234,-32},{254,-12}})));

  Modelica.Blocks.Sources.RealExpression realExpression7(
    final y=datRea.y[28])
    "Zone air temperature (EnergyPlus)"
    annotation (Placement(transformation(extent={{200,-32},{220,-12}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay m_flowFanEP(
    final samplePeriod=delayTimestep)
    "Unit delay on EnergyPlus results"
    annotation (Placement(transformation(extent={{234,118},{254,138}})));

  Modelica.Blocks.Sources.RealExpression realExpression9(
    final y=datRea.y[30])
    "Fan mass flow rate (EnergyPlus)"
    annotation (Placement(transformation(extent={{200,118},{220,138}})));

  Modelica.Blocks.Sources.RealExpression realExpression12(
    final y=datRea.y[6])
    "Heating coil heat transfer rate (EnergyPlus)"
    annotation (Placement(transformation(extent={{200,26},{220,46}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay QHeaCoiEP(
    final samplePeriod=delayTimestep)
    "Unit delay on EnergyPlus results"
    annotation (Placement(transformation(extent={{234,26},{254,46}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay TAirLvgEP(
    final samplePeriod=delayTimestep)
    "Unit delay on EnergyPlus results"
    annotation (Placement(transformation(extent={{234,82},{254,102}})));

  Modelica.Blocks.Sources.RealExpression realExpression14(
    final y=datRea.y[23])
    "Leaving air temperature (EnergyPlus)"
    annotation (Placement(transformation(extent={{200,82},{220,102}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay TAirMixEP(
    final samplePeriod=delayTimestep)
    "Unit delay on EnergyPlus results"
    annotation (Placement(transformation(extent={{234,54},{254,74}})));

  Modelica.Blocks.Sources.RealExpression realExpression15(
    final y=datRea.y[20])
    "Mixed air temperature (EnergyPlus)"
    annotation (Placement(transformation(extent={{200,54},{220,74}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay powHeaCoiEP(final samplePeriod=
        delayTimestep) "Unit delay on EnergyPlus results"
    annotation (Placement(transformation(extent={{234,-62},{254,-42}})));

  Modelica.Blocks.Sources.RealExpression realExpression16(
    final y=datRea.y[7])
    "Heating coil power consumption (EnergyPlus)"
    annotation (Placement(transformation(extent={{200,-62},{220,-42}})));

  Modelica.Blocks.Math.Mean powHeaCoiMod(
    final f=1/averagingTimestep)
    "Average out Modelica results over time"
    annotation (Placement(transformation(extent={{156,-64},{176,-44}})));

  Modelica.Blocks.Sources.RealExpression realExpression17(
    final y=pthp.HeaCoi.P)
    "Heating coil power consumption (Modelica)"
    annotation (Placement(transformation(extent={{120,-64},{140,-44}})));

  Modelica.Blocks.Sources.RealExpression realExpression10(
    final y=pthp.CooCoi.P)
    "Cooling coil power consumption (Modelica)"
    annotation (Placement(transformation(extent={{120,-118},{140,-98}})));

  Modelica.Blocks.Math.Mean powCooCoiMod(
    final f=1/averagingTimestep)
    "Average out Modelica results over time"
    annotation (Placement(transformation(extent={{156,-118},{176,-98}})));

  Modelica.Blocks.Sources.RealExpression realExpression11(
    final y=datRea.y[4])
    "Cooling coil power consumption"
    annotation (Placement(transformation(extent={{200,-116},{220,-96}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay powCooCoiEP(
    final samplePeriod=delayTimestep)
    "Unit delay on EnergyPlus results"
    annotation (Placement(transformation(extent={{234,-116},{254,-96}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay powFanEP(
    final samplePeriod=delayTimestep)
    "Unit delay on EnergyPlus results"
    annotation (Placement(transformation(extent={{234,-142},{254,-122}})));

  Modelica.Blocks.Sources.RealExpression realExpression18(
    final y=datRea.y[29])
    "Fan power consumption (EnergyPlus)"
    annotation (Placement(transformation(extent={{200,-142},{220,-122}})));

  Modelica.Blocks.Sources.RealExpression realExpression19(
    final y=pthp.SupHeaCoi.Q_flow)
    "Heat transferred to airloop by supplementary heating coil"
    annotation (Placement(transformation(extent={{-40,-142},{-20,-122}})));

  Modelica.Blocks.Math.Mean powSupHeaMod(
    final f=1/averagingTimestep)
    "Average out Modelica results over time"
    annotation (Placement(transformation(extent={{0,-142},{20,-122}})));

  Modelica.Blocks.Sources.RealExpression realExpression20(
    final y=datRea.y[10])
    "Heat transferred by supplementary heating coil (EnergyPlus)"
    annotation (Placement(transformation(extent={{40,-142},{60,-122}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay powSupHeaEP(
    final samplePeriod=delayTimestep)
    "Unit delay on EnergyPlus results"
    annotation (Placement(transformation(extent={{80,-142},{100,-122}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaFanEna
    "Convert fan enable signal to real value"
    annotation (Placement(transformation(extent={{-30,-80},{-10,-60}})));

equation
  connect(ava.y,conCycFanCycCoi. uAva) annotation (Line(points={{-108,-50},{-100,
          -50},{-100,-68},{-88,-68}},      color={255,0,255}));
  connect(fanOpeMod.y,conCycFanCycCoi. fanOpeMod) annotation (Line(points={{-108,
          -80},{-100,-80},{-100,-72},{-88,-72}},      color={255,0,255}));
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
  connect(conCycFanCycCoi.THeaSet, K2C[2].y) annotation (Line(points={{-88,-64},
          {-96,-64},{-96,34},{-42,34},{-42,90},{-58,90}},   color={0,0,127}));
  connect(K2C[3].y,conCycFanCycCoi. TCooSet) annotation (Line(points={{-58,90},{
          -46,90},{-46,36},{-98,36},{-98,-60},{-88,-60}},   color={0,0,127}));
  connect(pthp.port_Air_a2, zon.ports[1])
    annotation (Line(points={{24,-2},{76,-2},{76,30.9}},
                                                       color={0,127,255}));
  connect(pthp.port_Air_b2, zon.ports[2])
    annotation (Line(points={{24,-10},{80,-10},{80,30.9}},
                                                         color={0,127,255}));
  connect(con.y, zon.qGai_flow) annotation (Line(points={{22,40},{40,40},{40,60},
          {56,60}}, color={0,0,127}));
  connect(zon.TAir,conCycFanCycCoi. TZon) annotation (Line(points={{99,68},{108,
          68},{108,-98},{-100,-98},{-100,-56},{-88,-56}},
                                                        color={0,0,127}));
  connect(pthp.TAirSup,conCycFanCycCoi. TSup) annotation (Line(points={{25,4},{30,
          4},{30,-88},{-96,-88},{-96,-76},{-88,-76}},    color={0,0,127}));
  connect(damPos.y,pthp. uEco) annotation (Line(points={{-98,50},{-58,50},{-58,12},
          {-18,12}}, color={0,0,127}));

  connect(conCycFanCycCoi.yCooEna,pthp. uCooEna) annotation (Line(points={{-64,-54},
          {-36,-54},{-36,-15.8},{-18,-15.8}},                color={255,0,255}));
  connect(fanProOn.y,conCycFanCycCoi. uFan) annotation (Line(points={{56,10},{60,
          10},{60,-94},{-102,-94},{-102,-52},{-88,-52}},           color={255,0,
          255}));
  connect(conSupHea.ySupHea, pthp.uSupHea) annotation (Line(points={{-58,-2},{-40,
          -2},{-40,-20},{-18,-20}}, color={0,0,127}));
  connect(zon.TAir, conSupHea.TZon) annotation (Line(points={{99,68},{108,68},{108,
          -98},{-100,-98},{-100,0},{-82,0}}, color={0,0,127}));
  connect(conSupHea.TSetHea, K2C[2].y) annotation (Line(points={{-82,4},{-94,4},
          {-94,32},{-38,32},{-38,90},{-58,90}}, color={0,0,127}));
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
      points={{38,130},{58,130}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(TOut.y, conSupHea.TOut) annotation (Line(points={{81,130},{100,130},{100,
          86},{-36,86},{-36,30},{-92,30},{-92,-4},{-82,-4}}, color={0,0,127}));
  connect(conSupHea.yHeaEna, pthp.uHeaEna) annotation (Line(points={{-58,-6},{-38,
          -6},{-38,-23.8},{-18,-23.8}}, color={255,0,255}));
  connect(conCycFanCycCoi.yHeaEna, conSupHea.uHeaEna) annotation (Line(points={{
          -64,-58},{-44,-58},{-44,-20},{-92,-20},{-92,-12},{-82,-12}}, color={255,
          0,255}));
  connect(conCycFanCycCoi.yHeaMod, conSupHea.uHeaMod) annotation (Line(points={{
          -64,-77},{-42,-77},{-42,-18},{-90,-18},{-90,-8},{-82,-8}}, color={255,
          0,255}));
  connect(realExpression1.y,powFanMod. u)
    annotation (Line(points={{141,-132},{154,-132}},
                                                 color={0,0,127}));
  connect(realExpression2.y,m_flowFan. u)
    annotation (Line(points={{141,128},{154,128}},
                                                 color={0,0,127}));
  connect(realExpression3.y,TAirLvgMod. u)
    annotation (Line(points={{141,92},{154,92}},
                                               color={0,0,127}));
  connect(realExpression4.y,TAirMixMod. u)
    annotation (Line(points={{141,64},{154,64}},   color={0,0,127}));
  connect(realExpression5.y,QHeaCoiMod. u)
    annotation (Line(points={{141,34},{154,34}},   color={0,0,127}));
  connect(realExpression6.y,TZonAirMod. u)
    annotation (Line(points={{141,-22},{154,-22}}, color={0,0,127}));
  connect(realExpression7.y,TZonAirEP. u)
    annotation (Line(points={{221,-22},{232,-22}}, color={0,0,127}));
  connect(realExpression9.y,m_flowFanEP. u)
    annotation (Line(points={{221,128},{232,128}},
                                                 color={0,0,127}));
  connect(realExpression12.y,QHeaCoiEP. u)
    annotation (Line(points={{221,36},{232,36}}, color={0,0,127}));
  connect(realExpression14.y,TAirLvgEP. u)
    annotation (Line(points={{221,92},{232,92}}, color={0,0,127}));
  connect(realExpression15.y,TAirMixEP. u)
    annotation (Line(points={{221,64},{232,64}}, color={0,0,127}));
  connect(realExpression16.y, powHeaCoiEP.u)
    annotation (Line(points={{221,-52},{232,-52}}, color={0,0,127}));
  connect(realExpression17.y, powHeaCoiMod.u)
    annotation (Line(points={{141,-54},{154,-54}}, color={0,0,127}));
  connect(realExpression10.y,powCooCoiMod. u)
    annotation (Line(points={{141,-108},{154,-108}}, color={0,0,127}));
  connect(realExpression11.y,powCooCoiEP. u)
    annotation (Line(points={{221,-106},{232,-106}}, color={0,0,127}));
  connect(realExpression18.y,powFanEP. u)
    annotation (Line(points={{221,-132},{232,-132}}, color={0,0,127}));
  connect(realExpression19.y,powSupHeaMod. u)
    annotation (Line(points={{-19,-132},{-2,-132}}, color={0,0,127}));
  connect(realExpression20.y,powSupHeaEP. u)
    annotation (Line(points={{61,-132},{78,-132}}, color={0,0,127}));
  connect(conCycFanCycCoi.yFan, booToReaFanEna.u) annotation (Line(points={{-64,
          -74},{-38,-74},{-38,-70},{-32,-70}}, color={255,0,255}));
  connect(booToReaFanEna.y, pthp.uFan) annotation (Line(points={{-8,-70},{0,-70},
          {0,-40},{-30,-40},{-30,4},{-18,4}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{260,
            140}}), graphics={Polygon(points={{-48,-16},{-48,-16}}, lineColor={28,
              108,200})}),
    experiment(Tolerance=1e-06),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/ZoneEquipment/PackagedTerminalHeatPump/Validation/CoolingMode.mos"
        "Simulate and plot"),
    Documentation(info="<html>
    <p>
    This is an example model for the PTHP system model under cooling mode operation 
    with a cycling fan cycling coil (AUTO Fan) controller and a supplementary 
    heating controller. It consists of: 
    </p>
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
<p>
The simulation model provides a closed-loop example of <code>PTHP</code> that 
is operated by <code>cycFanCycCoi</code> and regulates the zone temperature in 
<code>zon</code> at the setpoint generated by <code>TZonSet</code>. 
</p>
</html>
", revisions="<html>
    <ul>
    <li>
    April 10, 2023 by Xing Lu and Karthik Devaprasad:<br/>
    First implementation.
    </li>
    </ul>
    </html>"));
end CoolingMode;

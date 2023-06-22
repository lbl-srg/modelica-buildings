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

  Buildings.Fluid.ZoneEquipment.BaseClasses.ModularController modCon(
    final sysTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.SystemTypes.pthp,
    final fanTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.FanTypes.conSpeFan,
    final has_fanOpeMod=true,
    tFanEna=60,
    dTHys=0.1)
    "Instance of modular controller with constant speed fan and DX coils"
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
    annotation (Placement(transformation(extent={{-30,-86},{-10,-66}})));

equation
  connect(ava.y, modCon.uAva) annotation (Line(points={{-108,-50},{-100,-50},{-100,
          -70},{-88,-70}}, color={255,0,255}));
  connect(fanOpeMod.y, modCon.fanOpeMod) annotation (Line(points={{-108,-80},{-100,
          -80},{-100,-73.4},{-88,-73.4}}, color={255,0,255}));
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
  connect(modCon.THeaSet, K2C[2].y) annotation (Line(points={{-88,-62},{-96,-62},
          {-96,34},{-42,34},{-42,90},{-58,90}}, color={0,0,127}));
  connect(K2C[3].y, modCon.TCooSet) annotation (Line(points={{-58,90},{-46,90},{
          -46,36},{-98,36},{-98,-58.2},{-88,-58.2}}, color={0,0,127}));
  connect(pthp.port_Air_a2, zon.ports[1])
    annotation (Line(points={{24,-2},{77,-2},{77,30.9}},
                                                       color={0,127,255}));
  connect(pthp.port_Air_b2, zon.ports[2])
    annotation (Line(points={{24,-10},{79,-10},{79,30.9}},
                                                         color={0,127,255}));
  connect(con.y, zon.qGai_flow) annotation (Line(points={{22,40},{40,40},{40,60},
          {56,60}}, color={0,0,127}));
  connect(zon.TAir, modCon.TZon) annotation (Line(points={{99,68},{108,68},{108,
          -98},{-100,-98},{-100,-54.6},{-88,-54.6}}, color={0,0,127}));
  connect(pthp.TAirSup, modCon.TSup) annotation (Line(points={{25,4},{30,4},{30,
          -88},{-96,-88},{-96,-77},{-88,-77}}, color={0,0,127}));
  connect(damPos.y,pthp. uEco) annotation (Line(points={{-98,50},{-58,50},{-58,12},
          {-17,12}}, color={0,0,127}));

  connect(modCon.yCooEna, pthp.uCooEna) annotation (Line(points={{-64,-52},{-36,
          -52},{-36,-20},{-17,-20}},     color={255,0,255}));
  connect(fanProOn.y, modCon.uFan) annotation (Line(points={{56,10},{60,10},{60,
          -94},{-102,-94},{-102,-51},{-88,-51}}, color={255,0,255}));
  connect(building.weaBus,pthp. weaBus) annotation (Line(
      points={{0,130},{14,130},{14,66},{-12.2,66},{-12.2,-0.4}},
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
  connect(modCon.yFan, booToReaFanEna.u)
    annotation (Line(points={{-64,-76},{-32,-76}}, color={255,0,255}));
  connect(booToReaFanEna.y, pthp.uFan) annotation (Line(points={{-8,-76},{0,-76},
          {0,-40},{-30,-40},{-30,8},{-17,8}}, color={0,0,127}));
  connect(TOut.y, modCon.TOut) annotation (Line(points={{81,130},{92,130},{92,76},
          {-92,76},{-92,-66},{-88,-66}}, color={0,0,127}));
  connect(modCon.ySupHea, pthp.uSupHea) annotation (Line(points={{-64,-60},{-50,
          -60},{-50,-8},{-17,-8}},   color={0,0,127}));
  connect(modCon.yHeaEna, pthp.uHeaEna) annotation (Line(points={{-64,-56},{-26,
          -56},{-26,-24},{-17,-24}},     color={255,0,255}));
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
    This is a validation model for the packaged terminal heat pump (PTHP) system model under cooling mode 
    with a modular controller. The validation model consists of: </p>
    <ul>
    <li>
    An instance of the PTHP system model <code>PackagedTerminalHeatPump</code>. 
    </li>
    <li>
    A thermal zone model <code>zon</code> of class 
    <a href=\"modelica://Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone\">
    Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone</a>. 
    </li>
    <li>
    A modular controller <code>ModularController</code> of class 
    <a href=\"modelica://Buildings.Fluid.ZoneEquipment.BaseClasses.ModularController\">
    Buildings.Fluid.ZoneEquipment.BaseClasses.ModularController</a>. 
    </li>
    </ul>
    <p>
    The validation model provides a closed-loop example of <code>PackagedTerminalHeatPump</code> that 
    is operated by <code>ModularController</code> to regulate the zone temperature in 
    <code>zon</code> at its cooling setpoint. 
    </p>
    </html>
    ", revisions="<html>
    <ul>
    <li>
    June 21, 2023, by Xing Lu, Karthik Devaprasad, and Junke Wang:<br/>
    First implementation.
    </li>
    </ul>
    </html>"));
end CoolingMode;

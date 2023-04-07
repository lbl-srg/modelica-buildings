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
    "Time-step used to average out Modelica results for comparison with EPlus results. Same val;ue is also applied to unit delay shift on EPlus power value";
  parameter Modelica.Units.SI.Time delayTimestep = 3600
    "Time-step used to unit delay shift on EPlus power value";
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant damPos(final k=0.2)
    "Outdoor air damper position"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
  Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump.PackagedTerminalHeatPump
    PTHP(
    QSup_flow_nominal=5600.34,
    dpCooDX_nominal(displayUnit="Pa") = 0,
    dpHeaDX_nominal(displayUnit="Pa") = 0,
    dpSupHea_nominal(displayUnit="Pa") = 0,
    SupHeaCoi(tau=3600),
    redeclare package MediumA = MediumA,
    mAirOut_flow_nominal=0.5075,
    mAir_flow_nominal=0.5075,
    dpAir_nominal(displayUnit="Pa") = dpAir_nominal,
    datHeaCoi=datHeaCoi,
    redeclare
      Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump.Validation.Data.FanData
      fanPer,
    datCooCoi=datCooCoi)
    annotation (Placement(transformation(extent={{-16,-26},{24,14}})));
  Modelica.Blocks.Sources.CombiTimeTable datRea(
    final tableOnFile=true,
    final fileName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Fluid/ZoneEquipment/PackagedTerminalHeatPump/1ZonePTHP.dat"),
    final columns=2:32,
    final tableName="EnergyPlus",
    final smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments)
    "Reader for \"FanCoilAutoSize_ConstantFlowVariableFan.idf\" energy plus example results"
    annotation (Placement(transformation(extent={{-120,76},{-100,96}})));

  Buildings.Controls.OBC.CDL.Continuous.Divide div1
    "Calculate mass fractions of constituents"
    annotation (Placement(transformation(extent={{-80,86},{-60,106}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter totMasAir(final p=1)
    "Add 1 to humidity ratio value to find total mass of moist air"
    annotation (Placement(transformation(extent={{-80,54},{-60,74}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter K2C[4](final p=fill(273.15,
        4)) "Convert temperature from Celsius to Kelvin "
    annotation (Placement(transformation(extent={{-80,116},{-60,136}})));

  Controls.CyclingFanCyclingCoil conVarWatConFan(
    heaCoiTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.HeaSou.ele,
    cooCoiTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.CooSou.heaPum,
    tFanEna=60,
    dTHys=0.1)
    annotation (Placement(transformation(extent={{-86,-78},{-50,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ava(k=true)
    "Availability signal"
    annotation (Placement(transformation(extent={{-130,-60},{-110,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fanOpeMod(k=false)
    "Fan operating mode"
    annotation (Placement(transformation(extent={{-130,-90},{-110,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis fanProOn(uLow=0.04, uHigh=
        0.05) "Check if fan is proven on based off of measured fan speed"
    annotation (Placement(transformation(extent={{34,0},{54,20}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTem
    annotation (Placement(transformation(extent={{30,58},{50,78}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay powHeaCoiEP(samplePeriod=
        delayTimestep)
    annotation (Placement(transformation(extent={{234,-90},{254,-70}})));
  inner ThermalZones.EnergyPlus_9_6_0.Building building(
    idfName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Fluid/ZoneEquipment/PackagedTerminalHeatPump/1ZonePTHP.idf"),
    epwName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw"),
    weaName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    annotation (Placement(transformation(extent={{-20,120},{0,140}})));

  ThermalZones.EnergyPlus_9_6_0.ThermalZone zon(
    zoneName="West Zone",
    redeclare package Medium = MediumA,
    T_start=295.15,
    nPorts=2) annotation (Placement(transformation(extent={{58,30},{98,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con[3](k=fill(0, 3))
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=PTHP.HeaCoi.P)
    annotation (Placement(transformation(extent={{120,-92},{140,-72}})));
  Modelica.Blocks.Math.Mean powHeaCoiMod(f=1/averagingTimestep)
    annotation (Placement(transformation(extent={{156,-92},{176,-72}})));
  Modelica.Blocks.Math.Mean powFanMod(f=1/averagingTimestep)
    annotation (Placement(transformation(extent={{156,-140},{176,-120}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=PTHP.fan.P)
    annotation (Placement(transformation(extent={{120,-140},{140,-120}})));
  Modelica.Blocks.Sources.RealExpression realExpression2(y=PTHP.fan.m_flow)
    annotation (Placement(transformation(extent={{120,120},{140,140}})));
  Modelica.Blocks.Math.Mean m_flowFan(f=1/averagingTimestep)
    annotation (Placement(transformation(extent={{156,120},{176,140}})));
  Modelica.Blocks.Sources.RealExpression realExpression3(y=PTHP.TAirLvg.T -
        273.15)
    annotation (Placement(transformation(extent={{120,84},{140,104}})));
  Modelica.Blocks.Math.Mean TAirLvgMod(f=1/averagingTimestep)
    annotation (Placement(transformation(extent={{156,84},{176,104}})));
  Modelica.Blocks.Sources.RealExpression realExpression4(y=PTHP.TAirMix.T -
        273.15)
    annotation (Placement(transformation(extent={{120,56},{140,76}})));
  Modelica.Blocks.Math.Mean TAirMixMod(f=1/averagingTimestep)
    annotation (Placement(transformation(extent={{156,56},{176,76}})));
  Modelica.Blocks.Math.Mean QHeaCoiMod(f=1/averagingTimestep)
    annotation (Placement(transformation(extent={{156,26},{176,46}})));
  Modelica.Blocks.Sources.RealExpression realExpression5(y=PTHP.HeaCoi.QSen_flow)
    annotation (Placement(transformation(extent={{120,26},{140,46}})));
  Modelica.Blocks.Sources.RealExpression realExpression6(y=senTem.T - 273.15)
    annotation (Placement(transformation(extent={{120,-30},{140,-10}})));
  Modelica.Blocks.Math.Mean TZonAirMod(f=1/averagingTimestep)
    annotation (Placement(transformation(extent={{156,-30},{176,-10}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay TZonAirEP(samplePeriod=
        delayTimestep)
    annotation (Placement(transformation(extent={{234,-30},{254,-10}})));
  Modelica.Blocks.Sources.RealExpression realExpression7(y=datRea.y[28])
    annotation (Placement(transformation(extent={{200,-30},{220,-10}})));
  Modelica.Blocks.Sources.RealExpression realExpression8(y=datRea.y[7])
    annotation (Placement(transformation(extent={{200,-90},{220,-70}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay m_flowFanEP(samplePeriod=
        delayTimestep)
    annotation (Placement(transformation(extent={{234,120},{254,140}})));
  Modelica.Blocks.Sources.RealExpression realExpression9(y=datRea.y[30])
    annotation (Placement(transformation(extent={{200,120},{220,140}})));
  Modelica.Blocks.Sources.RealExpression realExpression12(y=datRea.y[6])
    annotation (Placement(transformation(extent={{200,28},{220,48}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay QHeaCoiEP(samplePeriod=
        delayTimestep)
    annotation (Placement(transformation(extent={{234,28},{254,48}})));
   parameter HeatExchangers.DXCoils.AirSource.Data.Generic.DXCoil                 datHeaCoi(sta={
        Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.Stage(
        spe=1800/60,
        nomVal=
          Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.NominalValues(
          activate_CooCoi=false,
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
    HeatExchangers.DXCoils.AirSource.Data.Generic.DXCoil datCooCoi(sta={
        Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.Stage(
        spe=1800,
        nomVal=
          Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.NominalValues(
          activate_CooCoi=true,
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
          ffMax=1.125))}, nSta=1)
    annotation (Placement(transformation(extent={{30,90},{50,110}})));
  Modelica.Blocks.Math.Mean QLoaMod(f=1/averagingTimestep)
    annotation (Placement(transformation(extent={{156,0},{176,20}})));
  Modelica.Blocks.Sources.RealExpression realExpression13(y=zon.conQCon_flow.port.Q_flow)
    annotation (Placement(transformation(extent={{120,0},{140,20}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay TAirLvgEP(samplePeriod=
        delayTimestep)
    annotation (Placement(transformation(extent={{234,84},{254,104}})));
  Modelica.Blocks.Sources.RealExpression realExpression14(y=datRea.y[23])
    annotation (Placement(transformation(extent={{200,84},{220,104}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay TAirMixEP(samplePeriod=
        delayTimestep)
    annotation (Placement(transformation(extent={{234,56},{254,76}})));
  Modelica.Blocks.Sources.RealExpression realExpression15(y=datRea.y[20])
    annotation (Placement(transformation(extent={{200,56},{220,76}})));
  Controls.SupplementalHeating uSupHea(k=0.1) "Supplementary heat signal"
    annotation (Placement(transformation(extent={{-80,-12},{-60,8}})));
  BoundaryConditions.WeatherData.Bus weaBus "if not has_extOAPor and has_ven"
    annotation (Placement(transformation(extent={{18,110},{58,150}}),
      iconTransformation(extent={{-168,170},{-148,190}})));
  Modelica.Blocks.Routing.RealPassThrough TOut(y(
      final quantity="ThermodynamicTemperature",
      final unit="K",
      displayUnit="degC",
      min=0))
    annotation (Placement(transformation(extent={{60,120},{80,140}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay powHeaCoiEP1(samplePeriod=
        delayTimestep)
    annotation (Placement(transformation(extent={{234,-60},{254,-40}})));
  Modelica.Blocks.Sources.RealExpression realExpression16(y=datRea.y[7])
    annotation (Placement(transformation(extent={{200,-60},{220,-40}})));
  Modelica.Blocks.Math.Mean powHeaCoiMod1(f=1/averagingTimestep)
    annotation (Placement(transformation(extent={{156,-62},{176,-42}})));
  Modelica.Blocks.Sources.RealExpression realExpression17(y=PTHP.HeaCoi.P)
    annotation (Placement(transformation(extent={{120,-62},{140,-42}})));
  Modelica.Blocks.Sources.RealExpression realExpression10(y=PTHP.CooCoi.P)
    annotation (Placement(transformation(extent={{120,-116},{140,-96}})));
  Modelica.Blocks.Math.Mean powCooCoiMod(f=1/averagingTimestep)
    annotation (Placement(transformation(extent={{156,-116},{176,-96}})));
  Modelica.Blocks.Sources.RealExpression realExpression11(y=datRea.y[4])
    annotation (Placement(transformation(extent={{200,-114},{220,-94}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay powCooCoiEP(samplePeriod=
        delayTimestep)
    annotation (Placement(transformation(extent={{234,-114},{254,-94}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay powFanEP(samplePeriod=
        delayTimestep)
    annotation (Placement(transformation(extent={{234,-140},{254,-120}})));
  Modelica.Blocks.Sources.RealExpression realExpression18(y=datRea.y[29])
    annotation (Placement(transformation(extent={{200,-140},{220,-120}})));
  Modelica.Blocks.Sources.RealExpression realExpression19(y=PTHP.SupHeaCoi.Q_flow)
    annotation (Placement(transformation(extent={{-40,-140},{-20,-120}})));
  Modelica.Blocks.Math.Mean powSupHeaMod(f=1/averagingTimestep)
    annotation (Placement(transformation(extent={{0,-140},{20,-120}})));
  Modelica.Blocks.Sources.RealExpression realExpression20(y=datRea.y[10])
    annotation (Placement(transformation(extent={{40,-140},{60,-120}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay powSupHeaEP(samplePeriod=
        delayTimestep)
    annotation (Placement(transformation(extent={{80,-140},{100,-120}})));
equation
  connect(datRea.y[22], div1.u1) annotation (Line(points={{-99,86},{-94,86},{-94,
          102},{-82,102}},
                         color={0,0,127}));
  connect(datRea.y[22], totMasAir.u) annotation (Line(points={{-99,86},{-94,86},
          {-94,64},{-82,64}}, color={0,0,127}));
  connect(totMasAir.y, div1.u2) annotation (Line(points={{-58,64},{-56,64},{-56,
          82},{-88,82},{-88,90},{-82,90}},
                         color={0,0,127}));
  connect(ava.y, conVarWatConFan.uAva) annotation (Line(points={{-108,-50},{
          -100,-50},{-100,-66.7059},{-88,-66.7059}},
                                           color={255,0,255}));
  connect(fanOpeMod.y, conVarWatConFan.fanOpeMod) annotation (Line(points={{-108,
          -80},{-100,-80},{-100,-75.1765},{-88,-75.1765}},
                                                      color={255,0,255}));
  connect(PTHP.yFan_actual, fanProOn.u) annotation (Line(points={{25,10},{32,10}},
                            color={0,0,127}));
  connect(datRea.y[20], K2C[1].u) annotation (Line(points={{-99,86},{-94,86},{-94,
          126},{-82,126}},
                         color={0,0,127}));
  connect(datRea.y[26], K2C[2].u) annotation (Line(points={{-99,86},{-94,86},{-94,
          126},{-82,126}},
                         color={0,0,127}));
  connect(datRea.y[27], K2C[3].u) annotation (Line(points={{-99,86},{-94,86},{-94,
          126},{-82,126}},
                         color={0,0,127}));
  connect(datRea.y[28], K2C[4].u) annotation (Line(points={{-99,86},{-94,86},{-94,
          126},{-82,126}},
                         color={0,0,127}));
  connect(conVarWatConFan.THeaSet, K2C[2].y) annotation (Line(points={{-88,-58.2353},
          {-96,-58.2353},{-96,34},{-42,34},{-42,126},{-58,126}},
                                                            color={0,0,127}));
  connect(K2C[3].y, conVarWatConFan.TCooSet) annotation (Line(points={{-58,126},
          {-46,126},{-46,36},{-98,36},{-98,-49.7647},{-88,-49.7647}},
                                                            color={0,0,127}));
  connect(PTHP.port_Air_a2, zon.ports[1])
    annotation (Line(points={{24,-2},{76,-2},{76,30.9}},
                                                       color={0,127,255}));
  connect(PTHP.port_Air_b2, zon.ports[2])
    annotation (Line(points={{24,-10},{80,-10},{80,30.9}},
                                                         color={0,127,255}));
  connect(con.y, zon.qGai_flow) annotation (Line(points={{22,40},{40,40},{40,60},
          {56,60}}, color={0,0,127}));
  connect(zon.TAir, conVarWatConFan.TZon) annotation (Line(points={{99,68},{108,
          68},{108,-98},{-100,-98},{-100,-41.2941},{-88,-41.2941}},
                                                        color={0,0,127}));
  connect(PTHP.TAirSup, conVarWatConFan.TSup) annotation (Line(points={{25,4},{
          30,4},{30,-88},{-96,-88},{-96,-81.1059},{-88,-81.1059}},
                                                         color={0,0,127}));
  connect(realExpression.y,powHeaCoiMod. u)
    annotation (Line(points={{141,-82},{154,-82}},
                                                 color={0,0,127}));
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
  connect(senTem.port, zon.heaPorAir) annotation (Line(points={{30,68},{28,68},{
          28,46},{78,46},{78,50}},  color={191,0,0}));
  connect(realExpression6.y, TZonAirMod.u)
    annotation (Line(points={{141,-20},{154,-20}}, color={0,0,127}));
  connect(damPos.y, PTHP.uEco) annotation (Line(points={{-98,50},{-58,50},{-58,12},
          {-18,12}}, color={0,0,127}));
  connect(realExpression7.y, TZonAirEP.u)
    annotation (Line(points={{221,-20},{232,-20}}, color={0,0,127}));
  connect(realExpression8.y, powHeaCoiEP.u)
    annotation (Line(points={{221,-80},{232,-80}}, color={0,0,127}));
  connect(realExpression9.y, m_flowFanEP.u)
    annotation (Line(points={{221,130},{232,130}},
                                                 color={0,0,127}));
  connect(realExpression12.y, QHeaCoiEP.u)
    annotation (Line(points={{221,38},{232,38}}, color={0,0,127}));

  connect(realExpression13.y, QLoaMod.u)
    annotation (Line(points={{141,10},{154,10}}, color={0,0,127}));
  connect(conVarWatConFan.yCooEna, PTHP.uCooEna) annotation (Line(points={{-47.8,
          -32.8235},{-36,-32.8235},{-36,-15.8},{-18,-15.8}}, color={255,0,255}));
  connect(fanProOn.y, conVarWatConFan.uFan) annotation (Line(points={{56,10},{
          60,10},{60,-94},{-102,-94},{-102,-32.8235},{-88,-32.8235}},
                                                                   color={255,0,
          255}));
  connect(realExpression14.y, TAirLvgEP.u)
    annotation (Line(points={{221,94},{232,94}}, color={0,0,127}));
  connect(realExpression15.y, TAirMixEP.u)
    annotation (Line(points={{221,66},{232,66}}, color={0,0,127}));
  connect(uSupHea.ySupHea, PTHP.uSupHea) annotation (Line(points={{-58,2},{-40,2},
          {-40,-20},{-18,-20}}, color={0,0,127}));
  connect(zon.TAir, uSupHea.TZon) annotation (Line(points={{99,68},{108,68},{108,
          -98},{-100,-98},{-100,6},{-82,6}}, color={0,0,127}));
  connect(uSupHea.THeaSet, K2C[2].y) annotation (Line(points={{-82,2},{-94,2},{-94,
          32},{-38,32},{-38,126},{-58,126}}, color={0,0,127}));
  connect(building.weaBus, PTHP.weaBus) annotation (Line(
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
  connect(TOut.y, uSupHea.TOut) annotation (Line(points={{81,130},{100,130},{100,
          86},{-36,86},{-36,30},{-92,30},{-92,-2},{-82,-2}}, color={0,0,127}));
  connect(realExpression16.y, powHeaCoiEP1.u)
    annotation (Line(points={{221,-50},{232,-50}}, color={0,0,127}));
  connect(realExpression17.y, powHeaCoiMod1.u)
    annotation (Line(points={{141,-52},{154,-52}}, color={0,0,127}));
  connect(realExpression10.y, powCooCoiMod.u)
    annotation (Line(points={{141,-106},{154,-106}}, color={0,0,127}));
  connect(realExpression11.y, powCooCoiEP.u)
    annotation (Line(points={{221,-104},{232,-104}}, color={0,0,127}));
  connect(realExpression18.y, powFanEP.u)
    annotation (Line(points={{221,-130},{232,-130}}, color={0,0,127}));
  connect(uSupHea.yHeaEna, PTHP.uHeaEna) annotation (Line(points={{-59,-9},{-38,
          -9},{-38,-23.8},{-18,-23.8}}, color={255,0,255}));
  connect(conVarWatConFan.yHeaEna, uSupHea.uHeaEna) annotation (Line(points={{-47.8,
          -41.5765},{-44,-41.5765},{-44,-20},{-92,-20},{-92,-5},{-81,-5}},
        color={255,0,255}));
  connect(conVarWatConFan.yHeaMod, uSupHea.uHeaMod) annotation (Line(points={{-47.8,
          -81.1059},{-42,-81.1059},{-42,-18},{-90,-18},{-90,-8},{-81,-8}},
        color={255,0,255}));
  connect(realExpression19.y, powSupHeaMod.u)
    annotation (Line(points={{-19,-130},{-2,-130}}, color={0,0,127}));
  connect(realExpression20.y, powSupHeaEP.u)
    annotation (Line(points={{61,-130},{78,-130}}, color={0,0,127}));
  connect(conVarWatConFan.yFan, uSupHea.uFan) annotation (Line(points={{-47.8,
          -75.1765},{-34,-75.1765},{-34,-16},{-88,-16},{-88,-11},{-81,-11}},
                                                                   color={255,0,
          255}));
  connect(uSupHea.yFan, PTHP.uFan) annotation (Line(points={{-58,-4},{-38,-4},{-38,
          4},{-18,4}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{260,
            140}}), graphics={Polygon(points={{-48,-16},{-48,-16}}, lineColor={28,
              108,200})}),
    experiment(
      StartTime=1296000,
      StopTime=1900800,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/ZoneEquipment/PackagedTerminalHeatPump/Validation/CoolingMode.mos"
        "Cooling Mode"),
    Documentation(info="<html>
<p>This is an example model for the PTHP system model under cooling code demonstrating use-case with a cycling fan cycling coil (AUTO Fan) controller and a supplementary heating controller. It consists of: </p>
<ul>
<li>an instance of the PTHP system model <span style=\"font-family: Courier New;\">fanCoiUni</span>. </li>
<li>thermal zone model <span style=\"font-family: Courier New;\">zon</span> of class <a href=\"modelica://Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone\">Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone</a>. </li>
<li>PTHP controller <span style=\"font-family: Courier New;\">cycFanCycCoi</span> of class <a href=\"modelica://Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump.Controls.CyclingFanCyclingCoil\">
Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump.Controls.CyclingFanCyclingCoil</a>. </li>
<li>zone temperature setpoint controller <span style=\"font-family: Courier New;\">TZonSet</span>. </li>
</ul>
<p>The simulation model provides a closed-loop example of <span style=\"font-family: Courier New;\">PTHP</span> that is operated by <span style=\"font-family: Courier New;\">cycFanCycCoi</span> and regulates the zone temperature in <span style=\"font-family: Courier New;\">zon</span> at the setpoint generated by <span style=\"font-family: Courier New;\">TZonSet</span>. </p>
", revisions="<html>
    <ul>
    <li>
    Mar 30, 2023 by Karthik Devaprasad, Xing Lu:<br/>
    First implementation.
    </li>
    </ul>
    </html>"));
end CoolingMode;

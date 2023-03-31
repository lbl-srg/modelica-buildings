within Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump.Validation;
model CoolingModeEPlusComparison_withNewControl_withSPAWNZone
  "Validation model for cooling mode operation of window AC system"
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

  parameter HeatExchangers.DXCoils.AirCooled.Data.Generic.DXCoil datCoi(sta={
        Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.Stage(
        spe=1800/60,
        nomVal=
          Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-9365,
          COP_nominal=3.0,
          SHR_nominal=0.8,
          m_flow_nominal=1.2*0.56578),
        perCur=
          Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.PerformanceCurve(
          capFunT={0.942587793,0.009543347,0.00068377,-0.011042676,0.000005249,
            -0.00000972},
          capFunFF={0.8,0.2,0},
          EIRFunT={0.342414409,0.034885008,-0.0006237,0.004977216,0.000437951,-0.000728028},
          EIRFunFF={1.1552,-0.1808,0.0256},
          TConInMin=273.15 + 18,
          TConInMax=273.15 + 46.11,
          TEvaInMin=273.15 + 12.78,
          TEvaInMax=273.15 + 23.89,
          ffMin=0.5,
          ffMax=1.5))}, nSta=1)
  annotation (Placement(transformation(extent={{60,106},{80,126}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant damPos(final k=0.2)
    "Outdoor air damper position"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump.Validation.Data.SizingData
    winACSizing "Sizing parameters for window AC"
    annotation (Placement(transformation(extent={{60,72},{80,92}})));
  Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump.PackagedTerminalHeatPump
    PTHP(
    SupHeaCoi(tau=3600),
    redeclare package MediumA = MediumA,
    mAirOut_flow_nominal=winACSizing.mAirOut_flow_nominal,
    mAir_flow_nominal=winACSizing.mAir_flow_nominal,
    dpAir_nominal(displayUnit="Pa") = dpAir_nominal,
    dpDX_nominal(displayUnit="Pa") = dpDX_nominal,
    redeclare
      Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump.Validation.Data.FanData
      fanPer,
    datCooCoi=datCoi)
    annotation (Placement(transformation(extent={{-16,-24},{24,16}})));
  Modelica.Blocks.Sources.Pulse p(
    nperiod=1,
    offset=101325,
    width=100,
    period=864000,
    startTime=18144000,
    amplitude=1086) "Pressure"
    annotation (Placement(transformation(extent={{0,100},{20,120}})));
  Modelica.Blocks.Sources.CombiTimeTable datRea(
    final tableOnFile=true,
    final fileName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Fluid/ZoneEquipment/WindowAC/WindACFanOnOff.dat"),
    final columns=2:22,
    final tableName="EnergyPlus",
    final smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments)
    "Reader for \"FanCoilAutoSize_ConstantFlowVariableFan.idf\" energy plus example results"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));

  Buildings.Controls.OBC.CDL.Continuous.Divide div1
    "Calculate mass fractions of constituents"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter totMasAir(final p=1)
    "Add 1 to humidity ratio value to find total mass of moist air"
    annotation (Placement(transformation(extent={{-80,8},{-60,28}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter K2C[3](final p=fill(273.15,
        3)) "Convert temperature from Celsius to Kelvin "
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));

  Controls.CycleFanCyclingCoil       conVarWatConFan(tFanEna=60,
                                                     tCooCoiEna=60)
    annotation (Placement(transformation(extent={{-76,-68},{-40,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ava(k=true)
    "Availability signal"
    annotation (Placement(transformation(extent={{-130,-60},{-110,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fanOpeMod(k=false)
    "Fan operating mode"
    annotation (Placement(transformation(extent={{-130,-90},{-110,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis fanProOn(uLow=0.04, uHigh=
        0.05) "Check if fan is proven on based off of measured fan speed"
    annotation (Placement(transformation(extent={{30,6},{50,26}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    annotation (Placement(transformation(extent={{-30,-74},{-10,-54}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTem
    annotation (Placement(transformation(extent={{30,58},{50,78}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay powEP(samplePeriod=
        averagingTimestep)
    annotation (Placement(transformation(extent={{234,76},{254,96}})));
  inner ThermalZones.EnergyPlus_9_6_0.Building building(
    idfName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Fluid/ZoneEquipment/WindowAC/WindACFanOnOff.idf"),
    epwName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw"),
    weaName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    annotation (Placement(transformation(extent={{32,110},{52,130}})));

  ThermalZones.EnergyPlus_9_6_0.ThermalZone zon(
    zoneName="West Zone",
    redeclare package Medium = MediumA,
    nPorts=2) annotation (Placement(transformation(extent={{60,22},{100,62}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1[3](k=fill(0, 3))
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=PTHP.SupHeaCoi.P)
    annotation (Placement(transformation(extent={{118,74},{138,94}})));
  Modelica.Blocks.Math.Mean powModCooCoi(f=1/averagingTimestep)
    annotation (Placement(transformation(extent={{156,74},{176,94}})));
  Modelica.Blocks.Math.Mean powModFan(f=1/averagingTimestep)
    annotation (Placement(transformation(extent={{156,102},{176,122}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=PTHP.fan.P)
    annotation (Placement(transformation(extent={{118,102},{138,122}})));
  Modelica.Blocks.Sources.RealExpression realExpression2(y=PTHP.fan.m_flow)
    annotation (Placement(transformation(extent={{118,48},{138,68}})));
  Modelica.Blocks.Math.Mean m_flowFan(f=1/averagingTimestep)
    annotation (Placement(transformation(extent={{156,48},{176,68}})));
  Modelica.Blocks.Sources.RealExpression realExpression3(y=PTHP.TAirLvg.T -
        273.15)
    annotation (Placement(transformation(extent={{118,20},{138,40}})));
  Modelica.Blocks.Math.Mean TAirLvgMod(f=1/averagingTimestep)
    annotation (Placement(transformation(extent={{156,20},{176,40}})));
  Modelica.Blocks.Sources.RealExpression realExpression4(y=PTHP.TAirMix.T -
        273.15)
    annotation (Placement(transformation(extent={{118,-8},{138,12}})));
  Modelica.Blocks.Math.Mean TAirMixMod(f=1/averagingTimestep)
    annotation (Placement(transformation(extent={{156,-8},{176,12}})));
  Modelica.Blocks.Math.Mean QModCooCoi(f=1/averagingTimestep)
    annotation (Placement(transformation(extent={{156,-38},{176,-18}})));
  Modelica.Blocks.Sources.RealExpression realExpression5(y=-PTHP.SupHeaCoi.QSen_flow
         - PTHP.SupHeaCoi.QLat_flow)
    annotation (Placement(transformation(extent={{118,-38},{138,-18}})));
  Modelica.Blocks.Sources.RealExpression realExpression6(y=senTem.T - 273.15)
    annotation (Placement(transformation(extent={{118,-94},{138,-74}})));
  Modelica.Blocks.Math.Mean TZonAir(f=1/averagingTimestep)
    annotation (Placement(transformation(extent={{156,-94},{176,-74}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay TZonAirEP(samplePeriod=
        averagingTimestep)
    annotation (Placement(transformation(extent={{234,-94},{254,-74}})));
  Modelica.Blocks.Sources.RealExpression realExpression7(y=datRea.y[15])
    annotation (Placement(transformation(extent={{198,-94},{218,-74}})));
  Modelica.Blocks.Sources.RealExpression realExpression8(y=datRea.y[3])
    annotation (Placement(transformation(extent={{194,76},{214,96}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay m_flowFanEP(samplePeriod=
        averagingTimestep)
    annotation (Placement(transformation(extent={{234,48},{254,68}})));
  Modelica.Blocks.Sources.RealExpression realExpression9(y=datRea.y[9])
    annotation (Placement(transformation(extent={{194,48},{214,68}})));
  Modelica.Blocks.Sources.RealExpression realExpression11(y=datRea.y[5])
    annotation (Placement(transformation(extent={{196,-64},{216,-44}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay PLRCooCoiEP(samplePeriod=
        averagingTimestep)
    annotation (Placement(transformation(extent={{236,-64},{256,-44}})));
  Modelica.Blocks.Math.Mean PLRCooCoiMod(f=1/averagingTimestep)
    annotation (Placement(transformation(extent={{156,-64},{176,-44}})));
  Modelica.Blocks.Sources.RealExpression realExpression10(y=(PTHP.SupHeaCoi.QSen_flow
         + PTHP.SupHeaCoi.QLat_flow)/PTHP.SupHeaCoi.datCoi.sta[1].nomVal.Q_flow_nominal)
    annotation (Placement(transformation(extent={{118,-64},{138,-44}})));
  Modelica.Blocks.Sources.RealExpression realExpression12(y=datRea.y[1])
    annotation (Placement(transformation(extent={{200,-14},{220,6}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay QCooCoiEPlus(samplePeriod=
        averagingTimestep)
    annotation (Placement(transformation(extent={{236,-14},{256,6}})));
equation
  connect(datRea.y[11], div1.u1) annotation (Line(points={{-99,40},{-94,40},{-94,
          56},{-82,56}}, color={0,0,127}));
  connect(datRea.y[11], totMasAir.u) annotation (Line(points={{-99,40},{-94,40},
          {-94,18},{-82,18}}, color={0,0,127}));
  connect(totMasAir.y, div1.u2) annotation (Line(points={{-58,18},{-56,18},{-56,
          36},{-88,36},{-88,44},{-82,44}},
                         color={0,0,127}));
  connect(conVarWatConFan.yCooEna, PTHP.uCooEna) annotation (Line(points={{-38,
          -24},{-30,-24},{-30,-13.8},{-18,-13.8}}, color={255,0,255}));
  connect(ava.y, conVarWatConFan.uAva) annotation (Line(points={{-108,-50},{
          -100,-50},{-100,-56},{-78,-56}}, color={255,0,255}));
  connect(fanOpeMod.y, conVarWatConFan.fanOpeMod) annotation (Line(points={{
          -108,-80},{-100,-80},{-100,-64},{-78,-64}}, color={255,0,255}));
  connect(PTHP.yFan_actual, fanProOn.u) annotation (Line(points={{25,12},{26,12},
          {26,16},{28,16}}, color={0,0,127}));
  connect(fanProOn.y, conVarWatConFan.uFan) annotation (Line(points={{52,16},{
          100,16},{100,-80},{-86,-80},{-86,-24},{-78,-24}}, color={255,0,255}));
  connect(conVarWatConFan.yFan, booToRea.u)
    annotation (Line(points={{-38,-64},{-32,-64}}, color={255,0,255}));
  connect(datRea.y[7], K2C[1].u) annotation (Line(points={{-99,40},{-94,40},{-94,
          80},{-82,80}}, color={0,0,127}));
  connect(datRea.y[14], K2C[2].u) annotation (Line(points={{-99,40},{-94,40},{-94,
          80},{-82,80}}, color={0,0,127}));
  connect(datRea.y[15], K2C[3].u) annotation (Line(points={{-99,40},{-94,40},{-94,
          80},{-82,80}}, color={0,0,127}));
  connect(building.weaBus, PTHP.weaBus) annotation (Line(
      points={{52,120},{54,120},{54,88},{-11.8,88},{-11.8,14}},
      color={255,204,51},
      thickness=0.5));
  connect(K2C[2].y, conVarWatConFan.TCooSet) annotation (Line(points={{-58,80},{
          -44,80},{-44,-10},{-96,-10},{-96,-40},{-78,-40}}, color={0,0,127}));
  connect(PTHP.port_Air_a2, zon.ports[1])
    annotation (Line(points={{24,0},{78,0},{78,22.9}}, color={0,127,255}));
  connect(PTHP.port_Air_b2, zon.ports[2])
    annotation (Line(points={{24,-8},{82,-8},{82,22.9}}, color={0,127,255}));
  connect(con1.y, zon.qGai_flow) annotation (Line(points={{22,40},{40,40},{40,52},
          {58,52}}, color={0,0,127}));
  connect(zon.TAir, conVarWatConFan.TZon) annotation (Line(points={{101,60},{110,
          60},{110,-90},{-90,-90},{-90,-32},{-78,-32}}, color={0,0,127}));
  connect(PTHP.TAirSup, conVarWatConFan.TSup) annotation (Line(points={{25,6},{
          30,6},{30,-86},{-84,-86},{-84,-69},{-78,-69}}, color={0,0,127}));
  connect(booToRea.y, PTHP.uFan) annotation (Line(points={{-8,-64},{2,-64},{2,-38},
          {-32,-38},{-32,6},{-18,6}}, color={0,0,127}));
  connect(realExpression.y, powModCooCoi.u)
    annotation (Line(points={{139,84},{154,84}}, color={0,0,127}));
  connect(realExpression1.y, powModFan.u)
    annotation (Line(points={{139,112},{154,112}},
                                                 color={0,0,127}));
  connect(realExpression2.y, m_flowFan.u)
    annotation (Line(points={{139,58},{154,58}}, color={0,0,127}));
  connect(realExpression3.y, TAirLvgMod.u)
    annotation (Line(points={{139,30},{154,30}},
                                               color={0,0,127}));
  connect(realExpression4.y, TAirMixMod.u)
    annotation (Line(points={{139,2},{154,2}},     color={0,0,127}));
  connect(realExpression5.y, QModCooCoi.u)
    annotation (Line(points={{139,-28},{154,-28}}, color={0,0,127}));
  connect(senTem.port, zon.heaPorAir) annotation (Line(points={{30,68},{28,68},
          {28,46},{80,46},{80,42}}, color={191,0,0}));
  connect(realExpression6.y, TZonAir.u)
    annotation (Line(points={{139,-84},{154,-84}}, color={0,0,127}));
  connect(damPos.y, PTHP.uEco) annotation (Line(points={{-98,0},{-38,0},{-38,14},
          {-18,14}}, color={0,0,127}));
  connect(realExpression7.y, TZonAirEP.u)
    annotation (Line(points={{219,-84},{232,-84}}, color={0,0,127}));
  connect(realExpression8.y, powEP.u)
    annotation (Line(points={{215,86},{232,86}}, color={0,0,127}));
  connect(realExpression9.y, m_flowFanEP.u)
    annotation (Line(points={{215,58},{232,58}}, color={0,0,127}));
  connect(realExpression11.y, PLRCooCoiEP.u)
    annotation (Line(points={{217,-54},{234,-54}}, color={0,0,127}));
  connect(realExpression10.y, PLRCooCoiMod.u)
    annotation (Line(points={{139,-54},{154,-54}}, color={0,0,127}));
  connect(realExpression12.y, QCooCoiEPlus.u)
    annotation (Line(points={{221,-4},{234,-4}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},
            {260,140}})),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{260,
            140}})),
    experiment(
      StartTime=18144000,
      StopTime=18230400,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/ZoneEquipment/WindowAC/Validation/CoolingModeEPlusComparison_withNewControl_withSPAWNZone.mos"
        "Simulate and Plot"));
end CoolingModeEPlusComparison_withNewControl_withSPAWNZone;

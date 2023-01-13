within Buildings.Fluid.ZoneEquipment.WindowAC.Validation;
model CoolingModeEPlusComparison_withNewControl_withSPAWNZone_FixedOA
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
        spe=1800,
        nomVal=
          Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-9365,
          COP_nominal=3.5,
          SHR_nominal=0.8,
          m_flow_nominal=1.2*0.56578),
        perCur=
          Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.Data.Generic.BaseClasses.PerformanceCurve(
          capFunT={0.942587793,0.009543347,0.00068377,-0.011042676,0.000005249,-0.00000972},
          capFunFF={0.8,0.2,0},
          EIRFunT={0.342414409,0.034885008,-0.0006237,0.004977216,0.000437951,-0.000728028},
          EIRFunFF={1.1552,-0.1808,0.0256},
          TConInMin=273.15 + 10,
          TConInMax=273.15 + 46.11,
          TEvaInMin=273.15 + 12.78,
          TEvaInMax=273.15 + 23.89,
          ffMin=0.875,
          ffMax=1.125))}, nSta=1)
  annotation (Placement(transformation(extent={{60,106},{80,126}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant damPos(final k=0.2)
    "Outdoor air damper position"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Buildings.Fluid.ZoneEquipment.WindowAC.Validation.Data.SizingData winACSizing
    "Sizing parameters for window AC"
    annotation (Placement(transformation(extent={{60,72},{80,92}})));
  Buildings.Fluid.ZoneEquipment.WindowAC.WindowAC winAC(
    redeclare package MediumA = MediumA,
    mAirOut_flow_nominal=winACSizing.mAirOut_flow_nominal,
    mAir_flow_nominal=winACSizing.mAir_flow_nominal,
    oaPorTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.OAPorts.oaPorts,
    dpAir_nominal(displayUnit="Pa") = dpAir_nominal,
    dpDX_nominal(displayUnit="Pa") = dpDX_nominal,
    redeclare Buildings.Fluid.ZoneEquipment.WindowAC.Validation.Data.FanData fanPer,
    datCoi=datCoi)
    annotation (Placement(transformation(extent={{-20,-20},{20,20}})));
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

  Controls.CycleFanCyclingCoil       conVarWatConFan
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

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(k=100)
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTem
    annotation (Placement(transformation(extent={{30,58},{50,78}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay powEP(samplePeriod=
        averagingTimestep)
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  inner ThermalZones.EnergyPlus_9_6_0.Building building(
    idfName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Fluid/ZoneEquipment/WindowAC/WindACFanOnOff.idf"),
    epwName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw"),
    weaName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    annotation (Placement(transformation(extent={{30,110},{50,130}})));

  ThermalZones.EnergyPlus_9_6_0.ThermalZone zon(
    zoneName="West Zone",
    redeclare package Medium = MediumA,
    T_start=303.15,
    nPorts=2) annotation (Placement(transformation(extent={{60,22},{100,62}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1[3](k=fill(0, 3))
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=winAC.sinSpeDX.P)
    annotation (Placement(transformation(extent={{154,50},{174,70}})));
  Modelica.Blocks.Math.Mean powModCooCoi(f=1/averagingTimestep)
    annotation (Placement(transformation(extent={{192,50},{212,70}})));
  Modelica.Blocks.Math.Mean powModFan(f=1/averagingTimestep)
    annotation (Placement(transformation(extent={{192,78},{212,98}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=winAC.fan.P)
    annotation (Placement(transformation(extent={{154,78},{174,98}})));
  Modelica.Blocks.Sources.RealExpression realExpression2(y=winAC.fan.m_flow)
    annotation (Placement(transformation(extent={{154,24},{174,44}})));
  Modelica.Blocks.Math.Mean m_flowFan(f=1/averagingTimestep)
    annotation (Placement(transformation(extent={{192,24},{212,44}})));
  Modelica.Blocks.Sources.RealExpression realExpression3(y=winAC.TAirLvg.T -
        273.15)
    annotation (Placement(transformation(extent={{154,-2},{174,18}})));
  Modelica.Blocks.Math.Mean TAirLvgMod(f=1/averagingTimestep)
    annotation (Placement(transformation(extent={{192,-2},{212,18}})));
  Modelica.Blocks.Sources.RealExpression realExpression4(y=winAC.TAirMix.T -
        273.15)
    annotation (Placement(transformation(extent={{154,-32},{174,-12}})));
  Modelica.Blocks.Math.Mean TAirMixMod(f=1/averagingTimestep)
    annotation (Placement(transformation(extent={{192,-32},{212,-12}})));
  Modelica.Blocks.Math.Mean QModCooCoi(f=1/averagingTimestep)
    annotation (Placement(transformation(extent={{192,-62},{212,-42}})));
  Modelica.Blocks.Sources.RealExpression realExpression5(y=-winAC.sinSpeDX.QSen_flow
         - winAC.sinSpeDX.QLat_flow)
    annotation (Placement(transformation(extent={{154,-62},{174,-42}})));
  Modelica.Blocks.Sources.RealExpression realExpression6(y=senTem.T - 273.15)
    annotation (Placement(transformation(extent={{154,-96},{174,-76}})));
  Modelica.Blocks.Math.Mean TZonAir(f=1/averagingTimestep)
    annotation (Placement(transformation(extent={{192,-96},{212,-76}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay TZonAirEP(samplePeriod=
        averagingTimestep)
    annotation (Placement(transformation(extent={{-120,118},{-100,138}})));
  Sources.MassFlowSource_WeatherData bou(
    redeclare package Medium = MediumA,
    m_flow=0,
    nPorts=1)
    annotation (Placement(transformation(extent={{-60,124},{-40,144}})));
  BoundaryConditions.WeatherData.ReaderTMY3           weaDat(final filNam=
        Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Outdoor weather data"
    annotation (Placement(transformation(extent={{-94,120},{-74,140}})));
  Sources.Outside out(redeclare package Medium = MediumA, nPorts=1)
    annotation (Placement(transformation(extent={{-60,100},{-40,120}})));
equation
  connect(datRea.y[11], div1.u1) annotation (Line(points={{-99,40},{-94,40},{-94,
          56},{-82,56}}, color={0,0,127}));
  connect(datRea.y[11], totMasAir.u) annotation (Line(points={{-99,40},{-94,40},
          {-94,18},{-82,18}}, color={0,0,127}));
  connect(totMasAir.y, div1.u2) annotation (Line(points={{-58,18},{-56,18},{-56,
          36},{-88,36},{-88,44},{-82,44}},
                         color={0,0,127}));
  connect(conVarWatConFan.yCooEna, winAC.uCooEna) annotation (Line(points={{-38,
          -24},{-30,-24},{-30,-9.8},{-22,-9.8}}, color={255,0,255}));
  connect(ava.y, conVarWatConFan.uAva) annotation (Line(points={{-108,-50},{
          -100,-50},{-100,-56},{-78,-56}}, color={255,0,255}));
  connect(fanOpeMod.y, conVarWatConFan.fanOpeMod) annotation (Line(points={{
          -108,-80},{-100,-80},{-100,-64},{-78,-64}}, color={255,0,255}));
  connect(winAC.yFan_actual, fanProOn.u)
    annotation (Line(points={{21,16},{28,16}}, color={0,0,127}));
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
  connect(datRea.y[3], powEP.u) annotation (Line(points={{-99,40},{-94,40},{-94,
          58},{-130,58},{-130,70},{-122,70}}, color={0,0,127}));
  connect(building.weaBus, winAC.weaBus) annotation (Line(
      points={{50,120},{54,120},{54,88},{-15.8,88},{-15.8,18}},
      color={255,204,51},
      thickness=0.5));
  connect(K2C[2].y, conVarWatConFan.TCooSet) annotation (Line(points={{-58,80},{
          -44,80},{-44,-10},{-96,-10},{-96,-40},{-78,-40}}, color={0,0,127}));
  connect(winAC.port_Air_a2, zon.ports[1]) annotation (Line(points={{20,4},{78,
          4},{78,22.9}},      color={0,127,255}));
  connect(winAC.port_Air_b2, zon.ports[2])
    annotation (Line(points={{20,-4},{82,-4},{82,22.9}}, color={0,127,255}));
  connect(con1.y, zon.qGai_flow) annotation (Line(points={{22,40},{40,40},{40,52},
          {58,52}}, color={0,0,127}));
  connect(zon.TAir, conVarWatConFan.TZon) annotation (Line(points={{101,60},{110,
          60},{110,-90},{-90,-90},{-90,-32},{-78,-32}}, color={0,0,127}));
  connect(winAC.TAirSup, conVarWatConFan.TSup) annotation (Line(points={{21,10},
          {30,10},{30,-86},{-84,-86},{-84,-69},{-78,-69}}, color={0,0,127}));
  connect(booToRea.y, winAC.uFan) annotation (Line(points={{-8,-64},{2,-64},{2,
          -38},{-32,-38},{-32,10},{-22,10}}, color={0,0,127}));
  connect(realExpression.y, powModCooCoi.u)
    annotation (Line(points={{175,60},{190,60}}, color={0,0,127}));
  connect(realExpression1.y, powModFan.u)
    annotation (Line(points={{175,88},{190,88}}, color={0,0,127}));
  connect(realExpression2.y, m_flowFan.u)
    annotation (Line(points={{175,34},{190,34}}, color={0,0,127}));
  connect(realExpression3.y, TAirLvgMod.u)
    annotation (Line(points={{175,8},{190,8}}, color={0,0,127}));
  connect(realExpression4.y, TAirMixMod.u)
    annotation (Line(points={{175,-22},{190,-22}}, color={0,0,127}));
  connect(realExpression5.y, QModCooCoi.u)
    annotation (Line(points={{175,-52},{190,-52}}, color={0,0,127}));
  connect(senTem.port, zon.heaPorAir) annotation (Line(points={{30,68},{28,68},
          {28,46},{80,46},{80,42}}, color={191,0,0}));
  connect(realExpression6.y, TZonAir.u)
    annotation (Line(points={{175,-86},{190,-86}}, color={0,0,127}));
  connect(datRea.y[15], TZonAirEP.u) annotation (Line(points={{-99,40},{-98,40},
          {-98,52},{-132,52},{-132,128},{-122,128}}, color={0,0,127}));
  connect(damPos.y, winAC.uEco) annotation (Line(points={{-98,0},{-38,0},{-38,
          18},{-22,18}}, color={0,0,127}));
  connect(weaDat.weaBus, bou.weaBus) annotation (Line(
      points={{-74,130},{-66,130},{-66,134.2},{-60,134.2}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, out.weaBus) annotation (Line(
      points={{-74,130},{-68,130},{-68,110.2},{-60,110.2}},
      color={255,204,51},
      thickness=0.5));
  connect(out.ports[1], winAC.port_Air_b1) annotation (Line(points={{-40,110},{-30,
          110},{-30,4},{-20,4}}, color={0,127,255}));
  connect(bou.ports[1], winAC.port_Air_a1) annotation (Line(points={{-40,134},{-26,
          134},{-26,-4},{-20,-4}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,
            -100},{240,140}})),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{
            240,140}})),
    experiment(
      StartTime=18144000,
      StopTime=18230400,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/ZoneEquipment/WindowAC/Validation/CoolingModeEPlusComparison_withNewControl_withSPAWNZone.mos"
        "Simulate and Plot"));
end CoolingModeEPlusComparison_withNewControl_withSPAWNZone_FixedOA;

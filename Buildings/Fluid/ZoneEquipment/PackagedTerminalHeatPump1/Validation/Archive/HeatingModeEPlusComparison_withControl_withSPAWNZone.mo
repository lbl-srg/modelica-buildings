within Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump1.Validation.Archive;
model HeatingModeEPlusComparison_withControl_withSPAWNZone
  "Validation model for heating mode operation of PTHP system"
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

  parameter HeatExchangers.DXCoils.AirSource.Data.Generic.DXCoil datCoi(sta={
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
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(final filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Outdoor weather data"
    annotation (Placement(transformation(extent={{-80,110},{-60,130}})));
  Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump1.PackagedTerminalHeatPump
    PTHP(
    redeclare package MediumA = MediumA,
    mAirOut_flow_nominal=PTHPSizing.mAirOut_flow_nominal,
    mAir_flow_nominal=PTHPSizing.mAir_flow_nominal,
    dpAir_nominal(displayUnit="Pa") = dpAir_nominal,
    dpDX_nominal(displayUnit="Pa") = dpDX_nominal,
    redeclare
      Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump1.Validation.Data.FanData
      fanPer,
    datCooCoi=datCoi)
    annotation (Placement(transformation(extent={{-20,-20},{20,20}})));
  Modelica.Blocks.Sources.CombiTimeTable datRea(
    final tableOnFile=true,
    final fileName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Fluid/ZoneEquipment/WindowAC/WindACFanOnOff.dat"),
    final columns=2:20,
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

  Controls.ConstantFanCyclingCooling conVarWatConFan
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
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    annotation (Placement(transformation(extent={{-30,-74},{-10,-54}})));
  MixingVolumes.MixingVolume vol(
    redeclare package Medium = MediumA,
    T_start=303.15,
    m_flow_nominal=PTHPSizing.mAir_flow_nominal,
    V=113.27) annotation (Placement(transformation(extent={{-8,60},{12,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(k=100)
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  Sensors.Temperature senTem(redeclare package Medium = MediumA)
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=PTHP.fan.P + PTHP.SupHeaCoi.P)
    annotation (Placement(transformation(extent={{32,-70},{52,-50}})));
  Modelica.Blocks.Math.Mean powMod(f=1/averagingTimestep)
    annotation (Placement(transformation(extent={{70,-70},{90,-50}})));
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
    nPorts=3) annotation (Placement(transformation(extent={{60,22},{100,62}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1[3](k=fill(0, 3))
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
equation
  connect(damPos.y, PTHP.uEco) annotation (Line(points={{-98,0},{-40,0},{-40,18},
          {-22,18}}, color={0,0,127}));
  connect(datRea.y[11], div1.u1) annotation (Line(points={{-99,40},{-94,40},{-94,
          56},{-82,56}}, color={0,0,127}));
  connect(datRea.y[11], totMasAir.u) annotation (Line(points={{-99,40},{-94,40},
          {-94,18},{-82,18}}, color={0,0,127}));
  connect(totMasAir.y, div1.u2) annotation (Line(points={{-58,18},{-56,18},{-56,
          36},{-88,36},{-88,44},{-82,44}},
                         color={0,0,127}));
  connect(conVarWatConFan.yCooEna, PTHP.uCooEna) annotation (Line(points={{-38,
          -24},{-30,-24},{-30,-9.8},{-22,-9.8}}, color={255,0,255}));
  connect(ava.y, conVarWatConFan.uAva) annotation (Line(points={{-108,-50},{
          -100,-50},{-100,-56},{-78,-56}}, color={255,0,255}));
  connect(fanOpeMod.y, conVarWatConFan.fanOpeMod) annotation (Line(points={{
          -108,-80},{-100,-80},{-100,-64},{-78,-64}}, color={255,0,255}));
  connect(PTHP.yFan_actual, fanProOn.u)
    annotation (Line(points={{21,16},{28,16}}, color={0,0,127}));
  connect(fanProOn.y, conVarWatConFan.uFan) annotation (Line(points={{52,16},{
          100,16},{100,-80},{-86,-80},{-86,-24},{-78,-24}}, color={255,0,255}));
  connect(conVarWatConFan.yFan, booToRea.u)
    annotation (Line(points={{-38,-64},{-32,-64}}, color={255,0,255}));
  connect(booToRea.y, mul.u2) annotation (Line(points={{-8,-64},{-6,-64},{-6,
          -56},{-2,-56}}, color={0,0,127}));
  connect(conVarWatConFan.yFanSpe, mul.u1) annotation (Line(points={{-38,-56},{
          -34,-56},{-34,-44},{-2,-44}}, color={0,0,127}));
  connect(mul.y, PTHP.uFan) annotation (Line(points={{22,-50},{28,-50},{28,-36},
          {-34,-36},{-34,10},{-22,10}}, color={0,0,127}));
  connect(datRea.y[7], K2C[1].u) annotation (Line(points={{-99,40},{-94,40},{-94,
          80},{-82,80}}, color={0,0,127}));
  connect(datRea.y[14], K2C[2].u) annotation (Line(points={{-99,40},{-94,40},{-94,
          80},{-82,80}}, color={0,0,127}));
  connect(datRea.y[15], K2C[3].u) annotation (Line(points={{-99,40},{-94,40},{-94,
          80},{-82,80}}, color={0,0,127}));
  connect(realExpression.y, powMod.u)
    annotation (Line(points={{53,-60},{68,-60}}, color={0,0,127}));
  connect(datRea.y[3], powEP.u) annotation (Line(points={{-99,40},{-94,40},{-94,
          58},{-130,58},{-130,70},{-122,70}}, color={0,0,127}));
  connect(building.weaBus, PTHP.weaBus) annotation (Line(
      points={{50,120},{54,120},{54,88},{-15.8,88},{-15.8,18}},
      color={255,204,51},
      thickness=0.5));
  connect(K2C[2].y, conVarWatConFan.TCooSet) annotation (Line(points={{-58,80},{
          -44,80},{-44,-10},{-96,-10},{-96,-40},{-78,-40}}, color={0,0,127}));
  connect(PTHP.port_Air_a2, zon.ports[1]) annotation (Line(points={{20,4},{
          77.3333,4},{77.3333,22.9}}, color={0,127,255}));
  connect(PTHP.port_Air_b2, zon.ports[2])
    annotation (Line(points={{20,-4},{80,-4},{80,22.9}}, color={0,127,255}));
  connect(con1.y, zon.qGai_flow) annotation (Line(points={{22,40},{40,40},{40,52},
          {58,52}}, color={0,0,127}));
  connect(zon.TAir, conVarWatConFan.TZon) annotation (Line(points={{101,60},{110,
          60},{110,-90},{-90,-90},{-90,-32},{-78,-32}}, color={0,0,127}));
  connect(senTem.port, zon.ports[3]) annotation (Line(points={{30,60},{56,60},{
          56,22.9},{82.6667,22.9}},
                                 color={0,127,255}));
  connect(PTHP.TAirSup, conVarWatConFan.TSup) annotation (Line(points={{21,10},
          {30,10},{30,-86},{-84,-86},{-84,-69},{-78,-69}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},
            {120,140}})),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{120,
            140}})),
    experiment(
      StartTime=18144000,
      StopTime=18230400,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/ZoneEquipment/WindowAC/Validation/CoolingModeEPlusComparison_withControl_withSPAWNZone.mos"
        "Simulate and Plot"));
end HeatingModeEPlusComparison_withControl_withSPAWNZone;

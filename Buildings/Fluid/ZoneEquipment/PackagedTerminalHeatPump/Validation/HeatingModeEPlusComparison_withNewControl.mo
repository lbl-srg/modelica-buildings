within Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump.Validation;
model HeatingModeEPlusComparison_withNewControl
  "Validation model for cooling mode operation of PTHP system"
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
        Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.Stage(
        spe=1800,
        nomVal=
          Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-9365,
          COP_nominal=3.5,
          SHR_nominal=0.8,
          m_flow_nominal=1.2*0.56578),
        perCur=
          Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.PerformanceCurve(
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
  Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump.Validation.Data.SizingData
    PTHPSizing "Sizing parameters for PTHP"
    annotation (Placement(transformation(extent={{60,72},{80,92}})));
  Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump.PackagedTerminalHeatPump
    PTHP(
    redeclare package MediumA = MediumA,
    mAirOut_flow_nominal=PTHPSizing.mAirOut_flow_nominal,
    mAir_flow_nominal=PTHPSizing.mAir_flow_nominal,
    dpAir_nominal(displayUnit="Pa") = dpAir_nominal,
    dpDX_nominal(displayUnit="Pa") = dpDX_nominal,
    redeclare
      Buildings.Fluid.ZoneEquipment.PackagedTerminalHeatPump.Validation.Data.FanData
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

  Controls.CycleFanCyclingCoil       conVarWatConFan(tFanEna=360)
    annotation (Placement(transformation(extent={{-76,-68},{-40,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant ava(k=true)
    "Availability signal"
    annotation (Placement(transformation(extent={{-130,-60},{-110,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fanOpeMod(k=false)
    "Fan operating mode"
    annotation (Placement(transformation(extent={{-130,-90},{-110,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis fanProOn(uLow=0.04, uHigh=
        0.05) "Check if fan is proven on based off of measured fan speed"
    annotation (Placement(transformation(extent={{34,6},{54,26}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    annotation (Placement(transformation(extent={{-30,-74},{-10,-54}})));
  MixingVolumes.MixingVolume vol(
    redeclare package Medium = MediumA,
    T_start=303.15,
    m_flow_nominal=PTHPSizing.mAir_flow_nominal,
    V=113.27,
    nPorts=3) annotation (Placement(transformation(extent={{80,40},{100,60}})));
  Sensors.Temperature senTem(redeclare package Medium = MediumA)
    annotation (Placement(transformation(extent={{30,50},{50,70}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=PTHP.SupHeaCoi.P)
    annotation (Placement(transformation(extent={{126,-48},{146,-28}})));
  Modelica.Blocks.Math.Mean powModCooCoi(f=1/averagingTimestep)
    annotation (Placement(transformation(extent={{164,-48},{184,-28}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay powEP(samplePeriod=
        averagingTimestep)
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));

  HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo
    annotation (Placement(transformation(extent={{-8,70},{12,90}})));
  Modelica.Blocks.Math.Mean powModFan(f=1/averagingTimestep)
    annotation (Placement(transformation(extent={{164,-20},{184,0}})));
  Modelica.Blocks.Sources.RealExpression realExpression1(y=PTHP.fan.P)
    annotation (Placement(transformation(extent={{126,-20},{146,0}})));
  Modelica.Blocks.Sources.RealExpression realExpression2(y=PTHP.fan.m_flow)
    annotation (Placement(transformation(extent={{126,-74},{146,-54}})));
  Modelica.Blocks.Math.Mean m_flowFan(f=1/averagingTimestep)
    annotation (Placement(transformation(extent={{164,-74},{184,-54}})));
  Modelica.Blocks.Sources.RealExpression realExpression3(y=PTHP.TAirLvg.T -
        273.15)
    annotation (Placement(transformation(extent={{126,-100},{146,-80}})));
  Modelica.Blocks.Math.Mean TAirLvgMod(f=1/averagingTimestep)
    annotation (Placement(transformation(extent={{164,-100},{184,-80}})));
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
    annotation (Line(points={{21,16},{32,16}}, color={0,0,127}));
  connect(fanProOn.y, conVarWatConFan.uFan) annotation (Line(points={{56,16},{
          100,16},{100,-80},{-86,-80},{-86,-24},{-78,-24}}, color={255,0,255}));
  connect(conVarWatConFan.yFan, booToRea.u)
    annotation (Line(points={{-38,-64},{-32,-64}}, color={255,0,255}));
  connect(datRea.y[7], K2C[1].u) annotation (Line(points={{-99,40},{-94,40},{-94,
          80},{-82,80}}, color={0,0,127}));
  connect(datRea.y[14], K2C[2].u) annotation (Line(points={{-99,40},{-94,40},{-94,
          80},{-82,80}}, color={0,0,127}));
  connect(datRea.y[15], K2C[3].u) annotation (Line(points={{-99,40},{-94,40},{-94,
          80},{-82,80}}, color={0,0,127}));
  connect(realExpression.y, powModCooCoi.u)
    annotation (Line(points={{147,-38},{162,-38}}, color={0,0,127}));
  connect(datRea.y[3], powEP.u) annotation (Line(points={{-99,40},{-94,40},{-94,
          58},{-130,58},{-130,70},{-122,70}}, color={0,0,127}));
  connect(K2C[2].y, conVarWatConFan.TCooSet) annotation (Line(points={{-58,80},
          {-46,80},{-46,-10},{-98,-10},{-98,-40},{-78,-40}},color={0,0,127}));
  connect(PTHP.TAirSup, conVarWatConFan.TSup) annotation (Line(points={{21,10},
          {30,10},{30,-86},{-84,-86},{-84,-69},{-78,-69}}, color={0,0,127}));
  connect(PTHP.port_Air_a2, vol.ports[1]) annotation (Line(points={{20,4},{
          87.3333,4},{87.3333,40}}, color={0,127,255}));
  connect(PTHP.port_Air_b2, vol.ports[2])
    annotation (Line(points={{20,-4},{90,-4},{90,40}}, color={0,127,255}));
  connect(senTem.port, vol.ports[3]) annotation (Line(points={{40,50},{40,40},{
          92.6667,40}}, color={0,127,255}));
  connect(senTem.T, conVarWatConFan.TZon) annotation (Line(points={{47,60},{60,
          60},{60,-94},{-92,-94},{-92,-32},{-78,-32}}, color={0,0,127}));
  connect(weaDat.weaBus, PTHP.weaBus) annotation (Line(
      points={{-60,120},{-15.8,120},{-15.8,18}},
      color={255,204,51},
      thickness=0.5));
  connect(preHeaFlo.port, vol.heatPort) annotation (Line(points={{12,80},{54,80},
          {54,50},{80,50}}, color={191,0,0}));
  connect(datRea.y[3], preHeaFlo.Q_flow) annotation (Line(points={{-99,40},{-94,
          40},{-94,100},{-20,100},{-20,80},{-8,80}}, color={0,0,127}));
  connect(booToRea.y, PTHP.uFan) annotation (Line(points={{-8,-64},{0,-64},{0,-36},
          {-26,-36},{-26,10},{-22,10}}, color={0,0,127}));
  connect(realExpression1.y, powModFan.u)
    annotation (Line(points={{147,-10},{162,-10}}, color={0,0,127}));
  connect(realExpression2.y, m_flowFan.u)
    annotation (Line(points={{147,-64},{162,-64}}, color={0,0,127}));
  connect(realExpression3.y, TAirLvgMod.u)
    annotation (Line(points={{147,-90},{162,-90}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,
            -100},{200,140}})),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{
            200,140}})),
    experiment(
      StartTime=18144000,
      StopTime=18230400,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/ZoneEquipment/WindowAC/Validation/CoolingModeEPlusComparison_withControl.mos"
        "Simulate and Plot"));
end HeatingModeEPlusComparison_withNewControl;

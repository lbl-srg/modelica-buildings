within Buildings.Fluid.ZoneEquipment.WindowAC.Validation;
model CoolingMode
  "Validation model for cooling mode operation of window AC system"
  extends Modelica.Icons.Example;

  replaceable package MediumA = Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialCondensingGases
    "Medium model for air";

  parameter Modelica.Units.SI.PressureDifference dpAir_nominal=75
    "Pressure drop at m_flow_nominal across window AC ducts";

  parameter Modelica.Units.SI.PressureDifference dpDX_nominal=75
    "Pressure drop at m_flow_nominal across DX cooling coil";

  parameter Modelica.Units.SI.Time averagingTimestep = 3600
    "Time-step used to average out Modelica results for comparison with EPlus results. Same value is also applied to unit delay shift on EPlus power value";

  parameter HeatExchangers.DXCoils.AirSource.Data.Generic.CoolingCoil datCoi(sta={
        Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.Stage(
        spe=1800/60,
        nomVal=
          Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-7144,
          COP_nominal=3.0,
          SHR_nominal=0.8,
          m_flow_nominal=0.50747591),
        perCur=
          Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.PerformanceCurve(
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
    "Performance data record"
    annotation (Placement(transformation(extent={{60,106},{80,126}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant damPos(
    final k=0.2)
    "Outdoor air damper position"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));

  Buildings.Fluid.ZoneEquipment.WindowAC.Validation.Data.SizingData winACSizing(
    final mAir_flow_nominal=0.50747591)
    "Sizing parameters for window AC"
    annotation (Placement(transformation(extent={{60,72},{80,92}})));

  Buildings.Fluid.ZoneEquipment.WindowAC.WindowAC winAC(
    redeclare package MediumA = MediumA,
    final mAirOut_flow_nominal=winACSizing.mAirOut_flow_nominal,
    final mAir_flow_nominal=winACSizing.mAir_flow_nominal,
    final dpAir_nominal=dpAir_nominal,
    final dpDX_nominal= dpDX_nominal,
    redeclare Buildings.Fluid.ZoneEquipment.WindowAC.Validation.Data.FanData fanPer,
    final datCoi=datCoi,
    sinSpeDXCoo(
      tau=3600))
    annotation (Placement(transformation(extent={{-16,-24},{24,16}})));

  Modelica.Blocks.Sources.Pulse p(
    final nperiod=1,
    final offset=101325,
    final width=100,
    final period=864000,
    final startTime=18144000,
    final amplitude=1086)
    "Pressure"
    annotation (Placement(transformation(extent={{0,100},{20,120}})));

  Modelica.Blocks.Sources.CombiTimeTable datRea(
    final tableOnFile=true,
    final fileName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Fluid/ZoneEquipment/WindowAC/WindACFanOnOff.dat"),
    final columns=2:10,
    final tableName="EnergyPlus",
    final smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    final shiftTime= 15724800)
    "Reader for \"FanCoilAutoSize_ConstantFlowVariableFan.idf\" energy plus example results"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));

  Buildings.Controls.OBC.CDL.Continuous.AddParameter K2C[3](
    final p=fill(273.15,3))
    "Convert temperature from Celsius to Kelvin "
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));

  Buildings.Fluid.ZoneEquipment.BaseClasses.ModularController modCon(
    final heaCoiTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.HeaSou.noHea,
    final cooCoiTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.CooSou.eleDX,
    final supHeaTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.SupHeaSou.noHea,
    final fanTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.FanTypes.conSpeFan,
    final has_fanOpeMod=true,
    final minFanSpe=0.1,
    final tFanEna=60)
    "Instance of modular controller with constant speed fan and DX cooling coil"
    annotation (Placement(transformation(extent={{-76,-68},{-56,-36}})));

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
    annotation (Placement(transformation(extent={{30,6},{50,26}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Boolean to real conversion for fan signal"
    annotation (Placement(transformation(extent={{-28,-70},{-10,-52}})));

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTem
    "Zone air temperature sensor"
    annotation (Placement(transformation(extent={{30,58},{50,78}})));

  inner ThermalZones.EnergyPlus_9_6_0.Building building(
    final idfName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Fluid/ZoneEquipment/WindowAC/WindACFanOnOff.idf"),
    final epwName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw"),
    final weaName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Building energy model"
    annotation (Placement(transformation(extent={{32,110},{52,130}})));

  ThermalZones.EnergyPlus_9_6_0.ThermalZone zon(
    final zoneName="West Zone",
    redeclare package Medium = MediumA,
    final T_start=296.85,
    final nPorts=2)
    "Thermal zone model"
    annotation (Placement(transformation(extent={{60,22},{100,62}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1[3](
    final k=fill(0, 3))
    "Internal heat gain added to zone"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));

  Modelica.Blocks.Sources.RealExpression realExpression(
    final y=winAC.sinSpeDXCoo.P)
    "DX cooling coil power consumption"
    annotation (Placement(transformation(extent={{118,74},{138,94}})));

  Modelica.Blocks.Math.Mean PCooCoiMod(
    final f=1/averagingTimestep)
    "Time-averaged cooling coil power"
    annotation (Placement(transformation(extent={{156,74},{176,94}})));

  Modelica.Blocks.Math.Mean PFanMod(
    final f=1/averagingTimestep)
    "Time-averaged fan power"
    annotation (Placement(transformation(extent={{156,102},{176,122}})));

  Modelica.Blocks.Sources.RealExpression realExpression1(
    final y=winAC.fan.P)
    "Fan power consumption"
    annotation (Placement(transformation(extent={{118,102},{138,122}})));

  Modelica.Blocks.Sources.RealExpression realExpression2(
    final y=winAC.fan.m_flow)
    "Fan air mass flow rate"
    annotation (Placement(transformation(extent={{118,48},{138,68}})));

  Modelica.Blocks.Math.Mean m_flowFanMod(
    final f=1/averagingTimestep)
    "Time-averaged fan mass flow rate"
    annotation (Placement(transformation(extent={{156,48},{176,68}})));

  Modelica.Blocks.Sources.RealExpression realExpression3(
    final y=winAC.TAirLvg.T-273.15)
    "Window AC leaving air temperature (in deg C)"
    annotation (Placement(transformation(extent={{118,20},{138,40}})));

  Modelica.Blocks.Math.Mean TAirLvgMod(
    final f=1/averagingTimestep)
    "Time-averaged leaving air temperature from window AC"
    annotation (Placement(transformation(extent={{156,20},{176,40}})));

  Modelica.Blocks.Sources.RealExpression realExpression4(
    final y=winAC.TAirMix.T - 273.15)
    "Window AC mixed air temperature (in deg C)"
    annotation (Placement(transformation(extent={{118,-8},{138,12}})));

  Modelica.Blocks.Math.Mean TAirMixMod(
    final f=1/averagingTimestep)
    "Time-averaged mixed air temperature"
    annotation (Placement(transformation(extent={{156,-8},{176,12}})));

  Modelica.Blocks.Math.Mean QCooCoiMod(
    final f=1/averagingTimestep)
    "Time-averaged cooling coil heat removal rate"
    annotation (Placement(transformation(extent={{156,-38},{176,-18}})));

  Modelica.Blocks.Sources.RealExpression realExpression5(
    final y=-winAC.sinSpeDXCoo.QSen_flow - winAC.sinSpeDXCoo.QLat_flow)
    "Total heat removal rate from air stream by DX cooling coil"
    annotation (Placement(transformation(extent={{118,-38},{138,-18}})));

  Modelica.Blocks.Sources.RealExpression realExpression6(
    final y=senTem.T - 273.15)
    "Measured zone air temperature (in deg C)"
    annotation (Placement(transformation(extent={{118,-94},{138,-74}})));

  Modelica.Blocks.Math.Mean TZonAirMod(
    final f=1/averagingTimestep)
    "Time-averaged zone air temperature"
    annotation (Placement(transformation(extent={{156,-94},{176,-74}})));

  Modelica.Blocks.Sources.RealExpression TZonAirEP(
    final y=datRea.y[8])
    "Zone air temperature from EPlus"
    annotation (Placement(transformation(extent={{194,-94},{214,-74}})));

  Modelica.Blocks.Sources.RealExpression PCooCoiEP(
    final y=datRea.y[2] - datRea.y[9])
    "Cooling coil power consumption from EPlus"
    annotation (Placement(transformation(extent={{192,76},{212,96}})));

  Modelica.Blocks.Sources.RealExpression m_flowFanEP(
    final y=datRea.y[6])
    "Fan mass flow rate from EPlus"
    annotation (Placement(transformation(extent={{194,48},{214,68}})));

  Modelica.Blocks.Sources.RealExpression PLRCooCoiEP(
    final y=datRea.y[3])
    "Cooling coil PLR from EPlus"
    annotation (Placement(transformation(extent={{194,-64},{214,-44}})));

  Modelica.Blocks.Math.Mean PLRCooCoiMod(
    final f=1/averagingTimestep)
    "Time-averaged cooling coil PLR"
    annotation (Placement(transformation(extent={{156,-64},{176,-44}})));

  Modelica.Blocks.Sources.RealExpression realExpression10(
    final y=(winAC.sinSpeDXCoo.QSen_flow+winAC.sinSpeDXCoo.QLat_flow)/winAC.sinSpeDXCoo.datCoi.sta[1].nomVal.Q_flow_nominal)
    "PLR of DX cooling coil"
    annotation (Placement(transformation(extent={{118,-64},{138,-44}})));

  Modelica.Blocks.Sources.RealExpression QCooCoiEP(
    final y=datRea.y[1])
    "Cooling coil heat removal rate from EPlus"
    annotation (Placement(transformation(extent={{194,-36},{214,-16}})));

  Modelica.Blocks.Sources.RealExpression TAirLvgEP(
    final y=datRea.y[5])
    "Leaving air temperature from EPlus"
    annotation (Placement(transformation(extent={{194,20},{214,40}})));

equation
  connect(modCon.yCooEna, winAC.uCooEna) annotation (Line(points={{-54,-40},{-30,
          -40},{-30,-18},{-17,-18}},               color={255,0,255}));
  connect(ava.y, modCon.uAva) annotation (Line(points={{-108,-50},{-100,-50},{-100,
          -58},{-78,-58}},             color={255,0,255}));
  connect(fanOpeMod.y, modCon.fanOpeMod) annotation (Line(points={{-108,-80},{-100,
          -80},{-100,-62},{-78,-62}},             color={255,0,255}));
  connect(winAC.yFan_actual, fanProOn.u)
    annotation (Line(points={{25,12},{26,12},{26,16},{28,16}},
                                               color={0,0,127}));
  connect(fanProOn.y, modCon.uFan) annotation (Line(points={{52,16},{100,16},{100,
          -80},{-86,-80},{-86,-38},{-78,-38}},             color={255,0,255}));
  connect(modCon.yFan, booToRea.u) annotation (Line(points={{-54,-64},{-34,-64},
          {-34,-61},{-29.8,-61}},           color={255,0,255}));
  connect(datRea.y[4], K2C[1].u) annotation (Line(points={{-99,40},{-94,40},{-94,
          80},{-82,80}}, color={0,0,127}));
  connect(datRea.y[7], K2C[2].u) annotation (Line(points={{-99,40},{-94,40},{-94,
          80},{-82,80}}, color={0,0,127}));
  connect(datRea.y[8], K2C[3].u) annotation (Line(points={{-99,40},{-94,40},{-94,
          80},{-82,80}}, color={0,0,127}));
  connect(building.weaBus, winAC.weaBus) annotation (Line(
      points={{52,120},{54,120},{54,88},{-13.2,88},{-13.2,14.2}},
      color={255,204,51},
      thickness=0.5));
  connect(K2C[2].y, modCon.TCooSet) annotation (Line(points={{-58,80},{-44,80},{
          -44,-10},{-96,-10},{-96,-46},{-78,-46}},             color={0,0,127}));
  connect(winAC.port_Air_a2, zon.ports[1]) annotation (Line(points={{24,0},{78,0},
          {78,22.9}},         color={0,127,255}));
  connect(winAC.port_Air_b2, zon.ports[2])
    annotation (Line(points={{24,-8},{82,-8},{82,22.9}}, color={0,127,255}));
  connect(con1.y, zon.qGai_flow) annotation (Line(points={{22,40},{40,40},{40,52},
          {58,52}}, color={0,0,127}));
  connect(zon.TAir, modCon.TZon) annotation (Line(points={{101,60},{110,60},{110,
          -90},{-90,-90},{-90,-42},{-78,-42}},             color={0,0,127}));
  connect(winAC.TAirSup, modCon.TSup) annotation (Line(points={{25,6},{30,6},{30,
          -86},{-84,-86},{-84,-66},{-78,-66}},             color={0,0,127}));
  connect(booToRea.y, winAC.uFan) annotation (Line(points={{-8.2,-61},{2,-61},{2,
          -38},{-32,-38},{-32,10},{-17,10}}, color={0,0,127}));
  connect(realExpression.y, PCooCoiMod.u)
    annotation (Line(points={{139,84},{154,84}}, color={0,0,127}));
  connect(realExpression1.y, PFanMod.u)
    annotation (Line(points={{139,112},{154,112}}, color={0,0,127}));
  connect(realExpression2.y, m_flowFanMod.u)
    annotation (Line(points={{139,58},{154,58}}, color={0,0,127}));
  connect(realExpression3.y, TAirLvgMod.u)
    annotation (Line(points={{139,30},{154,30}},
                                               color={0,0,127}));
  connect(realExpression4.y, TAirMixMod.u)
    annotation (Line(points={{139,2},{154,2}},     color={0,0,127}));
  connect(realExpression5.y,QCooCoiMod. u)
    annotation (Line(points={{139,-28},{154,-28}}, color={0,0,127}));
  connect(senTem.port, zon.heaPorAir) annotation (Line(points={{30,68},{28,68},
          {28,46},{80,46},{80,42}}, color={191,0,0}));
  connect(realExpression6.y, TZonAirMod.u)
    annotation (Line(points={{139,-84},{154,-84}}, color={0,0,127}));
  connect(damPos.y, winAC.uEco) annotation (Line(points={{-98,0},{-38,0},{-38,14},
          {-17,14}}, color={0,0,127}));
  connect(realExpression10.y, PLRCooCoiMod.u)
    annotation (Line(points={{139,-54},{154,-54}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{260,
            140}})),
    experiment(
      StartTime=15897600,
      StopTime=16502400,
      Tolerance=1e-6),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/ZoneEquipment/WindowAC/Validation/CoolingMode.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
    <p>
    This is a validation model for the window air conditioner system model with a modular controller. 
    The validation model consists of: 
    </p>
    <ul>
    <li>
    An instance of the window air conditioner system model <code>WindowAC</code>. 
    </li>
    <li>
    thermal zone model <code>zon</code> of class 
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
    The simulation model provides a closed-loop example of <code>WindowAC</code> that 
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

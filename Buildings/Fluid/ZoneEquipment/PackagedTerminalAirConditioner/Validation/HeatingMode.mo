within Buildings.Fluid.ZoneEquipment.PackagedTerminalAirConditioner.Validation;
model HeatingMode
  "Validation model for heating mode operation of packaged terminal air conditioner"
  extends Modelica.Icons.Example;

  replaceable package MediumA = Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialCondensingGases
    "Medium model for air";

  parameter Modelica.Units.SI.PressureDifference dpAir_nominal=75
    "Pressure drop at m_flow_nominal";

  parameter Modelica.Units.SI.PressureDifference dpDX_nominal=75
    "Pressure drop at m_flow_nominal";

  parameter Modelica.Units.SI.Time averagingTimestep = 3600
    "Time-step used to average out Modelica results for comparison with EPlus results";

  parameter Modelica.Units.SI.Time delayTimestep = 3600
    "Time-step used to unit delay shift on EPlus power value";

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
          m_flow_nominal=0.50747591),
        perCur=
          Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.PerformanceCurve(
          capFunT={0.942587793,0.009543347,0.00068377,-0.011042676,0.000005249,-0.00000972},
          capFunFF={0.8,0.2,0},
          EIRFunT={0.342414409,0.034885008,-0.0006237,0.004977216,0.000437951,-0.000728028},
          EIRFunFF={1.1552,-0.1808,0.0256},
          TConInMin=273.15 + 18,
          TConInMax=273.15 + 46.11111,
          TEvaInMin=273.15 + 12.77778,
          TEvaInMax=273.15 + 23.88889,
          ffMin=0.875,
          ffMax=1.125))},
    nSta=1)
    "Cooling coil data"
    annotation (Placement(transformation(extent={{30,90},{50,110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant damPos(final k=0.27)
    "Outdoor air damper position"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));

  Buildings.Fluid.ZoneEquipment.PackagedTerminalAirConditioner.PackagedTerminalAirConditioner
    ptac(
    QHeaCoi_flow_nominal=5600.34,
    final dpCooDX_nominal=0,
    redeclare package MediumA = MediumA,
    final mAirOut_flow_nominal=0.50747591,
    final mAir_flow_nominal=0.50747591,
    final dpAir_nominal=dpAir_nominal,
    redeclare
      Buildings.Fluid.ZoneEquipment.PackagedTerminalAirConditioner.Validation.Data.FanData
      fanPer,
    datCooCoi=datCooCoi) "Packaged terminal air conditioner instance"
    annotation (Placement(transformation(extent={{-16,-26},{24,14}})));

  Modelica.Blocks.Sources.CombiTimeTable datRea(
    final tableOnFile=true,
    final fileName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Fluid/ZoneEquipment/PackagedTerminalAirConditioner/HeatingMode/1ZonePTAC.dat"),
    final columns=2:29,
    final tableName="EnergyPlus",
    final smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments)
    "Reader for energy plus reference results"
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));

  Buildings.Controls.OBC.CDL.Continuous.AddParameter K2C[2](final p=fill(273.15,
        2))
    "Convert temperature from Celsius to Kelvin "
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));

  Buildings.Fluid.ZoneEquipment.BaseClasses.ModularController modCon(
    final sysTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.SystemTypes.ptac,
    final fanTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.FanTypes.conSpeFan,
    final has_fanOpeMod=true,
    tFanEna=60,
    dTHys=0.1)
    "Instance of modular controller with constant speed fan and DX coil"
    annotation (Placement(transformation(extent={{-86,-80},{-66,-48}})));

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
    final uHigh=0.05) "Check if fan is proven on based on measured fan speed"
    annotation (Placement(transformation(extent={{34,0},{54,20}})));

  inner Buildings.ThermalZones.EnergyPlus_9_6_0.Building building(
    idfName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Fluid/ZoneEquipment/PackagedTerminalAirConditioner/HeatingMode/1ZonePTAC.idf"),
    epwName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw"),
    weaName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Building instance for thermal zone"
    annotation (Placement(transformation(extent={{-20,114},{0,134}})));

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
    annotation (Placement(transformation(extent={{156,-134},{176,-114}})));

  Modelica.Blocks.Sources.RealExpression realExpression1(
    final y=ptac.fan.P)
    "Fan power consumption (Modelica)"
    annotation (Placement(transformation(extent={{120,-134},{140,-114}})));

  Modelica.Blocks.Sources.RealExpression realExpression2(
    final y=ptac.fan.m_flow)
    "Fan mass flow rate (Modelica)"
    annotation (Placement(transformation(extent={{120,114},{140,134}})));

  Modelica.Blocks.Math.Mean m_flowFan(
    final f=1/averagingTimestep)
    "Average out Modelica results over time"
    annotation (Placement(transformation(extent={{156,114},{176,134}})));

  Modelica.Blocks.Sources.RealExpression realExpression3(
    final y=ptac.TAirLvg.T-273.15)
    "Leaving air temperature (Modelica)"
    annotation (Placement(transformation(extent={{120,84},{140,104}})));

  Modelica.Blocks.Math.Mean TAirLvgMod(
    final f=1/averagingTimestep)
    "Average out Modelica results over time"
    annotation (Placement(transformation(extent={{156,84},{176,104}})));

  Modelica.Blocks.Sources.RealExpression realExpression4(
    final y=ptac.TAirMix.T-273.15)
    "Mixed air temperature (Modelica)"
    annotation (Placement(transformation(extent={{120,54},{140,74}})));

  Modelica.Blocks.Math.Mean TAirMixMod(
    final f=1/averagingTimestep)
    "Average out Modelica results over time"
    annotation (Placement(transformation(extent={{156,54},{176,74}})));

  Modelica.Blocks.Math.Mean QHeaCoiMod(
    final f=1/averagingTimestep)
    "Average out Modelica results over time"
    annotation (Placement(transformation(extent={{156,20},{176,40}})));

  Modelica.Blocks.Sources.RealExpression realExpression5(final y=ptac.heaCoiEle.Q_flow)
    "Heating coil heat transfer rate (Modelica)"
    annotation (Placement(transformation(extent={{120,20},{140,40}})));

  Modelica.Blocks.Sources.RealExpression realExpression6(
    final y=zon.TAir - 273.15)
    "Zone air temperature (Modelica)"
    annotation (Placement(transformation(extent={{120,-26},{140,-6}})));

  Modelica.Blocks.Math.Mean TZonAirMod(
    final f=1/averagingTimestep)
    "Average out Modelica results over time"
    annotation (Placement(transformation(extent={{156,-26},{176,-6}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay TZonAirEP(
    final samplePeriod=delayTimestep)
    "Unit delay on EnergyPlus results"
    annotation (Placement(transformation(extent={{234,-26},{254,-6}})));

  Modelica.Blocks.Sources.RealExpression realExpression7(final y=datRea.y[25])
    "Zone air temperature (EnergyPlus)"
    annotation (Placement(transformation(extent={{200,-26},{220,-6}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay m_flowFanEP(
    final samplePeriod=delayTimestep)
    "Unit delay on EnergyPlus results"
    annotation (Placement(transformation(extent={{234,114},{254,134}})));

  Modelica.Blocks.Sources.RealExpression realExpression9(final y=datRea.y[27])
    "Fan mass flow rate (EnergyPlus)"
    annotation (Placement(transformation(extent={{200,114},{220,134}})));

  Modelica.Blocks.Sources.RealExpression realExpression12(
    final y=datRea.y[6])
    "Heating coil heat transfer rate (EnergyPlus)"
    annotation (Placement(transformation(extent={{200,22},{220,42}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay QHeaCoiEP(
    final samplePeriod=delayTimestep)
    "Unit delay on EnergyPlus results"
    annotation (Placement(transformation(extent={{234,22},{254,42}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay TAirLvgEP(
    final samplePeriod=delayTimestep)
    "Unit delay on EnergyPlus results"
    annotation (Placement(transformation(extent={{234,84},{254,104}})));

  Modelica.Blocks.Sources.RealExpression realExpression14(final y=datRea.y[20])
    "Leaving air temperature (EnergyPlus)"
    annotation (Placement(transformation(extent={{200,84},{220,104}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay TAirMixEP(
    final samplePeriod=delayTimestep)
    "Unit delay on EnergyPlus results"
    annotation (Placement(transformation(extent={{234,54},{254,74}})));

  Modelica.Blocks.Sources.RealExpression realExpression15(final y=datRea.y[17])
    "Mixed air temperature (EnergyPlus)"
    annotation (Placement(transformation(extent={{200,54},{220,74}})));

  Buildings.BoundaryConditions.WeatherData.Bus weaBus
    "Weather bus"
    annotation (Placement(transformation(extent={{18,104},{58,144}}),
      iconTransformation(extent={{-168,170},{-148,190}})));

  Modelica.Blocks.Routing.RealPassThrough TOut
    "Outdoor air drybulb temperature"
    annotation (Placement(transformation(extent={{62,114},{82,134}})));

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

  Modelica.Blocks.Sources.RealExpression realExpression17(final y=ptac.heaCoiEle.Q_flow)
    "Heating coil power consumption (Modelica)"
    annotation (Placement(transformation(extent={{120,-62},{140,-42}})));

  Modelica.Blocks.Sources.RealExpression realExpression10(
    final y=ptac.CooCoi.P)
    "Cooling coil power consumption (Modelica)"
    annotation (Placement(transformation(extent={{120,-100},{140,-80}})));

  Modelica.Blocks.Math.Mean powCooCoiMod(
    final f=1/averagingTimestep)
    "Average out Modelica results over time"
    annotation (Placement(transformation(extent={{156,-100},{176,-80}})));

  Modelica.Blocks.Sources.RealExpression realExpression11(
    final y=datRea.y[4])
    "Cooling coil power consumption"
    annotation (Placement(transformation(extent={{200,-98},{220,-78}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay powCooCoiEP(
    final samplePeriod=delayTimestep)
    "Unit delay on EnergyPlus results"
    annotation (Placement(transformation(extent={{234,-98},{254,-78}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay powFanEP(
    final samplePeriod=delayTimestep)
    "Unit delay on EnergyPlus results"
    annotation (Placement(transformation(extent={{234,-134},{254,-114}})));

  Modelica.Blocks.Sources.RealExpression realExpression18(final y=datRea.y[26])
    "Fan power consumption (EnergyPlus)"
    annotation (Placement(transformation(extent={{200,-134},{220,-114}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Convert enable signal to real value"
    annotation (Placement(transformation(extent={{-52,-84},{-32,-64}})));

  Modelica.Blocks.Math.Division division
    annotation (Placement(transformation(extent={{-92,-6},{-72,14}})));

  Modelica.Blocks.Sources.RealExpression Nominal_mass_flow(y=0.50747591)
    annotation (Placement(transformation(extent={{-132,-12},{-112,8}})));

equation
  connect(ptac.yFan_actual, fanProOn.u) annotation (Line(points={{25,10},{32,10}},
                            color={0,0,127}));
  connect(ptac.port_Air_a2, zon.ports[1])
    annotation (Line(points={{24,-2},{76,-2},{76,30.9}},
                                                       color={0,127,255}));
  connect(ptac.port_Air_b2, zon.ports[2])
    annotation (Line(points={{24,-10},{80,-10},{80,30.9}},
                                                         color={0,127,255}));
  connect(con.y, zon.qGai_flow) annotation (Line(points={{22,40},{40,40},{40,60},
          {56,60}}, color={0,0,127}));
  connect(realExpression1.y,powFanMod. u)
    annotation (Line(points={{141,-124},{154,-124}},
                                                 color={0,0,127}));
  connect(realExpression2.y, m_flowFan.u)
    annotation (Line(points={{141,124},{154,124}},
                                                 color={0,0,127}));
  connect(realExpression3.y, TAirLvgMod.u)
    annotation (Line(points={{141,94},{154,94}},
                                               color={0,0,127}));
  connect(realExpression4.y, TAirMixMod.u)
    annotation (Line(points={{141,64},{154,64}},   color={0,0,127}));
  connect(realExpression5.y,QHeaCoiMod. u)
    annotation (Line(points={{141,30},{154,30}},   color={0,0,127}));
  connect(realExpression6.y, TZonAirMod.u)
    annotation (Line(points={{141,-16},{154,-16}}, color={0,0,127}));
  connect(damPos.y,ptac. uEco) annotation (Line(points={{-98,50},{-58,50},{-58,12},
          {-17,12}}, color={0,0,127}));
  connect(realExpression7.y, TZonAirEP.u)
    annotation (Line(points={{221,-16},{232,-16}}, color={0,0,127}));
  connect(realExpression9.y, m_flowFanEP.u)
    annotation (Line(points={{221,124},{232,124}},
                                                 color={0,0,127}));
  connect(realExpression12.y, QHeaCoiEP.u)
    annotation (Line(points={{221,32},{232,32}}, color={0,0,127}));

  connect(realExpression14.y, TAirLvgEP.u)
    annotation (Line(points={{221,94},{232,94}}, color={0,0,127}));
  connect(realExpression15.y, TAirMixEP.u)
    annotation (Line(points={{221,64},{232,64}}, color={0,0,127}));
  connect(building.weaBus,ptac. weaBus) annotation (Line(
      points={{0,124},{14,124},{14,60},{-13.2,60},{-13.2,12.2}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus, building.weaBus) annotation (Line(
      points={{38,124},{0,124}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(weaBus.TDryBul, TOut.u) annotation (Line(
      points={{38,124},{60,124}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(realExpression16.y, powHeaCoiEP.u)
    annotation (Line(points={{221,-50},{232,-50}}, color={0,0,127}));
  connect(realExpression17.y, powHeaCoiMod.u)
    annotation (Line(points={{141,-52},{154,-52}}, color={0,0,127}));
  connect(realExpression10.y, powCooCoiMod.u)
    annotation (Line(points={{141,-90},{154,-90}},   color={0,0,127}));
  connect(realExpression11.y, powCooCoiEP.u)
    annotation (Line(points={{221,-88},{232,-88}},   color={0,0,127}));
  connect(realExpression18.y, powFanEP.u)
    annotation (Line(points={{221,-124},{232,-124}}, color={0,0,127}));
  connect(datRea.y[23], K2C[1].u)
    annotation (Line(points={{-99,90},{-82,90}}, color={0,0,127}));
  connect(datRea.y[24], K2C[2].u)
    annotation (Line(points={{-99,90},{-82,90}}, color={0,0,127}));
  connect(booToRea.y, ptac.uHea) annotation (Line(points={{-30,-74},{-24,-74},{-24,
          -16},{-17,-16}},         color={0,0,127}));
  connect(division.y, ptac.uFan)
    annotation (Line(points={{-71,4},{-44,4},{-44,8},{-17,8}},
                                               color={0,0,127}));
  connect(datRea.y[27], division.u1) annotation (Line(points={{-99,90},{-94,90},
          {-94,66},{-126,66},{-126,10},{-94,10}}, color={0,0,127}));
  connect(Nominal_mass_flow.y, division.u2)
    annotation (Line(points={{-111,-2},{-94,-2}}, color={0,0,127}));
  connect(fanProOn.y, modCon.uFan) annotation (Line(points={{56,10},{56,-100},{
          -104,-100},{-104,-50},{-88,-50}},
                                       color={255,0,255}));
  connect(zon.TAir, modCon.TZon) annotation (Line(points={{99,68},{106,68},{106,
          -104},{-92,-104},{-92,-54},{-88,-54}},     color={0,0,127}));
  connect(K2C[2].y, modCon.TCooSet) annotation (Line(points={{-58,90},{-52,90},
          {-52,-44},{-96,-44},{-96,-58},{-88,-58}},    color={0,0,127}));
  connect(K2C[1].y, modCon.THeaSet) annotation (Line(points={{-58,90},{-52,90},
          {-52,-44},{-96,-44},{-96,-62},{-88,-62}},color={0,0,127}));
  connect(ava.y, modCon.uAva) annotation (Line(points={{-108,-50},{-100,-50},{
          -100,-70},{-88,-70}},
                           color={255,0,255}));
  connect(modCon.fanOpeMod, fanOpeMod.y) annotation (Line(points={{-88,-74},{
          -100,-74},{-100,-80},{-108,-80}},
                                         color={255,0,255}));
  connect(ptac.TAirSup, modCon.TSup) annotation (Line(points={{25,4},{32,4},{32,
          -94},{-90,-94},{-90,-78},{-88,-78}}, color={0,0,127}));
  connect(modCon.yCooEna, ptac.uCooEna) annotation (Line(points={{-64,-52},{-40,
          -52},{-40,-20},{-17,-20}},     color={255,0,255}));
  connect(modCon.yHeaEna, booToRea.u) annotation (Line(points={{-64,-56},{-58,
          -56},{-58,-74},{-54,-74}},
                                color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{260,
            140}}), graphics={Polygon(points={{-48,-16},{-48,-16}}, lineColor={28,
              108,200})}),
    experiment(
      Tolerance=1e-06),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/ZoneEquipment/PackagedTerminalAirConditioner/Validation/HeatingMode.mos"
        "Simulate and plot"),
    Documentation(info="<html>
    <p>
    This is a validation model for the packaged terminal air conditioner (PTAC) system model under heating mode 
    with a modular controller. The validation model consists of: </p>
    <ul>
    <li>
    An instance of the PTAC system model <code>PackagedTerminalAirConditioner</code>. 
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
    The validation model provides a closed-loop example of <code>PackagedTerminalAirConditioner</code> that 
    is operated by <code>ModularController</code> to regulate the zone temperature in 
    <code>zon</code> at its heating setpoint. 
    </p>
    </html>
    ", revisions="<html>
    <ul>
    <li>
    June 21, 2023, by Junke Wang, Xing Lu, and Karthik Devaprasad:<br/>
    First implementation.
    </li>
    </ul>
    </html>"));
end HeatingMode;

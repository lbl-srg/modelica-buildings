within Buildings.Fluid.ZoneEquipment.PackagedTerminalAirConditioner.Validation;
model CoolingMode
  "Validation model for cooling mode operation of packaged terminal air conditioner"
  extends Modelica.Icons.Example;

  replaceable package MediumA = Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialCondensingGases
    "Medium model for air";

  parameter Modelica.Units.SI.PressureDifference dpAir_nominal=75
    "Pressure drop at m_flow_nominal";

  parameter Modelica.Units.SI.PressureDifference dpDX_nominal=75
    "Pressure drop at m_flow_nominal";

  parameter Modelica.Units.SI.Time averagingTimestep = 3600
    "Time-step used to average out Modelica results for comparison with EPlus";

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

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant damPos(
    final k=0.2) "Outdoor air damper position"
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
    final fileName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Fluid/ZoneEquipment/PackagedTerminalAirConditioner/CoolingMode/1ZonePTAC.dat"),
    final columns=2:29,
    final tableName="EnergyPlus",
    final smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments)
    "Reader for EnergyPlus reference results"
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));

  Buildings.Controls.OBC.CDL.Continuous.AddParameter K2C[2](final p=fill(273.15,
        2))
    "Convert temperature from Celsius to Kelvin "
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));

  Buildings.Fluid.ZoneEquipment.BaseClasses.ModularController modularController(
    final sysTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.SystemTypes.ptac,
    final fanTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.FanTypes.conSpeFan,
    final has_fanOpeMod=true,
    tFanEna=60,
    dTHys=0.1)
    "Modular controller"
    annotation (Placement(transformation(extent={{-86,-80},{-66,-52}})));

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
    idfName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Fluid/ZoneEquipment/PackagedTerminalAirConditioner/CoolingMode/1ZonePTAC.idf"),
    epwName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw"),
    weaName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Building instance for thermal zone"
    annotation (Placement(transformation(extent={{-20,114},{0,134}})));

  Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone zon(
    final zoneName="West Zone",
    redeclare package Medium = MediumA,
    final nPorts=2)
    "Thermal zone model"
    annotation (Placement(transformation(extent={{58,30},{98,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con[3](
    final k=fill(0, 3)) "Constant zero source for internal heat gains"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));

  Buildings.BoundaryConditions.WeatherData.Bus weaBus
    "Weather bus"
    annotation (Placement(transformation(extent={{18,104},{58,144}}),
      iconTransformation(extent={{-168,170},{-148,190}})));

  Modelica.Blocks.Routing.RealPassThrough TOut
    "Outdoor air drybulb temperature"
    annotation (Placement(transformation(extent={{60,114},{80,134}})));

  Modelica.Blocks.Math.Mean powFanMod(
    final f=1/averagingTimestep)
    "Average out Modelica results over time"
    annotation (Placement(transformation(extent={{156,-136},{176,-116}})));

  Modelica.Blocks.Sources.RealExpression realExpression1(
    final y=ptac.fan.P)
    "Fan power consumption (Modelica)"
    annotation (Placement(transformation(extent={{120,-136},{140,-116}})));

  Modelica.Blocks.Sources.RealExpression realExpression2(
    final y=ptac.fan.m_flow)
    "Fan mass flow rate (Modelica)"
    annotation (Placement(transformation(extent={{120,112},{140,132}})));

  Modelica.Blocks.Math.Mean m_flowFan(
    final f=1/averagingTimestep)
    "Average out Modelica results over time"
    annotation (Placement(transformation(extent={{156,112},{176,132}})));

  Modelica.Blocks.Sources.RealExpression realExpression3(
    final y=ptac.TAirLvg.T - 273.15)
    "Leaving air temperature (Modelica)"
    annotation (Placement(transformation(extent={{120,80},{140,100}})));

  Modelica.Blocks.Math.Mean TAirLvgMod(
    final f=1/averagingTimestep)
    "Average out Modelica results over time"
    annotation (Placement(transformation(extent={{156,80},{176,100}})));

  Modelica.Blocks.Sources.RealExpression realExpression4(
    final y=ptac.TAirMix.T - 273.15)
    "Mixed air temperature (Modelica)"
    annotation (Placement(transformation(extent={{120,48},{140,68}})));

  Modelica.Blocks.Math.Mean TAirMixMod(
    final f=1/averagingTimestep)
    "Average out Modelica results over time"
    annotation (Placement(transformation(extent={{156,48},{176,68}})));

  Modelica.Blocks.Math.Mean QHeaCoiMod(
    final f=1/averagingTimestep)
    "Average out Modelica results over time"
    annotation (Placement(transformation(extent={{156,14},{176,34}})));

  Modelica.Blocks.Sources.RealExpression realExpression5(final y=ptac.heaCoiEle.Q_flow)
    "Heating coil heat transfer rate (Modelica)"
    annotation (Placement(transformation(extent={{120,14},{140,34}})));

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

  Modelica.Blocks.Sources.RealExpression realExpression7(final y=datRea.y[25])
    "Zone air temperature (EnergyPlus)"
    annotation (Placement(transformation(extent={{200,-32},{220,-12}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay m_flowFanEP(
    final samplePeriod=delayTimestep)
    "Unit delay on EnergyPlus results"
    annotation (Placement(transformation(extent={{234,112},{254,132}})));

  Modelica.Blocks.Sources.RealExpression realExpression9(final y=datRea.y[27])
    "Fan mass flow rate (EnergyPlus)"
    annotation (Placement(transformation(extent={{200,112},{220,132}})));

  Modelica.Blocks.Sources.RealExpression realExpression12(
    final y=datRea.y[6])
    "Heating coil heat transfer rate (EnergyPlus)"
    annotation (Placement(transformation(extent={{200,16},{220,36}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay QHeaCoiEP(
    final samplePeriod=delayTimestep)
    "Unit delay on EnergyPlus results"
    annotation (Placement(transformation(extent={{234,16},{254,36}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay TAirLvgEP(
    final samplePeriod=delayTimestep)
    "Unit delay on EnergyPlus results"
    annotation (Placement(transformation(extent={{234,80},{254,100}})));

  Modelica.Blocks.Sources.RealExpression realExpression14(final y=datRea.y[20])
    "Leaving air temperature (EnergyPlus)"
    annotation (Placement(transformation(extent={{200,80},{220,100}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay TAirMixEP(
    final samplePeriod=delayTimestep)
    "Unit delay on EnergyPlus results"
    annotation (Placement(transformation(extent={{234,48},{254,68}})));

  Modelica.Blocks.Sources.RealExpression realExpression15(final y=datRea.y[17])
    "Mixed air temperature (EnergyPlus)"
    annotation (Placement(transformation(extent={{200,48},{220,68}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay powHeaCoiEP(final samplePeriod=
        delayTimestep) "Unit delay on EnergyPlus results"
    annotation (Placement(transformation(extent={{234,-66},{254,-46}})));

  Modelica.Blocks.Sources.RealExpression realExpression16(
    final y=datRea.y[7])
    "Heating coil power consumption (EnergyPlus)"
    annotation (Placement(transformation(extent={{200,-66},{220,-46}})));

  Modelica.Blocks.Math.Mean powHeaCoiMod(
    final f=1/averagingTimestep)
    "Average out Modelica results over time"
    annotation (Placement(transformation(extent={{156,-68},{176,-48}})));

  Modelica.Blocks.Sources.RealExpression realExpression17(final y=ptac.heaCoiEle.Q_flow)
    "Heating coil power consumption (Modelica)"
    annotation (Placement(transformation(extent={{120,-68},{140,-48}})));

  Modelica.Blocks.Sources.RealExpression realExpression10(
    final y=ptac.CooCoi.P)
    "Cooling coil power consumption (Modelica)"
    annotation (Placement(transformation(extent={{120,-106},{140,-86}})));

  Modelica.Blocks.Math.Mean powCooCoiMod(
    final f=1/averagingTimestep)
    "Average out Modelica results over time"
    annotation (Placement(transformation(extent={{156,-106},{176,-86}})));

  Modelica.Blocks.Sources.RealExpression realExpression11(
    final y=datRea.y[4])
    "Cooling coil power consumption"
    annotation (Placement(transformation(extent={{200,-104},{220,-84}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay powCooCoiEP(
    final samplePeriod=delayTimestep)
    "Unit delay on EnergyPlus results"
    annotation (Placement(transformation(extent={{234,-104},{254,-84}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay powFanEP(
    final samplePeriod=delayTimestep)
    "Unit delay on EnergyPlus results"
    annotation (Placement(transformation(extent={{234,-136},{254,-116}})));

  Modelica.Blocks.Sources.RealExpression realExpression18(final y=datRea.y[26])
    "Fan power consumption (EnergyPlus)"
    annotation (Placement(transformation(extent={{200,-136},{220,-116}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[2]
    "Convert enable signal to real value"
    annotation (Placement(transformation(extent={{-52,-86},{-32,-66}})));

equation
  connect(ptac.yFan_actual, fanProOn.u) annotation (Line(points={{25,10},{32,10}},
                            color={0,0,127}));
  connect(ptac.port_Air_a2, zon.ports[1])
    annotation (Line(points={{24,-2},{77,-2},{77,30.9}},
                                                       color={0,127,255}));
  connect(ptac.port_Air_b2, zon.ports[2])
    annotation (Line(points={{24,-10},{79,-10},{79,30.9}},
                                                         color={0,127,255}));
  connect(con.y, zon.qGai_flow) annotation (Line(points={{22,40},{40,40},{40,60},
          {56,60}}, color={0,0,127}));
  connect(damPos.y,ptac. uEco) annotation (Line(points={{-98,50},{-58,50},{-58,12},
          {-18,12}}, color={0,0,127}));

  connect(building.weaBus,ptac. weaBus) annotation (Line(
      points={{0,124},{14,124},{14,60},{-11.8,60},{-11.8,12}},
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
      points={{38,124},{58,124}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(realExpression1.y,powFanMod. u)
    annotation (Line(points={{141,-126},{154,-126}},
                                                 color={0,0,127}));
  connect(realExpression2.y,m_flowFan. u)
    annotation (Line(points={{141,122},{154,122}},
                                                 color={0,0,127}));
  connect(realExpression3.y,TAirLvgMod. u)
    annotation (Line(points={{141,90},{154,90}},
                                               color={0,0,127}));
  connect(realExpression4.y,TAirMixMod. u)
    annotation (Line(points={{141,58},{154,58}},   color={0,0,127}));
  connect(realExpression5.y,QHeaCoiMod. u)
    annotation (Line(points={{141,24},{154,24}},   color={0,0,127}));
  connect(realExpression6.y,TZonAirMod. u)
    annotation (Line(points={{141,-22},{154,-22}}, color={0,0,127}));
  connect(realExpression7.y,TZonAirEP. u)
    annotation (Line(points={{221,-22},{232,-22}}, color={0,0,127}));
  connect(realExpression9.y,m_flowFanEP. u)
    annotation (Line(points={{221,122},{232,122}},
                                                 color={0,0,127}));
  connect(realExpression12.y,QHeaCoiEP. u)
    annotation (Line(points={{221,26},{232,26}}, color={0,0,127}));
  connect(realExpression14.y,TAirLvgEP. u)
    annotation (Line(points={{221,90},{232,90}}, color={0,0,127}));
  connect(realExpression15.y,TAirMixEP. u)
    annotation (Line(points={{221,58},{232,58}}, color={0,0,127}));
  connect(realExpression16.y, powHeaCoiEP.u)
    annotation (Line(points={{221,-56},{232,-56}}, color={0,0,127}));
  connect(realExpression17.y, powHeaCoiMod.u)
    annotation (Line(points={{141,-58},{154,-58}}, color={0,0,127}));
  connect(realExpression10.y,powCooCoiMod. u)
    annotation (Line(points={{141,-96},{154,-96}},   color={0,0,127}));
  connect(realExpression11.y,powCooCoiEP. u)
    annotation (Line(points={{221,-94},{232,-94}},   color={0,0,127}));
  connect(realExpression18.y,powFanEP. u)
    annotation (Line(points={{221,-126},{232,-126}}, color={0,0,127}));
  connect(booToRea[1].y, ptac.uFan) annotation (Line(points={{-30,-76},{-24,-76},
          {-24,4},{-18,4}}, color={0,0,127}));
  connect(booToRea[2].y, ptac.uHea) annotation (Line(points={{-30,-76},{-24,-76},
          {-24,-23.8},{-18,-23.8}}, color={0,0,127}));
  connect(datRea.y[23], K2C[1].u)
    annotation (Line(points={{-99,90},{-82,90}}, color={0,0,127}));
  connect(datRea.y[24], K2C[2].u)
    annotation (Line(points={{-99,90},{-82,90}}, color={0,0,127}));
  connect(fanProOn.y, modularController.uFan) annotation (Line(points={{56,10},{
          54,10},{54,-96},{-102,-96},{-102,-53},{-88,-53}}, color={255,0,255}));
  connect(zon.TAir, modularController.TZon) annotation (Line(points={{99,68},{112,
          68},{112,-100},{-98,-100},{-98,-56.6},{-88,-56.6}},
                                                          color={0,0,127}));
  connect(ptac.TAirSup, modularController.TSup) annotation (Line(points={{25,4},{
          30,4},{30,-90},{-92,-90},{-92,-79},{-88,-79}},  color={0,0,127}));
  connect(K2C[2].y, modularController.TCooSet) annotation (Line(points={{-58,90},
          {-52,90},{-52,-44},{-94,-44},{-94,-60.2},{-88,-60.2}},
                                                             color={0,0,127}));
  connect(K2C[1].y, modularController.THeaSet) annotation (Line(points={{-58,90},
          {-52,90},{-52,-44},{-94,-44},{-94,-64},{-88,-64}}, color={0,0,127}));
  connect(modularController.uAva, ava.y) annotation (Line(points={{-88,-72},{-104,
          -72},{-104,-50},{-108,-50}}, color={255,0,255}));
  connect(modularController.fanOpeMod, fanOpeMod.y) annotation (Line(points={{-88,
          -75.4},{-104,-75.4},{-104,-80},{-108,-80}},
                                                  color={255,0,255}));
  connect(modularController.yCooEna, ptac.uCooEna) annotation (Line(points={{-64,-53},
          {-32,-53},{-32,-15.8},{-18,-15.8}},      color={255,0,255}));
  connect(modularController.yHeaEna, booToRea[2].u) annotation (Line(points={{-64,-56},
          {-60,-56},{-60,-76},{-54,-76}},      color={255,0,255}));
  connect(modularController.yFan, booToRea[1].u)
    annotation (Line(points={{-64,-72.6},{-60,-72.6},{-60,-76},{-54,-76}},
                                                   color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),
      Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{260,
            140}}), graphics={Polygon(points={{-48,-16},{-48,-16}}, lineColor={28,
              108,200})}),
    experiment(Tolerance=1e-06),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/ZoneEquipment/PackagedTerminalAirConditioner/Validation/CoolingMode.mos"
        "Simulate and plot"),
    Documentation(info="<html>
    <p>
    This is an example model for the PTAC system model under cooling mode operation 
    with a cycling fan cycling coil (AUTO Fan) controller. It consists of: 
    </p>
<ul>
<li>
an instance of the PTAC system model <code>PackagedTerminalAirConditioner</code>. 
</li>
<li>
thermal zone model <code>zon</code> of class 
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone\">
Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone</a>. 
</li>
<li>
PTAC controller <code>cycFanCycCoi</code> of class 
<a href=\"modelica://Buildings.Fluid.ZoneEquipment.PackagedTerminalAirConditioner.Controls.CyclingFanCyclingCoil\">
Buildings.Fluid.ZoneEquipment.PackagedTerminalAirConditioner.Controls.CyclingFanCyclingCoil</a>. 
</li>
</ul>
<p>
The simulation model provides a closed-loop example of <code>PTAC</code> that 
is operated by <code>cycFanCycCoi</code> and regulates the zone temperature in 
<code>zon</code> at its specific setpoint. 
</p>
</html>
", revisions="<html>
    <ul>
    <li>
    May 17, 2023 by Junke Wang, Xing Lu and Karthik Devaprasad:<br/>
    First implementation.
    </li>
    </ul>
    </html>"));
end CoolingMode;

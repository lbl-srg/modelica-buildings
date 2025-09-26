within Buildings.Fluid.ZoneEquipment.PackagedTerminalAirConditioner.Validation;
model CoolingMode
  "Validation model for cooling mode operation of packaged terminal air conditioner"
  extends Modelica.Icons.Example;

  replaceable package MediumA = Buildings.Media.Air "Medium model for air";

  parameter Modelica.Units.SI.PressureDifference dpAir_nominal=75
    "Pressure drop at m_flow_nominal";

  parameter Modelica.Units.SI.PressureDifference dpDX_nominal=75
    "Pressure drop at m_flow_nominal";

  parameter Modelica.Units.SI.Time averagingTimestep = 3600
    "Time-step used to average out Modelica results for comparison with EPlus";

  parameter Modelica.Units.SI.Time delayTimestep = 3600
    "Time-step used to unit delay shift on EPlus power value";

  parameter Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.DXCoil datCooCoi(
    sta={
      Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.Stage(
        spe=1800,
        nomVal=Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.NominalValues(
          Q_flow_nominal=-7144.01,
          COP_nominal=3.0,
          SHR_nominal=0.8,
          m_flow_nominal=0.50747591),
        perCur=Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.PerformanceCurve(
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
    final k=0.2)
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
    final fanPer=datFan,
    final datCooCoi=datCooCoi)
    "Packaged terminal air conditioner instance"
    annotation (Placement(transformation(extent={{-16,-26},{24,14}})));

  Modelica.Blocks.Sources.CombiTimeTable datRea(
    final tableOnFile=true,
    final fileName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Fluid/ZoneEquipment/PackagedTerminalAirConditioner/CoolingMode/1ZonePTAC.dat"),
    final columns=2:11,
    final tableName="EnergyPlus",
    final smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    final shiftTime(displayUnit="d") = 7776000,
    verboseExtrapolation=true)
    "Reader for EnergyPlus reference results"
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));

  Buildings.Controls.OBC.CDL.Continuous.AddParameter K2C[2](
    final p=fill(273.15,2))
    "Convert temperature from Celsius to Kelvin "
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));

  Buildings.Fluid.ZoneEquipment.BaseClasses.ModularController modCon(
    final heaCoiTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.HeaSou.ele,
    final cooCoiTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.CooSou.eleDX,
    final supHeaTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.SupHeaSou.noHea,
    final minFanSpe=0.1,
    final fanTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.FanTypes.conSpeFan,
    final has_fanOpeMod=true,
    final tFanEna=60,
    final dTHys=0.1)
    "Instance of modular controller with constant speed fan and DX coil"
    annotation (Placement(transformation(extent={{-86,-84},{-66,-52}})));

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
    "Check if fan is proven on based on measured fan speed"
    annotation (Placement(transformation(extent={{34,0},{54,20}})));

  inner Buildings.ThermalZones.EnergyPlus_9_6_0.Building building(
    final idfName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Fluid/ZoneEquipment/PackagedTerminalAirConditioner/CoolingMode/1ZonePTAC.idf"),
    final epwName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw"),
    final weaName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Building instance for thermal zone"
    annotation (Placement(transformation(extent={{-20,114},{0,134}})));

  Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone zon(
    final zoneName="West Zone",
    redeclare package Medium = MediumA,
    final nPorts=2)
    "Thermal zone model"
    annotation (Placement(transformation(extent={{58,30},{98,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con[3](
    final k=fill(0, 3))
    "Constant zero source for internal heat gains"
    annotation (Placement(transformation(extent={{0,50},{20,70}})));

  Buildings.BoundaryConditions.WeatherData.Bus weaBus
    "Weather bus"
    annotation (Placement(transformation(extent={{18,104},{58,144}}),
      iconTransformation(extent={{-168,170},{-148,190}})));

  Modelica.Blocks.Routing.RealPassThrough TOut
    "Outdoor air drybulb temperature"
    annotation (Placement(transformation(extent={{60,114},{80,134}})));

  Modelica.Blocks.Math.Mean PFanMod(
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

  Modelica.Blocks.Sources.RealExpression realExpression6(
    final y=zon.TAir - 273.15)
    "Zone air temperature (Modelica)"
    annotation (Placement(transformation(extent={{120,-32},{140,-12}})));

  Modelica.Blocks.Math.Mean TZonAirMod(
    final f=1/averagingTimestep)
    "Average out Modelica results over time"
    annotation (Placement(transformation(extent={{156,-32},{176,-12}})));

  Modelica.Blocks.Sources.RealExpression TZonAirEP(
    final y=datRea.y[8])
    "Zone air temperature (EnergyPlus)"
    annotation (Placement(transformation(extent={{200,-32},{220,-12}})));

  Modelica.Blocks.Sources.RealExpression m_flowFanEP(
    final y=datRea.y[10])
    "Fan mass flow rate (EnergyPlus)"
    annotation (Placement(transformation(extent={{200,112},{220,132}})));

  Modelica.Blocks.Sources.RealExpression QHeaCoiEP(
    final y=datRea.y[2])
    "Heating coil heat transfer rate (EnergyPlus)"
    annotation (Placement(transformation(extent={{200,16},{220,36}})));

  Modelica.Blocks.Sources.RealExpression TAirLvgEP(
    final y=datRea.y[5])
    "Leaving air temperature (EnergyPlus)"
    annotation (Placement(transformation(extent={{200,80},{220,100}})));

  Modelica.Blocks.Sources.RealExpression TAirMixEP(
    final y=datRea.y[4])
    "Mixed air temperature (EnergyPlus)"
    annotation (Placement(transformation(extent={{200,48},{220,68}})));

  Modelica.Blocks.Sources.RealExpression PHeaCoiEP(
    final y=datRea.y[3])
    "Heating coil power consumption (EnergyPlus)"
    annotation (Placement(transformation(extent={{200,-66},{220,-46}})));

  Modelica.Blocks.Math.Mean PHeaCoiMod(
    final f=1/averagingTimestep)
    "Average out Modelica results over time"
    annotation (Placement(transformation(extent={{156,-68},{176,-48}})));

  Modelica.Blocks.Math.Mean PCooCoiMod(
    final f=1/averagingTimestep)
    "Average out Modelica results over time"
    annotation (Placement(transformation(extent={{156,-106},{176,-86}})));

  Modelica.Blocks.Sources.RealExpression PCooCoiEP(
    final y=datRea.y[1])
    "Cooling coil power consumption"
    annotation (Placement(transformation(extent={{200,-104},{220,-84}})));

  Modelica.Blocks.Sources.RealExpression PFanEP(
    final y=datRea.y[9])
    "Fan power consumption (EnergyPlus)"
    annotation (Placement(transformation(extent={{200,-136},{220,-116}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[2]
    "Convert enable signal to real value"
    annotation (Placement(transformation(extent={{-52,-86},{-32,-66}})));

  parameter Data.FanData datFan
    annotation (Placement(transformation(extent={{30,66},{50,86}})));
equation
  connect(ptac.yFan_actual, fanProOn.u) annotation (Line(points={{25,10},{32,10}},
                            color={0,0,127}));
  connect(ptac.port_Air_a2, zon.ports[1])
    annotation (Line(points={{24,-2},{76,-2},{76,30.9}},
                                                       color={0,127,255}));
  connect(ptac.port_Air_b2, zon.ports[2])
    annotation (Line(points={{24,-10},{80,-10},{80,30.9}},
                                                         color={0,127,255}));
  connect(con.y, zon.qGai_flow) annotation (Line(points={{22,60},{56,60}},
                    color={0,0,127}));
  connect(damPos.y,ptac. uEco) annotation (Line(points={{-98,50},{-58,50},{-58,12},
          {-17,12}}, color={0,0,127}));

  connect(building.weaBus,ptac. weaBus) annotation (Line(
      points={{0,124},{12,124},{12,100},{-13.2,100},{-13.2,12.2}},
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
  connect(realExpression1.y, PFanMod.u)
    annotation (Line(points={{141,-126},{154,-126}}, color={0,0,127}));
  connect(realExpression2.y,m_flowFan. u)
    annotation (Line(points={{141,122},{154,122}},
                                                 color={0,0,127}));
  connect(realExpression3.y,TAirLvgMod. u)
    annotation (Line(points={{141,90},{154,90}},
                                               color={0,0,127}));
  connect(realExpression4.y,TAirMixMod. u)
    annotation (Line(points={{141,58},{154,58}},   color={0,0,127}));
  connect(realExpression6.y,TZonAirMod. u)
    annotation (Line(points={{141,-22},{154,-22}}, color={0,0,127}));
  connect(booToRea[1].y, ptac.uFan) annotation (Line(points={{-30,-76},{-24,-76},
          {-24,8},{-17,8}}, color={0,0,127}));
  connect(booToRea[2].y, ptac.uHea) annotation (Line(points={{-30,-76},{-24,-76},
          {-24,-16},{-17,-16}},     color={0,0,127}));
  connect(datRea.y[6], K2C[1].u)
    annotation (Line(points={{-99,90},{-82,90}}, color={0,0,127}));
  connect(datRea.y[7], K2C[2].u)
    annotation (Line(points={{-99,90},{-82,90}}, color={0,0,127}));
  connect(fanProOn.y, modCon.uFan) annotation (Line(points={{56,10},{60,10},{60,
          -94},{-102,-94},{-102,-54},{-88,-54}}, color={255,0,255}));
  connect(zon.TAir, modCon.TZon) annotation (Line(points={{99,68},{112,68},{112,
          -100},{-98,-100},{-98,-58},{-88,-58}},     color={0,0,127}));
  connect(ptac.TAirSup, modCon.TSup) annotation (Line(points={{25,4},{30,4},{30,
          -90},{-92,-90},{-92,-82},{-88,-82}}, color={0,0,127}));
  connect(K2C[2].y, modCon.TCooSet) annotation (Line(points={{-58,90},{-52,90},{
          -52,-44},{-94,-44},{-94,-62},{-88,-62}},     color={0,0,127}));
  connect(K2C[1].y, modCon.THeaSet) annotation (Line(points={{-58,90},{-52,90},{
          -52,-44},{-94,-44},{-94,-66},{-88,-66}}, color={0,0,127}));
  connect(modCon.uAva, ava.y) annotation (Line(points={{-88,-74},{-104,-74},{-104,
          -50},{-108,-50}}, color={255,0,255}));
  connect(modCon.fanOpeMod, fanOpeMod.y) annotation (Line(points={{-88,-78},{-104,
          -78},{-104,-80},{-108,-80}},   color={255,0,255}));
  connect(modCon.yCooEna, ptac.uCooEna) annotation (Line(points={{-64,-56},{-32,
          -56},{-32,-20},{-17,-20}},     color={255,0,255}));
  connect(modCon.yHeaEna, booToRea[2].u) annotation (Line(points={{-64,-60},{-60,
          -60},{-60,-76},{-54,-76}}, color={255,0,255}));
  connect(modCon.yFan, booToRea[1].u) annotation (Line(points={{-64,-80},{-60,-80},
          {-60,-76},{-54,-76}}, color={255,0,255}));
  connect(ptac.PHeaCoi, QHeaCoiMod.u) annotation (Line(points={{25,-16},{100,
          -16},{100,24},{154,24}}, color={0,0,127}));
  connect(ptac.PHeaCoi, PHeaCoiMod.u) annotation (Line(points={{25,-16},{100,
          -16},{100,-58},{154,-58}}, color={0,0,127}));
  connect(ptac.PCooCoi, PCooCoiMod.u) annotation (Line(points={{25,-22},{80,-22},
          {80,-96},{154,-96}}, color={0,0,127}));
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
    This is a validation model for the packaged terminal air conditioner (PTAC) 
    system model under cooling mode with a modular controller. The validation model 
    consists of: </p>
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
    <code>zon</code> at its cooling setpoint. 
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
end CoolingMode;

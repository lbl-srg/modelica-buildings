within Buildings.Examples.DemandFlexibility;
model DFSimpleRatchetOnOffLoad5Zone
    extends Modelica.Icons.Example;
           parameter Integer nZones=5;
replaceable package MediumAir = Buildings.Media.Air;
          parameter Real TCooSetOcc(unit="K")=273.15 + 25.56
    "Zone cooling temperature setpoint";
        parameter Real THeaSetOcc(unit="K")=273.15 + 22.22
    "Zone heating temperature setpoint";
              parameter Real TCooSetUnocc(unit="K")=273.15+32.22
    "Zone cooling temperature setpoint";
        parameter Real THeaSetUnocc(unit="K")=273.15+15.56
    "Zone heating temperature setpoint";

  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable occupancyMode(
    table=[0,0; 7,1; 20,0; 24,0],
    timeScale=3600,
    period=86400)
    annotation (Placement(transformation(extent={{-132,56},{-112,76}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat1(filNam=
        ModelicaServices.ExternalReferences.loadResource(
        "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    annotation (Placement(transformation(extent={{-134,10},{-114,30}})));
  Buildings.Examples.DemandFlexibility.ThermalZones.Building5Zone
    building_5_zone
    annotation (Placement(transformation(extent={{6,2},{26,24}})));
  Buildings.Examples.DemandFlexibility.HVAC.CustomAirConditionerOnOffTimer
    custom_air_conditioner_OnOff_timer[5]
    annotation (Placement(transformation(extent={{56,60},{76,80}})));
  Buildings.Controls.OBC.DemandFlexibility.MultipleZoneRatchet
    MultipleZoneRatchet(
    nZones=5,
    TZonHeaSetNomOcc=THeaSetOcc,
    TZonHeaSetNomUnocc=THeaSetUnocc,
    TZonCooSetNomOcc=TCooSetOcc,
    TZonCooSetNomUnocc=TCooSetUnocc,
    loadShedDurationTypical(displayUnit="h"))
    annotation (Placement(transformation(extent={{-58,52},{-20,84}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum mulSum(nin=5)
    annotation (Placement(transformation(extent={{104,58},{124,78}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput
                                        totalElectricPower
    annotation (Placement(transformation(extent={{160,58},{180,78}})));
  Buildings.Examples.DemandFlexibility.HVAC.SetpointProcessing
    setpoint_processing[5]
    annotation (Placement(transformation(extent={{-2,60},{18,80}})));
  Buildings.Examples.DemandFlexibility.ThermalZones.Building5Zone
    building_5_zone_baseline
    annotation (Placement(transformation(extent={{6,-102},{26,-80}})));
  Buildings.Examples.DemandFlexibility.HVAC.CustomAirConditionerOnOffTimer
    custom_air_conditioner_OnOff_timer_baseline[5]
    annotation (Placement(transformation(extent={{56,-44},{76,-24}})));
  Buildings.Controls.OBC.DemandFlexibility.MultipleZoneRatchet
    MultipleZoneRatchetBaseline(
    nZones=5,
    TZonHeaSetNomOcc=THeaSetOcc,
    TZonHeaSetNomUnocc=THeaSetUnocc,
    TZonCooSetNomOcc=TCooSetOcc,
    TZonCooSetNomUnocc=TCooSetUnocc,
    loadShedDurationTypical(displayUnit="h"),
    loaSheHeaAct=false,
    loaSheCooAct=false)
    annotation (Placement(transformation(extent={{-58,-52},{-20,-20}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum mulSum_baseline(nin=5)
    annotation (Placement(transformation(extent={{104,-46},{124,-26}})));
  Buildings.Examples.DemandFlexibility.HVAC.SetpointProcessing
    setpoint_processing_baseline[5]
    annotation (Placement(transformation(extent={{-2,-44},{18,-24}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput totalElectricPowerBaseline
    annotation (Placement(transformation(extent={{160,-46},{180,-26}})));
equation
  connect(custom_air_conditioner_OnOff_timer.port_b, building_5_zone.port_a)
    annotation (Line(points={{76.3333,61.8667},{80,61.8667},{80,-4},{2,-4},{2,
          19.38},{6.2,19.38}},       color={0,127,255}));
  connect(custom_air_conditioner_OnOff_timer.port_a, building_5_zone.port_b)
    annotation (Line(points={{55.7778,61.7333},{30,61.7333},{30,19.38},{26.2,
          19.38}},                   color={0,127,255}));
  connect(building_5_zone.TZon, custom_air_conditioner_OnOff_timer.ZAT)
    annotation (Line(points={{27,13.22},{34,13.22},{34,70.6667},{55,70.6667}},
                     color={0,0,127}));
  connect(building_5_zone.TZon, MultipleZoneRatchet.TZon) annotation (Line(
        points={{27,13.22},{34,13.22},{34,84},{-16,84},{-16,88},{-66,88},{-66,
          72.5091},{-59.4929,72.5091}}, color={0,0,127}));
  connect(weaDat1.weaBus,building_5_zone. weaBus) annotation (Line(
      points={{-114,20},{0,20},{0,9.04},{5.4,9.04}},
      color={255,204,51},
      thickness=0.5));
  connect(mulSum.u[1:5], custom_air_conditioner_OnOff_timer.electricPower)
    annotation (Line(points={{102,68.8},{82,68.8},{82,76.1333},{77.1111,76.1333}},
                            color={0,0,127}));
  connect(mulSum.y,totalElectricPower)  annotation (Line(points={{126,68},{170,
          68}},                      color={0,0,127}));
  connect(occupancyMode.y[1], MultipleZoneRatchet.occSta) annotation (Line(
        points={{-110,66},{-68,66},{-68,79.2},{-59.3571,79.2}}, color={255,0,
          255}));
  connect(MultipleZoneRatchet.TZonHeaSetCom, setpoint_processing.TZonHeaSetCom)
    annotation (Line(points={{-18.6429,70.7636},{-14,70.7636},{-14,75},{-4,75}},
        color={0,0,127}));
  connect(MultipleZoneRatchet.TZonCooSetCom, setpoint_processing.TZonCooSetCom)
    annotation (Line(points={{-18.6429,58.5455},{-14,58.5455},{-14,65.8},{-4,
          65.8}}, color={0,0,127}));
  connect(setpoint_processing.TZonHeaSetPro, custom_air_conditioner_OnOff_timer.THeaSet)
    annotation (Line(points={{20,74.6},{50,74.6},{50,75.4667},{54.8889,75.4667}},
        color={0,0,127}));
  connect(custom_air_conditioner_OnOff_timer.TCooSet, setpoint_processing.TZonCooSetPro)
    annotation (Line(points={{54.8889,65.8667},{52,66},{20,66}}, color={0,0,127}));
  connect(setpoint_processing.TZonHeaSetPro, MultipleZoneRatchet.TZonHeaSetCur)
    annotation (Line(points={{20,74.6},{28,74.6},{28,90},{-70,90},{-70,70.1818},
          {-59.4929,70.1818}}, color={0,0,127}));
  connect(setpoint_processing.TZonCooSetPro, MultipleZoneRatchet.TZonCooSetCur)
    annotation (Line(points={{20,66},{28,66},{28,46},{-62,46},{-62,67.7091},{
          -59.3571,67.7091}}, color={0,0,127}));
  connect(custom_air_conditioner_OnOff_timer_baseline.port_b,
    building_5_zone_baseline.port_a) annotation (Line(points={{76.3333,-42.1333},
          {80,-42.1333},{80,-108},{2,-108},{2,-84.62},{6.2,-84.62}}, color={0,
          127,255}));
  connect(custom_air_conditioner_OnOff_timer_baseline.port_a,
    building_5_zone_baseline.port_b) annotation (Line(points={{55.7778,-42.2667},
          {30,-42.2667},{30,-84.62},{26.2,-84.62}}, color={0,127,255}));
  connect(building_5_zone_baseline.TZon,
    custom_air_conditioner_OnOff_timer_baseline.ZAT) annotation (Line(points={{27,
          -90.78},{34,-90.78},{34,-33.3333},{55,-33.3333}},    color={0,0,127}));
  connect(building_5_zone_baseline.TZon, MultipleZoneRatchetBaseline.TZon)
    annotation (Line(points={{27,-90.78},{34,-90.78},{34,-20},{-16,-20},{-16,
          -16},{-66,-16},{-66,-31.4909},{-59.4929,-31.4909}}, color={0,0,127}));
  connect(weaDat1.weaBus, building_5_zone_baseline.weaBus) annotation (Line(
      points={{-114,20},{-74,20},{-74,-94.96},{5.4,-94.96}},
      color={255,204,51},
      thickness=0.5));
  connect(mulSum_baseline.u[1:5], custom_air_conditioner_OnOff_timer_baseline.electricPower)
    annotation (Line(points={{102,-35.2},{82,-35.2},{82,-27.8667},{77.1111,
          -27.8667}}, color={0,0,127}));
  connect(mulSum_baseline.y, totalElectricPowerBaseline)
    annotation (Line(points={{126,-36},{170,-36}}, color={0,0,127}));
  connect(occupancyMode.y[1], MultipleZoneRatchetBaseline.occSta) annotation (
      Line(points={{-110,66},{-68,66},{-68,-18},{-64,-18},{-64,-24.8},{-59.3571,
          -24.8}}, color={255,0,255}));
  connect(MultipleZoneRatchetBaseline.TZonHeaSetCom,
    setpoint_processing_baseline.TZonHeaSetCom) annotation (Line(points={{
          -18.6429,-33.2364},{-14,-33.2364},{-14,-29},{-4,-29}}, color={0,0,127}));
  connect(MultipleZoneRatchetBaseline.TZonCooSetCom,
    setpoint_processing_baseline.TZonCooSetCom) annotation (Line(points={{
          -18.6429,-45.4545},{-14,-45.4545},{-14,-38.2},{-4,-38.2}}, color={0,0,
          127}));
  connect(setpoint_processing_baseline.TZonHeaSetPro,
    custom_air_conditioner_OnOff_timer_baseline.THeaSet) annotation (Line(
        points={{20,-29.4},{50,-29.4},{50,-28.5333},{54.8889,-28.5333}}, color=
          {0,0,127}));
  connect(custom_air_conditioner_OnOff_timer_baseline.TCooSet,
    setpoint_processing_baseline.TZonCooSetPro) annotation (Line(points={{54.8889,
          -38.1333},{52,-38},{20,-38}},         color={0,0,127}));
  connect(setpoint_processing_baseline.TZonHeaSetPro,
    MultipleZoneRatchetBaseline.TZonHeaSetCur) annotation (Line(points={{20,
          -29.4},{28,-29.4},{28,-14},{-70,-14},{-70,-33.8182},{-59.4929,
          -33.8182}}, color={0,0,127}));
  connect(setpoint_processing_baseline.TZonCooSetPro,
    MultipleZoneRatchetBaseline.TZonCooSetCur) annotation (Line(points={{20,-38},
          {28,-38},{28,-58},{-62,-58},{-62,-36.2909},{-59.3571,-36.2909}},
        color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,
            -100},{160,100}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{160,
            100}})),
    experiment(
    StartTime=0,
      StopTime=172800,
      Interval=60,
      __Dymola_Algorithm="Dassl"));
end DFSimpleRatchetOnOffLoad5Zone;

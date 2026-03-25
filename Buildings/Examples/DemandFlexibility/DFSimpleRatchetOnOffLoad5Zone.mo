within Buildings.Examples.DemandFlexibility;
model DFSimpleRatchetOnOffLoad5Zone
    extends Modelica.Icons.Example;

replaceable package MediumAir = Buildings.Media.Air;
          parameter Real TCooSetOcc(unit="K")=273.15 + 25.56
    "Zone cooling temperature setpoint";
        parameter Real THeaSetOcc(unit="K")=273.15 + 22.22
    "Zone heating temperature setpoint";
              parameter Real TCooSetUnocc(unit="K")=273.15+32.22
    "Zone cooling temperature setpoint";
        parameter Real THeaSetUnocc(unit="K")=273.15+15.56
    "Zone heating temperature setpoint";

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat1(filNam=
        ModelicaServices.ExternalReferences.loadResource(
        "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    annotation (Placement(transformation(extent={{-222,8},{-202,28}})));
  Buildings.Examples.DemandFlexibility.ThermalZones.Building5Zone
    building_5_zone
    annotation (Placement(transformation(extent={{6,2},{26,24}})));
  Buildings.Examples.DemandFlexibility.HVAC.CustomAirConditionerOnOffTimer
    custom_air_conditioner_OnOff_timer[5]
    annotation (Placement(transformation(extent={{56,60},{76,80}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum mulSum(nin=5)
    annotation (Placement(transformation(extent={{104,58},{124,78}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput
                                        totalElectricPower
    annotation (Placement(transformation(extent={{160,58},{180,78}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.DualTemperatureSetpointMock
    setpoint_processing[5]
    annotation (Placement(transformation(extent={{-2,60},{18,80}})));
  Buildings.Examples.DemandFlexibility.ThermalZones.Building5Zone
    building_5_zone_baseline
    annotation (Placement(transformation(extent={{6,-102},{26,-80}})));
  Buildings.Examples.DemandFlexibility.HVAC.CustomAirConditionerOnOffTimer
    custom_air_conditioner_OnOff_timer_baseline[5]
    annotation (Placement(transformation(extent={{56,-44},{76,-24}})));
  Buildings.Controls.OBC.CDL.Reals.MultiSum mulSum_baseline(nin=5)
    annotation (Placement(transformation(extent={{104,-46},{124,-26}})));
  Buildings.Controls.OBC.DemandFlexibility.Generic.DualTemperatureSetpointMock
    setpoint_processing_baseline[5]
    annotation (Placement(transformation(extent={{-2,-44},{18,-24}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput totalElectricPowerBaseline
    annotation (Placement(transformation(extent={{160,-46},{180,-26}})));
  Controls.OBC.DemandFlexibility.ZoneSetpointControl.MultipleZones
    multipleZoneSetpointControl(
    nZon=5,
    delChaSheHea=-0.5556,
    delChaRebHea=0.5556,
    delSheThoHea=0.2778,
    delSheThoCoo=0.2778,
    delChaSheCoo=0.5556,
    delChaRebCoo=-0.5556)
    annotation (Placement(transformation(extent={{-66,52},{-30,86}})));
  Controls.OBC.CDL.Integers.Sources.TimeTable
                                 intTimTab(
    table=[0,0; 14,-1; 16,1; 21,2; 22,0; 24,0],
    timeScale=3600,
    period=86400)
    annotation (Placement(transformation(extent={{-108,116},{-88,136}})));
  Controls.OBC.DemandFlexibility.ZoneSetpointControl.ZoneSetpointSource
    zoneSetpointSource[5](occStaHouSta=6, occStaHouEnd=19)
    annotation (Placement(transformation(extent={{-180,64},{-160,84}})));
  Controls.OBC.DemandFlexibility.ZoneSetpointControl.MultipleZones
    multipleZoneSetpointControl_baseline(
    nZon=5,
    demFleHeaAct=false,
    demFleCooAct=false,
    delChaSheHea=-0.5556,
    delChaRebHea=0.5556,
    delSheThoHea=0.2778,
    delSheThoCoo=0.2778,
    delChaSheCoo=0.5556,
    delChaRebCoo=-0.5556)
    annotation (Placement(transformation(extent={{-68,-48},{-32,-14}})));
  Controls.OBC.CDL.Integers.Sources.TimeTable intTimTab_baseline(
    table=[0,0; 14,-1; 16,1; 21,2; 22,0; 24,0],
    timeScale=3600,
    period=86400)
    annotation (Placement(transformation(extent={{-140,-14},{-120,6}})));
  Controls.OBC.DemandFlexibility.ZoneSetpointControl.ZoneSetpointSource
    zoneSetpointSource_baseline[5](occStaHouSta=6, occStaHouEnd=19)
    annotation (Placement(transformation(extent={{-122,-48},{-102,-28}})));
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
  connect(weaDat1.weaBus,building_5_zone. weaBus) annotation (Line(
      points={{-202,18},{0,18},{0,9.04},{5.4,9.04}},
      color={255,204,51},
      thickness=0.5));
  connect(mulSum.u[1:5], custom_air_conditioner_OnOff_timer.electricPower)
    annotation (Line(points={{102,68.8},{82,68.8},{82,76.1333},{77.1111,76.1333}},
                            color={0,0,127}));
  connect(mulSum.y,totalElectricPower)  annotation (Line(points={{126,68},{170,
          68}},                      color={0,0,127}));
  connect(setpoint_processing.yTSetHea, custom_air_conditioner_OnOff_timer.THeaSet)
    annotation (Line(points={{20,74.6},{50,74.6},{50,75.4667},{54.8889,75.4667}},
        color={0,0,127}));
  connect(custom_air_conditioner_OnOff_timer.TCooSet, setpoint_processing.yTSetCoo)
    annotation (Line(points={{54.8889,65.8667},{52,66},{20,66}}, color={0,0,127}));
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
  connect(weaDat1.weaBus, building_5_zone_baseline.weaBus) annotation (Line(
      points={{-202,18},{-166,18},{-166,-94},{-80,-94},{-80,-94.96},{5.4,-94.96}},
      color={255,204,51},
      thickness=0.5));
  connect(mulSum_baseline.u[1:5], custom_air_conditioner_OnOff_timer_baseline.electricPower)
    annotation (Line(points={{102,-35.2},{82,-35.2},{82,-27.8667},{77.1111,
          -27.8667}}, color={0,0,127}));
  connect(mulSum_baseline.y, totalElectricPowerBaseline)
    annotation (Line(points={{126,-36},{170,-36}}, color={0,0,127}));
  connect(setpoint_processing_baseline.yTSetHea,
    custom_air_conditioner_OnOff_timer_baseline.THeaSet) annotation (Line(
        points={{20,-29.4},{50,-29.4},{50,-28.5333},{54.8889,-28.5333}}, color=
          {0,0,127}));
  connect(custom_air_conditioner_OnOff_timer_baseline.TCooSet,
    setpoint_processing_baseline.yTSetCoo) annotation (Line(points={{54.8889,-38.1333},
          {52,-38},{20,-38}}, color={0,0,127}));
  connect(multipleZoneSetpointControl.TSetComHea, setpoint_processing.uTSetHea)
    annotation (Line(points={{-28,79.8476},{-14,79.8476},{-14,75},{-4,75}},
        color={0,0,127}));
  connect(multipleZoneSetpointControl.TSetComCoo, setpoint_processing.uTSetCoo)
    annotation (Line(points={{-28,62.8476},{-14,62.8476},{-14,65.8},{-4,65.8}},
        color={0,0,127}));
  connect(intTimTab.y[1], multipleZoneSetpointControl.uMod) annotation (Line(
        points={{-86,126},{-76,126},{-76,83.0857},{-68,83.0857}}, color={255,
          127,0}));
  connect(zoneSetpointSource.TSetTarPreHea, multipleZoneSetpointControl.TSetTarPreHea)
    annotation (Line(points={{-158,82},{-68.2,82},{-68.2,79.6857}}, color={0,0,
          127}));
  connect(zoneSetpointSource.TSetTarSheHea, multipleZoneSetpointControl.TSetTarSheHea)
    annotation (Line(points={{-158,78.6},{-158,76},{-76,76},{-76,78},{-68.2,78},
          {-68.2,76.7714}}, color={0,0,127}));
  connect(zoneSetpointSource.TSetNomHea, multipleZoneSetpointControl.TSetNomHea)
    annotation (Line(points={{-158,75.8},{-158,78},{-68.2,78},{-68.2,73.3714}},
        color={0,0,127}));
  connect(zoneSetpointSource.TSetTarPreCoo, multipleZoneSetpointControl.TSetTarPreCoo)
    annotation (Line(points={{-158,72},{-76,72},{-76,63.0095},{-68.2,63.0095}},
        color={0,0,127}));
  connect(zoneSetpointSource.TSetTarSheCoo, multipleZoneSetpointControl.TSetTarSheCoo)
    annotation (Line(points={{-158,69.4},{-158,72},{-78,72},{-78,62},{-68.4,62},
          {-68.4,60.0952}}, color={0,0,127}));
  connect(zoneSetpointSource.TSetNomCoo, multipleZoneSetpointControl.TSetNomCoo)
    annotation (Line(points={{-158,65.8},{-158,58},{-76,58},{-76,62},{-68.4,62},
          {-68.4,57.019}}, color={0,0,127}));
  connect(setpoint_processing.yTSetHea, multipleZoneSetpointControl.TSetCurHea)
    annotation (Line(points={{20,74.6},{20,64},{-68,64},{-68,70.4571}}, color={
          0,0,127}));
  connect(setpoint_processing.yTSetCoo, multipleZoneSetpointControl.TSetCurCoo)
    annotation (Line(points={{20,66},{28,66},{28,48},{-67.8,48},{-67.8,53.4571}},
        color={0,0,127}));
  connect(building_5_zone.TZon, multipleZoneSetpointControl.TCur) annotation (
      Line(points={{27,13.22},{34,13.22},{34,46},{-80,46},{-80,66.7333},{-68.2,
          66.7333}}, color={0,0,127}));
  connect(intTimTab_baseline.y[1], multipleZoneSetpointControl_baseline.uMod)
    annotation (Line(points={{-118,-4},{-78,-4},{-78,-16.9143},{-70,-16.9143}},
        color={255,127,0}));
  connect(zoneSetpointSource_baseline.TSetTarPreHea,
    multipleZoneSetpointControl_baseline.TSetTarPreHea) annotation (Line(points
        ={{-100,-30},{-100,-20.3143},{-70.2,-20.3143}}, color={0,0,127}));
  connect(zoneSetpointSource_baseline.TSetTarSheHea,
    multipleZoneSetpointControl_baseline.TSetTarSheHea) annotation (Line(points
        ={{-100,-33.4},{-80,-33.4},{-80,-23.2286},{-70.2,-23.2286}}, color={0,0,
          127}));
  connect(zoneSetpointSource_baseline.TSetNomHea,
    multipleZoneSetpointControl_baseline.TSetNomHea) annotation (Line(points={{
          -100,-36.2},{-78,-36.2},{-78,-26.6286},{-70.2,-26.6286}}, color={0,0,
          127}));
  connect(zoneSetpointSource_baseline.TSetTarPreCoo,
    multipleZoneSetpointControl_baseline.TSetTarPreCoo) annotation (Line(points
        ={{-100,-40},{-78,-40},{-78,-36.9905},{-70.2,-36.9905}}, color={0,0,127}));
  connect(zoneSetpointSource_baseline.TSetTarSheCoo,
    multipleZoneSetpointControl_baseline.TSetTarSheCoo) annotation (Line(points
        ={{-100,-42.6},{-84,-42.6},{-84,-39.9048},{-70.4,-39.9048}}, color={0,0,
          127}));
  connect(zoneSetpointSource_baseline.TSetNomCoo,
    multipleZoneSetpointControl_baseline.TSetNomCoo) annotation (Line(points={{
          -100,-46.2},{-100,-46},{-78,-46},{-78,-42.981},{-70.4,-42.981}},
        color={0,0,127}));
  connect(multipleZoneSetpointControl_baseline.TSetComHea,
    setpoint_processing_baseline.uTSetHea) annotation (Line(points={{-30,-20.1524},
          {-12,-20.1524},{-12,-29},{-4,-29}}, color={0,0,127}));
  connect(multipleZoneSetpointControl_baseline.TSetComCoo,
    setpoint_processing_baseline.uTSetCoo) annotation (Line(points={{-30,-37.1524},
          {-28,-38.2},{-4,-38.2}}, color={0,0,127}));
  connect(setpoint_processing_baseline.yTSetHea,
    multipleZoneSetpointControl_baseline.TSetCurHea) annotation (Line(points={{
          20,-29.4},{28,-29.4},{28,-6},{-80,-6},{-80,-22},{-82,-22},{-82,-29.5429},
          {-70,-29.5429}}, color={0,0,127}));
  connect(setpoint_processing_baseline.yTSetCoo,
    multipleZoneSetpointControl_baseline.TSetCurCoo) annotation (Line(points={{
          20,-38},{28,-38},{28,-52},{-69.8,-52},{-69.8,-46.5429}}, color={0,0,
          127}));
  connect(building_5_zone_baseline.TZon, multipleZoneSetpointControl_baseline.TCur)
    annotation (Line(points={{27,-90.78},{-20.5,-90.78},{-20.5,-33.2667},{-70.2,
          -33.2667}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,
            -100},{160,100}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{160,
            100}})),
    experiment(
      StartTime=46800,
      StopTime=61200,
      Interval=60,
      __Dymola_Algorithm="Dassl"));
end DFSimpleRatchetOnOffLoad5Zone;

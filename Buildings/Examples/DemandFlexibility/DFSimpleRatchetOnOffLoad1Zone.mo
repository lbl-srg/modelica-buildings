within Buildings.Examples.DemandFlexibility;
model DFSimpleRatchetOnOffLoad1Zone
    extends Modelica.Icons.Example;
           parameter Integer nZones=5;
replaceable package MediumAir = Buildings.Media.Air;
          parameter Real TCooSetOcc(unit="K")=273.15 + 25.56
    "Zone cooling temperature setpoint";
        parameter Real THeaSetOcc(unit="K")=273.15 + 20
    "Zone heating temperature setpoint";
              parameter Real TCooSetUno(unit="K")=273.15+32.22
    "Zone cooling temperature setpoint";
        parameter Real THeaSetUno(unit="K")=273.15+15.56
    "Zone heating temperature setpoint";

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat1(filNam=
        ModelicaServices.ExternalReferences.loadResource(
        "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    annotation (Placement(transformation(extent={{-130,-12},{-110,8}})));
  Buildings.Examples.DemandFlexibility.ThermalZones.Building1Zone
    building_1_zone
    annotation (Placement(transformation(extent={{46,-14},{66,8}})));
  Buildings.Examples.DemandFlexibility.HVAC.CustomAirConditionerOnOffTimer
    custom_air_conditioner_OnOff_timer(heater_thermal_power_nominal=3000,
      cooler_thermal_power_nominal=5000)
    annotation (Placement(transformation(extent={{80,38},{100,58}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput
                                        totalElectricPower
    annotation (Placement(transformation(extent={{140,42},{160,62}})));
  Buildings.Examples.DemandFlexibility.HVAC.SetpointProcessing
    setpoint_processing
    annotation (Placement(transformation(extent={{10,38},{30,58}})));
  Buildings.Examples.DemandFlexibility.ThermalZones.Building1Zone
    building_1_zone_baseline
    annotation (Placement(transformation(extent={{38,-106},{58,-84}})));
  Buildings.Examples.DemandFlexibility.HVAC.CustomAirConditionerOnOffTimer
    custom_air_conditioner_OnOff_timer_baseline(heater_thermal_power_nominal=
        3000, cooler_thermal_power_nominal=5000)
    annotation (Placement(transformation(extent={{72,-54},{92,-34}})));
  Buildings.Examples.DemandFlexibility.HVAC.SetpointProcessing
    setpoint_processing_baseline
    annotation (Placement(transformation(extent={{2,-54},{22,-34}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput totalElectricPowerBaseline
    annotation (Placement(transformation(extent={{140,-50},{160,-30}})));
  Controls.OBC.DemandFlexibility.ZoneSetpointControl.SingleZone
    singleZoneSetpointControl(
    delChaSheHea=-0.5556,
    delChaRebHea=0.5556,
    delSheThoHea=0.2778,
    delSheThoCoo=0.2778,
    delChaSheCoo=0.5556,
    delChaRebCoo=-0.5556)
    annotation (Placement(transformation(extent={{-42,30},{-22,68}})));
  Controls.OBC.CDL.Logical.Sources.Constant con(k=true)
    annotation (Placement(transformation(extent={{-114,92},{-94,112}})));
  Controls.OBC.CDL.Integers.Sources.TimeTable intTimTab(
    table=[0,0; 14,-1; 16,1; 21,2; 22,0; 24,0],
    timeScale=3600,
    period=86400)
    annotation (Placement(transformation(extent={{-142,68},{-122,88}})));
  Controls.OBC.DemandFlexibility.ZoneSetpointControl.ZoneSetpointSource
    zoneSetpointSource(
    TSetNomHeaOcc=THeaSetOcc,
    TSetNomHeaUno=THeaSetUno,
    TSetNomCooOcc=TCooSetOcc,
    TSetNomCooUno=TCooSetUno,
    occStaHouSta=6,
    occStaHouEnd=19)
    annotation (Placement(transformation(extent={{-150,40},{-130,60}})));
  Controls.OBC.DemandFlexibility.ZoneSetpointControl.SingleZone
    singleZoneSetpointControl_baseline(
    demFleHeaAct=false,
    demFleCooAct=false,
    delChaSheHea=-0.5556,
    delChaRebHea=0.5556,
    delSheThoHea=0.2778,
    delSheThoCoo=0.2778,
    delChaSheCoo=0.5556,
    delChaRebCoo=-0.5556)
    annotation (Placement(transformation(extent={{-42,-64},{-22,-26}})));
  Controls.OBC.CDL.Logical.Sources.Constant con_baseline(k=true)
    annotation (Placement(transformation(extent={{-152,-34},{-132,-14}})));
  Controls.OBC.CDL.Integers.Sources.TimeTable intTimTab_baseline(
    table=[0,0; 14,-1; 16,1; 21,2; 22,0; 24,0],
    timeScale=3600,
    period=86400)
    annotation (Placement(transformation(extent={{-160,-76},{-140,-56}})));
  Controls.OBC.DemandFlexibility.ZoneSetpointControl.ZoneSetpointSource
    zoneSetpointSource_baseline(
    TSetNomHeaOcc=THeaSetOcc,
    TSetNomHeaUno=THeaSetUno,
    TSetNomCooOcc=TCooSetOcc,
    TSetNomCooUno=TCooSetUno,
    occStaHouSta=6,
    occStaHouEnd=19)
    annotation (Placement(transformation(extent={{-104,-56},{-84,-36}})));
equation
  connect(custom_air_conditioner_OnOff_timer.port_b,building_1_zone. port_a)
    annotation (Line(points={{100.333,39.8667},{106,39.8667},{106,-20},{40,-20},
          {40,3.38},{46.2,3.38}},    color={0,127,255}));
  connect(custom_air_conditioner_OnOff_timer.port_a,building_1_zone. port_b)
    annotation (Line(points={{79.7778,39.7333},{72,39.7333},{72,3.38},{66.2,
          3.38}},                    color={0,127,255}));
  connect(building_1_zone.TZon, custom_air_conditioner_OnOff_timer.ZAT)
    annotation (Line(points={{67,-2.78},{74,-2.78},{74,48.6667},{79,48.6667}},
                     color={0,0,127}));
  connect(weaDat1.weaBus,building_1_zone. weaBus) annotation (Line(
      points={{-110,-2},{42,-2},{42,-6.96},{45.4,-6.96}},
      color={255,204,51},
      thickness=0.5));

  connect(totalElectricPower, custom_air_conditioner_OnOff_timer.electricPower)
    annotation (Line(points={{150,52},{106,52},{106,54.1333},{101.111,54.1333}},
                                                               color={0,0,127}));
  connect(setpoint_processing.TZonHeaSetPro, custom_air_conditioner_OnOff_timer.THeaSet)
    annotation (Line(points={{32,52.6},{74,52.6},{74,53.4667},{78.8889,53.4667}},
        color={0,0,127}));
  connect(setpoint_processing.TZonCooSetPro, custom_air_conditioner_OnOff_timer.TCooSet)
    annotation (Line(points={{32,44},{34,43.8667},{78.8889,43.8667}}, color={0,
          0,127}));
  connect(custom_air_conditioner_OnOff_timer_baseline.port_b,
    building_1_zone_baseline.port_a) annotation (Line(points={{92.3333,-52.1333},
          {98,-52.1333},{98,-112},{32,-112},{32,-88.62},{38.2,-88.62}}, color={
          0,127,255}));
  connect(custom_air_conditioner_OnOff_timer_baseline.port_a,
    building_1_zone_baseline.port_b) annotation (Line(points={{71.7778,-52.2667},
          {64,-52.2667},{64,-88.62},{58.2,-88.62}}, color={0,127,255}));
  connect(building_1_zone_baseline.TZon,
    custom_air_conditioner_OnOff_timer_baseline.ZAT) annotation (Line(points={{59,
          -94.78},{66,-94.78},{66,-43.3333},{71,-43.3333}},    color={0,0,127}));
  connect(weaDat1.weaBus, building_1_zone_baseline.weaBus) annotation (Line(
      points={{-110,-2},{-68,-2},{-68,-98.96},{37.4,-98.96}},
      color={255,204,51},
      thickness=0.5));
  connect(totalElectricPowerBaseline,
    custom_air_conditioner_OnOff_timer_baseline.electricPower) annotation (Line(
        points={{150,-40},{98,-40},{98,-37.8667},{93.1111,-37.8667}}, color={0,
          0,127}));
  connect(setpoint_processing_baseline.TZonHeaSetPro,
    custom_air_conditioner_OnOff_timer_baseline.THeaSet) annotation (Line(
        points={{24,-39.4},{66,-39.4},{66,-38.5333},{70.8889,-38.5333}}, color=
          {0,0,127}));
  connect(setpoint_processing_baseline.TZonCooSetPro,
    custom_air_conditioner_OnOff_timer_baseline.TCooSet) annotation (Line(
        points={{24,-48},{26,-48.1333},{70.8889,-48.1333}}, color={0,0,127}));
  connect(singleZoneSetpointControl.TSetComHea, setpoint_processing.TZonHeaSetCom)
    annotation (Line(points={{-20.2609,58},{-2,58},{-2,53},{8,53}},
                                                               color={0,0,127}));
  connect(singleZoneSetpointControl.TSetComCoo, setpoint_processing.TZonCooSetCom)
    annotation (Line(points={{-20.2609,38.2},{-20.2609,34},{0,34},{0,43.8},{8,
          43.8}},
        color={0,0,127}));
  connect(con.y, singleZoneSetpointControl.have_priHea) annotation (Line(points
        ={{-92,102},{-52,102},{-52,67.2},{-44,67.2}}, color={255,0,255}));
  connect(con.y, singleZoneSetpointControl.have_priCoo) annotation (Line(points
        ={{-92,102},{-52,102},{-52,64},{-44,64}}, color={255,0,255}));
  connect(intTimTab.y[1], singleZoneSetpointControl.uMod) annotation (Line(
        points={{-120,78},{-54,78},{-54,60.6},{-43.7391,60.6}},
                                                           color={255,127,0}));
  connect(zoneSetpointSource.TSetTarPreHea, singleZoneSetpointControl.TSetTarPreHea)
    annotation (Line(points={{-128,58},{-52,58},{-52,48.4},{-43.7391,48.4}},
                                                                        color={0,
          0,127}));
  connect(zoneSetpointSource.TSetTarSheHea, singleZoneSetpointControl.TSetTarSheHea)
    annotation (Line(points={{-128,54.6},{-128,50},{-52,50},{-52,44.8},{
          -43.7391,44.8}},
        color={0,0,127}));
  connect(zoneSetpointSource.TSetNomHea, singleZoneSetpointControl.TSetNomHea)
    annotation (Line(points={{-128,51.8},{-128,52},{-54,52},{-54,41.4},{
          -43.7391,41.4}},
        color={0,0,127}));
  connect(zoneSetpointSource.TSetTarPreCoo, singleZoneSetpointControl.TSetTarPreCoo)
    annotation (Line(points={{-128,48},{-128,37.8},{-43.7391,37.8}},
                                                            color={0,0,127}));
  connect(zoneSetpointSource.TSetTarSheCoo, singleZoneSetpointControl.TSetTarSheCoo)
    annotation (Line(points={{-128,45.4},{-128,46},{-52,46},{-52,33.8},{
          -43.7391,33.8}},
        color={0,0,127}));
  connect(zoneSetpointSource.TSetNomCoo, singleZoneSetpointControl.TSetNomCoo)
    annotation (Line(points={{-128,41.8},{-128,40},{-54,40},{-54,30.4},{
          -43.7391,30.4}},
        color={0,0,127}));
  connect(setpoint_processing.TZonHeaSetPro, singleZoneSetpointControl.TSetCurHea)
    annotation (Line(points={{32,52.6},{40,52.6},{40,26},{-66,26},{-66,57.8},{
          -43.7391,57.8}},
                  color={0,0,127}));
  connect(setpoint_processing.TZonCooSetPro, singleZoneSetpointControl.TSetCurCoo)
    annotation (Line(points={{32,44},{30,44},{30,14},{-43.7391,14},{-43.7391,52}},
        color={0,0,127}));
  connect(building_1_zone.TZon, singleZoneSetpointControl.TCur) annotation (
      Line(points={{67,-2.78},{67,30},{-56,30},{-56,54.8},{-43.7391,54.8}},
                                                                       color={0,
          0,127}));
  connect(singleZoneSetpointControl_baseline.TSetComHea,
    setpoint_processing_baseline.TZonHeaSetCom) annotation (Line(points={{
          -20.2609,-36},{-10,-36},{-10,-39},{0,-39}},
                                        color={0,0,127}));
  connect(singleZoneSetpointControl_baseline.TSetComCoo,
    setpoint_processing_baseline.TZonCooSetCom) annotation (Line(points={{
          -20.2609,-55.8},{-20.2609,-60},{-10,-60},{-10,-48.2},{0,-48.2}},
                                                      color={0,0,127}));
  connect(con_baseline.y, singleZoneSetpointControl_baseline.have_priHea)
    annotation (Line(points={{-130,-24},{-52,-24},{-52,-26.8},{-44,-26.8}},
        color={255,0,255}));
  connect(con_baseline.y, singleZoneSetpointControl_baseline.have_priCoo)
    annotation (Line(points={{-130,-24},{-52,-24},{-52,-30},{-44,-30}}, color={255,
          0,255}));
  connect(intTimTab_baseline.y[1], singleZoneSetpointControl_baseline.uMod)
    annotation (Line(points={{-138,-66},{-54,-66},{-54,-33.4},{-43.7391,-33.4}},
        color={255,127,0}));
  connect(zoneSetpointSource_baseline.TSetTarPreHea,
    singleZoneSetpointControl_baseline.TSetTarPreHea) annotation (Line(points={{-82,-38},
          {-52,-38},{-52,-45.6},{-43.7391,-45.6}},     color={0,0,127}));
  connect(zoneSetpointSource_baseline.TSetTarSheHea,
    singleZoneSetpointControl_baseline.TSetTarSheHea) annotation (Line(points={{-82,
          -41.4},{-52,-41.4},{-52,-49.2},{-43.7391,-49.2}},color={0,0,127}));
  connect(zoneSetpointSource_baseline.TSetNomHea,
    singleZoneSetpointControl_baseline.TSetNomHea) annotation (Line(points={{-82,
          -44.2},{-50,-44.2},{-50,-52.6},{-43.7391,-52.6}},
                                                       color={0,0,127}));
  connect(zoneSetpointSource_baseline.TSetTarPreCoo,
    singleZoneSetpointControl_baseline.TSetTarPreCoo) annotation (Line(points={{-82,-48},
          {-52,-48},{-52,-56.2},{-43.7391,-56.2}}, color={0,0,127}));
  connect(zoneSetpointSource_baseline.TSetTarSheCoo,
    singleZoneSetpointControl_baseline.TSetTarSheCoo) annotation (Line(points={{-82,
          -50.6},{-58,-50.6},{-58,-60.2},{-43.7391,-60.2}},color={0,0,127}));
  connect(zoneSetpointSource_baseline.TSetNomCoo,
    singleZoneSetpointControl_baseline.TSetNomCoo) annotation (Line(points={{-82,
          -54.2},{-82,-68},{-52,-68},{-52,-63.6},{-43.7391,-63.6}},
                                                               color={0,0,127}));
  connect(setpoint_processing_baseline.TZonHeaSetPro,
    singleZoneSetpointControl_baseline.TSetCurHea) annotation (Line(points={{24,
          -39.4},{32,-39.4},{32,-38},{34,-38},{34,-74},{-58,-74},{-58,-36.2},{
          -43.7391,-36.2}},
                   color={0,0,127}));
  connect(setpoint_processing_baseline.TZonCooSetPro,
    singleZoneSetpointControl_baseline.TSetCurCoo) annotation (Line(points={{24,-48},
          {30,-48},{30,-80},{-43.7391,-80},{-43.7391,-42}},
                                                         color={0,0,127}));
  connect(building_1_zone_baseline.TZon, singleZoneSetpointControl_baseline.TCur)
    annotation (Line(points={{59,-94.78},{66,-94.78},{66,-42},{38,-42},{38,-16},
          {-56,-16},{-56,-46},{-50,-46},{-50,-39.2},{-43.7391,-39.2}},
                                                                  color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-140,
            -120},{140,100}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-120},{140,
            100}})),
    experiment(
    StartTime=18403200,
      StopTime=18576000,
      Interval=60,
      __Dymola_Algorithm="Dassl"));
end DFSimpleRatchetOnOffLoad1Zone;

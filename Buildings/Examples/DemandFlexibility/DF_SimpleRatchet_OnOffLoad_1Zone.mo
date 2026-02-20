within Buildings.Examples.DemandFlexibility;
model DF_SimpleRatchet_OnOffLoad_1Zone
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

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat1(filNam=
        ModelicaServices.ExternalReferences.loadResource(
        "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    annotation (Placement(transformation(extent={{-130,-12},{-110,8}})));
  Buildings.Examples.DemandFlexibility.ThermalZones.building_1_zone building_1_zone
    annotation (Placement(transformation(extent={{46,-14},{66,8}})));
  Buildings.Examples.DemandFlexibility.HVAC.custom_air_conditioner_OnOff_timer custom_air_conditioner_OnOff_timer(
      heater_thermal_power_nominal=3000, cooler_thermal_power_nominal=5000)
    annotation (Placement(transformation(extent={{80,38},{100,58}})));
  Buildings.Controls.OBC.DemandFlexibility.single_zone_ratchet single_zone_ratchet(
    TZonHeaSetNomOcc=THeaSetOcc,
    TZonHeaSetNomUnocc=THeaSetUnocc,
    TZonCooSetNomOcc=TCooSetOcc,
    TZonCooSetNomUnocc=TCooSetUnocc,
    loadShedDurationTypical(displayUnit="h"))
    annotation (Placement(transformation(extent={{-50,36},{-12,68}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput
                                        totalElectricPower
    annotation (Placement(transformation(extent={{140,42},{160,62}})));
  Buildings.Examples.DemandFlexibility.HVAC.setpoint_processing setpoint_processing
    annotation (Placement(transformation(extent={{10,38},{30,58}})));
  Buildings.Examples.DemandFlexibility.ThermalZones.building_1_zone building_1_zone_baseline
    annotation (Placement(transformation(extent={{38,-106},{58,-84}})));
  Buildings.Examples.DemandFlexibility.HVAC.custom_air_conditioner_OnOff_timer custom_air_conditioner_OnOff_timer_baseline(
      heater_thermal_power_nominal=3000, cooler_thermal_power_nominal=5000)
    annotation (Placement(transformation(extent={{72,-54},{92,-34}})));
  Buildings.Controls.OBC.DemandFlexibility.single_zone_ratchet single_zone_ratchet_baseline(
    TZonHeaSetNomOcc=THeaSetOcc,
    TZonHeaSetNomUnocc=THeaSetUnocc,
    TZonCooSetNomOcc=TCooSetOcc,
    TZonCooSetNomUnocc=TCooSetUnocc,
    loadShedDurationTypical(displayUnit="h"),
    loaSheHeaAct=false,
    loaSheCooAct=false)
    annotation (Placement(transformation(extent={{-58,-56},{-20,-24}})));
  Buildings.Examples.DemandFlexibility.HVAC.setpoint_processing setpoint_processing_baseline
    annotation (Placement(transformation(extent={{2,-54},{22,-34}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput totalElectricPower_baseline
    annotation (Placement(transformation(extent={{140,-50},{160,-30}})));
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
  connect(building_1_zone.TZon, single_zone_ratchet.TZon) annotation (Line(
        points={{67,-2.78},{74,-2.78},{74,42},{44,42},{44,24},{-58,24},{-58,
          56.5091},{-51.4929,56.5091}},
                     color={0,0,127}));
  connect(weaDat1.weaBus,building_1_zone. weaBus) annotation (Line(
      points={{-110,-2},{42,-2},{42,-6.96},{45.4,-6.96}},
      color={255,204,51},
      thickness=0.5));

  connect(totalElectricPower, custom_air_conditioner_OnOff_timer.electricPower)
    annotation (Line(points={{150,52},{106,52},{106,54.1333},{101.111,54.1333}},
                                                               color={0,0,127}));
  connect(single_zone_ratchet.TZonHeaSetCom, setpoint_processing.TZonHeaSetCom)
    annotation (Line(points={{-10.6429,54.7636},{-8,53},{8,53}}, color={0,0,127}));
  connect(single_zone_ratchet.TZonCooSetCom, setpoint_processing.TZonCooSetCom)
    annotation (Line(points={{-10.6429,42.5455},{0,42.5455},{0,43.8},{8,43.8}},
        color={0,0,127}));
  connect(setpoint_processing.TZonHeaSetPro, custom_air_conditioner_OnOff_timer.THeaSet)
    annotation (Line(points={{32,52.6},{74,52.6},{74,53.4667},{78.8889,53.4667}},
        color={0,0,127}));
  connect(setpoint_processing.TZonCooSetPro, custom_air_conditioner_OnOff_timer.TCooSet)
    annotation (Line(points={{32,44},{34,43.8667},{78.8889,43.8667}}, color={0,
          0,127}));
  connect(setpoint_processing.TZonHeaSetPro, single_zone_ratchet.TZonHeaSetCur)
    annotation (Line(points={{32,52.6},{40,52.6},{40,28},{-56,28},{-56,54.1818},
          {-51.4929,54.1818}}, color={0,0,127}));
  connect(setpoint_processing.TZonCooSetPro, single_zone_ratchet.TZonCooSetCur)
    annotation (Line(points={{32,44},{42,44},{42,26},{-56,26},{-56,51.7091},{
          -51.4929,51.7091}}, color={0,0,127}));
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
  connect(building_1_zone_baseline.TZon, single_zone_ratchet_baseline.TZon)
    annotation (Line(points={{59,-94.78},{66,-94.78},{66,-50},{36,-50},{36,-68},
          {-66,-68},{-66,-35.4909},{-59.4929,-35.4909}}, color={0,0,127}));
  connect(weaDat1.weaBus, building_1_zone_baseline.weaBus) annotation (Line(
      points={{-110,-2},{-68,-2},{-68,-98.96},{37.4,-98.96}},
      color={255,204,51},
      thickness=0.5));
  connect(totalElectricPower_baseline,
    custom_air_conditioner_OnOff_timer_baseline.electricPower) annotation (Line(
        points={{150,-40},{98,-40},{98,-37.8667},{93.1111,-37.8667}}, color={0,
          0,127}));
  connect(single_zone_ratchet_baseline.TZonHeaSetCom,
    setpoint_processing_baseline.TZonHeaSetCom) annotation (Line(points={{
          -18.6429,-37.2364},{-16,-39},{0,-39}}, color={0,0,127}));
  connect(single_zone_ratchet_baseline.TZonCooSetCom,
    setpoint_processing_baseline.TZonCooSetCom) annotation (Line(points={{
          -18.6429,-49.4545},{-8,-49.4545},{-8,-48.2},{0,-48.2}}, color={0,0,
          127}));
  connect(setpoint_processing_baseline.TZonHeaSetPro,
    custom_air_conditioner_OnOff_timer_baseline.THeaSet) annotation (Line(
        points={{24,-39.4},{66,-39.4},{66,-38.5333},{70.8889,-38.5333}}, color=
          {0,0,127}));
  connect(setpoint_processing_baseline.TZonCooSetPro,
    custom_air_conditioner_OnOff_timer_baseline.TCooSet) annotation (Line(
        points={{24,-48},{26,-48.1333},{70.8889,-48.1333}}, color={0,0,127}));
  connect(setpoint_processing_baseline.TZonHeaSetPro,
    single_zone_ratchet_baseline.TZonHeaSetCur) annotation (Line(points={{24,
          -39.4},{32,-39.4},{32,-64},{-64,-64},{-64,-37.8182},{-59.4929,
          -37.8182}}, color={0,0,127}));
  connect(setpoint_processing_baseline.TZonCooSetPro,
    single_zone_ratchet_baseline.TZonCooSetCur) annotation (Line(points={{24,-48},
          {34,-48},{34,-66},{-64,-66},{-64,-40.2909},{-59.4929,-40.2909}},
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
end DF_SimpleRatchet_OnOffLoad_1Zone;

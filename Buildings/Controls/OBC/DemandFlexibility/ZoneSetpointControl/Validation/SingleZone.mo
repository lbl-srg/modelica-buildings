within Buildings.Controls.OBC.DemandFlexibility.ZoneSetpointControl.Validation;
model SingleZone
  extends Modelica.Icons.Example;
  CDL.Reals.Sources.Sin                        TZon(
    final freqHz=1/86400,
    final amplitude=1,
    phase=3.1415926535898,
    final offset=273.15 + 36)
    "Zone temperature"
    annotation (Placement(transformation(extent={{-72,8},{-52,28}})));
  Buildings.Controls.OBC.DemandFlexibility.ZoneSetpointControl.SingleZone
    singleZoneSetpointControl(
    delChaSheHea=-0.5556,
    delChaRebHea=0.5556,
    delSheThoHea=0.5556,
    delSheThoCoo=0.5556,
    delChaSheCoo=0.5556,
    delChaRebCoo=-0.5556)
    annotation (Placement(transformation(extent={{50,-68},{96,-2}})));
  .Buildings.Controls.OBC.DemandFlexibility.ZoneSetpointControl.ZoneSetpointSource
    zoneSetpointSource(occStaHouSta=6, occStaHouEnd=19)
    annotation (Placement(transformation(extent={{-72,-78},{-52,-58}})));
  CDL.Integers.Sources.TimeTable intTimTab(
    table=[0,0; 14,-1; 16,1; 21,2; 22,0; 24,0],
    timeScale=3600,
    period=86400)
    annotation (Placement(transformation(extent={{-72,72},{-52,92}})));
  Generic.DualTemperatureSetpointMock dualTemperatureSetpointMock(TRes=0.5556)
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={62,46})));
  CDL.Interfaces.RealOutput TSetHea
    annotation (Placement(transformation(extent={{196,46},{236,86}})));
  CDL.Interfaces.RealOutput TSetCoo
    annotation (Placement(transformation(extent={{204,-70},{244,-30}})));
equation
  connect(TZon.y, singleZoneSetpointControl.TCur) annotation (Line(points={{-50,18},
          {-8,18},{-8,-20.0632},{46.8276,-20.0632}},      color={0,0,127}));
  connect(zoneSetpointSource.TSetTarSheHea, singleZoneSetpointControl.TSetTarSheHea)
    annotation (Line(points={{-50,-63.4},{-50,-62},{-8,-62},{-8,-37.4316},{
          46.8276,-37.4316}},                                           color={
          0,0,127}));
  connect(zoneSetpointSource.TSetNomHea, singleZoneSetpointControl.TSetNomHea)
    annotation (Line(points={{-50,-66.2},{-50,-66},{4,-66},{4,-43.3368},{
          46.8276,-43.3368}},                                           color={
          0,0,127}));
  connect(zoneSetpointSource.TSetTarPreCoo, singleZoneSetpointControl.TSetTarPreCoo)
    annotation (Line(points={{-50,-70},{16,-70},{16,-50},{46,-50},{46,-49.5895},
          {46.8276,-49.5895}},
        color={0,0,127}));
  connect(zoneSetpointSource.TSetTarSheCoo, singleZoneSetpointControl.TSetTarSheCoo)
    annotation (Line(points={{-50,-72.6},{-50,-72},{24,-72},{24,-56},{46,-56},{
          46,-56.5368},{46.8276,-56.5368}},
                     color={0,0,127}));
  connect(zoneSetpointSource.TSetNomCoo, singleZoneSetpointControl.TSetNomCoo)
    annotation (Line(points={{-50,-76.2},{-50,-76},{36,-76},{36,-62.4421},{
          46.8276,-62.4421}},
        color={0,0,127}));
  connect(intTimTab.y[1], singleZoneSetpointControl.uMod) annotation (Line(
        points={{-50,82},{18,82},{18,-7.90526},{46.8276,-7.90526}},    color={
          255,127,0}));
  connect(zoneSetpointSource.TSetTarPreHea, singleZoneSetpointControl.TSetTarPreHea)
    annotation (Line(points={{-50,-60},{-20,-60},{-20,-32},{46,-32},{46,
          -31.1789},{46.8276,-31.1789}}, color={0,0,127}));
  connect(singleZoneSetpointControl.TSetComHea, dualTemperatureSetpointMock.uTSetHea)
    annotation (Line(points={{99.1724,-19.3684},{126,-19.3684},{126,41},{74,41}},
        color={0,0,127}));
  connect(singleZoneSetpointControl.TSetComCoo, dualTemperatureSetpointMock.uTSetCoo)
    annotation (Line(points={{99.1724,-53.7579},{168,-53.7579},{168,50.2},{74,
          50.2}}, color={0,0,127}));
  connect(dualTemperatureSetpointMock.yTSetHea, singleZoneSetpointControl.TSetCurHea)
    annotation (Line(points={{50,41.4},{40,41.4},{40,-14.8526},{46.8276,
          -14.8526}}, color={0,0,127}));
  connect(dualTemperatureSetpointMock.yTSetCoo, singleZoneSetpointControl.TSetCurCoo)
    annotation (Line(points={{50,50},{2,50},{2,-24.9263},{46.8276,-24.9263}},
        color={0,0,127}));
  connect(dualTemperatureSetpointMock.yTSetHea, TSetHea) annotation (Line(
        points={{50,41.4},{34,41.4},{34,48},{18,48},{18,60},{216,60},{216,66}},
        color={0,0,127}));
  connect(TSetCoo, dualTemperatureSetpointMock.yTSetCoo) annotation (Line(
        points={{224,-50},{132,-50},{132,102},{40,102},{40,50},{50,50}}, color=
          {0,0,127}));
  annotation (experiment(
      StopTime=172800,
      Interval=60,
      __Dymola_Algorithm="Dassl"));
end SingleZone;

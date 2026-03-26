within Buildings.Controls.OBC.DemandFlexibility.ZoneSetpointControl.Validation;
model MultipleZones
  extends Modelica.Icons.Example;
  parameter Integer nZon=4;
  CDL.Integers.Sources.TimeTable intTimTab(
    table=[0,0; 14,-1; 16,1; 21,2; 22,0; 24,0],
    timeScale=3600,
    period=86400)
    annotation (Placement(transformation(extent={{-92,74},{-72,94}})));
  CDL.Reals.Sources.Sin                        TZon(
    final freqHz=1/86400,
    final amplitude=1,
    phase=3.1415926535898,
    final offset=273.15 + 36)
    "Zone temperature"
    annotation (Placement(transformation(extent={{-92,6},{-72,26}})));
  .Buildings.Controls.OBC.DemandFlexibility.ZoneSetpointControl.ZoneSetpointSource
    zoneSetpointSource[nZon](occStaHouSta=6, occStaHouEnd=19)
    annotation (Placement(transformation(extent={{-92,-84},{-72,-64}})));
  Buildings.Controls.OBC.DemandFlexibility.ZoneSetpointControl.MultipleZones
    multipleZoneSetpointControl(nZon=nZon,
    delChaSheHea=-0.5556,
    delChaRebHea=0.5556,
    delSheThoHea=0.5556,
    delSheThoCoo=0.5556,
    delChaSheCoo=0.5556,
    delChaRebCoo=-0.5556)
    annotation (Placement(transformation(extent={{54,-70},{94,-2}})));
  CDL.Routing.RealScalarReplicator reaScaRep1(nout=nZon)
    annotation (Placement(transformation(extent={{-50,6},{-30,26}})));
  Generic.DualTemperatureSetpointMock dualTemperatureSetpointMock[nZon](TRes=
        0.5556) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={68,46})));
  CDL.Interfaces.RealOutput TSetHea[nZon]
    annotation (Placement(transformation(extent={{182,40},{222,80}})));
  CDL.Interfaces.RealOutput TSetCoo[nZon]
    annotation (Placement(transformation(extent={{190,-76},{230,-36}})));
equation
  connect(intTimTab.y[1], multipleZoneSetpointControl.uMod) annotation (Line(
        points={{-70,84},{46,84},{46,-4.992},{52.4615,-4.992}},
                                                color={255,127,0}));
  connect(zoneSetpointSource.TSetTarPreHea, multipleZoneSetpointControl.TSetTarPreHea)
    annotation (Line(points={{-70,-66},{-20,-66},{-20,-32.192},{52.4615,-32.192}},
                                                                     color={0,0,
          127}));
  connect(zoneSetpointSource.TSetNomHea, multipleZoneSetpointControl.TSetNomHea)
    annotation (Line(points={{-70,-72.2},{-70,-72},{2,-72},{2,-43.616},{52.4615,
          -43.616}},
        color={0,0,127}));
  connect(zoneSetpointSource.TSetTarPreCoo, multipleZoneSetpointControl.TSetTarPreCoo)
    annotation (Line(points={{-70,-76},{16,-76},{16,-51.504},{52.4615,-51.504}},
                                                                          color
        ={0,0,127}));
  connect(zoneSetpointSource.TSetTarSheCoo, multipleZoneSetpointControl.TSetTarSheCoo)
    annotation (Line(points={{-70,-78.6},{-70,-78},{28,-78},{28,-57.488},{
          52.4615,-57.488}},                                          color={0,
          0,127}));
  connect(zoneSetpointSource.TSetNomCoo, multipleZoneSetpointControl.TSetNomCoo)
    annotation (Line(points={{-70,-82.2},{-70,-82},{46,-82},{46,-63.472},{
          52.4615,-63.472}},
                     color={0,0,127}));
  connect(TZon.y, reaScaRep1.u) annotation (Line(points={{-70,16},{-52,16}},
                                             color={0,0,127}));
  connect(reaScaRep1.y, multipleZoneSetpointControl.TCur) annotation (Line(
        points={{-28,16},{8,16},{8,-18.592},{52.4615,-18.592}},color={0,0,127}));
  connect(zoneSetpointSource.TSetTarSheHea, multipleZoneSetpointControl.TSetTarSheHea)
    annotation (Line(points={{-70,-69.4},{-10,-69.4},{-10,-38},{52.4615,-38},{
          52.4615,-38.72}}, color={0,0,127}));
  connect(multipleZoneSetpointControl.TSetComHea, dualTemperatureSetpointMock.uTSetHea)
    annotation (Line(points={{95.5385,-23.216},{140,-23.216},{140,41},{80,41}},
        color={0,0,127}));
  connect(multipleZoneSetpointControl.TSetComCoo, dualTemperatureSetpointMock.uTSetCoo)
    annotation (Line(points={{95.5385,-51.776},{172,-51.776},{172,50.2},{80,
          50.2}}, color={0,0,127}));
  connect(dualTemperatureSetpointMock.yTSetHea, multipleZoneSetpointControl.TSetCurHea)
    annotation (Line(points={{56,41.4},{46,41.4},{46,42},{38,42},{38,-10.976},{
          52.4615,-10.976}}, color={0,0,127}));
  connect(dualTemperatureSetpointMock.yTSetCoo, multipleZoneSetpointControl.TSetCurCoo)
    annotation (Line(points={{56,50},{14,50},{14,-25.12},{52.4615,-25.12}},
        color={0,0,127}));
  connect(dualTemperatureSetpointMock.yTSetHea, TSetHea) annotation (Line(
        points={{56,41.4},{26,41.4},{26,42},{-8,42},{-8,60},{202,60}}, color={0,
          0,127}));
  connect(dualTemperatureSetpointMock.yTSetCoo, TSetCoo) annotation (Line(
        points={{56,50},{-14,50},{-14,10},{210,10},{210,-56}}, color={0,0,127}));
  annotation (experiment(
      StopTime=172800,
      Interval=60,
      __Dymola_Algorithm="Dassl"));
end MultipleZones;

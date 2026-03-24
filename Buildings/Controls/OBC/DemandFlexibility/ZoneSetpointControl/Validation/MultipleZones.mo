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
    final amplitude=12,
    phase=3.1415926535898,
    final offset=273.15 + 22)
    "Zone temperature"
    annotation (Placement(transformation(extent={{-92,6},{-72,26}})));
  CDL.Reals.Sources.TimeTable timTab(
    table=[0,273.15 + 14; 7,273.15 + 20; 17,273.15 + 19; 20,273.15 + 14; 24,273.15
         + 14],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    timeScale=3600)
    annotation (Placement(transformation(extent={{-92,44},{-72,64}})));
  CDL.Reals.Sources.TimeTable timTab1(
    table=[0,273.15 + 33; 7,273.15 + 28; 18,273.15 + 29; 20,273.15 + 33; 24,273.15
         + 33],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    timeScale=3600)
    annotation (Placement(transformation(extent={{-92,-36},{-72,-16}})));
  ZoneSetpointSource zoneSetpointSource[nZon](occStaHouSta=6, occStaHouEnd=19)
    annotation (Placement(transformation(extent={{-92,-84},{-72,-64}})));
  Buildings.Controls.OBC.DemandFlexibility.ZoneSetpointControl.MultipleZones
    multipleZoneSetpointControl(nZon=nZon)
    annotation (Placement(transformation(extent={{54,-70},{94,-2}})));
  CDL.Routing.RealScalarReplicator reaScaRep1(nout=nZon)
    annotation (Placement(transformation(extent={{-50,6},{-30,26}})));
  CDL.Routing.RealScalarReplicator reaScaRep2(nout=nZon)
    annotation (Placement(transformation(extent={{-50,44},{-30,64}})));
  CDL.Routing.RealScalarReplicator reaScaRep3(nout=nZon)
    annotation (Placement(transformation(extent={{-50,-36},{-30,-16}})));
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
  connect(timTab.y[1], reaScaRep2.u)
    annotation (Line(points={{-70,54},{-52,54}},   color={0,0,127}));
  connect(reaScaRep2.y, multipleZoneSetpointControl.TSetCurHea) annotation (
      Line(points={{-28,54},{14,54},{14,-10.976},{52.4615,-10.976}},
        color={0,0,127}));
  connect(timTab1.y[1], reaScaRep3.u)
    annotation (Line(points={{-70,-26},{-52,-26}}, color={0,0,127}));
  connect(reaScaRep3.y, multipleZoneSetpointControl.TSetCurCoo) annotation (
      Line(points={{-28,-26},{52.4615,-26},{52.4615,-25.12}}, color={0,0,127}));
  connect(zoneSetpointSource.TSetTarSheHea, multipleZoneSetpointControl.TSetTarSheHea)
    annotation (Line(points={{-70,-69.4},{-10,-69.4},{-10,-38},{52.4615,-38},{
          52.4615,-38.72}}, color={0,0,127}));
  annotation (experiment(
      StopTime=172800,
      Interval=60,
      __Dymola_Algorithm="Dassl"));
end MultipleZones;

within Buildings.Controls.OBC.DemandFlexibility.ZoneSetpointControl.Validation;
model SingleZone
  extends Modelica.Icons.Example;
  CDL.Reals.Sources.TimeTable timTab(
    table=[0,273.15 + 14; 7,273.15 + 20; 17,273.15 + 19; 20,273.15 + 14; 24,
        273.15 + 14],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    timeScale=3600)
    annotation (Placement(transformation(extent={{-72,40},{-52,60}})));
  CDL.Reals.Sources.TimeTable timTab1(
    table=[0,273.15 + 33; 7,273.15 + 28; 18,273.15 + 29; 20,273.15 + 33; 24,
        273.15 + 33],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    timeScale=3600)
    annotation (Placement(transformation(extent={{-72,-36},{-52,-16}})));
  CDL.Reals.Sources.Sin                        TZon(
    final freqHz=1/86400,
    final amplitude=12,
    phase=3.1415926535898,
    final offset=273.15 + 22)
    "Zone temperature"
    annotation (Placement(transformation(extent={{-72,8},{-52,28}})));
  Buildings.Controls.OBC.DemandFlexibility.ZoneSetpointControl.SingleZone
    singleZoneSetpointControl
    annotation (Placement(transformation(extent={{50,-68},{96,-2}})));
  ZoneSetpointSource zoneSetpointSource(occStaHouSta=6, occStaHouEnd=19)
    annotation (Placement(transformation(extent={{-72,-78},{-52,-58}})));
  CDL.Integers.Sources.TimeTable intTimTab(
    table=[0,0; 14,-1; 16,1; 21,2; 22,0; 24,0],
    timeScale=3600,
    period=86400)
    annotation (Placement(transformation(extent={{-72,72},{-52,92}})));
equation
  connect(timTab.y[1], singleZoneSetpointControl.TSetCurHea) annotation (Line(
        points={{-50,50},{8,50},{8,-14.8526},{46.8276,-14.8526}},
                                                     color={0,0,127}));
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
  connect(timTab1.y[1], singleZoneSetpointControl.TSetCurCoo) annotation (Line(
        points={{-50,-26},{48,-26},{48,-24.9263},{46.8276,-24.9263}}, color={0,
          0,127}));
  connect(zoneSetpointSource.TSetTarPreHea, singleZoneSetpointControl.TSetTarPreHea)
    annotation (Line(points={{-50,-60},{-20,-60},{-20,-32},{46,-32},{46,
          -31.1789},{46.8276,-31.1789}}, color={0,0,127}));
  annotation (experiment(
      StopTime=172800,
      Interval=60,
      __Dymola_Algorithm="Dassl"));
end SingleZone;

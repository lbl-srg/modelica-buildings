within Buildings.Controls.OBC.DemandFlexibility.Validation;
model SingleZoneSetpointControl
  extends Modelica.Icons.Example;
  CDL.Reals.Sources.TimeTable timTab(
    table=[0,273.15 + 14; 7,273.15 + 20; 17,273.15 + 19; 20,273.15 + 14; 24,
        273.15 + 14],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    timeScale=3600)
    annotation (Placement(transformation(extent={{-84,2},{-64,22}})));
  CDL.Reals.Sources.TimeTable timTab1(
    table=[0,273.15 + 33; 7,273.15 + 28; 18,273.15 + 29; 20,273.15 + 33; 24,
        273.15 + 33],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    timeScale=3600)
    annotation (Placement(transformation(extent={{-84,-36},{-64,-16}})));
  CDL.Reals.Sources.Sin                        TZon(
    final freqHz=1/86400,
    final amplitude=12,
    phase=3.1415926535898,
    final offset=273.15 + 22)
    "Zone temperature"
    annotation (Placement(transformation(extent={{-86,42},{-66,62}})));
  Buildings.Controls.OBC.DemandFlexibility.ZoneSetpointControl.SingleZone
    singleZoneSetpointControl
    annotation (Placement(transformation(extent={{12,4},{32,42}})));
  CDL.Logical.Sources.Constant con(k=true)
    annotation (Placement(transformation(extent={{-38,76},{-18,96}})));
  Generic.ZoneSetpointSource zoneSetpointSource(occStaHouSta=6, occStaHouEnd=19)
    annotation (Placement(transformation(extent={{-46,22},{-26,42}})));
  CDL.Integers.Sources.TimeTable intTimTab(
    table=[0,0; 14,-1; 16,1; 21,2; 22,0; 24,0],
    timeScale=3600,
    period=86400)
    annotation (Placement(transformation(extent={{-78,72},{-58,92}})));
equation
  connect(con.y, singleZoneSetpointControl.have_priHea) annotation (Line(points
        ={{-16,86},{2,86},{2,41.2},{10,41.2}}, color={255,0,255}));
  connect(con.y, singleZoneSetpointControl.have_priCoo) annotation (Line(points
        ={{-16,86},{2,86},{2,38},{10,38}}, color={255,0,255}));
  connect(timTab.y[1], singleZoneSetpointControl.TSetCurHea) annotation (Line(
        points={{-62,12},{0,12},{0,23.4},{10,23.4}}, color={0,0,127}));
  connect(timTab1.y[1], singleZoneSetpointControl.TSetCurCoo) annotation (Line(
        points={{-62,-26},{2,-26},{2,7.4},{10,7.4}}, color={0,0,127}));
  connect(TZon.y, singleZoneSetpointControl.TCur) annotation (Line(points={{-64,
          52},{-4,52},{-4,10},{2,10},{2,20.2},{10,20.2}}, color={0,0,127}));
  connect(zoneSetpointSource.TSetTarPreHea, singleZoneSetpointControl.TSetTarPreHea)
    annotation (Line(points={{-24,40},{-2,40},{-2,32.2},{10,32.2}}, color={0,0,
          127}));
  connect(zoneSetpointSource.TSetTarSheHea, singleZoneSetpointControl.TSetTarSheHea)
    annotation (Line(points={{-24,36.6},{-6,36.6},{-6,28.6},{10,28.6}}, color={
          0,0,127}));
  connect(zoneSetpointSource.TSetNomHea, singleZoneSetpointControl.TSetNomHea)
    annotation (Line(points={{-24,33.8},{-8,33.8},{-8,25.8},{10,25.8}}, color={
          0,0,127}));
  connect(zoneSetpointSource.TSetTarPreCoo, singleZoneSetpointControl.TSetTarPreCoo)
    annotation (Line(points={{-24,30},{-10,30},{-10,22},{2,22},{2,17},{10,17}},
        color={0,0,127}));
  connect(zoneSetpointSource.TSetTarSheCoo, singleZoneSetpointControl.TSetTarSheCoo)
    annotation (Line(points={{-24,27.4},{-12,27.4},{-12,18},{-2,18},{-2,14.4},{
          10,14.4}}, color={0,0,127}));
  connect(zoneSetpointSource.TSetNomCoo, singleZoneSetpointControl.TSetNomCoo)
    annotation (Line(points={{-24,23.8},{-24,6},{0,6},{0,10.8},{10,10.8}},
        color={0,0,127}));
  connect(intTimTab.y[1], singleZoneSetpointControl.uMod) annotation (Line(
        points={{-56,82},{-44,82},{-44,54},{0,54},{0,34.6},{10,34.6}}, color={
          255,127,0}));
  annotation (experiment(
      StopTime=172800,
      Interval=60,
      __Dymola_Algorithm="Dassl"));
end SingleZoneSetpointControl;

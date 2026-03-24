within Buildings.Controls.OBC.DemandFlexibility.Validation;
model MultipleZoneSetpointControl
  extends Modelica.Icons.Example;
  parameter Integer nZon=4;
  CDL.Integers.Sources.TimeTable intTimTab(
    table=[0,0; 14,-1; 16,1; 21,2; 22,0; 24,0],
    timeScale=3600,
    period=86400)
    annotation (Placement(transformation(extent={{-72,38},{-52,58}})));
  CDL.Reals.Sources.Sin                        TZon(
    final freqHz=1/86400,
    final amplitude=12,
    phase=3.1415926535898,
    final offset=273.15 + 22)
    "Zone temperature"
    annotation (Placement(transformation(extent={{-96,-4},{-76,16}})));
  CDL.Reals.Sources.TimeTable timTab(
    table=[0,273.15 + 14; 7,273.15 + 20; 17,273.15 + 19; 20,273.15 + 14; 24,273.15
         + 14],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    timeScale=3600)
    annotation (Placement(transformation(extent={{-92,-54},{-72,-34}})));
  CDL.Reals.Sources.TimeTable timTab1(
    table=[0,273.15 + 33; 7,273.15 + 28; 18,273.15 + 29; 20,273.15 + 33; 24,273.15
         + 33],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    timeScale=3600)
    annotation (Placement(transformation(extent={{-92,-92},{-72,-72}})));
  Generic.ZoneSetpointSource zoneSetpointSource[nZon](occStaHouSta=6,
      occStaHouEnd=19)
    annotation (Placement(transformation(extent={{-34,0},{-14,20}})));
  Buildings.Controls.OBC.DemandFlexibility.ZoneSetpointControl.MultipleZones
    multipleZoneSetpointControl(nZon=nZon)
    annotation (Placement(transformation(extent={{20,-2},{56,32}})));
  CDL.Routing.RealScalarReplicator reaScaRep1(nout=nZon)
    annotation (Placement(transformation(extent={{-62,-26},{-42,-6}})));
  CDL.Routing.RealScalarReplicator reaScaRep2(nout=nZon)
    annotation (Placement(transformation(extent={{-50,-54},{-30,-34}})));
  CDL.Routing.RealScalarReplicator reaScaRep3(nout=nZon)
    annotation (Placement(transformation(extent={{-52,-92},{-32,-72}})));
equation
  connect(intTimTab.y[1], multipleZoneSetpointControl.uMod) annotation (Line(
        points={{-50,48},{18,48},{18,29.0857}}, color={255,127,0}));
  connect(zoneSetpointSource.TSetTarPreHea, multipleZoneSetpointControl.TSetTarPreHea)
    annotation (Line(points={{-12,18},{-12,25.6857},{17.8,25.6857}}, color={0,0,
          127}));
  connect(zoneSetpointSource.TSetTarSheHea, multipleZoneSetpointControl.TSetTarSheHea)
    annotation (Line(points={{-12,14.6},{8,14.6},{8,22.7714},{17.8,22.7714}},
        color={0,0,127}));
  connect(zoneSetpointSource.TSetNomHea, multipleZoneSetpointControl.TSetNomHea)
    annotation (Line(points={{-12,11.8},{10,11.8},{10,19.3714},{17.8,19.3714}},
        color={0,0,127}));
  connect(zoneSetpointSource.TSetTarPreCoo, multipleZoneSetpointControl.TSetTarPreCoo)
    annotation (Line(points={{-12,8},{10,8},{10,9.00952},{17.8,9.00952}}, color
        ={0,0,127}));
  connect(zoneSetpointSource.TSetTarSheCoo, multipleZoneSetpointControl.TSetTarSheCoo)
    annotation (Line(points={{-12,5.4},{-10,6.09524},{17.6,6.09524}}, color={0,
          0,127}));
  connect(zoneSetpointSource.TSetNomCoo, multipleZoneSetpointControl.TSetNomCoo)
    annotation (Line(points={{-12,1.8},{-12,2},{10,2},{10,3.01905},{17.6,
          3.01905}}, color={0,0,127}));
  connect(TZon.y, reaScaRep1.u) annotation (Line(points={{-74,6},{-66,6},{-66,
          -8},{-72,-8},{-72,-16},{-64,-16}}, color={0,0,127}));
  connect(reaScaRep1.y, multipleZoneSetpointControl.TCur) annotation (Line(
        points={{-40,-16},{8,-16},{8,12.7333},{17.8,12.7333}}, color={0,0,127}));
  connect(timTab.y[1], reaScaRep2.u)
    annotation (Line(points={{-70,-44},{-52,-44}}, color={0,0,127}));
  connect(reaScaRep2.y, multipleZoneSetpointControl.TSetCurHea) annotation (
      Line(points={{-28,-44},{-20,-44},{-20,-6},{6,-6},{6,16.4571},{18,16.4571}},
        color={0,0,127}));
  connect(timTab1.y[1], reaScaRep3.u)
    annotation (Line(points={{-70,-82},{-54,-82}}, color={0,0,127}));
  connect(reaScaRep3.y, multipleZoneSetpointControl.TSetCurCoo) annotation (
      Line(points={{-30,-82},{18.2,-82},{18.2,-0.542857}}, color={0,0,127}));
  annotation (experiment(
      StopTime=172800,
      Interval=60,
      __Dymola_Algorithm="Dassl"));
end MultipleZoneSetpointControl;

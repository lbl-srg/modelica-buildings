within Buildings.Controls.OBC.DemandFlexibility.Validation;
model MultipleZoneRatchet
  extends Modelica.Icons.Example;
  parameter Integer nZones=4;
  Buildings.Controls.OBC.DemandFlexibility.MultipleZoneRatchet
    MultipleZoneRatchet(nZones=nZones)
    annotation (Placement(transformation(extent={{28,-26},{84,18}})));
  CDL.Reals.Sources.TimeTable timTab(
    table=[0,273.15 + 14; 7,273.15 + 20; 17,273.15 + 19; 20,273.15 + 14; 24,273.15
         + 14],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    timeScale=3600)
    annotation (Placement(transformation(extent={{-90,-16},{-70,4}})));
  CDL.Reals.Sources.TimeTable timTab1(
    table=[0,273.15 + 33; 7,273.15 + 28; 18,273.15 + 29; 20,273.15 + 33; 24,273.15
         + 33],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    timeScale=3600)
    annotation (Placement(transformation(extent={{-90,-68},{-70,-48}})));
  CDL.Reals.Sources.Sin                        TZon(
    final freqHz=1/86400,
    final amplitude=12,
    phase=3.1415926535898,
    final offset=273.15 + 22)
    "Zone temperature"
    annotation (Placement(transformation(extent={{-90,40},{-70,60}})));
  CDL.Routing.RealScalarReplicator reaScaRep(nout=nZones)
    annotation (Placement(transformation(extent={{-42,40},{-22,60}})));
  CDL.Routing.RealScalarReplicator reaScaRep1(nout=nZones)
    annotation (Placement(transformation(extent={{-50,-16},{-30,4}})));
  CDL.Routing.RealScalarReplicator reaScaRep2(nout=nZones)
    annotation (Placement(transformation(extent={{-50,-68},{-30,-48}})));
  CDL.Logical.Sources.TimeTable booTimTab(
    table=[0,0; 7,1; 20,0; 24,0],
    timeScale=3600,
    period=86400)
    annotation (Placement(transformation(extent={{-90,72},{-70,92}})));
equation
  connect(TZon.y, reaScaRep.u)
    annotation (Line(points={{-68,50},{-44,50}}, color={0,0,127}));
  connect(reaScaRep.y, MultipleZoneRatchet.TZon) annotation (Line(points={{-20,
          50},{12,50},{12,2.2},{25.8,2.2}}, color={0,0,127}));
  connect(timTab.y[1], reaScaRep1.u)
    annotation (Line(points={{-68,-6},{-52,-6}}, color={0,0,127}));
  connect(timTab1.y[1], reaScaRep2.u)
    annotation (Line(points={{-68,-58},{-52,-58}}, color={0,0,127}));
  connect(reaScaRep1.y, MultipleZoneRatchet.TZonHeaSetCur) annotation (Line(
        points={{-28,-6},{16,-6},{16,-1},{25.8,-1}}, color={0,0,127}));
  connect(reaScaRep2.y, MultipleZoneRatchet.TZonCooSetCur) annotation (Line(
        points={{-28,-58},{16,-58},{16,-8},{18,-8},{18,-4.4},{26,-4.4}}, color=
          {0,0,127}));
  connect(booTimTab.y[1], MultipleZoneRatchet.occSta) annotation (Line(points={
          {-68,82},{18,82},{18,11.4},{26,11.4}}, color={255,0,255}));
  annotation (experiment(
      StopTime=172800,
      Interval=60,
      __Dymola_Algorithm="Dassl"));
end MultipleZoneRatchet;

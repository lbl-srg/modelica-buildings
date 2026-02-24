within Buildings.Controls.OBC.DemandFlexibility.Validation;
model multiple_zone_ratchet_load_response
  extends Modelica.Icons.Example;
  parameter Integer nZones=4;
  Buildings.Controls.OBC.DemandFlexibility.multiple_zone_ratchet_load_response
    multiple_zone_ratchet_load_response(nZones=nZones)
    annotation (Placement(transformation(extent={{28,-26},{84,18}})));
  CDL.Reals.Sources.TimeTable timTab(
    table=[0,273.15 + 14; 7,273.15 + 20; 17,273.15 + 19; 20,273.15 + 14; 24,273.15
         + 14],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    timeScale=3600)
    annotation (Placement(transformation(extent={{-90,-4},{-70,16}})));
  CDL.Reals.Sources.TimeTable timTab1(
    table=[0,273.15 + 33; 7,273.15 + 28; 18,273.15 + 29; 20,273.15 + 33; 24,273.15
         + 33],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    timeScale=3600)
    annotation (Placement(transformation(extent={{-90,-36},{-70,-16}})));
  CDL.Reals.Sources.Sin                        TZon(
    final freqHz=1/86400,
    final amplitude=12,
    phase=3.1415926535898,
    final offset=273.15 + 22) "Zone temperature"
    annotation (Placement(transformation(extent={{-90,40},{-70,60}})));
  CDL.Routing.RealScalarReplicator reaScaRep(nout=nZones)
    annotation (Placement(transformation(extent={{-42,40},{-22,60}})));
  CDL.Routing.RealScalarReplicator reaScaRep1(nout=nZones)
    annotation (Placement(transformation(extent={{-50,-4},{-30,16}})));
  CDL.Routing.RealScalarReplicator reaScaRep2(nout=nZones)
    annotation (Placement(transformation(extent={{-50,-36},{-30,-16}})));
  CDL.Logical.Sources.TimeTable booTimTab(
    table=[0,0; 7,1; 20,0; 24,0],
    timeScale=3600,
    period=86400)
    annotation (Placement(transformation(extent={{-90,72},{-70,92}})));
  CDL.Reals.Sources.Sin Pel(
    final freqHz=1/86400,
    final amplitude=100,
    phase=3.9269908169872,
    final offset=400)
    annotation (Placement(transformation(extent={{-50,-64},{-30,-44}})));
  CDL.Reals.Sources.Sin Pel_limit(
    final freqHz=1/86400,
    final amplitude=100,
    phase=4.7123889803847,
    final offset=400)
    annotation (Placement(transformation(extent={{-50,-98},{-30,-78}})));
equation
  connect(TZon.y, reaScaRep.u)
    annotation (Line(points={{-68,50},{-44,50}}, color={0,0,127}));
  connect(reaScaRep.y, multiple_zone_ratchet_load_response.TZon) annotation (
      Line(points={{-20,50},{12,50},{12,4.63077},{25.9467,4.63077}}, color={0,0,
          127}));
  connect(timTab.y[1], reaScaRep1.u)
    annotation (Line(points={{-68,6},{-52,6}}, color={0,0,127}));
  connect(timTab1.y[1], reaScaRep2.u)
    annotation (Line(points={{-68,-26},{-52,-26}}, color={0,0,127}));
  connect(reaScaRep1.y, multiple_zone_ratchet_load_response.TZonHeaSetCur)
    annotation (Line(points={{-28,6},{10,6},{10,1.92308},{25.9467,1.92308}},
        color={0,0,127}));
  connect(reaScaRep2.y, multiple_zone_ratchet_load_response.TZonCooSetCur)
    annotation (Line(points={{-28,-26},{22,-26},{22,-0.953846},{26.1333,
          -0.953846}}, color={0,0,127}));
  connect(booTimTab.y[1], multiple_zone_ratchet_load_response.occSta)
    annotation (Line(points={{-68,82},{18,82},{18,12.4154},{26.1333,12.4154}},
        color={255,0,255}));
  connect(Pel.y, multiple_zone_ratchet_load_response.Pel) annotation (Line(
        points={{-28,-54},{-12,-54},{-12,-17.8769},{26.1333,-17.8769}}, color={
          0,0,127}));
  connect(Pel_limit.y, multiple_zone_ratchet_load_response.Pel_limit)
    annotation (Line(points={{-28,-88},{24,-88},{24,-22.7846},{26.1333,-22.7846}},
        color={0,0,127}));
end multiple_zone_ratchet_load_response;

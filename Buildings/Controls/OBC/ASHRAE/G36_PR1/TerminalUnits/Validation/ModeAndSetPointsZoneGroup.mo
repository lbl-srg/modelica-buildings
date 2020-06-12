within Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Validation;
model ModeAndSetPointsZoneGroup

  parameter Integer numZon = 5 "number of zones in the zone group";
  Generic.SetPoints.GroupStatus zonGroSta "Zone group status"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
  Generic.SetPoints.ZoneStatus_re zonSta[numZon](
    TZonHeaOn=fill(293.15, numZon),
    TZonHeaOff=fill(285.15, numZon),
    TZonCooOn=fill(297.15, numZon),
    TZonCooOff=fill(303.15, numZon),
    bouLim=fill(1.1, numZon))
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  ModeAndSetPoints_re modSetPoi
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  Buildings.Controls.SetPoints.OccupancySchedule occSch(occupancy=3600*{6,19})
    "Occupancy schedule for the zone group"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
equation
  connect(zonSta.yCooTim, zonGroSta.uCooTim) annotation (Line(points={{-38,21},
          {-26,21},{-26,20},{-12,20}},color={0,0,127}));
  connect(zonSta.yWarTim, zonGroSta.uWarTim) annotation (Line(points={{-38,19},
          {-26,19},{-26,18},{-12,18}},color={0,0,127}));
  connect(zonGroSta.yCooTim, modSetPoi.maxCooDowTim) annotation (Line(points={{12,
          19},{34,19},{34,16},{38,16}}, color={0,0,127}));
  connect(zonGroSta.yWarTim, modSetPoi.maxWarUpTim) annotation (Line(points={{12,
          17},{32,17},{32,14},{38,14}}, color={0,0,127}));
  connect(zonGroSta.yOccHeaHig, modSetPoi.uOccHeaHig) annotation (Line(points={{12,15},
          {30,15},{30,12},{38,12}},        color={255,0,255}));
  connect(zonGroSta.yHigOccCoo, modSetPoi.uHigOccCoo) annotation (Line(points={{12,13},
          {28,13},{28,10},{38,10}},        color={255,0,255}));
  connect(zonGroSta.yColZon, modSetPoi.totColZon) annotation (Line(points={{12,11},
          {26,11},{26,8},{38,8}}, color={255,127,0}));
  connect(zonGroSta.yUnoHeaHig, modSetPoi.unoHeaHigMin)
    annotation (Line(points={{12,9},{24,9},{24,6},{38,6}}, color={255,0,255}));
  connect(zonGroSta.TZonMin, modSetPoi.TZonMax)
    annotation (Line(points={{12,7},{22,7},{22,4},{38,4}}, color={0,0,127}));
  connect(zonGroSta.TZonMax, modSetPoi.TZonMin)
    annotation (Line(points={{12,5},{20,5},{20,2},{38,2}}, color={0,0,127}));
  connect(zonGroSta.yHotZon, modSetPoi.totHotZon)
    annotation (Line(points={{12,3},{18,3},{18,0},{38,0}}, color={255,127,0}));
  connect(zonGroSta.yHigUnoCoo, modSetPoi.maxHigUnoCoo) annotation (Line(points={{12,1},{
          16,1},{16,-2},{38,-2}},         color={255,0,255}));
  connect(zonSta.yOccHeaHig, zonGroSta.uOccHeaHig) annotation (Line(points={{-38,15},
          {-26,15},{-26,10},{-12,10}},     color={255,0,255}));
  connect(zonSta.yHigOccCoo, zonGroSta.uHigOccCoo) annotation (Line(points={{-38,11},
          {-26,11},{-26,16},{-12,16}},     color={255,0,255}));
  connect(zonSta.yColZon, zonGroSta.uColZon) annotation (Line(points={{-38,9},{
          -26,9},{-26,12},{-12,12}},
                               color={255,127,0}));
  connect(zonSta.yUnoHeaHig, zonGroSta.uUnoHeaHig) annotation (Line(points={{-38,7},
          {-26,7},{-26,16},{-12,16}},  color={255,0,255}));
  connect(zonSta.yHigUnoCoo, zonGroSta.uHigUnoCoo) annotation (Line(points={{-38,1},
          {-26,1},{-26,8},{-12,8}},    color={255,0,255}));
  connect(zonSta.yHotZon, zonGroSta.uHotZon) annotation (Line(points={{-38,3},{
          -26,3},{-26,6},{-12,6}},
                               color={255,127,0}));
  connect(zonSta.TZonGro, zonGroSta.TZon) annotation (Line(points={{-38,11},{
          -26,11},{-26,14},{-12,14}},
                                 color={0,0,127}));
  connect(zonSta.TCooSetOn, zonGroSta.TZonCooSetOcc) annotation (Line(points={{
          -38,13},{-26,13},{-26,4},{-12,4}}, color={0,0,127}));
  connect(zonSta.TCooSetOff, zonGroSta.TZonCooSetUno) annotation (Line(points={
          {-38,3},{-26,3},{-26,2},{-12,2}}, color={0,0,127}));
  connect(zonSta.THeaSetOn, zonGroSta.TZonHeaSetOcc) annotation (Line(points={{
          -38,17},{-24,17},{-24,0},{-12,0}}, color={0,0,127}));
  connect(zonSta.THeaSetOff, zonGroSta.TZonHeaSetUno) annotation (Line(points={
          {-38,9},{-24,9},{-24,-2},{-12,-2}}, color={0,0,127}));
  connect(zonGroSta.TGroCooOcc, modSetPoi.TZonCooSetOcc) annotation (Line(
        points={{12,-1},{26,-1},{26,-12},{38,-12}}, color={0,0,127}));
  connect(zonGroSta.TGroCooUno, modSetPoi.TZonCooSetUno) annotation (Line(
        points={{12,-3},{24,-3},{24,-14},{38,-14}}, color={0,0,127}));
  connect(zonGroSta.TGroHeaOcc, modSetPoi.TZonHeaSetOcc) annotation (Line(
        points={{12,-5},{22,-5},{22,-16},{38,-16}}, color={0,0,127}));
  connect(zonGroSta.TGroHeaUno, modSetPoi.TZonHeaSetUno) annotation (Line(
        points={{12,-7},{20,-7},{20,-18},{38,-18}}, color={0,0,127}));
  connect(occSch.tNexOcc, modSetPoi.tNexOcc) annotation (Line(points={{-19,56},
          {36,56},{36,20},{38,20}}, color={0,0,127}));
  connect(occSch.occupied, modSetPoi.uOcc) annotation (Line(points={{-19,44},{
          34,44},{34,18.025},{38,18.025}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ModeAndSetPointsZoneGroup;

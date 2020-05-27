within Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Validation;
model ModeAndSetPointsZoneGroup

  parameter Integer numZon = 5 "number of zones in the zone group";
  Generic.SetPoints.ZoneGroupStatus zonGroSta "Zone group status"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
  Generic.SetPoints.ZoneStatus_re zonSta[numZon]
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  ModeAndSetPoints_re modSetPoi
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
equation
  connect(zonSta.yCooTim, zonGroSta.uCooTim) annotation (Line(points={{-38,18},
          {-26,18},{-26,18},{-12,18}},color={0,0,127}));
  connect(zonSta.yWarTim, zonGroSta.uWarTim) annotation (Line(points={{-38,16},
          {-26,16},{-26,16},{-12,16}},color={0,0,127}));
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
  connect(zonSta.yOccHeaHig, zonGroSta.uOccHeaHig) annotation (Line(points={{-38,14},
          {-26,14},{-26,14},{-12,14}},     color={255,0,255}));
  connect(zonSta.yHigOccCoo, zonGroSta.uHigOccCoo) annotation (Line(points={{-38,12},
          {-26,12},{-26,12},{-12,12}},     color={255,0,255}));
  connect(zonSta.yColZon, zonGroSta.uColZon) annotation (Line(points={{-38,8},{
          -26,8},{-26,8},{-12,8}},
                               color={255,127,0}));
  connect(zonSta.yUnoHeaHig, zonGroSta.uUnoHeaHig) annotation (Line(points={{-38,6},
          {-26,6},{-26,6},{-12,6}},    color={255,0,255}));
  connect(zonSta.yHigUnoCoo, zonGroSta.uHigUnoCoo) annotation (Line(points={{-38,4},
          {-26,4},{-26,4},{-12,4}},    color={255,0,255}));
  connect(zonSta.yHotZon, zonGroSta.uHotZon) annotation (Line(points={{-38,2},{
          -26,2},{-26,2},{-12,2}},
                               color={255,127,0}));
  connect(zonSta.TZonAll, zonGroSta.TZon) annotation (Line(points={{-38,10},{
          -26,10},{-26,10},{-12,10}},
                                 color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ModeAndSetPointsZoneGroup;

within Buildings.Applications.DHC.Examples.Combined.Generation5.Unidirectional.Loads;
model BuildingTimeSeriesWithETS
  "Model of a building with thermal loads as time series, with an energy transfer station"
  extends BaseClasses.PartialBuildingWithETS(
    redeclare DHC.Loads.Examples.BaseClasses.BuildingTimeSeries bui(
      final filNam=filNam),
    ets(QChiWat_flow_nominal=sum(bui.terUniCoo.QCoo_flow_nominal),
        QHeaWat_flow_nominal=sum(bui.terUniHea.QHea_flow_nominal)));
  parameter String filNam
    "Library path of the file with thermal loads as time series";
  annotation (Line(
      points={{-1,100},{0.1,100},{0.1,71.4}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
end BuildingTimeSeriesWithETS;

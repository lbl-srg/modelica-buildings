within Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans;
model VAVMultiZoneG36Airflow
  extends VAVMultiZoneOpenLoop(redeclare replaceable
      Components.Controls.G36VAVMultiZone ctl(idZon={"Box_1","Box_1"},
        namGroZon={"Floor_1","Floor_1"}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end VAVMultiZoneG36Airflow;

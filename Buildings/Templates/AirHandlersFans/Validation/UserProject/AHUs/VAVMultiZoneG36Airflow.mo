within Buildings.Templates.AirHandlersFans.Validation.UserProject.AHUs;
model VAVMultiZoneG36Airflow
  extends VAVMultiZoneOpenLoop(
                      redeclare replaceable Components.Controls.G36VAVMultiZone
      ctr);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end VAVMultiZoneG36Airflow;

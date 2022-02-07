within Buildings.Templates.AirHandlersFans.Validation;
model VAVMultiZoneG36Pressure
  "Return fan control based on direct building pressure"
  extends VAVMultiZoneG36Airflow(
    redeclare UserProject.AHUs.ControlsGuideline36Pressure ahu);

  annotation (
    experiment(Tolerance=1e-6, StopTime=1),
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
Bug in In Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.Controller (#1913)

retFanDpCon.uMinOutAirDam is not connected, yielding a singular model.
</html>"));
end VAVMultiZoneG36Pressure;

within Buildings.Templates.AirHandlersFans.Validation.UserProject.AHUs;
model VAVMultiZoneG36Pressure
  extends VAVMultiZoneOpenLoop(
                      redeclare replaceable Components.Controls.G36VAVMultiZone
      ctr(typCtrFanRet=Buildings.Templates.AirHandlersFans.Types.ControlFanReturn.Pressure));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end VAVMultiZoneG36Pressure;

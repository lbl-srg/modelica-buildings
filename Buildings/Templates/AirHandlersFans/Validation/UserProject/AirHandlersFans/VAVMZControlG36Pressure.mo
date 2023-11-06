within Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans;
model VAVMZControlG36Pressure "Configuration of multiple-zone VAV"
  extends Buildings.Templates.AirHandlersFans.VAVMultiZone(
    nZon=2,
    redeclare replaceable  Buildings.Templates.AirHandlersFans.Components.Controls.G36VAVMultiZone ctl(
      typCtlFanRet=Buildings.Templates.AirHandlersFans.Types.ControlFanReturn.BuildingPressure,
      idZon={"Box_1","Box_1"},
      namGro={"Floor_1"},
      namGroZon={"Floor_1","Floor_1"}));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This is a configuration model with the same default options as
<a href=\"modelica://Buildings.Templates.AirHandlersFans.VAVMultiZone\">
Buildings.Templates.AirHandlersFans.VAVMultiZone</a>
except for the following options.<br/>
</p>
<table summary=\"summary\" border=\"1\">
<tr><th>Component</th><th>Configuration</th></tr>
<tr><td>Heating coil</td><td>Hot water coil - Two-way modulating valve - Preheat position</td></tr>
<tr><td>Cooling coil</td><td>Chilled water coil - Two-way modulating valve</td></tr>
<tr><td>Controller</td><td>Guideline 36 controller - Return fan with building pressure control</td></tr>
</table>
</html>"));
end VAVMZControlG36Pressure;

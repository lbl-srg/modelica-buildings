within Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans;
model VAVMZControlG36Airflow "Configuration of multiple-zone VAV"
  extends VAVMZCoilWaterHeatingCooling(
                               redeclare replaceable
      Components.Controls.G36VAVMultiZone ctl(idZon={"Box_1","Box_1"},
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
<tr><td>Controller</td><td>Guideline 36 controller - Return fan with airflow tracking control</td></tr>
</table>
</html>"));
end VAVMZControlG36Airflow;

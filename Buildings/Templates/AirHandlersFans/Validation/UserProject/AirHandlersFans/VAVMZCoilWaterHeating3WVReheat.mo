within Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans;
model VAVMZCoilWaterHeating3WVReheat "Configuration of multiple-zone VAV"
  extends Buildings.Templates.AirHandlersFans.VAVMultiZone(
    redeclare replaceable Buildings.Templates.AirHandlersFans.Components.Controls.OpenLoop ctl
      "Open loop controller",
    redeclare replaceable Buildings.Templates.Components.Coils.None coiHeaPre,
    redeclare replaceable
      Buildings.Templates.Components.Coils.WaterBasedHeating coiHeaReh(
        redeclare final package MediumHeaWat = MediumHeaWat,
        redeclare Buildings.Templates.Components.Valves.ThreeWayModulating val),
    nZon=2);
  annotation (
    defaultComponentName="ahu", Documentation(info="<html>
<p>
This is a configuration model with the same default options as
<a href=\"modelica://Buildings.Templates.AirHandlersFans.VAVMultiZone\">
Buildings.Templates.AirHandlersFans.VAVMultiZone</a>
except for the following options.<br/>
</p>
<table summary=\"summary\" border=\"1\">
<tr><th>Component</th><th>Configuration</th></tr>
<tr><td>Heating coil</td><td>Hot water coil - Three-way modulating valve - Reheat position</td></tr>
</table>
</html>"));
end VAVMZCoilWaterHeating3WVReheat;

within Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans;
model VAVMZDedicatedDampersAirflow "Configuration of multiple-zone VAV"
  extends Buildings.Templates.AirHandlersFans.VAVMultiZone(
    redeclare replaceable Buildings.Templates.AirHandlersFans.Components.Controls.OpenLoop ctl
      "Open loop controller",
    secOutRel(redeclare replaceable model OutdoorSection_MAWD =
          Buildings.Templates.AirHandlersFans.Components.OutdoorSection.DedicatedDampersAirflow),
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
<tr><td>Outdoor air section</td><td>Separate dedicated OA dampers with AFMS</td></tr>
</table>
</html>"));
end VAVMZDedicatedDampersAirflow;

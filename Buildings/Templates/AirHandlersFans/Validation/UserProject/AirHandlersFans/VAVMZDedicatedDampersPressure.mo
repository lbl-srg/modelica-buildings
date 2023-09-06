within Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans;
model VAVMZDedicatedDampersPressure "Configuration of multiple-zone VAV"
  extends Buildings.Templates.AirHandlersFans.VAVMultiZone(
    secOutRel(redeclare model OutdoorSection_MAWD =
          Buildings.Templates.AirHandlersFans.Components.OutdoorSection.DedicatedDampersPressure),
    redeclare replaceable Buildings.Templates.AirHandlersFans.Components.Controls.OpenLoop ctl
      "Open loop controller",
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
<tr><td>Outdoor air section</td><td>Separate dedicated OA dampers with differential pressure sensor</td></tr>
</table>
</html>"));
end VAVMZDedicatedDampersPressure;

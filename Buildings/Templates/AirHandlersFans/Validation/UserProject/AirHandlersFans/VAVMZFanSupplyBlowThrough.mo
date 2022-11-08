within Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans;
model VAVMZFanSupplyBlowThrough "Configuration of multiple-zone VAV"
  extends Buildings.Templates.AirHandlersFans.VAVMultiZone(
    redeclare replaceable Buildings.Templates.AirHandlersFans.Components.Controls.OpenLoop ctl
      "Open loop controller",
    redeclare replaceable Buildings.Templates.Components.Fans.None fanSupDra,
    nZon=2,
    redeclare replaceable Buildings.Templates.Components.Fans.SingleVariable
      fanSupBlo);

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
<tr><td>Supply fan</td><td>Single fan - Variable speed - Blow-through position</td></tr>
</table>
</html>"));
end VAVMZFanSupplyBlowThrough;

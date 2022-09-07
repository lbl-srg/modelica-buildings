within Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans;
model VAVMZFanRelief "Configuration of multiple-zone VAV"
  extends Buildings.Templates.AirHandlersFans.VAVMultiZone(
    redeclare replaceable Buildings.Templates.AirHandlersFans.Components.Controls.OpenLoop ctl
      "Open loop controller",
    secOutRel(redeclare replaceable
        Buildings.Templates.AirHandlersFans.Components.ReliefReturnSection.ReliefFan
        secRel "Relief fan with two-position relief damper"),
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
<tr><td>Relief/return air section</td><td>Relief fan with two-position relief damper</td></tr>
<tr><td>Return fan</td><td>No fan</td></tr>
<tr><td>Relief fan</td><td>Single fan - Variable speed</td></tr>
</table>
</html>"));
end VAVMZFanRelief;

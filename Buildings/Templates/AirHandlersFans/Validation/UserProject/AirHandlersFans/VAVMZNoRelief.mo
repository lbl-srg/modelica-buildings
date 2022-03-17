within Buildings.Templates.AirHandlersFans.Validation.UserProject.AirHandlersFans;
model VAVMZNoRelief "Air economizer - No relief branch"
  extends VAVMultiZone(
    redeclare replaceable
      Buildings.Templates.AirHandlersFans.Components.OutdoorReliefReturnSection.EconomizerNoRelief
      secOutRel "Air economizer - No relief branch",
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
<tr><td>Relief/return air section</td><td>No relief</td></tr>
<tr><td>Return fan</td><td>No fan</td></tr>
</table>
</html>"));
end VAVMZNoRelief;

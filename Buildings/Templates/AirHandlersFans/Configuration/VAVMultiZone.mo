within Buildings.Templates.AirHandlersFans.Configuration;
record VAVMultiZone "Configuration parameters for multiple-zone VAV"
  extends Buildings.Templates.AirHandlersFans.Configuration.PartialAirHandler;

  parameter Buildings.Templates.Components.Types.Coil typCoiHeaPre
    "Type of heating coil in preheat position"
    annotation (Evaluate=true);
  parameter Buildings.Templates.Components.Types.Coil typCoiCoo
    "Type of cooling coil"
    annotation (Evaluate=true);
  parameter Buildings.Templates.Components.Types.Coil typCoiHeaReh
    "Type of heating coil in reheat position"
    annotation (Evaluate=true);
  parameter Buildings.Templates.Components.Types.Valve typValCoiHeaPre
    "Type of valve for heating coil in preheat position"
    annotation (Evaluate=true);
  parameter Buildings.Templates.Components.Types.Valve typValCoiCoo
    "Type of valve for cooling coil"
    annotation (Evaluate=true);
  parameter Buildings.Templates.Components.Types.Valve typValCoiHeaReh
    "Type of valve for heating coil in reheat position"
    annotation (Evaluate=true);
  parameter Buildings.Templates.Components.Types.Damper typDamOut
    "Outdoor air damper type"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.Damper typDamOutMin
    "Minimum outdoor air damper type"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.Damper typDamRel
    "Relief damper type"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Templates.Components.Types.Damper typDamRet
    "Return damper type"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection typSecOut
    "Type of outdoor air section"
    annotation (Evaluate=true);
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.BuildingPressureControlTypes buiPreCon
    "Type of building pressure control system"
    annotation (Evaluate=true);
  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.VentilationStandard stdVen
    "Ventilation standard"
    annotation(Evaluate=true);

annotation (
  defaultComponentPrefixes = "parameter",
  defaultComponentName = "cfg",
    Documentation(info="<html>
<p>
This record provides the set of configuration parameters for the class
<a href=\"modelica://Buildings.Templates.AirHandlersFans.VAVMultiZone\">
Buildings.Templates.AirHandlersFans.VAVMultiZone</a>.
</p>
</html>"));
end VAVMultiZone;

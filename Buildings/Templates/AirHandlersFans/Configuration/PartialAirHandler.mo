within Buildings.Templates.AirHandlersFans.Configuration;
record PartialAirHandler "Configuration parameters for air handler interface class"
  extends Modelica.Icons.Record;

  parameter Buildings.Templates.AirHandlersFans.Types.Configuration typ
    "Type of system"
    annotation (Evaluate=true);
  parameter Buildings.Templates.Components.Types.Fan typFanSup
    "Type of supply fan"
    annotation (Evaluate=true);
  parameter Buildings.Templates.Components.Types.Fan typFanRet
    "Type of return fan"
    annotation (Evaluate=true);
  parameter Buildings.Templates.Components.Types.Fan typFanRel
    "Type of relief fan"
    annotation (Evaluate=true);
  parameter Boolean have_souChiWat
    "Set to true if cooling coil requires fluid ports on the source side"
    annotation (Evaluate=true);
  parameter Boolean have_souHeaWat
    "Set to true if heating coil requires fluid ports on the source side"
    annotation (Evaluate=true);
  parameter Buildings.Templates.AirHandlersFans.Types.Controller typCtl
    "Type of controller"
    annotation (Evaluate=true);

  annotation (Documentation(info="<html>
<p>
This record provides the set of configuration parameters for the class
<a href=\"modelica://Buildings.Templates.AirHandlersFans.Interfaces.PartialAirHandler\">
Buildings.Templates.AirHandlersFans.Interfaces.PartialAirHandler</a>.
</p>
</html>"));
end PartialAirHandler;

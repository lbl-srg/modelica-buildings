within Buildings.Templates.ZoneEquipment.Configuration;
record PartialAirTerminal "Configuration parameters for air terminal unit interface class"
  extends Modelica.Icons.Record;

  parameter Buildings.Templates.ZoneEquipment.Types.Configuration typ
    "Type of system"
    annotation (Evaluate=true);
  parameter Boolean have_souChiWat
    "Set to true if system uses CHW"
    annotation (Evaluate=true);
  parameter Boolean have_souHeaWat
    "Set to true if system uses HHW"
    annotation (Evaluate=true);
  parameter Buildings.Templates.ZoneEquipment.Types.Controller typCtl
    "Type of controller"
    annotation (Evaluate=true);

  annotation (Documentation(info="<html>
<p>
This record provides the set of configuration parameters for the class
<a href=\"modelica://Buildings.Templates.ZoneEquipment.Interfaces.PartialAirTerminal\">
Buildings.Templates.ZoneEquipment.Interfaces.PartialAirTerminal</a>.
</p>
</html>"));
end PartialAirTerminal;

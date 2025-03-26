within Buildings.Templates.ZoneEquipment.Components.Data;
record PartialController "Record for controller interface class"
  extends Modelica.Icons.Record;

  parameter Buildings.Templates.ZoneEquipment.Types.Controller typ
    "Type of controller"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  annotation (Documentation(info="<html>
<p>
This record provides the set of sizing and operating parameters for the class
<a href=\"modelica://Buildings.Templates.ZoneEquipment.Components.Interfaces.PartialController\">
Buildings.Templates.ZoneEquipment.Components.Controls.Interfaces.PartialController</a>.
</p>
</html>"));
end PartialController;

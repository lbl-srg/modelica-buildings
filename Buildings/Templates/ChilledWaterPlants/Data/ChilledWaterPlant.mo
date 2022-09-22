within Buildings.Templates.ChilledWaterPlants.Data;
record ChilledWaterPlant "Record for chilled water plant model"
  extends Modelica.Icons.Record;

  parameter Buildings.Templates.Components.Types.Chiller typChi
    "Type of chiller"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Buildings.Templates.ChilledWaterPlants.Components.Data.Controller ctr
    "Controller"
    annotation (Dialog(group="Controls"));
end ChilledWaterPlant;

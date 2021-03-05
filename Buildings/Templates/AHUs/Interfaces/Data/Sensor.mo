within Buildings.Templates.AHUs.Interfaces.Data;
record Sensor
  extends Modelica.Icons.Record;
  parameter Types.Branch bra
    "Branch where the equipment is installed"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  outer parameter String id=""
    "System identifier";
  outer parameter ExternData.JSONFile dat
    "External parameter file"
    annotation (Placement(transformation(extent={{76,76},{96,96}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Sensor;

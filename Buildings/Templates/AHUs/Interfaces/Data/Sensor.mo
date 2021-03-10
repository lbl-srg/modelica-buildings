within Buildings.Templates.AHUs.Interfaces.Data;
record Sensor
  extends Modelica.Icons.Record;

  final parameter String braStr=
    if Modelica.Utilities.Strings.find(insNam, "Out")<>0 then "Supply"
    elseif Modelica.Utilities.Strings.find(insNam, "Sup")<>0 then "Supply"
    elseif Modelica.Utilities.Strings.find(insNam, "Mix")<>0 then "Supply"
    elseif Modelica.Utilities.Strings.find(insNam, "Hea")<>0 then "Supply"
    elseif Modelica.Utilities.Strings.find(insNam, "Coo")<>0 then "Supply"
    elseif Modelica.Utilities.Strings.find(insNam, "Ret")<>0 then "Return"
    else "Undefined"
    "String used to identify the sensor location";

  final parameter String insNam = getInstanceName()
    "Instance name";
  outer parameter String id
    "System identifier";
  outer parameter ExternData.JSONFile dat
    "External parameter file"
    annotation (Placement(transformation(extent={{76,76},{96,96}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Sensor;

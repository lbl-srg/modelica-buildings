within Buildings.Templates.AHUs.Interfaces.Data;
record Fan
  extends Modelica.Icons.Record;

  final parameter String braStr=
    if Modelica.Utilities.Strings.find(insNam, "fanSup")<>0 then "Supply"
    elseif Modelica.Utilities.Strings.find(insNam, "fanRet")<>0 then "Return"
    elseif Modelica.Utilities.Strings.find(insNam, "fanRel")<>0 then "Return"
    else "Undefined"
    "Sting used to identify the fan location"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  final parameter String insNam = getInstanceName()
    "Instance name";
  outer parameter String id
    "System identifier";
  outer parameter ExternData.JSONFile dat
    "External parameter file"
    annotation (Placement(transformation(extent={{76,76},{96,96}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Fan;

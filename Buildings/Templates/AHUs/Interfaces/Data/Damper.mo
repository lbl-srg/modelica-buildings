within Buildings.Templates.AHUs.Interfaces.Data;
record Damper
  extends Modelica.Icons.Record;

  final parameter String braStr=
    if Modelica.Utilities.Strings.find(insNam, "damOut")<>0 then "Outdoor air"
    elseif Modelica.Utilities.Strings.find(insNam, "damOutMin")<>0 then "Minimum outdoor air"
    elseif Modelica.Utilities.Strings.find(insNam, "damRel")<>0 then "Relief air"
    elseif Modelica.Utilities.Strings.find(insNam, "damRet")<>0 then "Return air"
    else "Undefined"
    "String used to identify the damper location"
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
end Damper;

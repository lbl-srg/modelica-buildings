within Buildings.Templates.AHUs.Interfaces.Data;
record Coil
  extends Modelica.Icons.Record;

  inner parameter Modelica.SIunits.MassFlowRate mAir_flow_nominal(min=0)=
    dat.getReal(varName=id + "." + funStr + " coil.Air mass flow rate")
    "Air mass flow rate"
    annotation(Dialog(group = "Nominal condition"));
  inner parameter Modelica.SIunits.PressureDifference dpAir_nominal(
    displayUnit="Pa")=
    dat.getReal(varName=id + "." + funStr + " coil.Air pressure drop")
    "Air pressure drop"
    annotation(Dialog(group = "Nominal condition"));

  final inner parameter String funStr=
    if Modelica.Utilities.Strings.find(insNam, "coiCoo")<>0 then "Cooling"
    elseif Modelica.Utilities.Strings.find(insNam, "coiHea")<>0 then "Heating"
    elseif Modelica.Utilities.Strings.find(insNam, "coiReh")<>0 then "Reheat"
    else "Undefined"
    "String used to identify the coil function"
    annotation(Evaluate=true, Dialog(group="Configuration"));
  final parameter String insNam = getInstanceName()
    "Instance name"
    annotation(Evaluate=true);
  outer parameter String id
    "System identifier";
  outer parameter ExternData.JSONFile dat
    "External parameter file"
    annotation (Placement(transformation(extent={{76,76},{96,96}})));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Coil;

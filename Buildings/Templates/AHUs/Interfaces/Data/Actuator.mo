within Buildings.Templates.AHUs.Interfaces.Data;
record Actuator
  extends Modelica.Icons.Record;

  outer parameter Modelica.SIunits.MassFlowRate mWat_flow_nominal(min=0)
    "Liquid mass flow rate"
    annotation(Dialog(group = "Nominal condition"));
  outer parameter Modelica.SIunits.PressureDifference dpWat_nominal(
    displayUnit="Pa")
    "Liquid pressure drop"
    annotation(Dialog(group = "Nominal condition"));

  outer parameter String funStr
    "String used to identify the coil function";
  outer parameter String id
    "System identifier";
  outer parameter ExternData.JSONFile dat
    "External parameter file"
    annotation (Placement(transformation(extent={{76,76},{96,96}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Actuator;

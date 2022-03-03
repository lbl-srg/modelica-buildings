within Buildings.Templates.Components.Dampers.Interfaces;
record Data
  extends Modelica.Icons.Record;

  parameter Buildings.Templates.Components.Types.Damper typ
    "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal(
    final min=0) = 1
    "Air mass flow rate"
    annotation (
      Dialog(group="Schedule.Mechanical",
        enable=typ<>Buildings.Templates.Components.Types.Damper.None));
  parameter Modelica.Units.SI.PressureDifference dp_nominal(
    final min=0,
    displayUnit="Pa")=
    if typ==Buildings.Templates.Components.Types.Damper.None then 0
    elseif typ==Buildings.Templates.Components.Types.Damper.PressureIndependent then 50
    else 15
    "Air pressure drop"
    annotation (
      Dialog(group="Schedule.Mechanical",
        enable=typ<>Buildings.Templates.Components.Types.Damper.None));
end Data;

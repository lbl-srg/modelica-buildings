within Buildings.Templates.Components.Data;
record Damper
  extends Modelica.Icons.Record;

  parameter Buildings.Templates.Components.Types.Damper typ
    "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal(
    final min=0) = 1
    "Air mass flow rate"
    annotation (
      Dialog(group="Mechanical",
        enable=typ<>Buildings.Templates.Components.Types.Damper.None));
  parameter Modelica.Units.SI.PressureDifference dp_nominal(
    final min=0,
    displayUnit="Pa")=
    if typ==Buildings.Templates.Components.Types.Damper.None then 0
    elseif typ==Buildings.Templates.Components.Types.Damper.PressureIndependent then 50
    else 15
    "Air pressure drop"
    annotation (
      Dialog(group="Mechanical",
        enable=typ<>Buildings.Templates.Components.Types.Damper.None));
  parameter Modelica.Units.SI.PressureDifference dpFixed_nominal(
    final min=0,
    displayUnit="Pa")=0
    "Air pressure drop of fixed elements in series with damper"
    annotation (
      Dialog(group="Mechanical", enable=false));
end Damper;

within Buildings.Templates.Components.Data;
record Damper "Record for damper model"
  extends Modelica.Icons.Record;

  parameter Buildings.Templates.Components.Types.Damper typ
    "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal(
    final min=0,
    start=1)
    "Air mass flow rate"
    annotation (
      Dialog(group="Mechanical",
        enable=typ<>Buildings.Templates.Components.Types.Damper.None));
  parameter Modelica.Units.SI.PressureDifference dp_nominal(
    final min=0,
    displayUnit="Pa",
    start=if typ==Buildings.Templates.Components.Types.Damper.None then 0
    elseif typ==Buildings.Templates.Components.Types.Damper.PressureIndependent then 50
    else 15)
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
  annotation (Documentation(info="<html>
<p>
This record provides the set of sizing parameters for
the class
<a href=\"modelica://Buildings.Templates.Components.Actuators.Damper\">
Buildings.Templates.Components.Actuators.Damper</a>.
</p>
</html>"));
end Damper;

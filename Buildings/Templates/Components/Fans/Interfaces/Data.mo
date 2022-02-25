within Buildings.Templates.Components.Fans.Interfaces;
record Data
  extends Modelica.Icons.Record;

  parameter Buildings.Templates.Components.Types.Fan typ
    "Equipment type"
    annotation (Dialog(group="Configuration"));
  parameter Integer nFan(min=0)=1
    "Number of fans"
    annotation (Dialog(group="Configuration",
      enable=typ==Buildings.Templates.Components.Types.Fan.ArrayVariable));
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal(
    final min=0) = 1
    "Air mass flow rate"
    annotation (
      Dialog(group="Nominal condition",
        enable=typ <> Buildings.Templates.Components.Types.Fan.None));
  parameter Modelica.Units.SI.PressureDifference dp_nominal=
    if typ==Buildings.Templates.Components.Types.Fan.None then 0
      else 0.5e3
    "Total pressure rise"
    annotation (
    Dialog(group="Nominal condition",
    enable=typ <> Buildings.Templates.Components.Types.Fan.None));
  replaceable parameter Buildings.Fluid.Movers.Data.Generic per(
    pressure(
      V_flow={0, 1, 2} * m_flow_nominal / 1.2 / max(1, nFan),
      dp={1.5, 1, 0} * dp_nominal))
    constrainedby Buildings.Fluid.Movers.Data.Generic
    "Performance data"
    annotation (
      choicesAllMatching=true,
      Dialog(enable=typ <> Buildings.Templates.Components.Types.Fan.None),
      Placement(transformation(extent={{-90,-88},{-70,-68}})));
end Data;

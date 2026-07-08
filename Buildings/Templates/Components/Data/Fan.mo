within Buildings.Templates.Components.Data;
record Fan "Record for fan model"
  extends Modelica.Icons.Record;

  parameter Buildings.Templates.Components.Types.Fan typ
    "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  parameter Integer nFan(
    final min=0,
    start=if typ==Buildings.Templates.Components.Types.Fan.None then 0 else 1)
    "Number of fans"
    annotation (Evaluate=true, Dialog(group="Configuration",
      enable=typ==Buildings.Templates.Components.Types.Fan.ArrayVariable));
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal(
    final min=0,
    start=1)
    "Total air mass flow rate"
    annotation (
      Dialog(group="Nominal condition",
        enable=typ <> Buildings.Templates.Components.Types.Fan.None));
  parameter Modelica.Units.SI.PressureDifference dp_nominal(
    final min=0,
    displayUnit="Pa",
    start=if typ==Buildings.Templates.Components.Types.Fan.None then 1
      else 500)
    "Total pressure rise"
    annotation (
    Dialog(group="Nominal condition",
      enable=typ <> Buildings.Templates.Components.Types.Fan.None));
  // HACK: The following parameter declaration and corresponding binding with
  // per.pressure.V_flow is a workaround against a false positive model
  // check error with Dymola 2026.x.
  final parameter Modelica.Units.SI.VolumeFlowRate VPer_flow[:] =
    {0, 1, 2} * m_flow_nominal / 1.2 / max(1, nFan)
    "Volume flow rate support points for performance curve";
  replaceable parameter Buildings.Fluid.Movers.Data.Generic per(
    pressure(
      V_flow=VPer_flow,
      dp={1.5, 1, 0} * dp_nominal))
    constrainedby Buildings.Fluid.Movers.Data.Generic
    "Performance data"
    annotation (
      choicesAllMatching=true,
      Dialog(enable=typ <> Buildings.Templates.Components.Types.Fan.None),
      Placement(transformation(extent={{-90,-88},{-70,-68}})));
  annotation (
  defaultComponentPrefixes = "parameter",
  defaultComponentName="datFan",
  Documentation(info="<html>
<p>
This record provides the set of sizing parameters for
the classes within
<a href=\"modelica://Buildings.Templates.Components.Fans\">
Buildings.Templates.Components.Fans</a>.
</p>
</html>"));
end Fan;

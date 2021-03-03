within Buildings.Experimental.Templates.AHUs.Coils.HeatExchangers.Data;
record None
  extends Modelica.Icons.Record;

  /* Tentative to include the following...
  Would need final binding in Coils.Data.CoolingWater.
  */
  /*
  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal(min=0)
    "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal(min=0)
    "Nominal mass flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dp1_nominal(
    displayUnit="Pa")
    "Nominal pressure drop"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dp2_nominal(
    displayUnit="Pa")
    "Nominal pressure drop"
    annotation(Dialog(group = "Nominal condition"));
  */

  annotation (
    defaultComponentName="datHex",
    defaultComponentPrefixes="outer parameter",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end None;

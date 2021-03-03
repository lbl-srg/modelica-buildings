within Buildings.Experimental.Templates.AHUs.Coils.HeatExchangers.Data;
record Discretized
  extends None;

  parameter Modelica.SIunits.ThermalConductance UA_nominal(min=0)
    "Thermal conductance at nominal flow, used to compute heat capacity"
    annotation (Dialog(tab="General", group="Nominal condition"));
  parameter Real r_nominal=2/3
    "Ratio between air-side and water-side convective heat transfer coefficient"
    annotation (Dialog(group="Nominal condition"));
  parameter Integer nEle(min=1) = 5
    "Number of pipe segments used for discretization"
    annotation (Dialog(group="Geometry"));

  annotation (
    defaultComponentName="datHex",
    defaultComponentPrefixes="outer parameter",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end Discretized;

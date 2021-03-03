within Buildings.Experimental.Templates.AHUs.Coils.HeatExchangers.Data;
record EffectivenessNTU
  extends None;

  // FIXME: Dummy default values fo testing purposes only.
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal(min=0)=1e4
    "Nominal heat flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Temperature T_a1_nominal=7+273.15
    "Nominal inlet temperature"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Temperature T_a2_nominal=30+273.15
    "Nominal inlet temperature"
    annotation(Dialog(group = "Nominal condition"));
  parameter Buildings.Fluid.Types.HeatExchangerConfiguration configuration=
    Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow
    "Heat exchanger configuration"
    annotation (Evaluate=true);

  annotation (
    defaultComponentName="datHex",
    defaultComponentPrefixes="outer parameter",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end EffectivenessNTU;

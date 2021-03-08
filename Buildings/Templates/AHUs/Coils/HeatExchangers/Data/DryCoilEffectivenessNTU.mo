within Buildings.Templates.AHUs.Coils.HeatExchangers.Data;
record DryCoilEffectivenessNTU
  extends Interfaces.Data.HeatExchangerWater;

  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal(min=0)=
    dat.getReal(varName=id + "." + funStr + " coil.Capacity")
    "Nominal heat flow rate"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Temperature T_a1_nominal=
    dat.getReal(varName=id + "." + funStr + " coil.Entering liquid temperature")
    "Nominal inlet temperature"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Temperature T_a2_nominal=
    dat.getReal(varName=id + "." + funStr + " coil.Entering air temperature")
    "Nominal inlet temperature"
    annotation(Dialog(group = "Nominal condition"));
  parameter Buildings.Fluid.Types.HeatExchangerConfiguration configuration=
    Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow
    "Heat exchanger configuration"
    annotation (Evaluate=true);

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end DryCoilEffectivenessNTU;

within Buildings.Fluid.HeatExchangers;
model SteamHeatExchangerEffectivenessNTU
  "Steam heat exchanger with effectiveness - NTU relation"
  extends Buildings.Fluid.Interfaces.PartialFourPortFourMediumCounter;

  parameter con configuration "Heat exchanger configuration"
    annotation (Evaluate=true);

  parameter Boolean use_Q_flow_nominal = true
    "Set to true to specify Q_flow_nominal and temperatures, or to false to specify effectiveness"
    annotation (Evaluate=true,
                Dialog(group="Nominal thermal performance"));

  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal(fixed=use_Q_flow_nominal)
    "Nominal heat transfer"
    annotation (Dialog(group="Nominal thermal performance",
                       enable=use_Q_flow_nominal));
  parameter Modelica.SIunits.Temperature T_a1_nominal(fixed=use_Q_flow_nominal)
    "Nominal temperature at port a1"
    annotation (Dialog(group="Nominal thermal performance",
                       enable=use_Q_flow_nominal));
  parameter Modelica.SIunits.Temperature T_a2_nominal(fixed=use_Q_flow_nominal)
    "Nominal temperature at port a2"
    annotation (Dialog(group="Nominal thermal performance",
                       enable=use_Q_flow_nominal));

  parameter Real eps_nominal(fixed=not use_Q_flow_nominal)
    "Nominal heat transfer effectiveness"
    annotation (Dialog(group="Nominal thermal performance",
                       enable=not use_Q_flow_nominal));

  input Modelica.SIunits.ThermalConductance UA "UA value";

  Real eps(min=0, max=1) "Heat exchanger effectiveness";

  // NTU has been removed as NTU goes to infinity as CMin goes to zero.
  // This quantity is not good for modeling.
  //  Real NTU(min=0) "Number of transfer units";
  final parameter Modelica.SIunits.ThermalConductance UA_nominal(fixed=false)
    "Nominal UA value";
  final parameter Real NTU_nominal(min=0, fixed=false)
    "Nominal number of transfer units";

//protected

initial equation


equation



  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
    preferredView="info",
defaultComponentName="hex",
    Documentation(info="<html>
</html>", revisions="<html>
<ul>
<li>
[date], by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
end SteamHeatExchangerEffectivenessNTU;

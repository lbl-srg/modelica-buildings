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
<p>
Model of a plate heat exchanger without humidity condensation.
This model transfers heat in the amount of
</p>
<p align=\"center\" style=\"font-style:italic;\">
  Q&#775; = Q&#775;<sub>max</sub>  &epsilon;<br/>
  &epsilon; = f(NTU, Z, flowRegime),
</p>
<p>
where
<i>Q&#775;<sub>max</sub></i> is the maximum heat that can be transferred,
<i>&epsilon;</i> is the heat transfer effectiveness,
<i>NTU</i> is the Number of Transfer Units,
<i>Z</i> is the ratio of minimum to maximum capacity flow rate and
<i>flowRegime</i> is the heat exchanger flow regime.
such as
parallel flow, cross flow or counter flow.
</p>
<p>
The flow regimes depend on the heat exchanger configuration. All configurations
defined in
<a href=\"modelica://Buildings.Fluid.Types.HeatExchangerConfiguration\">
Buildings.Fluid.Types.HeatExchangerConfiguration</a>
are supported.
</p>
<p>
The convective heat transfer coefficients scale proportional to
<i>(m&#775;/m&#775;<sub>0</sub>)<sup>n</sup></i>, where
<i>m&#775;</i> is the mass flow rate,
<i>m&#775;<sub>0</sub></i> is the nominal mass flow rate, and
<i>n=0.8</i> for both streams.
</p>
<p>
For a plate exchanger, use
<a href=\"modelica://Buildings.Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU\">
Buildings.Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU</a>.
</p>
<p>
For a heat and moisture exchanger, use
<a href=\"modelica://Buildings.Fluid.MassExchangers.ConstantEffectiveness\">
Buildings.Fluid.MassExchangers.ConstantEffectiveness</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
[date], by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
end SteamHeatExchangerEffectivenessNTU;

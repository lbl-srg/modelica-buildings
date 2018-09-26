within Buildings.Fluid.HeatExchangers;
model DryCoilEffectivenessNTU
  "Heat exchanger with effectiveness - NTU relation and no moisture condensation"
  extends Buildings.Fluid.HeatExchangers.BaseClasses.PartialEffectivenessNTU(
    UA = 1/(1/hA.hA_1 + 1/hA.hA_2));

  parameter Real r_nominal(
    min=0,
    max=1) = 2/3
    "Ratio between air-side and water-side convective heat transfer (hA-value) at nominal condition";

  Buildings.Fluid.HeatExchangers.BaseClasses.HADryCoil hA(
    final r_nominal=r_nominal,
    final UA_nominal=UA_nominal,
    final m_flow_nominal_w=m1_flow_nominal,
    final m_flow_nominal_a=m2_flow_nominal,
    waterSideTemperatureDependent=false,
    airSideTemperatureDependent=false)
    "Model for convective heat transfer coefficient";

equation
  // Convective heat transfer coefficient
  hA.m1_flow = m1_flow;
  hA.m2_flow = m2_flow;
  hA.T_1 = T_in1;
  hA.T_2 = T_in2;

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={Rectangle(
          extent={{-70,78},{70,-82}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid)}),
    preferredView="info",
defaultComponentName="hex",
    Documentation(info="<html>
<p>
Model of a coil without humidity condensation.
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
<i>n=0.8</i> on the air-side and <i>n=0.85</i> on the water side.
</p>
<p>
For a plate exchanger, use
<a href=\"modelica://Buildings.Fluid.MassExchangers.PlateHeatExchangerEffectivenessNTU\">
Buildings.Fluid.MassExchangers.PlateHeatExchangerEffectivenessNTU</a>.
</p>
<p>
For a heat and moisture exchanger, use
<a href=\"modelica://Buildings.Fluid.MassExchangers.ConstantEffectiveness\">
Buildings.Fluid.MassExchangers.ConstantEffectiveness</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 25, 2018, by Michael Wetter:<br/>
Refactored model to use a common base class with
<a href=\"modelica://Buildings.Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU\">
Buildings.Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU</a>.
</li>
</ul>
</html>"));
end DryCoilEffectivenessNTU;

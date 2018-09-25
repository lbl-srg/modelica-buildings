within Buildings.Fluid.HeatExchangers;
model PlateHeatExchangerEffectivenessNTU
  "Plate heat exchanger with effectiveness - NTU relation and no moisture condensation"
  extends Buildings.Fluid.HeatExchangers.BaseClasses.PartialEffectivenessNTU(
    UA = 1/(1/hA1 + 1/hA2));

protected
  parameter Modelica.SIunits.ThermalConductance hA1_nominal(min=0)=2*UA_nominal
    "Nominal convective heat transfer coefficient for medium 1";
  parameter Modelica.SIunits.ThermalConductance hA2_nominal(min=0)=2*UA_nominal
    "Nominal convective heat transfer coefficient for medium 2";

  parameter Real n1(min=0, max=1)=0.85
    "Exponent for convective heat transfer coefficient, h1~m1_flow^n1";
  parameter Real n2(min=0, max=1)=0.85
   "Exponent for convective heat transfer coefficient, h2~m2_flow^n2";

equation
  // Convective heat transfer coefficients
 hA1 = hA1_nominal * Buildings.Utilities.Math.Functions.regNonZeroPower(
   x = m1_flow/m1_flow_nominal,
   n = n1,
   delta = 0.1);
 hA2 = hA2_nominal * Buildings.Utilities.Math.Functions.regNonZeroPower(
   x = m2_flow/m2_flow_nominal,
   n = n2,
   delta = 0.1);
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
Model of a plate heat exchanger without humidity condensation.
This model transfers heat in the amount of
</p>
<p align=\"center\" style=\"font-style:italic;\">
  Q = Q<sub>max</sub>  &epsilon;<br/>
  &epsilon; = f(NTU, Z, flowRegime),
</p>
<p>
where
<i>Q<sub>max</sub></i> is the maximum heat that can be transferred,
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
First implementation.
</li>
</ul>
</html>"));
end PlateHeatExchangerEffectivenessNTU;

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

  parameter Real n1(min=0, max=1)=0.8
    "Exponent for convective heat transfer coefficient, h1~m1_flow^n1";
  parameter Real n2(min=0, max=1)=0.8
   "Exponent for convective heat transfer coefficient, h2~m2_flow^n2";

  Modelica.SIunits.ThermalConductance hA1
    "Convective heat transfer coefficient for medium 1";
  Modelica.SIunits.ThermalConductance hA2
    "Convective heat transfer coefficient for medium 2";

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
            100}}), graphics={
        Rectangle(
          extent={{-62,60},{-50,-58}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-50,60},{-34,-58}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-22,60},{-6,-58}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-34,60},{-22,-58}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{6,60},{22,-58}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-6,60},{6,-58}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{34,60},{50,-58}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          extent={{22,60},{34,-58}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{50,60},{62,-58}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None)}),
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

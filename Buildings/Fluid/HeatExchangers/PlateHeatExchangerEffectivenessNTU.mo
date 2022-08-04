within Buildings.Fluid.HeatExchangers;
model PlateHeatExchangerEffectivenessNTU
  "Plate heat exchanger with effectiveness - NTU relation and no moisture condensation"
  extends Buildings.Fluid.HeatExchangers.BaseClasses.PartialEffectivenessNTU(
    UA = 1/(1/hA1 + 1/hA2));

  parameter Real r_nominal(min=0)=
      (k1_default * (m1_flow_nominal/eta1_default)^n1 * Pr1_default^(1/3)) /
      (k2_default * (m2_flow_nominal/eta2_default)^n2 * Pr2_default^(1/3))
    "Ratio between convective heat transfer coefficients at nominal conditions, r_nominal = hA1_nominal/hA2_nominal"
    annotation(Dialog(tab="Advanced", group="Heat transfer coefficients"));

  parameter Real n1(min=0, max=1)=0.8
    "Exponent for convective heat transfer coefficient, h1~m1_flow^n1"
    annotation(Dialog(tab="Advanced", group="Heat transfer coefficients"));
  parameter Real n2(min=0, max=1)=n1
   "Exponent for convective heat transfer coefficient, h2~m2_flow^n2"
   annotation(Dialog(tab="Advanced", group="Heat transfer coefficients"));

  // The convection coefficients must be final as they must be consistent with UA_nominal
  final parameter Modelica.Units.SI.ThermalConductance hA1_nominal(min=0) = (1+r_nominal)*UA_nominal
    "Nominal convective heat transfer coefficient for medium 1";
  final parameter Modelica.Units.SI.ThermalConductance hA2_nominal(min=0) = hA1_nominal/r_nominal
    "Nominal convective heat transfer coefficient for medium 2";

  Modelica.Units.SI.ThermalConductance hA1
    "Convective heat transfer coefficient for medium 1";
  Modelica.Units.SI.ThermalConductance hA2
    "Convective heat transfer coefficient for medium 2";

  final parameter Medium1.DynamicViscosity eta1_default = Medium1.dynamicViscosity(sta1_default) "Dynamic viscosity";
  final parameter Medium1.ThermalConductivity k1_default = Medium1.thermalConductivity(sta1_default) "Thermal conductivity";
  final parameter Medium1.PrandtlNumber Pr1_default = Medium1.prandtlNumber(sta1_default) "Prandtl number";
  final parameter Medium2.DynamicViscosity eta2_default = Medium2.dynamicViscosity(sta2_default) "Dynamic viscosity";
  final parameter Medium2.ThermalConductivity k2_default = Medium2.thermalConductivity(sta2_default) "Thermal conductivity";
  final parameter Medium2.PrandtlNumber Pr2_default = Medium2.prandtlNumber(sta2_default) "Prandtl number";

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
<h4>Convective heat transfer coefficients</h4>
<p>
The convective heat transfer coefficients scale proportional to
<i>(m&#775;/m&#775;<sub>0</sub>)<sup>n</sup></i>, where
<i>m&#775;</i> is the mass flow rate and
<i>m&#775;<sub>0</sub></i> is the nominal mass flow rate.
By default, the exponents are
<i>n=0.8</i> for both streams.
The convective heat transfer coefficients are computed based on the UA-value, neglecting
the thermal conductance of the heat exchanger material.
The ratio of the convection coefficients at design conditions can be
adjusted using the parameter <i>r<sub>0</sub>=(hA)<sub>0,1</sub> &frasl; (hA)<sub>0,2</sub></i>
where
<i>(hA)<sub>0,1</sub></i> and
<i>(hA)<sub>0,2</sub></i> are the respective products of the heat transfer coefficient times surface area.
By default, the ratio <i>r<sub>0</sub></i> is computed based on the similarity law for
turbulent flow, which states that the convective heat transfer coefficient <i>h</i> follows the proportionality law
<p align=\"center\" style=\"font-style:italic;\">
  h &prop; k (&rho; v x / &eta;)<sup>n1</sup> Pr<sup>1/3</sup>,
</p>
<p>
where <i>k</i> is the heat conductivity of the fluid,
<i>&rho;</i> is the density,
<i>v</i> is the flow velocity,
<i>x</i> is the characteristic length,
<i>&eta;</i> is the dynamic viscosity and
<i>Pr</i> is the Prandtl number.
Under the assumption that both sides of the heat exchanger are identical,
and considering that the velocity is proportional to the mass flow rate divided by the density,
the ratio <i>r<sub>0</sub></i> is
<p align=\"center\" style=\"font-style:italic;\">
r<sub>0</sub> = (k<sub>1</sub> (m&#775;<sub>0,1</sub> / &eta;<sub>0,1</sub>)<sup>n1</sup> Pr<sub>0,1</sub><sup>1/3</sup>) &frasl;
  (k<sub>2</sub> (m&#775;<sub>0,2</sub> / &eta;<sub>0,2</sub>)<sup>n2</sup> Pr<sub>0,2</sub><sup>1/3</sup>).
</p>
<p>
This is the default setting for the parameter <code>r_nominal</code>.
Thus, if both sides of the heat exchanger have the same temperature difference, and the same medium, then
<i>r<sub>0</sub>=1</i>. However, if medium 1 is air and medium 2 is water, and the heat exchanger is designed
to have the same temperature drop for both media, then  <i>r<sub>0</sub>=0.5</i>.
</p>
<h4>Related model</h4>
<p>
For a heat and moisture exchanger, use
<a href=\"modelica://Buildings.Fluid.MassExchangers.ConstantEffectiveness\">
Buildings.Fluid.MassExchangers.ConstantEffectiveness</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 15, 2022, by Michael Wetter:<br/>
Introduced parameter <code>r_nominal</code> and exposed exponents of convective heat transfer coefficients.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2918\">issue 2918</a>.
</li>
<li>
September 25, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PlateHeatExchangerEffectivenessNTU;

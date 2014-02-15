within Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses;
function convectionResistance
  "Thermal resistance between the fluid and the tube"

  // Geometry of the borehole
  input Modelica.SIunits.Height hSeg "Height of the element";
  input Modelica.SIunits.Radius rTub "Tube radius";

  // Thermal properties
  input Modelica.SIunits.ThermalConductivity kMed
    "Thermal conductivity of the fluid";
  input Modelica.SIunits.DynamicViscosity mueMed
    "Dynamic viscosity of the fluid";
  input Modelica.SIunits.SpecificHeatCapacity cpMed
    "Specific heat capacity of the fluid";
  // Mass flow rates
  input Modelica.SIunits.MassFlowRate m_flow "Mass flow rate";
  input Modelica.SIunits.MassFlowRate m_flow_nominal "Nominal mass flow rate";

  // Outputs
  output Modelica.SIunits.ThermalResistance R
    "Thermal resistance between the fluid and the tube";

protected
  Modelica.SIunits.CoefficientOfHeatTransfer h
    "Convective heat transfer coefficient of the fluid";

  Real k(unit="s/kg")
    "Coefficient used in the computation of the convective heat transfer coefficient";

algorithm
  // ********** Convection resistance **********
  // Dittus-Boelter: h = 0.023*k_f*Re*Pr/(2*rTub)
  // Re = rho*v*DTub / mue_f = m_flow/(pi r^2) * DTub/mue_f = 2*m_flow / ( mue*pi*rTub)
  k := 2/(mueMed*Modelica.Constants.pi*rTub);

  // Convection
  h := 0.023*kMed*(cpMed*mueMed/kMed)^(0.35)/(2*rTub)*
         Buildings.Utilities.Math.Functions.regNonZeroPower(
           x=m_flow*k,
           n=0.8,
           delta=0.01*m_flow_nominal*k);
  R := 1/(2*Modelica.Constants.pi*rTub*hSeg*h);

  annotation (Diagram(graphics), Documentation(info="<html>
<p>
This model computes the convection resistance in the pipes of a borehole segment 
with heigth <i>h<sub>Seg</sub></i>.
</p>
<p>
The correlation of Dittus-Boelter is used to find the convection heat transfer coefficient as
</p>
<p align=\"center\" style=\"font-style:italic;\">
  Nu = 0.023 &nbsp; Re<sup>0.8</sup> &nbsp; Pr<sup>n</sup>,
</p>
<p>
where <i>Nu</i> is the Nusselt number, 
<i>Re</i> is the Reynolds number and 
<i>Pr</i> is the Prandlt number.
We selected <i>n=0.35</i>, as the reference uses <i>n=0.4</i> for heating and 
<i>n=0.3</i> for cooling.
Dittus-Boelter&apos;s correlation is valid for turbulent flow in cylindrical smooth pipe.
</p>
<!-- fixme: Dittus-Boelter requires a reference -->
</html>", revisions="<html>
<p>
<ul>
<li>
February 14, 2014, by Michael Wetter:<br/>
Removed unused input <code>rBor</code>.
Revised documentation.
</li>
<li>
January 24, 2014, by Michael Wetter:<br/>
Revised implementation. 
Changed <code>cpFluid</code> to <code>cpMed</code> to use consistent notation.
Added regularization for computation of convective heat transfer coefficient to
avoid an event and a non-differentiability.
</li>
<li>
January 23, 2014, by Damien Picard:<br/>
First implementation.
</li>
</ul>
</p>
</html>"));
end convectionResistance;

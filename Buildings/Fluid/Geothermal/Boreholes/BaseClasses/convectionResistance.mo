within Buildings.Fluid.Geothermal.Boreholes.BaseClasses;
function convectionResistance
  "Thermal resistance between the fluid and the tube"

  // Geometry of the borehole
  input Modelica.Units.SI.Height hSeg "Height of the element";
  input Modelica.Units.SI.Radius rTub "Tube radius";

  // Thermal properties
  input Modelica.Units.SI.ThermalConductivity kMed
    "Thermal conductivity of the fluid";
  input Modelica.Units.SI.DynamicViscosity mueMed
    "Dynamic viscosity of the fluid";
  input Modelica.Units.SI.SpecificHeatCapacity cpMed
    "Specific heat capacity of the fluid";
  // Mass flow rates
  input Modelica.Units.SI.MassFlowRate m_flow "Mass flow rate";
  input Modelica.Units.SI.MassFlowRate m_flow_nominal "Nominal mass flow rate";

  // Outputs
  output Modelica.Units.SI.ThermalResistance R
    "Thermal resistance between the fluid and the tube";

protected
  Modelica.Units.SI.CoefficientOfHeatTransfer h
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

  annotation ( Documentation(info="<html>
<p>
This model computes the convection resistance in the pipes of a borehole segment
with heigth <i>h<sub>Seg</sub></i>.
</p>
<p>
The correlation of Dittus-Boelter (1930) is used to find the convection heat transfer coefficient as
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
+<h4>References</h4>
<p>
Dittus P.W. and L.M.K Boelter, (1930).
<a href=\"http://dx.doi.org/10.1016/0735-1933(85)90003-X\">
Heat transfer in automobile radiators
of the tubular type</a>.
<i>Univ Calif Pub Eng</i>, 2(13):443-461.
(Reprinted in Int. J. Comm. Heat Mass Transf. 12 (1985), 3:22).
DOI:10.1016/0735-1933(85)90003-X.
</p>
</html>", revisions="<html>
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
</html>"));
end convectionResistance;

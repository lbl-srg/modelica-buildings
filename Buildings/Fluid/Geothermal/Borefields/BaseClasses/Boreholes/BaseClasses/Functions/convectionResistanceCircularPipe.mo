within Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions;
function convectionResistanceCircularPipe
  "Thermal resistance from the fluid in pipes and the grout zones (Bauer et al. 2011)"
  extends Modelica.Icons.Function;

  // Geometry of the borehole
  input Modelica.Units.SI.Height hSeg "Height of the element";
  input Modelica.Units.SI.Radius rTub "Tube radius";
  input Modelica.Units.SI.Length eTub "Tube thickness";
  // thermal properties
  input Modelica.Units.SI.ThermalConductivity kMed
    "Thermal conductivity of the fluid";
  input Modelica.Units.SI.DynamicViscosity muMed
    "Dynamic viscosity of the fluid";
  input Modelica.Units.SI.SpecificHeatCapacity cpMed
    "Specific heat capacity of the fluid";
  input Modelica.Units.SI.MassFlowRate m_flow "Mass flow rate";
  input Modelica.Units.SI.MassFlowRate m_flow_nominal "Nominal mass flow rate";

  // Outputs
  output Modelica.Units.SI.ThermalResistance RFluPip
    "Convection resistance (or conduction in fluid if no mass flow)";

protected
  Modelica.Units.SI.Radius rTub_in=rTub - eTub "Pipe inner radius";
  Modelica.Units.SI.CoefficientOfHeatTransfer h
    "Convective heat transfer coefficient of the fluid";

  Real k(unit="s/kg")
    "Coefficient used in the computation of the convective heat transfer coefficient";
  Modelica.Units.SI.MassFlowRate m_flow_abs=
      Buildings.Utilities.Math.Functions.spliceFunction(
      m_flow,
      -m_flow,
      m_flow,
      m_flow_nominal/30);
  Real Re "Reynolds number";
  Real NuTurb "Nusselt at Re=2400";
  Real Nu "Nusselt";

algorithm
  // Convection resistance and Reynolds number
  k := 2/(muMed*Modelica.Constants.pi*rTub_in);
  Re := m_flow_abs*k;

  if Re>=2400 then
    // Turbulent, fully-developped flow in a smooth circular pipe with the
    // Dittus-Boelter correlation: h = 0.023*k_f*Re*Pr/(2*rTub)
    // Re = rho*v*DTub / mue_f
    //    = m_flow/(pi r^2) * DTub/mue_f = 2*m_flow / ( mue*pi*rTub)
    Nu := 0.023*(cpMed*muMed/kMed)^(0.35)*
      Buildings.Utilities.Math.Functions.regNonZeroPower(
        x=Re,
        n=0.8,
        delta=0.01*m_flow_nominal*k);
  else
    // Laminar, fully-developped flow in a smooth circular pipe with uniform
    // imposed temperature: Nu=3.66 for Re<=2300. For 2300<Re<2400, a smooth
    // transition is created with the splice function.
    NuTurb := 0.023*(cpMed*muMed/kMed)^(0.35)*(2400)^(0.8);
    Nu := Buildings.Utilities.Math.Functions.spliceFunction(NuTurb,3.66,Re-(2300+2400)/2,((2300+2400)/2)-2300);
  end if;
  h := Nu*kMed/(2*rTub_in);

  RFluPip := 1/(2*Modelica.Constants.pi*rTub_in*hSeg*h);

  annotation (Documentation(info="<html>
<p>
This model computes the convection resistance in the pipes of a borehole segment
with heigth <i>h<sub>Seg</sub></i> using correlations suggested by Bergman et al. (2011).
</p>
<p>
If the flow is laminar (<i>Re &le; 2300</i>, with <i>Re</i> being the Reynolds number of the flow),
the Nusselt number of the flow is assumed to be constant at 3.66. If the flow is turbulent (<i>Re &gt; 2300</i>),
the correlation of Dittus-Boelter is used to find the convection heat transfer coefficient as
</p>
<p align=\"center\" style=\"font-style:italic;\">
  Nu = 0.023 &nbsp; Re<sup>0.8</sup> &nbsp; Pr<sup>n</sup>,
</p>
<p>
where <i>Nu</i> is the Nusselt number and
<i>Pr</i> is the Prandlt number.
A value of <i>n=0.35</i> is used, as the reference uses <i>n=0.4</i> for heating and
<i>n=0.3</i> for cooling. To ensure that the function is continuously differentiable,
a smooth transition between the laminar and turbulent values is created for the
range <i>2300 &lt; Re &lt; 2400</i>.
</p>
<h4>References</h4>
<p>
Bergman, T. L., Incropera, F. P., DeWitt, D. P., &amp; Lavine, A. S. (2011). <i>Fundamentals of heat and mass
transfer</i> (7th ed.). New York: John Wiley &amp; Sons.
</p>
</html>", revisions="<html>
<ul>
<li>
June 4, 2023, by Michael Wetter:<br/>
Corrected variability.<br/>
This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1762\">IBPSA, #1762</a>.
</li>
<li>
July 10, 2018, by Alex Laferri&egrave;re:<br/>
Added laminar flow and smooth laminar-turbulent transition.
Revised documentation.
</li>
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
end convectionResistanceCircularPipe;

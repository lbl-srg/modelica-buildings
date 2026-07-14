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
  Real f "Darcy-Weisbach friction factor from Churchill (1977)";
  Real NuTurb "Nusselt at Re=4000";
  Real Nu "Nusselt";

  // Pipe roughness for Churchill friction factor.
  // eps = 0.001e-3 m is the default absolute roughness for smooth HDPE pipe.
  Real eps(unit="m") = 0.001e-3
    "Absolute pipe wall roughness (0.001 mm, smooth HDPE default)";
  Real eps_D = eps / (2*rTub_in)
    "Relative pipe roughness epsilon/D";

algorithm
  // Convection resistance and Reynolds number
  k := 2/(muMed*Modelica.Constants.pi*rTub_in);
  Re := m_flow_abs*k;

  if Re>=4000 then
    // Turbulent, fully-developped flow in a smooth circular pipe with the
    // Gnielinski (1975) correlation:
    //   Nu = (f/8)*(Re-1000)*Pr / (1 + 12.7*sqrt(f/8)*(Pr^(2/3)-1))
    // Friction factor from Churchill (1977): explicit, C-infinity smooth,
    // valid for all flow regimes.
    f  := Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.churchillFrictionFactor(
            Re=Re, eps_D=eps_D);
    Nu := (f/8)*(Re - 1000)*(cpMed*muMed/kMed) /
            (1 + 12.7*sqrt(f/8)*((cpMed*muMed/kMed)^(2/3) - 1));
  else
    // Laminar, fully-developped flow in a smooth circular pipe with uniform
    // imposed temperature: Nu=3.66 for Re<=2300. For 2300<Re<4000, a smooth
    // transition is created with the splice function.
    f      := Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.churchillFrictionFactor(
                Re=4000, eps_D=eps_D);
    NuTurb := (f/8)*(4000 - 1000)*(cpMed*muMed/kMed) /
                (1 + 12.7*sqrt(f/8)*((cpMed*muMed/kMed)^(2/3) - 1));
    Nu := Buildings.Utilities.Math.Functions.spliceFunction(NuTurb,3.66,Re-(2300+4000)/2,((2300+4000)/2)-2300);
  end if;
  h := Nu*kMed/(2*rTub_in);

  RFluPip := 1/(2*Modelica.Constants.pi*rTub_in*hSeg*h);

  annotation (Documentation(info="<html>
<p>
This model computes the convection resistance in the pipes of a borehole segment
with heigth <i>h<sub>Seg</sub></i>.
</p>
<p>
If the flow is laminar (<i>Re &le; 2300</i>, with <i>Re</i> being the Reynolds number of the flow),
the Nusselt number of the flow is assumed to be constant at 3.66. If the flow is turbulent (<i>Re &gt; 2300</i>),
the correlation of Gnielinski (1975) is used to find the convection heat transfer coefficient as
</p>
<p align=\"center\" style=\"font-style:italic;\">
  Nu = (f/8) (Re &minus; 1000) Pr / (1 + 12.7 &radic;(f/8) (Pr<sup>2/3</sup> &minus; 1))
</p>
<p>
where the Darcy-Weisbach friction factor <i>f</i> is computed with the explicit,
C&infin;-smooth Churchill (1977) correlation, valid for all flow regimes without
regime switching. For the transition region
2300 &lt; <i>Re</i> &lt; 4000, a smooth C<sup>1</sup>-continuous splice
interpolation is applied between the laminar value (Nu = 3.66) and the turbulent
value evaluated at Re = 4000.
</p>
<p>
Pipe roughness is set to &epsilon; = 0.001 mm (smooth HDPE default). The
relative roughness &epsilon;/<i>D</i> is computed internally from the tube
geometry. 
</p>
<h4>References</h4>
<p>
Churchill, S. W. (1977). Friction-factor equation spans all fluid-flow regimes.
<i>Chemical Engineering</i>, 84(24), 91&ndash;92.
</p>
<p>
Gnielinski, V. (1975). Neue Gleichungen f&uuml;r den W&auml;rme- und den
Stoff&uuml;bergang in turbulent durchstr&ouml;mten Rohren und Kan&auml;len.
<i>Forschung im Ingenieurwesen</i>, 41(1), 8&ndash;16.
<a href=\"https://doi.org/10.1007/BF02559682\">doi:10.1007/BF02559682</a>
</p>
<p>
Gnielinski, V. (2013). On heat transfer in tubes.
<i>International Journal of Heat and Mass Transfer</i>, 63, 134&ndash;140.
<a href=\"https://doi.org/10.1016/j.ijheatmasstransfer.2013.04.015\">doi:10.1016/j.ijheatmasstransfer.2013.04.015</a>
</p>
</html>", revisions="<html>
<ul>
<li>
July 14, 2026,by L. Meertens:<br/>
Replaced Dittus-Boelter correlation with Gnielinski (1975).
including Churchill (1977) friction factor.
Extended turbulent transition region from Re=2400 to Re=4000.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4655\">Buildings, #4655</a>.
</li>
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

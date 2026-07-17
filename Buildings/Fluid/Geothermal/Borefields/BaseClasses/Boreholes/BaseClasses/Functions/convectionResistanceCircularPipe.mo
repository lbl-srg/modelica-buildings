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
  // eps = 0.001e-3 m is the default absolute roughness for smooth HDPE pipe.
  input Modelica.Units.SI.Length roughness = 0.001e-3
    "Absolute pipe wall roughness";


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
  Real Pr "Prandtl number";
  Real f "Darcy-Weisbach friction factor from Churchill (1977)";
  Real Nu "Nusselt";

  // Pipe roughness for Churchill friction factor.
  Real eps_D = roughness / (2*rTub_in)
    "Relative pipe roughness epsilon/D";

  // Quintic Hermite anchor scalars 
  Real NuTurb
    "Gnielinski Nu at Re = Re_turb (upper anchor of quintic Hermite)";
  Real NuTurb_fdp
    "Gnielinski Nu at Re = Re_turb + h_fd (finite-difference point)";
  Real NuTurb_fdm
    "Gnielinski Nu at Re = Re_turb - h_fd (finite-difference point)";
  Real dNuTurb_scaled
    "dNu/dRe at Re = Re_turb, rescaled by transition width L_trans";
  Real d2NuTurb_scaled
    "d2Nu/dRe2 at Re = Re_turb, rescaled by L_trans^2";
  
  // Hermite parameter and basis-function helpers
  Real t "Hermite parameter in [0,1] mapping Re_lam -> Re_turb";

  // Finite-difference step for Gnielinski derivatives at Re = 4000
  constant Real h_fd = 0.5 "Finite-difference step (Re units)";
  constant Real Re_lam   = 2300 "Upper Reynolds number of laminar regime";
  constant Real Re_turb  = 4000 "Lower Reynolds number of turbulent regime";
  constant Real L_trans  = 1700 "Transition width = Re_turb - Re_lam";

algorithm
  // Convection resistance and Reynolds number
  k := 2/(muMed*Modelica.Constants.pi*rTub_in);
  Re := m_flow_abs*k;
  Pr := cpMed*muMed/kMed;

  if Re>=4000 then
    // ------------------------------------------------------------------
    // Turbulent — fully-developed flow.
    // Gnielinski (1975) correlation with Churchill (1977) friction factor.
    // ------------------------------------------------------------------
    f  := .Buildings.Fluid.FixedResistances.Functions.churchillFrictionFactor(
            Re=Re, eps_D=eps_D);
    Nu := (f/8)*(Re - 1000)*Pr /
            (1 + 12.7*sqrt(f/8)*(Pr^(2/3) - 1));
  else
    // ------------------------------------------------------------------
    // Laminar (Re <= Re_lam): Nu = 3.66.
    // Transition (Re_lam < Re < Re_turb): C2-continuous quintic Hermite.
    //
    // Matches at Re_lam: value = 3.66, slope = 0, curvature = 0
    // Matches at Re_turb: value, slope and curvature from Gnielinski
    //
    // Active basis functions (H01, H02 drop out since Nu'(0)=Nu''(0)=0):
    //   Nu(t) = 3.66*H00(t) + NuTurb*H10(t)
    //         + dNuTurb_scaled*H11(t) + d2NuTurb_scaled*H12(t)
    //   H00 = 1 - 10t^3 + 15t^4 - 6t^5
    //   H10 =     10t^3 - 15t^4 + 6t^5
    //   H11 =    - 4t^3 +  7t^4 - 3t^5
    //   H12 =    0.5t^3 -    t^4 + 0.5t^5
    //   t   = (Re - Re_lam) / L_trans in [0,1]
    // ------------------------------------------------------------------

    // Anchor scalars at Re_turb via central finite differences
    NuTurb   := (.Buildings.Fluid.FixedResistances.Functions.churchillFrictionFactor(
                   Re=Re_turb, eps_D=eps_D)/8)
                *(Re_turb - 1000)*Pr
                / (1 + 12.7*sqrt(
                     .Buildings.Fluid.FixedResistances.Functions.churchillFrictionFactor(
                       Re=Re_turb, eps_D=eps_D)/8)*(Pr^(2/3) - 1));

    NuTurb_fdp := (.Buildings.Fluid.FixedResistances.Functions.churchillFrictionFactor(
                     Re=Re_turb + h_fd, eps_D=eps_D)/8)
                  *(Re_turb + h_fd - 1000)*Pr
                  / (1 + 12.7*sqrt(
                       .Buildings.Fluid.FixedResistances.Functions.churchillFrictionFactor(
                         Re=Re_turb + h_fd, eps_D=eps_D)/8)*(Pr^(2/3) - 1));

    NuTurb_fdm := (.Buildings.Fluid.FixedResistances.Functions.churchillFrictionFactor(
                     Re=Re_turb - h_fd, eps_D=eps_D)/8)
                  *(Re_turb - h_fd - 1000)*Pr
                  / (1 + 12.7*sqrt(
                       .Buildings.Fluid.FixedResistances.Functions.churchillFrictionFactor(
                         Re=Re_turb - h_fd, eps_D=eps_D)/8)*(Pr^(2/3) - 1));

    dNuTurb_scaled  := (NuTurb_fdp - NuTurb_fdm) / (2*h_fd) * L_trans;
    d2NuTurb_scaled := (NuTurb_fdp - 2*NuTurb + NuTurb_fdm) / h_fd^2 * L_trans^2;

    t := max(0, min(1, (Re - Re_lam) / L_trans));

    Nu := 3.66  *(1 - 10*t^3 + 15*t^4 - 6*t^5)
        + NuTurb        *(    10*t^3 - 15*t^4 + 6*t^5)
        + dNuTurb_scaled*(  - 4*t^3 +  7*t^4 - 3*t^5)
        + d2NuTurb_scaled*( 0.5*t^3 -    t^4 + 0.5*t^5);

  end if;
  h := Nu*kMed/(2*rTub_in);

  RFluPip := 1/(2*Modelica.Constants.pi*rTub_in*hSeg*h);

  annotation (Documentation(info="<html>
<p>
This model computes the convection resistance in the pipes of a borehole segment
with heigth <i>h<sub>Seg</sub></i>.
</p>
<p>
If the flow is laminar (<i>Re</i> &le; 2300), the Nusselt number is constant at
Nu = 3.66. If the flow is turbulent (<i>Re</i> &ge; 4000), the Gnielinski (1975)
correlation is used:
</p>
<p align=\"center\" style=\"font-style:italic;\">
  Nu = (f/8)(Re &minus; 1000) Pr / (1 + 12.7 &radic;(f/8) (Pr<sup>2/3</sup> &minus; 1))
</p>
<p>
where <i>f</i> is the Churchill (1977) friction factor, explicit and
C&infin;-smooth across all flow regimes.
</p>
<p>
For the transition region 2300 &lt; <i>Re</i> &lt; 4000, a <b>C&sup2;-continuous
quintic Hermite interpolation</b> is used. The polynomial matches value, slope and
curvature from the laminar branch at Re = 2300 and from Gnielinski at Re = 4000, giving C&sup2; continuity at both boundaries. Slope and curvature at Re = 4000 are evaluated by central finite difference on Gnielinski with step &Delta;Re = 0.5. All three anchor
scalars (Nu<sub>turb</sub>, dNu<sub>turb</sub>&middot;L, d&sup2;Nu<sub>turb</sub>&middot;L&sup2;) are recomputed at every function call.
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
Extended turbulent transition region from Re=2400 to Re=4000. 
Replaced C&sup1; sinusoidal splice with C&sup2; quintic Hermite interpolation
in the transition region. <br/>
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

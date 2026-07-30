within Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions;
function pressureLossPipe
  "Pressure loss of a circular pipe using Darcy-Weisbach friction factor"
  extends Modelica.Icons.Function;

  input Modelica.Units.SI.Length length
    "Pipe length";
  input Modelica.Units.SI.Radius rTub
    "Outer tube radius";
  input Modelica.Units.SI.Length eTub
    "Tube wall thickness";
  input Modelica.Units.SI.Length roughness = 0.001e-3
    "Absolute pipe wall roughness";
  input Modelica.Units.SI.Density rhoMed
    "Fluid density";
  input Modelica.Units.SI.DynamicViscosity muMed
    "Fluid dynamic viscosity";
  input Modelica.Units.SI.MassFlowRate m_flow
    "Mass flow rate";
  input Real kMinor(unit="1", min=0) = 0
    "Sum of minor-loss coefficients";
  input Modelica.Units.SI.MassFlowRate m_flow_small(min=Modelica.Constants.eps) = 1e-4
    "Small mass flow rate for regularization";
  output Modelica.Units.SI.PressureDifference dp
    "Pressure drop";
  output Modelica.Units.SI.PressureDifference dpMajor
    "Major Darcy-Weisbach pressure drop";
  output Modelica.Units.SI.PressureDifference dpMinor
    "Minor pressure drop";
  output Modelica.Units.SI.ReynoldsNumber Re
    "Reynolds number";


protected
  Modelica.Units.SI.Radius rTub_in = rTub - eTub
    "Inner tube radius";
  Modelica.Units.SI.Diameter diameter = 2*rTub_in
    "Inner tube diameter";
  Modelica.Units.SI.Area crossArea =
    Modelica.Constants.pi*rTub_in^2
    "Inner cross-sectional area";
  Real eps_D = roughness/diameter
    "Relative roughness";
  Real lambda2
    "Modified friction coefficient, lambda*Re^2";
  Modelica.Units.SI.MassFlowRate m_flow_abs
    "Regularized absolute mass flow rate";
  Real s(unit="1")
    "Regularized sign of mass flow rate";
  Real c(unit="Pa")
    "Common pressure-drop coefficient";


algorithm
  assert(rTub > eTub,
    "The outer tube radius rTub must be larger than the tube wall thickness eTub.");
  assert(rhoMed > 0,
    "The fluid density rhoMed must be positive.");
  assert(muMed > 0,
    "The fluid dynamic viscosity muMed must be positive.");
  assert(kMinor >= 0,
    "The minor-loss coefficient kMinor must be non-negative.");

  m_flow_abs := sqrt(m_flow^2 + m_flow_small^2);
  s := m_flow/m_flow_abs;

  Re := diameter*m_flow_abs/(crossArea*muMed);

  lambda2 :=
    Buildings.Fluid.FixedResistances.Functions.churchillFrictionFactorRe2(
      Re=Re,
      eps_D=eps_D);

  c := muMed^2/(2*rhoMed*diameter^2);

  dpMajor := s*c*(length/diameter)*lambda2;

  dpMinor := s*c*kMinor*Re^2;

  dp := dpMajor + dpMinor;


  annotation (
    smoothOrder=1,
    Documentation(info="<html>
<p>
This function computes the major Darcy-Weisbach pipe-friction loss and an
optional minor-loss contribution.
</p>
<p>
The mass flow rate is regularized near zero using
<i>m&#775;<sub>reg</sub> = sqrt(m&#775;<sup>2</sup> + m&#775;<sub>small</sub><sup>2</sup>)</i>
and <i>s = m&#775;/m&#775;<sub>reg</sub></i>. This avoids non-differentiable use of
absolute value or sign functions.
</p>
<p>
The Reynolds number is
<i>Re = D m&#775;<sub>reg</sub> / (A &mu;)</i>.
The modified friction coefficient
<i>&lambda;<sub>2</sub> = f Re<sup>2</sup></i> is evaluated by
<a href=\"modelica://Buildings.Fluid.FixedResistances.Functions.churchillFrictionFactorRe2\">
Buildings.Fluid.FixedResistances.Functions.churchillFrictionFactorRe2</a>.
</p>
<p>
With <i>c = &mu;<sup>2</sup> / (2 &rho; D<sup>2</sup>)</i>, the signed pressure-drop
contributions are
<i>&Delta;p<sub>major</sub> = s c (L/D) &lambda;<sub>2</sub></i> and
<i>&Delta;p<sub>minor</sub> = s c k<sub>minor</sub> Re<sup>2</sup></i>.
The total pressure drop is
<i>&Delta;p = &Delta;p<sub>major</sub> + &Delta;p<sub>minor</sub></i>.
</p>
<p>
The separate outputs <code>dpMajor</code>, <code>dpMinor</code>, and <code>Re</code>
support post-processing of major/minor loss contributions and flow regime.
</p>
<h4>References</h4>
<p>
Churchill, S. W. (1977).
<a href=\"https://files.engineering.com/files/85c0f3a6-a102-4a22-9d35-f15858c0dd2b/CEM_-_Friction-factor_equation_(1977).pdf\">
Friction-factor equation spans all fluid-flow regimes</a>.
<i>Chemical Engineering</i>, 84(24), 91&ndash;92.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 2026, by Lone Meertens:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4656\">Buildings, #4656</a>.
</li>
</ul>
</html>"));

end pressureLossPipe;

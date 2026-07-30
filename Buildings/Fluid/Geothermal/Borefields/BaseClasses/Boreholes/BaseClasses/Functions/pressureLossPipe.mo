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
  output Modelica.Units.SI.PressureDifference dp
    "Pressure drop";

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
  Modelica.Units.SI.ReynoldsNumber Re
    "Reynolds number";
  Real lambda2
    "Modified friction coefficient, lambda*Re^2";
  Modelica.Units.SI.PressureDifference dpAbsMajor
    "Absolute major pressure drop";
  Modelica.Units.SI.PressureDifference dpAbsMinor
    "Absolute minor pressure drop";

algorithm
  assert(rTub > eTub,
    "The outer tube radius rTub must be larger than the tube wall thickness eTub.");
  assert(rhoMed > 0,
    "The fluid density rhoMed must be positive.");
  assert(muMed > 0,
    "The fluid dynamic viscosity muMed must be positive.");
  assert(kMinor >= 0,
    "The minor-loss coefficient kMinor must be non-negative.");

  Re := diameter*abs(m_flow)/(crossArea*muMed);

  lambda2 :=
    Buildings.Fluid.FixedResistances.Functions.churchillFrictionFactorRe2(
      Re=Re,
      eps_D=eps_D);

  /*
    Major Darcy-Weisbach pressure loss:
      dp_major =
        sign(m_flow) * L*mu^2/(2*rho*D^3) * lambda2
    with
      lambda2 = f*Re^2.
    Minor loss:
      dp_minor =
        sign(m_flow) * kMinor*rho*v^2/2
    which can be written with Re as
      dp_minor =
        sign(m_flow) * kMinor*mu^2*Re^2/(2*rho*D^2).
  */

  dpAbsMajor :=
    length*muMed^2/(2*rhoMed*diameter^3)*lambda2;

  dpAbsMinor :=
    kMinor*muMed^2/(2*rhoMed*diameter^2)*Re^2;

  dp := smooth(1,
    if noEvent(m_flow >= 0) then
      dpAbsMajor + dpAbsMinor
    else
     -dpAbsMajor - dpAbsMinor);

  annotation (
    smoothOrder=1,
    Documentation(info="<html>
<p>
This function computes the pressure loss in a circular pipe using the
Darcy-Weisbach equation. The result includes the major pipe-friction loss and,
optionally, a minor-loss contribution represented by a loss coefficient.
</p>

<p>
The Reynolds number is
</p>
<p align=\"center\" style=\"font-style:italic;\">
  Re = D |m&#775;| / (A &mu;),
</p>
<p>
where <i>Re</i> is the Reynolds number, <i>D</i> is the inner pipe diameter,
<i>A</i> is the inner pipe cross-sectional area, <i>m&#775;</i> is the mass
flow rate, and <i>&mu;</i> is the dynamic viscosity.
</p>

<p>
The major pressure loss is evaluated as
</p>
<p align=\"center\" style=\"font-style:italic;\">
  &Delta;p<sub>major</sub> =
  sign(m&#775;) L &mu;<sup>2</sup> &lambda;<sub>2</sub> /
  (2 &rho; D<sup>3</sup>),
</p>
<p>
where <i>L</i> is the pipe length, <i>&rho;</i> is the fluid density, and
</p>
<p align=\"center\" style=\"font-style:italic;\">
  &lambda;<sub>2</sub> = f Re<sup>2</sup>.
</p>
<p>
The modified friction coefficient <i>&lambda;<sub>2</sub></i> is evaluated by
<a href=\"modelica://Buildings.Fluid.FixedResistances.Functions.churchillFrictionFactorRe2\">
Buildings.Fluid.FixedResistances.Functions.churchillFrictionFactorRe2</a>.
This avoids evaluating the singular raw friction factor at zero flow and gives
the correct laminar limit near zero Reynolds number.
</p>

<p>
The minor pressure loss is evaluated using
</p>
<p align=\"center\" style=\"font-style:italic;\">
  &Delta;p<sub>minor</sub> =
  sign(m&#775;) K<sub>minor</sub> &rho; v<sup>2</sup>/2,
</p>
<p>
where <i>K<sub>minor</sub></i> is the sum of the minor-loss coefficients and
<i>v = |m&#775;| / (&rho; A)</i> is the mean flow velocity. Equivalently, this
is implemented as
</p>
<p align=\"center\" style=\"font-style:italic;\">
  &Delta;p<sub>minor</sub> =
  sign(m&#775;) K<sub>minor</sub> &mu;<sup>2</sup> Re<sup>2</sup> /
  (2 &rho; D<sup>2</sup>).
</p>

<p>
The total pressure loss is
</p>
<p align=\"center\" style=\"font-style:italic;\">
  &Delta;p =
  &Delta;p<sub>major</sub> + &Delta;p<sub>minor</sub>.
</p>

<p>
If <code>kMinor=0</code>, only the major Darcy-Weisbach pipe-friction loss is
included.
</p>

<p>
Equivalent-length data may be converted to an approximate loss coefficient at a
documented reference condition using
</p>
<p align=\"center\" style=\"font-style:italic;\">
  K = f L<sub>eq</sub> / D.
</p>
<p>
Because <i>f</i> depends on the flow regime, this conversion should be based on
a specified nominal or reference condition.
</p>

<h4>References</h4>
<p>
Churchill, S. W. (1977). Friction-factor equation spans all fluid-flow regimes.
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

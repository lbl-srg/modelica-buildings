within Buildings.Fluid.FixedResistances.Functions;
function churchillFrictionFactorRe2
  "Modified friction coefficient lambda2 = f*Re^2 using Churchill correlation"
  extends .Modelica.Icons.Function;

  input Real Re(unit="1")
    "Reynolds number";
  input Real eps_D(unit="1")
    "Relative roughness";
  output Real lambda2(unit="1")
    "Darcy friction factor multiplied by Re^2";

protected
  constant Real Re_min(unit="1") = 1e-6
    "Lower Reynolds number bound for evaluating the raw Churchill correlation";

  constant Real Re_delta(unit="1") = 1e-5
    "Width of the smoothing interval above Re_min";

  Real lambda2Lam(unit="1")
    "Laminar asymptote lambda*Re^2 = 64*Re";

algorithm
  lambda2Lam := 64*Re;

  lambda2 := smooth(2,
    if noEvent(Re <= Re_min) then
      lambda2Lam
    else
      (
        1 - Buildings.Utilities.Math.Functions.smoothHeaviside(
              x=Re - (Re_min + Re_delta/2),
              delta=Re_delta/2))
      * lambda2Lam
      + Buildings.Utilities.Math.Functions.smoothHeaviside(
          x=Re - (Re_min + Re_delta/2),
          delta=Re_delta/2)
      * Buildings.Fluid.FixedResistances.Functions.churchillFrictionFactor(
          Re=Re,
          eps_D=eps_D)
      * Re^2);

annotation (
  smoothOrder=2,
  Documentation(info="<html>
<p>
This function computes the modified Darcy friction coefficient
<i>&lambda;<sub>2</sub></i>,
</p>
<p align=\"center\" style=\"font-style:italic;\">
  &lambda;<sub>2</sub> = f Re<sup>2</sup>,
</p>
<p>
where <i>f</i> is the Darcy-Weisbach friction factor computed with the
Churchill (1977) correlation.
</p>

<p>
Using <i>&lambda;<sub>2</sub></i> is convenient for pressure-drop calculations
because the raw friction factor <i>f</i> is singular at <i>Re = 0</i>, whereas
<i>&lambda;<sub>2</sub></i> has a finite laminar limit. For laminar flow,
</p>
<p align=\"center\" style=\"font-style:italic;\">
  f = 64/Re,
  &nbsp;&nbsp;
  &lambda;<sub>2</sub> = f Re<sup>2</sup> = 64 Re.
</p>

<p>
For <i>Re</i> &le; <code>Re_min</code>, this function returns the laminar
limit <i>&lambda;<sub>2</sub> = 64 Re</i> and does not evaluate the raw
Churchill friction-factor correlation. This avoids evaluating the singular
expression at zero flow.
</p>

<p>
For <i>Re</i> &gt; <code>Re_min</code>, the function blends the laminar limit
with the Churchill expression <i>f Re<sup>2</sup></i> using
<a href=\"modelica://Buildings.Utilities.Math.Functions.smoothHeaviside\">
Buildings.Utilities.Math.Functions.smoothHeaviside</a>.
The blending interval is
</p>
<p align=\"center\" style=\"font-style:italic;\">
  Re_min &lt; Re &lt; Re_min + Re_delta.
</p>

<p>
The threshold <code>Re_min</code> is not a physical laminar-to-turbulent
transition. It is only a numerical guard used to avoid the singular raw
friction factor at zero flow. The laminar-to-turbulent behavior for positive
Reynolds numbers is provided by the Churchill correlation itself.
</p>

<p>
The condition at <code>Re_min</code> is evaluated with <code>noEvent</code>
to avoid event generation near zero flow. This improves robustness when
solvers iterate around zero mass flow or during flow reversal.
</p>

<p>
This function should be used in Darcy-Weisbach pressure-drop calculations that
need to include zero or near-zero mass flow.
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
July 22, 2026, by Lone Meertens:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4656\">Buildings, #4656</a>.
</li>
</ul>
</html>"));
end churchillFrictionFactorRe2;

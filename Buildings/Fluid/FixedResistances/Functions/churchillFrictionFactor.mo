within Buildings.Fluid.FixedResistances.Functions;
function churchillFrictionFactor
  "Darcy-Weisbach friction factor for all flow regimes"
  extends .Modelica.Icons.Function;

  input Real Re(min=0)
    "Reynolds number";
  input Real eps_D(min=0)
    "Relative pipe roughness, epsilon/D";
  output Real f
    "Darcy-Weisbach friction factor";

protected
  Real A
    "Churchill coefficient A";
  Real B
    "Churchill coefficient B";

algorithm
  assert(noEvent(Re > 0),
    "churchillFrictionFactor requires Re > 0. "
    + "Use churchillFrictionFactorRe2 for zero-flow pressure-loss regularization.");  
  A := (2.457*.Modelica.Math.log(
          1/((7/Re)^0.9 + 0.27*eps_D)))^16;
  B := (37530/Re)^16;

  f := 8*((8/Re)^12 + 1/(A + B)^(3/2))^(1/12);

annotation (Documentation(info="<html>
<p>
This function computes the Darcy-Weisbach friction factor <i>f</i> for internal
pipe flow using the explicit correlation of Churchill (1977). The correlation is
valid for strictly positive Reynolds numbers and covers laminar, transitional,
and turbulent flow without regime switching.
</p>
<p>
The correlation is:
</p>
<p align=\"center\" style=\"font-style:italic;\">
  f = 8 &nbsp; [(8/Re)<sup>12</sup> + 1/(A+B)<sup>3/2</sup>]<sup>1/12</sup>
</p>
<p>
where
</p>
<p align=\"center\" style=\"font-style:italic;\">
  A = [2.457 &nbsp; ln(1 / ((7/Re)<sup>0.9</sup> + 0.27 &epsilon;/D))]<sup>16</sup>,
  &nbsp;&nbsp;
  B = (37530/Re)<sup>16</sup>.
</p>
<p>
Key properties of this correlation:
</p>
<ul>
<li>
Explicit &mdash; no iteration required.
</li>
<li>
Smooth for <i>Re &gt; 0</i> and continuous across laminar, transitional, and
turbulent regimes without regime switching.
</li>
<li>
Asymptotes to <i>f = 64/Re</i> in the laminar regime.
</li>
<li>
Agrees with Colebrook-White to within 2% in the turbulent regime.
</li>
</ul>
<p>
The raw friction factor is singular at <i>Re= 0</i> . Therefore, this function
requires <i>Re &gt; 0</i>. For pressure-drop calculations that need to include
zero flow, use
<a href=\"modelica://Buildings.Fluid.FixedResistances.Functions.churchillFrictionFactorRe2\">
Buildings.Fluid.FixedResistances.Functions.churchillFrictionFactorRe2</a>,
which returns the regularized modified friction coefficient
<i>&lambda;<sub>2</sub> = f Re<sup>2</sup></i>.
</p>
<h4>References</h4>
<p>
Churchill, S. W. (1977).
<a href=\"https://files.engineering.com/files/85c0f3a6-a102-4a22-9d35-f15858c0dd2b/CEM_-_Friction-factor_equation_(1977).pdf\">
Friction-factor equation spans all fluid-flow regimes</a>.
<i>Chemical Engineering</i>, 84(24), 91&ndash;92.
</p>
</html>", revisions="<html>
<ul>
<li>
July 14, 2026, by Lone Meertens:<br/>
First implementation.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4655\">Buildings, #4655</a>.
</li>
</ul>
</html>"));

end churchillFrictionFactor;

within Buildings.Fluid.FixedResistances.Functions;
function churchillFrictionFactor
  "Darcy-Weisbach friction factor for all flow regimes (Churchill, 1977)"
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
  A := (2.457*.Modelica.Math.log(
          1/((7/Re)^0.9 + 0.27*eps_D)))^16;
  B := (37530/Re)^16;

  f := 8*((8/Re)^12 + 1/(A + B)^(3/2))^(1/12);

  annotation (Documentation(info="<html>
<p>
This function computes the Darcy-Weisbach friction factor <i>f</i> for internal
pipe flow using the explicit correlation of Churchill (1977), which is valid
across all flow regimes (laminar, transitional, and turbulent) without regime
switching.
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
Explicit — no iteration required.
</li>
<li>
C&infin; smooth across all Reynolds numbers — no regime switching.
</li>
<li>
Asymptotes to <i>f</i> = 64/<i>Re</i> in the laminar regime.
</li>
<li>
Agrees with Colebrook-White to within 2% in the turbulent regime.
</li>
</ul>
<p>
The input <code>eps_D</code> is the relative roughness &epsilon;/<i>D</i>.
For smooth pipes (e.g. HDPE), use <code>eps_D = 0</code>.
</p>
<h4>References</h4>
<p>
Churchill, S. W. (1977). Friction-factor equation spans all fluid-flow regimes.
<i>Chemical Engineering</i>, 84(24), 91&ndash;92.
</p>
</html>", revisions="<html>
<ul>
<li>
July 14, 2026, by L. Meertens:<br/>
First implementation.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4655\">Buildings, #4655</a>.
</li>
</ul>
</html>"));
end churchillFrictionFactor;

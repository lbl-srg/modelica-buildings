within Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.Functions;
function wetterAfjei1997
  "Correction of COP for icing and defrost according to Wetter, Afjei and Glass"
  extends
    Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.Functions.partialIcingFactor;
protected
  parameter Real offLin=0.03 "First factor for linear term, offset";
  parameter Real sloLin=-0.004 "Second factor for linear term, slope";
  parameter Real gauFac=0.1534 "Parameter for gaussian curve, factor";
  parameter Real gauMea=0.8869 "Parameter for gaussian curve, mean";
  parameter Real gauSig=26.06 "Parameter for gaussian curve, sigma";
  Real fac "Probability of icing";
  Real linTer "Linear part of equation";
  Real gauTer "Gaussian part of equation";
algorithm
  linTer :=offLin + sloLin*TEvaInMea;
  gauTer :=gauFac*Modelica.Math.exp(-(TEvaInMea - gauMea)*(TEvaInMea - gauMea)/
    gauSig);
  fac := gauTer + Buildings.Utilities.Math.Functions.smoothMax(
    x1=1E-5,
    x2= linTer,
    deltaX=0.25E-5);
  iceFac:=1 - fac;
  annotation (Documentation(info="<html>
<p>
  Correction of the coefficient of performance due to
  icing/frosting according to Wetter, Afjei and Glass (1997).
</p>
<p>
  For more information on the <code>iceFac</code>, see the documentation of <a href=
  \"modelica://Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialRefrigerantCycle\">
  Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.BaseClasses.PartialRefrigerantCycle</a>
</p>
<h4>References</h4>
<p>
Thomas Afjei, Michael Wetter and Andrew Glass.<br/>
TRNSYS type: Dual-stage compressor heat pump including frost and cycle losses. Model description and implementation in TRNSYS.</br>
TRNSYS user meeting, November 1997, Stuttgart, Germany.<br/>
<a href=\"https://simulationresearch.lbl.gov/wetter/download/type204_hp.pdf\">
https://simulationresearch.lbl.gov/wetter/download/type204_hp.pdf</a>
</p>
</html>",
  revisions="<html><ul>
  <li>
  December 7, 2023, by Michael Wetter:<br/>
  Reformulated to make function once continuously differentiable, and to avoid
  an event that is triggered based on <code>TEvaInMea</code>).
  </li>
  <li>
    <i>November 26, 2018</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>"));
end wetterAfjei1997;

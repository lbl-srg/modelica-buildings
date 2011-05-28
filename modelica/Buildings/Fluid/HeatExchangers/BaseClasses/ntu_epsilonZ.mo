within Buildings.Fluid.HeatExchangers.BaseClasses;
function ntu_epsilonZ
  "Computes number of transfer units for given heat exchanger effectiveness and heat exchanger flow regime"
  import f = Buildings.Fluid.Types.HeatExchangerFlowRegime;
  input Real eps(min=0, max=0.999) "Heat exchanger effectiveness";
  input Real Z(min=0, max=1) "Ratio of capacity flow rate (CMin/CMax)";
  input Buildings.Fluid.Types.HeatExchangerFlowRegime flowRegime
    "Heat exchanger flow regime";
  output Real NTU "Number of transfer units";

protected
  Real a "Auxiliary variable";
algorithm
  if (flowRegime == f.ParallelFlow) then // parallel flow
    a := Z+1;
    assert(eps < 1/a,
      "Invalid input data. eps > 1/(1+Z) is physically not possible for parallel flow." +
      "\n  Received eps = " + String(eps) +
      "\n             Z = " + String(Z) +
      "\n       1/(Z+1) = " + String(1/a));
    NTU := -(Modelica.Math.log(1-eps*a))/(a);
  elseif (flowRegime == f.CounterFlow) then// counter flow
   // a is constraining Z since eps is not defined for Z=1.
    a := smooth(1, if Z < 0.97 then Z else
      Buildings.Utilities.Math.Functions.smoothMin(
      x1=Z,
      x2=0.98,
      deltaX=0.01));
    NTU := Modelica.Math.log((1-eps)/(1-eps*a)) / (a-1);

  elseif (flowRegime == f.CrossFlowUnmixed) then
    a := 0;
    NTU := Internal.solve(eps, 1E-20, 1E6, {Z});
  elseif (flowRegime == f.CrossFlowCMinUnmixedCMaxMixed) then
    // cross flow, (single pass), CMax mixed, CMin unmixed. (Coil with one row.)
   a := smooth(1, if Z > 0.03 then Z else
      Buildings.Utilities.Math.Functions.smoothMin(
      x1=0.02,
      x2=Z,
      deltaX=0.01));
    NTU := -Modelica.Math.log(1+(Modelica.Math.log(1-eps*a)/a));
  elseif (flowRegime == f.CrossFlowCMinMixedCMaxUnmixed) then
    // cross flow, (single pass), CMin mixed, CMax unmixed.
   a := smooth(1, if Z > 0.03 then Z else
      Buildings.Utilities.Math.Functions.smoothMin(
      x1=0.02,
      x2=Z,
      deltaX=0.01));
    NTU := -Modelica.Math.log(1+Z*Modelica.Math.log(1-eps))/Z;
  else
    a := 0;
    NTU := 0;
    assert(0 < flowRegime and flowRegime < 6, "Flow regime is not implemented.");
  end if;

  annotation (preferedView="info",
             inverse(eps=Buildings.Fluid.HeatExchangers.BaseClasses.epsilon_ntuZ(NTU=NTU, Z=Z, flowRegime=flowRegime)),
           smoothOrder=1,
Documentation(info="<html>
This function computes the number of transfer units for a given heat exchanger effectiveness,
capacity flow ratio and heat exchanger flow regime.
</p>
<p>
Note that for the flow regime <code>CrossFlowUnmixed</code>, computing the
function requires the numerical solution of an equation in one variable.
This is handled internally and not exposed to the global solver.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 11, 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end ntu_epsilonZ;

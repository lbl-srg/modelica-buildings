within Buildings.Fluid.HeatExchangers.BaseClasses;
function epsilon_ntuZ
  "Computes heat exchanger effectiveness for given number of transfer units and heat exchanger flow regime"
  import f = Buildings.Fluid.Types.HeatExchangerFlowRegime;
  input Real NTU "Number of transfer units";
  input Real Z(min=0, max=1) "Ratio of capacity flow rate (CMin/CMax)";
  input Buildings.Fluid.Types.HeatExchangerFlowRegime flowRegime
    "Heat exchanger flow regime";
  output Real eps(min=0, max=1) "Heat exchanger effectiveness";
protected
  Real a "Auxiliary variable";
algorithm
  if (flowRegime == f.ParallelFlow) then // parallel flow
    a := 0;
    eps := (1 - Modelica.Math.exp(-NTU*(1 + Z)))/(1 + Z);
  elseif (flowRegime == f.CounterFlow) then// counter flow
   // a is constraining Z since eps is not defined for Z=1.
    a := smooth(1, if Z < 0.97 then Z else
      Buildings.Utilities.Math.Functions.smoothMin(
      x1=Z,
      x2=0.98,
      deltaX=0.01));
    eps := (1 - Modelica.Math.exp(-NTU*(1 - a)))/(1 - a*Modelica.Math.exp(-NTU*(
      1 - a)));
  elseif (flowRegime == f.CrossFlowUnmixed) then
   a := NTU^(-0.22);
    eps := 1 - Modelica.Math.exp( ( Modelica.Math.exp( - NTU * Z * a)  - 1)  / (Z * a));
  elseif (flowRegime == f.CrossFlowCMinUnmixedCMaxMixed) then
    // cross flow, (single pass), CMax mixed, CMin unmixed. (Coil with one row.)
    a := 0;
    eps := (1 - Modelica.Math.exp(-Z*(1 - Modelica.Math.exp(-NTU))))/Z;
  elseif (flowRegime == f.CrossFlowCMinMixedCMaxUnmixed) then
    // cross flow, (single pass), CMin mixed, CMax unmixed.
    a := 0;
    eps := 1 - Modelica.Math.exp(-(1 - Modelica.Math.exp(-Z*NTU))/Z);
  else
    a := 0;
    eps := 0;
    assert(f.ParallelFlow <= flowRegime and
           flowRegime <= f.CrossFlowCMinUnmixedCMaxMixed,
           "Flow regime is not implemented.");
  end if;
  annotation(preferredView="info",
             inverse(NTU=Buildings.Fluid.HeatExchangers.BaseClasses.ntu_epsilonZ(eps=eps, Z=Z, flowRegime=flowRegime)),
           smoothOrder=1,
           Documentation(info="<html>
This function computes the heat exchanger effectiveness for a given number of transfer units, capacity flow ratio and heat exchanger flow regime.
</html>",
revisions="<html>
<ul>
<li>
September 25, 2013, by Michael Wetter:<br/>
Changed test in the <code>assert</code> statement as OpenModelica
had an error when comparing enumerations with integers.
</li>
<li>
February 11, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end epsilon_ntuZ;

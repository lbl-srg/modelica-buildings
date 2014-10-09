within Buildings.Fluid.HeatExchangers.BaseClasses;
function epsilon_ntuZ
  "Computes heat exchanger effectiveness for given number of transfer units and heat exchanger flow regime"
  import f = Buildings.Fluid.Types.HeatExchangerFlowRegime;
  input Real NTU "Number of transfer units";
  input Real Z(min=0, max=1) "Ratio of capacity flow rate (CMin/CMax)";
  input Integer flowRegime
    "Heat exchanger flow regime, see  Buildings.Fluid.Types.HeatExchangerFlowRegime";
  output Real eps(min=0, max=1) "Heat exchanger effectiveness";
protected
  Real a "Auxiliary variable";
algorithm
  if (flowRegime == Integer(f.ParallelFlow)) then // parallel flow
    a := 0;
    eps := (1 - Modelica.Math.exp(-NTU*(1 + Z)))/(1 + Z);
  elseif (flowRegime == Integer(f.CounterFlow)) then// counter flow
   // a is constraining Z since eps is not defined for Z=1.
    a := smooth(1, if Z < 0.97 then Z else
      Buildings.Utilities.Math.Functions.smoothMin(
      x1=Z,
      x2=0.98,
      deltaX=0.01));
    eps := (1 - Modelica.Math.exp(-NTU*(1 - a)))/(1 - a*Modelica.Math.exp(-NTU*(
      1 - a)));
  elseif (flowRegime == Integer(f.CrossFlowUnmixed)) then
   a := NTU^(-0.22);
    eps := 1 - Modelica.Math.exp( ( Modelica.Math.exp( - NTU * Z * a)  - 1)  / (Z * a));
  elseif (flowRegime == Integer(f.CrossFlowCMinUnmixedCMaxMixed)) then
    // cross flow, (single pass), CMax mixed, CMin unmixed. (Coil with one row.)
    a := 0;
    eps := (1 - Modelica.Math.exp(-Z*(1 - Modelica.Math.exp(-NTU))))/Z;
  elseif (flowRegime == Integer(f.CrossFlowCMinMixedCMaxUnmixed)) then
    // cross flow, (single pass), CMin mixed, CMax unmixed.
    a := 0;
    eps := 1 - Modelica.Math.exp(-(1 - Modelica.Math.exp(-Z*NTU))/Z);
  else
    a := 0;
    eps := 0;
    assert(Integer(f.ParallelFlow) <= flowRegime and
           flowRegime <= Integer(f.CrossFlowCMinUnmixedCMaxMixed),
           "Flow regime is not implemented.");
  end if;
  annotation(preferredView="info",
             inverse(NTU=Buildings.Fluid.HeatExchangers.BaseClasses.ntu_epsilonZ(eps=eps, Z=Z, flowRegime=flowRegime)),
           smoothOrder=1,
           Documentation(info="<html>
<p>
This function computes the heat exchanger effectiveness for a given number of transfer units, capacity flow ratio and heat exchanger flow regime.
The different options for the flow regime are declared in
<a href=\"modelica://Buildings.Fluid.Types.HeatExchangerFlowRegime\">
Buildings.Fluid.Types.HeatExchangerFlowRegime</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 7, 2014, by Michael Wetter:<br/>
Changed the type of the input <code>flowRegime</code> from
<code>Buildings.Fluid.Types.HeatExchangerFlowRegime</code>
to <code>Integer</code>.
This was required because this argument is passed in Dymola 2015 in the function
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.epsilon_C\">
Buildings.Fluid.HeatExchangers.BaseClasses.epsilon_C</a>
as an integer. Without this change, a translation warning occurs.
</li>
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

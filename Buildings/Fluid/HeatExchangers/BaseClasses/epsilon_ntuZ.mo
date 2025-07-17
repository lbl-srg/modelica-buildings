within Buildings.Fluid.HeatExchangers.BaseClasses;
function epsilon_ntuZ
  "Computes heat exchanger effectiveness for given number of transfer units and heat exchanger flow regime"
  input Real NTU "Number of transfer units";
  input Real Z(min=0, max=1) "Ratio of capacity flow rate (CMin/CMax)";
  input Integer flowRegime
    "Heat exchanger flow regime, see Buildings.Fluid.Types.HeatExchangerFlowRegime";
  output Real eps(min=0, max=1) "Heat exchanger effectiveness";
protected
  Real a "Auxiliary variable";
algorithm
  if (flowRegime == Integer(Buildings.Fluid.Types.HeatExchangerFlowRegime.ParallelFlow)) then // parallel flow
    a := 0;
    eps := (1 - Modelica.Math.exp(-NTU*(1 + Z)))/(1 + Z);
  elseif (flowRegime == Integer(Buildings.Fluid.Types.HeatExchangerFlowRegime.CounterFlow)) then// counter flow
   // a is constraining Z since eps is not defined for Z=1.
    a := smooth(1, if Z < 0.97 then Z else
      Buildings.Utilities.Math.Functions.smoothMin(
      x1=Z,
      x2=0.98,
      deltaX=0.01));
    eps := (1 - Modelica.Math.exp(-NTU*(1 - a)))/(1 - a*Modelica.Math.exp(-NTU*(
      1 - a)));
  elseif (flowRegime == Integer(Buildings.Fluid.Types.HeatExchangerFlowRegime.CrossFlowUnmixed)) then
   a := NTU^(-0.22);
    eps := 1 - Modelica.Math.exp( ( Modelica.Math.exp( - NTU * Z * a)  - 1)  / (Z * a));
  elseif (flowRegime == Integer(Buildings.Fluid.Types.HeatExchangerFlowRegime.CrossFlowCMinUnmixedCMaxMixed)) then
    // cross flow, (single pass), CMax mixed, CMin unmixed. (Coil with one row.)
    a := 0;
    eps := (1 - Modelica.Math.exp(-Z*(1 - Modelica.Math.exp(-NTU))))/Z;
  elseif (flowRegime == Integer(Buildings.Fluid.Types.HeatExchangerFlowRegime.CrossFlowCMinMixedCMaxUnmixed)) then
    // cross flow, (single pass), CMin mixed, CMax unmixed.
    a := 0;
    eps := 1 - Modelica.Math.exp(-(1 - Modelica.Math.exp(-Z*NTU))/Z);
  elseif (flowRegime == Integer(Buildings.Fluid.Types.HeatExchangerFlowRegime.ConstantTemperaturePhaseChange)) then
    // one side is experiencing constant temperature phase change
    // Z is unused
    a := 0;
    eps := 1 - Modelica.Math.exp(-NTU);
  else
    a := 0;
    eps := 0;
    assert(Integer(Buildings.Fluid.Types.HeatExchangerFlowRegime.ParallelFlow) <= flowRegime and
           flowRegime <= Integer(Buildings.Fluid.Types.HeatExchangerFlowRegime.ConstantTemperaturePhaseChange),
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
February 7, 2025, by Jelger Jansen:<br/>
Removed <code>import</code> statement.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1961\">IBPSA, #1961</a>.
</li>
<li>
September 28, 2016, by Massimo Cimmino:<br/>
Added case for constant temperature phase change on one side of
the heat exchanger.
</li>
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

within Buildings.Fluid.HeatExchangers.BaseClasses;
function ntu_epsilonZ
  "Computes number of transfer units for given heat exchanger effectiveness and heat exchanger flow regime"
  import f = Buildings.Fluid.Types.HeatExchangerFlowRegime;
  input Real eps(min=0, max=0.999) "Heat exchanger effectiveness";
  input Real Z(min=0, max=1) "Ratio of capacity flow rate (CMin/CMax)";
  input Integer flowRegime
    "Heat exchanger flow regime";
  output Real NTU "Number of transfer units";

protected
  Real a "Auxiliary variable";

  function epsilon_ntuZ_crossFlowUnmixed
    "Internal function to solve eps=f(NTU, Z) for NTU for cross flow unmixed"
    extends Modelica.Math.Nonlinear.Interfaces.partialScalarFunction;

    input Real eps(min=0, max=0.999) "Heat exchanger effectiveness";
    input Real Z(min=0, max=1) "Ratio of capacity flow rate (CMin/CMax)";

  protected
    Real NTUExp "Auxiliary variable";

  algorithm
    NTUExp := u^(-0.22);
    y := 1 - Modelica.Math.exp( ( Modelica.Math.exp( - u * Z * NTUExp)  - 1)  / (Z * NTUExp))-eps;
  end epsilon_ntuZ_crossFlowUnmixed;

algorithm
  if (flowRegime == Integer(f.ParallelFlow)) then // parallel flow
    a := Z+1;
    assert(eps < 1/a,
      "Invalid input data. eps > 1/(1+Z) is physically not possible for parallel flow.
  Received eps = " + String(eps) + "
             Z = " + String(Z) + "
       1/(Z+1) = " + String(1/a));
    NTU := -(Modelica.Math.log(1-eps*a))/(a);
  elseif (flowRegime == Integer(f.CounterFlow)) then// counter flow
   // a is constraining Z since eps is not defined for Z=1.
    a := smooth(1, if Z < 0.97 then Z else
      Buildings.Utilities.Math.Functions.smoothMin(
      x1=Z,
      x2=0.98,
      deltaX=0.01));
    NTU := Modelica.Math.log((1-eps)/(1-eps*a)) / (a-1);

  elseif (flowRegime == Integer(f.CrossFlowUnmixed)) then
    a := 0;
    // The function Internal.solve evaluates epsilon_ntuZ at NTU=x_min-1e-10 and NTU=x_max+1e-10
    // when it solves iteratively epsilon_ntuZ for ntu
    // Therefore, we set x_min=1.5*1e-10 to prevent computing NTU^(-0.22)=(-1e-10)^(-0.22).
    NTU :=Modelica.Math.Nonlinear.solveOneNonlinearEquation(
      f=function epsilon_ntuZ_crossFlowUnmixed(eps=eps, Z=Z),
      u_min=1.5*1e-10,
      u_max=1e6);
  elseif (flowRegime == Integer(f.CrossFlowCMinUnmixedCMaxMixed)) then
    // cross flow, (single pass), CMax mixed, CMin unmixed. (Coil with one row.)
   a := smooth(1, if Z > 0.03 then Z else
      Buildings.Utilities.Math.Functions.smoothMin(
      x1=0.02,
      x2=Z,
      deltaX=0.01));
    NTU := -Modelica.Math.log(1+(Modelica.Math.log(1-eps*a)/a));
  elseif (flowRegime == Integer(f.CrossFlowCMinMixedCMaxUnmixed)) then
    // cross flow, (single pass), CMin mixed, CMax unmixed.
   a := smooth(1, if Z > 0.03 then Z else
      Buildings.Utilities.Math.Functions.smoothMin(
      x1=0.02,
      x2=Z,
      deltaX=0.01));
    NTU := -Modelica.Math.log(1+Z*Modelica.Math.log(1-eps))/Z;
  elseif (flowRegime == Integer(f.ConstantTemperaturePhaseChange)) then
    // one side is experiencing constant temperature phase change
    // Z is unused
    a := 0;
    NTU := -Modelica.Math.log((1-eps));
  else
    a := 0;
    NTU := 0;
    assert(Integer(f.ParallelFlow) <= flowRegime and
           flowRegime <= Integer(f.ConstantTemperaturePhaseChange),
           "Flow regime is not implemented.");
  end if;

  annotation (preferredView="info",
             inverse(eps=Buildings.Fluid.HeatExchangers.BaseClasses.epsilon_ntuZ(NTU=NTU, Z=Z, flowRegime=flowRegime)),
           smoothOrder=1,
Documentation(info="<html>
<p>
This function computes the number of transfer units for a given heat exchanger effectiveness,
capacity flow ratio and heat exchanger flow regime.
The different options for the flow regime are declared in
<a href=\"modelica://Buildings.Fluid.Types.HeatExchangerFlowRegime\">
Buildings.Fluid.Types.HeatExchangerFlowRegime</a>.
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
February 28, 2020, by Michael Wetter:<br/>
Replaced call to <code>Media.Common.OneNonLinearEquation</code> to use
<a href=\"modelica://Modelica.Math.Nonlinear.solveOneNonlinearEquation\">
Modelica.Math.Nonlinear.solveOneNonlinearEquation</a>
because <code>Media.Common.OneNonLinearEquation</code> will be obsolete in MSL 4.0.0.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1299\">issue 1299</a>.
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
This was done to have the same argument list as
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.epsilon_ntuZ\">
Buildings.Fluid.HeatExchangers.BaseClasses.epsilon_ntuZ</a>,
in which the type had to be changed.
</li>
<li>
April 29, 2013, by Michael Wetter:<br/>
Added dummy argument to function call of <code>Internal.solve</code>
to avoid a warning during model check in Dymola 2015.
</li>
<li>
August 10, 2011, by Michael Wetter:<br/>
Changed implementation to use
<code>Modelica.Media.Common.OneNonLinearEquation</code> instead of
<code>Buildings.Utilities.Math.BaseClasses.OneNonLinearEquation</code>.
</li>
<li>
February 11, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ntu_epsilonZ;

within Buildings.Fluid.HeatExchangers.BaseClasses;
function epsilon_C
  "Computes heat exchanger effectiveness for given capacity flow rates and heat exchanger flow regime"
  input Modelica.SIunits.ThermalConductance UA "UA value";
  input Modelica.SIunits.ThermalConductance C1_flow
    "Enthalpy flow rate medium 1";
  input Modelica.SIunits.ThermalConductance C2_flow
    "Enthalpy flow rate medium 2";
  input Integer flowRegime
    "Heat exchanger flow regime, see  Buildings.Fluid.Types.HeatExchangerFlowRegime";
  input Modelica.SIunits.ThermalConductance CMin_flow_nominal
    "Minimum enthalpy flow rate at nominal condition";
  input Modelica.SIunits.ThermalConductance CMax_flow_nominal
    "Maximum enthalpy flow rate at nominal condition";
  input Real delta = 1E-3 "Small value used for smoothing";
  output Real eps(min=0, max=1) "Heat exchanger effectiveness";
  output Real NTU "Number of transfer units";
  output Real Z(min=0, max=1) "Ratio of capacity flow rate (CMin/CMax)";
protected
  Modelica.SIunits.ThermalConductance deltaCMin
    "Small number for capacity flow rate";
  Modelica.SIunits.ThermalConductance deltaCMax
    "Small number for capacity flow rate";
  Modelica.SIunits.ThermalConductance CMin_flow "Minimum capacity flow rate";
  Modelica.SIunits.ThermalConductance CMax_flow "Maximum capacity flow rate";
  Modelica.SIunits.ThermalConductance CMinNZ_flow
    "Minimum capacity flow rate, bounded away from zero";
  Modelica.SIunits.ThermalConductance CMaxNZ_flow
    "Maximum capacity flow rate, bounded away from zero";
  Real gai(min=0, max=1)
    "Gain used to force UA to zero for very small flow rates";
algorithm
  deltaCMin := delta*CMin_flow_nominal;
  deltaCMax := delta*CMax_flow_nominal;
  // effectiveness
  CMin_flow :=Buildings.Utilities.Math.Functions.smoothMin(
    C1_flow,
    C2_flow,
    deltaCMin/4);
  CMax_flow :=Buildings.Utilities.Math.Functions.smoothMax(
    C1_flow,
    C2_flow,
    deltaCMax/4);
  // CMin and CMax, constrained to be non-zero to compute eps-NTU-Z relationship
  CMinNZ_flow :=Buildings.Utilities.Math.Functions.smoothMax(
    CMin_flow,
    deltaCMin,
    deltaCMin/4);
  CMaxNZ_flow :=Buildings.Utilities.Math.Functions.smoothMax(
    CMax_flow,
    deltaCMax,
    deltaCMax/4);
  Z := CMin_flow/CMaxNZ_flow;
  // Gain that goes to zero as CMin_flow gets below deltaCMin
  // This is needed to allow zero flow
  gai := Buildings.Utilities.Math.Functions.spliceFunction(
           pos=1,
           neg=0,
           x=CMin_flow-deltaCMin,
           deltax=deltaCMin/2);
  if (gai == 0) then
    NTU := 0;
    eps := 1; // around zero flow, eps=Q/(CMin*dT) should be one
  else
    NTU :=gai*UA/CMinNZ_flow;
    eps := gai*Buildings.Fluid.HeatExchangers.BaseClasses.epsilon_ntuZ(
                  NTU=NTU,
                  Z=Z,
                  flowRegime=flowRegime);
  end if;

  annotation(preferredView="info",
           smoothOrder=1,
           Documentation(info="<html>
<p>
This function computes the heat exchanger effectiveness,
the Number of Transfer Units, and the capacity flow ratio
for given capacity flow rates.
</p>
<p>
The implementation allows for zero flow rate.
As <code>CMin_flow</code> crosses <code>delta*CMin_flow_nominal</code> from above,
the Number of Transfer Units and the heat exchanger effectiveness go to zero.
</p>
<p>
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
This was done to have the same argument list as
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.epsilon_ntuZ\">
Buildings.Fluid.HeatExchangers.BaseClasses.epsilon_ntuZ</a>,
in which the type had to be changed.
</li>
<li>
July 6, 2014, by Michael Wetter:<br/>
Removed unused <code>import</code> statement.
</li>
<li>
February 20, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end epsilon_C;

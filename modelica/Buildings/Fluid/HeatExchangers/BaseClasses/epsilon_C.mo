within Buildings.Fluid.HeatExchangers.BaseClasses;
function epsilon_C
  "Computes heat exchanger effectiveness for given capacity flow rates and heat exchanger flow regime"
  import f = Buildings.Fluid.Types.HeatExchangerFlowRegime;
  input Modelica.SIunits.ThermalConductance UA "UA value";
  input Modelica.SIunits.ThermalConductance C1_flow
    "Enthalpy flow rate medium 1";
  input Modelica.SIunits.ThermalConductance C2_flow
    "Enthalpy flow rate medium 2";
  input Buildings.Fluid.Types.HeatExchangerFlowRegime flowRegime
    "Heat exchanger flow regime";
  input Modelica.SIunits.ThermalConductance CMin_flow_nominal
    "Minimum enthalpy flow rate at nominal condition";
  input Modelica.SIunits.ThermalConductance CMax_flow_nominal
    "Maximum enthalpy flow rate at nominal condition";
  input Real delta = 1E-3 "Small value used for smoothing";
  output Real eps(min=0, max=1) "Heat exchanger effectiveness";
  output Real NTU "Number of transfer units";
  output Real Z(min=0, max=1) "Ratio of capacity flow rate (CMin/CMax)";
protected
  Modelica.SIunits.ThermalConductance delta_C
    "Small number for capacity flow rate";
  Modelica.SIunits.ThermalConductance CMin_flow "Minimum capacity flow rate";
  Modelica.SIunits.ThermalConductance CMax_flow "Maximum capacity flow rate";
  Modelica.SIunits.ThermalConductance CMinNZ_flow
    "Minimum capacity flow rate, bounded away from zero";
  Modelica.SIunits.ThermalConductance CMaxNZ_flow
    "Maximum capacity flow rate, bounded away from zero";

algorithm
  delta_C := delta*(C1_flow + C2_flow);
  // effectiveness
  CMin_flow :=Buildings.Utilities.Math.Functions.smoothMin(
    C1_flow,
    C2_flow,
    delta_C);
  CMax_flow :=Buildings.Utilities.Math.Functions.smoothMax(
    C1_flow,
    C2_flow,
    delta_C);
  // CMin and CMax, constrained to be non-zero to compute eps-NTU-Z relationship
  CMinNZ_flow :=Buildings.Utilities.Math.Functions.smoothMax(
    CMin_flow,
    delta*CMin_flow_nominal,
    delta*CMin_flow_nominal/2);
  CMaxNZ_flow :=Buildings.Utilities.Math.Functions.smoothMax(
    CMax_flow,
    delta*CMax_flow_nominal,
    delta*CMax_flow_nominal/2);
  Z :=CMinNZ_flow/CMaxNZ_flow;
  // NTU value that will be used in the dry coil computation
  NTU :=UA/CMinNZ_flow;
  eps := Buildings.Fluid.HeatExchangers.BaseClasses.epsilon_ntuZ(NTU=NTU, Z=Z, flowRegime=flowRegime);
  annotation(preferedView="info",
           smoothOrder=1,
           Documentation(info="<html>
This function computes the heat exchanger effectiveness,
the Number of Transfer Units, and the capacity flow ratio
for given capacity flow rates.
</p>
<p>
The implementation allows for zero flow rate.
</html>",
revisions="<html>
<ul>
<li>
February 20, 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end epsilon_C;

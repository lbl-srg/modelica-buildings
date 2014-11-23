within Buildings.Fluid.Movers.Data;
record Generic "Generic data record for pumps and fans"
  extends Modelica.Icons.Record;
  parameter Modelica.SIunits.Conversions.NonSIunits.AngularVelocity_rpm N_nominal = 3000
    "Nominal rotational speed for flow characteristic";
  parameter Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters pressure
    "Volume flow rate vs. total pressure rise"
    annotation(Evaluate=true);
  parameter
    Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters
    hydraulicEfficiency(
      V_flow=pressure.V_flow,
      eta={0.7 for i in 1:size(pressure.V_flow,1)}) "Hydraulic efficiency";
  parameter
    Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters
    motorEfficiency(
      V_flow=pressure.V_flow,
      each eta={0.7 for i in 1:size(pressure.V_flow,1)})
    "Electric motor efficiency";
  // Power requires default values to avoid in Dymola the message
  // Failed to expand the variable Power.V_flow
  parameter Buildings.Fluid.Movers.BaseClasses.Characteristics.powerParameters power(
    V_flow={0},
    P={0}) "Volume flow rate vs. electrical power consumption";
  parameter Boolean motorCooledByFluid=true
    "If true, then motor heat is added to fluid stream";
  parameter Boolean use_powerCharacteristic=false
    "Use powerCharacteristic instead of efficiencyCharacteristic";

//protected
//  final parameter Real d[:] = Buildings.Utilities.Math.Functions.splineDerivatives(
//      x=power.V_flow,
//      y=power.P) "Spline coefficients for power";
  annotation (Documentation(
info="<html>
<p>
Record containing parameters for pumps or fans as can be found in data sheets. 
</p>
<p>
This record may be used to assign for example fan performance data using
declaration such as
<pre>
  Buildings.Fluid.Movers.FlowMachine_y fan(
      redeclare package Medium = Medium,
      per(pressure(V_flow={0,m_flow_nominal,2*m_flow_nominal}/1.2,
                   dp={2*dp_nominal,dp_nominal,0}))) \"Fan\";
</pre>
</p>
<p>
An example that uses manufacturer data can be found in
<a href=\"modelica://Buildings.Fluid.Movers.Examples.FlowMachine_Nrpm_Data\">
Buildings.Fluid.Movers.Examples.FlowMachine_Nrpm_Data</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
November 22, 2014 by Michael Wetter:<br/>
Removed computation of efficiency based on power usage that was
implemented by Filip Jorrison because
users may not enter a default efficiency in which case the power
computation will be used. However, if users set <code>use_powerCharacteristic=false</code>,
then the efficiency computation resulted in a division by zero.
Furthermore, if a user specifies that the power consumption is zero at
zero flow (which needs to be to avoid the pump from overheating),
then the efficiency at zero volume flow rate also yields a division by zero.
</li>
<li>June 16, 2014 by Michael Wetter:<br/>
Set <code>Evaluate=true</code> annotation for <code>pressure</code> to avoid
the translation warning
<pre>
The parameter per.pressure.V_flow has some elements
per.pressure.V_flow[2]

which were fixed to constants,
since they control structural properties such as sizes of arrays.
</pre>
See <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/209#issuecomment-46109021\">
https://github.com/lbl-srg/modelica-buildings/issues/209#issuecomment-46109021</a>.
</li>
<li>April 17, 2014 by Filip Jorissen:<br/>
Initial version.
</li>
</ul>
</html>"));
end Generic;

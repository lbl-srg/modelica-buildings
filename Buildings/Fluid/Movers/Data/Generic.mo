within Buildings.Fluid.Movers.Data;
record Generic "Generic data record for pumps and fans"
  extends Modelica.Icons.Record;
  parameter Modelica.SIunits.Conversions.NonSIunits.AngularVelocity_rpm
    N_nominal "Nominal rotational speed for flow characteristic";
  parameter Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters pressure
    "Volume flow rate vs. total pressure rise"
    annotation(Evaluate=true);
  parameter
    Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters
    hydraulicEfficiency(
      V_flow=pressure.V_flow,
      eta=sqrt(pressure.V_flow.*pressure.dp./
          {Buildings.Fluid.Movers.BaseClasses.Characteristics.power(
             per=power,
             V_flow=i,
             r_N=1,
             delta=0.01,
             d=d) for i in pressure.V_flow})) "Hydraulic efficiency";
  parameter
    Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters
    motorEfficiency(
      V_flow=pressure.V_flow,
      eta=sqrt(pressure.V_flow.*pressure.dp./
          {Buildings.Fluid.Movers.BaseClasses.Characteristics.power(
            per=power,
            V_flow=i,
            r_N=1,
            delta=0.01,
            d=d) for i in pressure.V_flow})) "Electric motor efficiency";
  parameter Buildings.Fluid.Movers.BaseClasses.Characteristics.powerParameters power
    "Volume flow rate vs. electrical power consumption";
  parameter Boolean motorCooledByFluid=true
    "If true, then motor heat is added to fluid stream";
  parameter Boolean use_powerCharacteristic=false
    "Use powerCharacteristic instead of efficiencyCharacteristic";

protected
  final parameter Real d[:] = if ( size(power.V_flow, 1) == 1)  then
      {0}
   else
      Buildings.Utilities.Math.Functions.splineDerivatives(
      x=power.V_flow,
      y=power.P);

  annotation (Documentation(revisions="<html>
<ul>
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
<li>April 17, 2014
    by Filip Jorissen:<br/>
       Initial version.
</li>
</ul>
</html>", info="<html>
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
</html>"));
end Generic;

within Buildings.Templates.Utilities;
function computeBalancingPressureDrop
  "Compute the design pressure drop of a balancing valve"
  extends Modelica.Icons.Function;
  input Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Design mass flow rate (target)";
  input Modelica.Units.SI.PressureDifference dp_nominal
    "Pressure drop of equipment in series at design flow rate";
  input Buildings.Templates.Components.Data.PumpSingle datPum
    "Pump parameters";
  input Real r_N(unit="1")=1
    "Relative revolution, r_N=N/N_nominal";
  output Modelica.Units.SI.PressureDifference dpBal_nominal
    "Pressure drop of balancing valve at design flow rate";
protected
  Modelica.Units.SI.PressureDifference dpPum_nominal =
    Buildings.Fluid.Movers.BaseClasses.Characteristics.pressure(
    V_flow=m_flow_nominal / datPum.rho_default,
    r_N=r_N,
    d=Buildings.Utilities.Math.Functions.splineDerivatives(
      x=datPum.per.pressure.V_flow,
      y=datPum.per.pressure.dp),
    dpMax=max(datPum.per.pressure.dp),
    V_flow_max=max(datPum.per.pressure.V_flow),
    per=Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParametersInternal(
      n=size(datPum.per.pressure.V_flow, 1),
      V_flow=datPum.per.pressure.V_flow,
      dp=datPum.per.pressure.dp))
    "Pump head at target design flow";
algorithm
  dpBal_nominal := dpPum_nominal - dp_nominal;
  annotation (Documentation(info="<html>
<p>
Given the design mass flow rate, the design pressure drop
of all equipment in series, the pump parameters and the 
pump speed, the function returns the pressure drop
of a balancing valve at design flow, so that the total 
pressure drop is equal to the pump head.
</p>
<p>
The model 
<a href=\"modelica://Buildings.Templates.Plants.HeatPumps.Components.Validation.PumpsPrimaryDedicated\">
Buildings.Templates.Plants.HeatPumps.Components.Validation.PumpsPrimaryDedicated</a>
serves as a validation model for this function and illustrates how the function
can be used to calculate either the design pressure drop of balancing 
valves or the primary pump speed required to provide the design flow.
</p>
</html>"));
end computeBalancingPressureDrop;

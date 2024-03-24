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
end computeBalancingPressureDrop;

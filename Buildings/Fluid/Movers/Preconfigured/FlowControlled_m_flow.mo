within Buildings.Fluid.Movers.Preconfigured;
model FlowControlled_m_flow "FlowControlled_m_flow with pre-filled parameters"
  extends Buildings.Fluid.Movers.FlowControlled_m_flow(
    final per(
            PowerOrEfficiencyIsHydraulic=true,
            etaHydMet=Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.EulerNumber,
            etaMotMet=Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.GenericCurve),
    final constantMassFlowRate,
    final massFlowRates,
    final addPowerToMedium=false,
    final nominalValuesDefineDefaultPressureCurve=true,
    final inputType=Buildings.Fluid.Types.InputType.Continuous,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial);
end FlowControlled_m_flow;

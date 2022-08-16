within Buildings.Fluid.Movers.Preconfigured;
model FlowControlled_dp "FlowControlled_dp with pre-filled parameters"
  extends Buildings.Fluid.Movers.FlowControlled_dp(
    final per(
            PowerOrEfficiencyIsHydraulic=true,
            etaHydMet=Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.EulerNumber,
            etaMotMet=Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.GenericCurve),
    final constantHead,
    final heads,
    final addPowerToMedium=false,
    final nominalValuesDefineDefaultPressureCurve=true,
    final inputType=Buildings.Fluid.Types.InputType.Continuous,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial);
end FlowControlled_dp;

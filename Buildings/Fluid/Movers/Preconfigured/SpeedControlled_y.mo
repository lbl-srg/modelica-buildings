within Buildings.Fluid.Movers.Preconfigured;
model SpeedControlled_y "SpeedControlled_y with pre-filled parameters"
  extends Buildings.Fluid.Movers.SpeedControlled_y(
    final per(
            pressure(V_flow=m_flow_nominal/rho_default*{0,1,2},
                     dp=dp_nominal*{2,1,0}),
            PowerOrEfficiencyIsHydraulic=true,
            etaHydMet=Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.EulerNumber,
            etaMotMet=Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.GenericCurve),
    final addPowerToMedium=false,
    final inputType=Buildings.Fluid.Types.InputType.Continuous,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial);

  parameter Modelica.Units.SI.PressureDifference dp_nominal
    "Nominal pressure head for preconfiguration"
    annotation(Dialog(group="Nominal condition"));

end SpeedControlled_y;

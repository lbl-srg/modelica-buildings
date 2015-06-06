within Buildings.OpenStudioToModelica.InternalHeatGains.Schedules.Fixed;
model PlugLoads "Internal heat gains due to plug loads"
extends
    Buildings.OpenStudioToModelica.InternalHeatGains.Schedules.BaseClasses.SimplePowerDensitySchedule;
  parameter Modelica.SIunits.HeatFlux PPlu
    "Installed plug load power per unit area";
equation
  P_nominal = PPlu*ATot;
end PlugLoads;

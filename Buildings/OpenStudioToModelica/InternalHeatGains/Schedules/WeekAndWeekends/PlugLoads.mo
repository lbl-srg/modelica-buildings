within Buildings.OpenStudioToModelica.InternalHeatGains.Schedules.WeekAndWeekends;
model PlugLoads "Internal heat gains due to plug loads"
extends
    Buildings.OpenStudioToModelica.InternalHeatGains.Schedules.BaseClasses.PowerDensitySchedule;
  parameter Modelica.SIunits.HeatFlux PPlu
    "Installed plug load power per unit area";
equation
  P_nominal = PPlu*ATot;
end PlugLoads;

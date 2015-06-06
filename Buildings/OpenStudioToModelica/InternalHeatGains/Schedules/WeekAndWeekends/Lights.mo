within Buildings.OpenStudioToModelica.InternalHeatGains.Schedules.WeekAndWeekends;
model Lights "Internal heat gains due to lighting systems"
  extends
    Buildings.OpenStudioToModelica.InternalHeatGains.Schedules.BaseClasses.PowerDensitySchedule;
  parameter Modelica.SIunits.HeatFlux PLig "Lights power per unit area";
equation
  P_nominal = PLig*ATot;
end Lights;

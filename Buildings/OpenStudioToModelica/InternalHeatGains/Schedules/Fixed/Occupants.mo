within Buildings.OpenStudioToModelica.InternalHeatGains.Schedules.Fixed;
model Occupants "Internal heat gains due to occupants"
  extends
    Buildings.OpenStudioToModelica.InternalHeatGains.Schedules.BaseClasses.SimplePowerDensitySchedule;
  parameter Real nOcc "Number of buildings occupants per unit area";
  parameter Modelica.SIunits.Power PPer "Power per occupant";
equation
  P_nominal = PPer*nOcc*ATot;
end Occupants;

within Buildings.Examples.Schedules;
model CoolingAvailability "Schedule for cooling coil availability"
  extends Modelica.Blocks.Sources.CombiTimeTable(
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    table=[0,0.0; 8*3600,0.0; 8*3600,1.0; 18*3600,1.0; 18*3600,0.0; 24*3600,0.0],
    columns={2});
end CoolingAvailability;

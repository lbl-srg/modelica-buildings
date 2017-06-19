within Buildings.Examples.Schedules;
model TSetCoo "Schedule of cooling setpoint temperature"
  extends Modelica.Blocks.Sources.CombiTimeTable(
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    table=[0,30+273.15; 8*3600,30+273.15; 8*3600,25+273.15; 18*3600,25+273.15; 18*3600,30+273.15; 24*3600,30+273.15],
    columns={2});
end TSetCoo;

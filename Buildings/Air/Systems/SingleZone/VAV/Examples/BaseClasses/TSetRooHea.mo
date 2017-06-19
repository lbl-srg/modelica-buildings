within Buildings.Air.Systems.SingleZone.VAV.Examples.BaseClasses;
model TSetRooHea "Schedule of heating setpoint temperature"
  extends Modelica.Blocks.Sources.CombiTimeTable(
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    table=[0,15+273.15; 8*3600,15+273.15; 8*3600,20+273.15; 18*3600,20+273.15; 18*3600,15+273.15; 24*3600,15+273.15],
    columns={2});
end TSetRooHea;

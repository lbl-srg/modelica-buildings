within Buildings.Examples.ScalableBenchmarks.BuildingVAV.BaseClasses;
model CoolSetpoint "Schedule for cooling setpoint"
  extends Modelica.Blocks.Sources.CombiTimeTable(
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    table=[0,273.15+32.0; 8*3600,273.15+27.0; 18*3600,273.15+32.0; 24*3600,273.15+32.0],
    columns={2});
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This block defines room air cooling setpoints.
</p>
</html>"));
end CoolSetpoint;

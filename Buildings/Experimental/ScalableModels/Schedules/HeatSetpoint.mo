within Buildings.Experimental.ScalableModels.Schedules;
model HeatSetpoint "Schedule for heating setpoint"
  extends Modelica.Blocks.Sources.CombiTimeTable(
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    table=[
      0,       273.15+13.0;
      8*3600,  273.15+20.0;
      18*3600, 273.15+13.0;
      24*3600, 273.15+13.0],
    columns={2});
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Schedule for heating setpoint temperature.
</p>
</html>", revisions="<html>
<ul>
<li>
June 16, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end HeatSetpoint;

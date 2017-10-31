within Buildings.Examples.ScalableBenchmarks.BuildingVAV.BaseClasses;
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

  annotation (
    Documentation(info="<html>
<p>
This block defines room air heating setpoints.
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

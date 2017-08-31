within Buildings.Examples.ScalableBenchmarks.BuildingVAV.BaseClasses;
model IntLoad "Schedule for time varying internal loads"
  extends Modelica.Blocks.Sources.CombiTimeTable(
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    table=[
      0,       0.1;
      8*3600,  1.0;
      18*3600, 0.1;
      24*3600, 0.1],
    columns={2});
  annotation (Documentation(info="<html>
<p>
This block defines schedule of internal load.
</p>
</html>", revisions="<html>
<ul>
<li>
June 16, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end IntLoad;

within Buildings.Air.Systems.SingleZone.VAV.Examples.BaseClasses;
model InternalLoads "Schedule for time varying internal loads"
  extends Modelica.Blocks.Sources.CombiTimeTable(
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    table=[
      0,0.1;
      8*3600,0.1;
      8*3600,1.0;
      18*3600,1.0;
      18*3600,0.1;
      24*3600,0.1],
    columns={2});
  annotation (Documentation(info="<html>
<p>
Internal load profile for the thermal zone.
</p>
</html>", revisions="<html>
<ul>
<li>
June 1, 2017, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"));
end InternalLoads;

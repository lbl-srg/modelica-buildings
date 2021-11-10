within Buildings.Examples.ScalableBenchmarks.ZoneScaling.MixedAir;
model Large10Floors
  "Model of a large building with 10 floors and 50 conditioned zones"
  extends
    Buildings.Examples.ScalableBenchmarks.ZoneScaling.MixedAir.Large2Floors(      numFlo=10)
    annotation (
experiment(
      StartTime=432000,
      StopTime=864000,
      Tolerance=1e-05),
Documentation(info="<html>
</html>", revisions="<html>
<ul>
<li>
March 25, 2021, by Baptiste Ravache:<br/>
First implementation.
</li>
</ul>
</html>"));

  annotation (Documentation(revisions="<html>
<ul>
<li>
March 25, 2021, by Baptiste Ravache:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Example model of a large office building with 50 thermal zones
that are supplied by 10 multizone VAV air handling units.<br/>
The thermal zones are modeled using
<a href=\"modelica://Buildings.ThermalZones.Detailed.MixedAir\">
Buildings.ThermalZones.Detailed.MixedAir</a> objects.
</p>
</html>"));
end Large10Floors;

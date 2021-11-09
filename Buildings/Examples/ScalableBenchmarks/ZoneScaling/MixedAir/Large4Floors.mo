within Buildings.Examples.ScalableBenchmarks.ZoneScaling.MixedAir;
model Large4Floors
  "Open loop model of a large building with 4 floors and 15 zones"
  extends Buildings.Examples.ScalableBenchmarks.ZoneScaling.MixedAir.Large2Floors(final numFlo=4);

    annotation (
experiment(
      StopTime=432000,
      Tolerance=1e-05,
      __Dymola_Algorithm="Cvode"),
Documentation(info="<html>
</html>", revisions="<html>
<ul>
<li>
March 25, 2021, by Baptiste Ravache:<br/>
First implementation.
</li>
</ul>
</html>"));
end Large4Floors;

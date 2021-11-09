within Buildings.Examples.ScalableBenchmarks.ZoneScaling.EnergyPlus;
model Large10Floors
  "Open loop model of a large building with 10 floors and 50 zones"
  extends Buildings.Examples.ScalableBenchmarks.ZoneScaling.EnergyPlus.Large2Floors(final numFlo=10);

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
end Large10Floors;

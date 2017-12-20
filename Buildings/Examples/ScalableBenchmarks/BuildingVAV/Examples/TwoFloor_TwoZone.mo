within Buildings.Examples.ScalableBenchmarks.BuildingVAV.Examples;
model TwoFloor_TwoZone "Closed-loop model with 2 zone in 2 floor"
  extends Buildings.Examples.ScalableBenchmarks.BuildingVAV.Examples.OneFloor_OneZone(
    nFlo=2,
    nZon=2);

annotation (
  experiment(StopTime=604800, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Examples/ScalableBenchmarks/BuildingVAV/Examples/TwoFloor_TwoZone.mos"
        "Simulate and plot"),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-360,-120},{140,200}})),
  Documentation(info="<html>
<p>
The model demonstrates the scalability of model
<a href=\"modelica://Buildings.Examples.ScalableBenchmarks.BuildingVAV.Examples.OneFloor_OneZone\">
Buildings.Examples.ScalableBenchmarks.BuildingVAV.Examples.OneFloor_OneZone</a>
by setting it to be a multizone model with 2 zones in 2 floor, i.e.
<code>nFlo=2, nZon=2</code>.
</p></html>", revisions="<html>
<ul>
<li>
June 16, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end TwoFloor_TwoZone;

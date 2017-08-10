within Buildings.Examples.ScalableBenchmarks.BuildingVAV.Examples;
model TwoFloor_TwoZone "Building model with 2 zone in 2 floor"
  extends
<<<<<<< HEAD:Buildings/Examples/ScalableBenchmarks/BuildingVAV/Examples/TwoFloor_TwoZone.mo
    Buildings.Examples.ScalableBenchmarks.BuildingVAV.Examples.OneFloor_OneZone(
      nFlo=2, nZon=2);
=======
    Buildings.Experimental.ScalableModels.ScalableBuildingModels.MultiFloorWithVAV(
     nFlo=2,
     nZon=2);
>>>>>>> 5b164ea632946bb56b1d0872367ab85832801162:Buildings/Experimental/ScalableModels/ScalableDemos/ScalableDemo_2Floor_2Zone.mo

annotation (
  experiment(StopTime=604800, Tolerance=1e-06,__Dymola_Algorithm="Radau"),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Examples/ScalableBenchmarks/BuildingVAV/Examples/TwoFloor_TwoZone.mos"
        "Simulate and plot"),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-360,-120},{140,200}})),
  Documentation(info="<html>
<p>
The model demonstrates the scalability of model 
<a href=\"modelica://Buildings.Examples.ScalableBenchmarks.Examples.OneFloor_OneZone\">
Buildings.Examples.ScalableBenchmarks.Examples.OneFloor_OneZone</a> 
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

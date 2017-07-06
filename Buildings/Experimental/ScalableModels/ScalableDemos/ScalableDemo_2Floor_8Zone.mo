within Buildings.Experimental.ScalableModels.ScalableDemos;
model ScalableDemo_2Floor_8Zone
  extends
    Buildings.Experimental.ScalableModels.ScalableBuildingModels.MultiFloorWithVAV(
     nFlo=2, nZon=8);

annotation (
  experiment(StopTime=604800, Tolerance=1e-06,__Dymola_Algorithm="Radau"),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/ScalableModels/ScalableDemos/ScalableDemo_2Floor_8Zone.mos"
        "Simulate and plot"),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-360,-120},{140,200}})),
  Documentation(info="<html>
<p>
The model demonstrates the scalability of model 
<a href=\"modelica://Buildings.Experimental.ScalableModels.ScalableBuildingModels.MultiFloorWithVAV\">
Buildings.Experimental.ScalableModels.ScalableBuildingModels.MultiFloorWithVAV</a> 
by setting it to be a multizone model with 8 zones in each of the 2 floors, i.e.
<code>nFlo=2, nZon=8</code>.
</p></html>", revisions="<html>
<ul>
<li>
June 16, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ScalableDemo_2Floor_8Zone;

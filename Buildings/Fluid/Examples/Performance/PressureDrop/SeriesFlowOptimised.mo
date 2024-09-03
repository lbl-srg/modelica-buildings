within Buildings.Fluid.Examples.Performance.PressureDrop;
model SeriesFlowOptimised
  "Series connection with prescribed flow and optimised parameters"
  extends SeriesFlow(resSeries(each from_dp=false));
  annotation (Documentation(revisions="<html>
<ul>
<li>
May 26, 2017, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Example model that demonstrates how translation statistics
depend on the type of boundary conditions,
the parallel or series configuration of the components
and the value of parameter <code>from_dp</code>.
</p>
</html>"), experiment(Tolerance=1e-6, StopTime=1), __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Examples/Performance/PressureDrop/SeriesFlowOptimised.mos"
        "Simulate and plot"));
end SeriesFlowOptimised;

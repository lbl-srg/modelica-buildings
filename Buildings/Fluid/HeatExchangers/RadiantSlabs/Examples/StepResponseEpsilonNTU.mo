within Buildings.Fluid.HeatExchangers.RadiantSlabs.Examples;
model StepResponseEpsilonNTU
  "Model that tests the radiant slab with epsilon-NTU configuration"
  extends StepResponse(
   sla(nSeg=1,
       use_epsilon_NTU=true));
 annotation(__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/RadiantSlabs/Examples/StepResponseEpsilonNTU.mos"
        "Simulate and plot"),
          Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-120},
            {100,100}})),
Documentation(info="<html>
<p>
This model is identical to
<a href=\"modelica://Buildings.Fluid.HeatExchangers.RadiantSlabs.Examples.StepResponse\">
Buildings.Fluid.HeatExchangers.RadiantSlabs.Examples.StepResponse</a>
except that the number of segments in the slab is set to <i>1</i>
and the heat transfer between the fluid and the slab is computed using
an epsilon-NTU model.
</p>
</html>",
revisions="<html>
<ul>
<li>
October 7, 2014, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(
      StopTime=86400,
      Tolerance=1e-05));
end StepResponseEpsilonNTU;

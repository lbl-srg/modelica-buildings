within Buildings.Fluid.HeatExchangers.RadiantSlabs.Examples;
model StepResponseFiniteDifference "Model that tests the radiant slab"
  extends
    Buildings.Fluid.HeatExchangers.RadiantSlabs.Examples.StepResponseEpsilonNTU(
    sla(heatTransfer=Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.HeatTransfer.FiniteDifference));
 annotation(__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/RadiantSlabs/Examples/StepResponseFiniteDifference.mos"
        "Simulate and plot"),
          Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-120},
            {100,100}})),
Documentation(info="<html>
<p>
This example models the step response of a radiant slab.
</p>
</html>",
revisions="<html>
<ul>
<li>
October 11, 2013, by Michael Wetter:<br/>
Added missing <code>parameter</code> keyword in the declaration of the data record.
</li>
<li>
April 5, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(
      StopTime=86400,
      Tolerance=1e-05));
end StepResponseFiniteDifference;

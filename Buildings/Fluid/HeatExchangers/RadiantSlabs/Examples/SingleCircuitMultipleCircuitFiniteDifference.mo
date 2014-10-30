within Buildings.Fluid.HeatExchangers.RadiantSlabs.Examples;
model SingleCircuitMultipleCircuitFiniteDifference
  "Model that tests the radiant slab with multiple parallel circuits"
  extends
    Buildings.Fluid.HeatExchangers.RadiantSlabs.Examples.SingleCircuitMultipleCircuitEpsilonNTU(
    sla1(heatTransfer=Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.HeatTransfer.FiniteDifference),
    sla2(heatTransfer=Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.HeatTransfer.FiniteDifference),
    sla3(heatTransfer=Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.HeatTransfer.FiniteDifference));

 annotation(__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/RadiantSlabs/Examples/SingleCircuitMultipleCircuitFiniteDifference.mos"
        "Simulate and plot"),
          Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-140,-160},
            {160,160}})),
Documentation(info="<html>
<p>
This example compares the results of two models of a single circuit that are arranged in
parallel, versus a model that directly implements two parallel circuits.
Both configurations have the same mass flow rate and temperatures.
For simplicity, a combined convective and radiative resistance
which is independent of the temperature difference has been used.
The model is exposed to a step change in pressure, which causes forward and reverse
flow.
</p>
</html>",
revisions="<html>
<ul>
<li>
October 11, 2013, by Michael Wetter:<br/>
Added missing <code>parameter</code> keyword in the declaration of the data record.
</li>
<li>
June 27, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(
      StopTime=86400,
      Tolerance=1e-05));
end SingleCircuitMultipleCircuitFiniteDifference;

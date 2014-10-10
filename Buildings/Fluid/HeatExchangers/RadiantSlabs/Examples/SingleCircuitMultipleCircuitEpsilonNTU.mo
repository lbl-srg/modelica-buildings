within Buildings.Fluid.HeatExchangers.RadiantSlabs.Examples;
model SingleCircuitMultipleCircuitEpsilonNTU
  "Model that tests the radiant slab with multiple parallel circuits and epsilon-NTU configuration"
  extends SingleCircuitMultipleCircuit(
    nSeg=1,
    sla1(use_epsilon_NTU=true),
    sla2(use_epsilon_NTU=true),
    sla3(use_epsilon_NTU=true));

 annotation(__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/RadiantSlabs/Examples/SingleCircuitMultipleCircuitEpsilonNTU.mos"
        "Simulate and plot"),
          Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-120},
            {100,100}})),
Documentation(info="<html>
<p>
This model is identical to
<a href=\"modelica://Buildings.Fluid.HeatExchangers.RadiantSlabs.Examples.SingleCircuitMultipleCircuit\">
Buildings.Fluid.HeatExchangers.RadiantSlabs.Examples.SingleCircuitMultipleCircuit</a>
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
end SingleCircuitMultipleCircuitEpsilonNTU;

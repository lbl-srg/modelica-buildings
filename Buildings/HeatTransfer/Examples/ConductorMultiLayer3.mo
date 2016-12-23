within Buildings.HeatTransfer.Examples;
model ConductorMultiLayer3
  "Test model for multi layer heat conductor with one
  state added at the surfaces a and b of the construction"
  extends ConductorMultiLayer;
  annotation (experiment(StartTime=0, StopTime=86400, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/HeatTransfer/Examples/ConductorMultiLayer3.mos" "Simulate and plot"),
  Documentation(revisions="<html>
<ul>
<li>
December 6 2016, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This example is similar to <a href=\"modelica://Buildings.HeatTransfer.Examples.ConductorMultiLayer\">
Buildings.HeatTransfer.Examples.ConductorMultiLayer</a>. The main difference
is that a state is added at the surfaces a and b of the construction.
</p>
</html>"));
end ConductorMultiLayer3;

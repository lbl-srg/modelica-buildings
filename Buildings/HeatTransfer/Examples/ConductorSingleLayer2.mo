within Buildings.HeatTransfer.Examples;
model ConductorSingleLayer2
    "Test model for single layer heat conductor without
  states added at the surfaces of the construction"
  extends ConductorSingleLayer(
    con(stateAtSurface_a=false, stateAtSurface_b=false),
    con1(stateAtSurface_a=false, stateAtSurface_b=false),
    con2(stateAtSurface_a=false, stateAtSurface_b=false));
  annotation (experiment(StartTime=0, StopTime=86400, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/HeatTransfer/Examples/ConductorSingleLayer2.mos" "Simulate and plot"),
  Documentation(revisions="<html>
<ul>
<li>
December 14 2016, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This example is similar to <a href=\"modelica://Buildings.HeatTransfer.Examples.ConductorSingleLayer\">
Buildings.HeatTransfer.Examples.ConductorSingleLayer</a>. The main difference
is that there are no states at the surfaces of the construction.
</p>
</html>"));
end ConductorSingleLayer2;

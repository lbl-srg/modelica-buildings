within Buildings.Fluid.Examples.FlowSystem;
model Simplified3 "Neglecting pressure drop in splitters"
  extends Simplified2(
    spl(dp_nominal={1000,0,0}),
    spl1(dp_nominal={0,0,0}),
    spl3(dp_nominal={0,0,0}),
    spl2(dp_nominal={1000,0,0}));
  annotation (Documentation(info="<html>
<p>
The model is further simplified by removing some small pressure drops in the bypass.
This allows the solver to identify sub-circuits.
</p>
</html>", revisions="<html>
<ul>
<li>
October 7, 2016, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(Tolerance=1e-6, StopTime=1000),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Examples/FlowSystem/Simplified3.mos"
        "Simulate and plot"));
end Simplified3;

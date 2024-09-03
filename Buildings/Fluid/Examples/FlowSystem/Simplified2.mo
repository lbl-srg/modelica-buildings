within Buildings.Fluid.Examples.FlowSystem;
model Simplified2 "Using from_dp"
  extends Simplified1(
    valSouth1(each from_dp=true),
    valSouth2(each from_dp=true),
    valNorth1(each from_dp=true),
    valNorth2(each from_dp=true));
  annotation (Documentation(info="<html>
<p>
The model is simplified: using <code>from_dp</code> to find more efficient tearing variables.
</p>
</html>", revisions="<html>
<ul>
<li>
December 14, 2016, by Michael Wetter:<br/>
Added missing <code>each</code> keyword.
</li>
<li>
October 7, 2016, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(Tolerance=1e-6, StopTime=1000),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Examples/FlowSystem/Simplified2.mos"
        "Simulate and plot"));
end Simplified2;

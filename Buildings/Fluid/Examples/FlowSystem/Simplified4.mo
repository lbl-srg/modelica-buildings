within Buildings.Fluid.Examples.FlowSystem;
model Simplified4 "Removed valve dynamics"
  extends Simplified3(
    valNorth(each filteredOpening=false),
    valSouth(each filteredOpening=false),
    pmpNorth(
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
      massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
      filteredSpeed=false),
    pmpSouth(
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
      massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
      filteredSpeed=false),
    valSouth1(each filteredOpening=false),
    valSouth2(each filteredOpening=false),
    valNorth1(each filteredOpening=false),
    valNorth2(each filteredOpening=false),
    pumpHea(filteredSpeed=false),
    pumpCoo(filteredSpeed=false),
    valCoo(filteredOpening=false),
    valHea(filteredOpening=false));
  annotation (Documentation(info="<html>
<p>
The model is further simplified by removing the valve and pump control dynamics.
</p>
</html>", revisions="<html>
<ul>
<li>
December 14, 2016, by Michael Wetter:<br/>
Added missing <code>each</code> keywords.
</li>
<li>
October 7, 2016, by Filip Jorissen:<br/>
First implementation.
</li>
</ul>
</html>"), __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/Examples/FlowSystem/Simplified4.mos"
        "Simulate and plot"));
end Simplified4;

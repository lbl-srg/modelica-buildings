within Buildings.Fluid.Examples.FlowSystem;
model Simplified4 "Removed valve dynamics"
  extends Simplified3(
    valNorth(each use_input_filter=false),
    valSouth(each use_input_filter=false),
    pmpNorth(
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
      massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
      use_input_filter=false),
    pmpSouth(
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
      massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
      use_input_filter=false),
    valSouth1(each use_input_filter=false),
    valSouth2(each use_input_filter=false),
    valNorth1(each use_input_filter=false),
    valNorth2(each use_input_filter=false),
    pumpHea(use_input_filter=false),
    pumpCoo(use_input_filter=false),
    valCoo(use_input_filter=false),
    valHea(use_input_filter=false));
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

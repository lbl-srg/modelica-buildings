within Buildings.Fluid.Actuators.Valves.Data;
record Linear = Generic (
    y =  {0, 1},
    phi = {0.0001, 1}) "Linear opening curve"
  annotation (
defaultComponentName="datValLin",
Documentation(info="<html>
<p>
Linear valve opening characteristics with 
a normalized leakage flow rate of <i>0.0001</i>.
</p>
<p>
<b>Note</b>: This record is only for demonstration,
as the implementation in 
<a href=\"modelica://Buildings.Fluid.Actuators.Valves.TwoWayLinear\">
Buildings.Fluid.Actuators.Valves.TwoWayLinear</a>
is more efficient.
</p>
</html>", revisions="<html>
<ul>
<li>
March 27, 2014, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));

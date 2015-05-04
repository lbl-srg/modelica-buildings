within Buildings.Fluid.Actuators.Valves;
model TwoWayLinear "Two way valve with linear flow characteristics"
  extends BaseClasses.PartialTwoWayValveKv(phi=l + y_actual*(1 - l));

initial equation
  // Since the flow model Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow computes
  // 1/k^2, the parameter l must not be zero.
  assert(l > 0, "Valve leakage parameter l must be bigger than zero.");
annotation (
defaultComponentName="val",
Documentation(info="<html>
<p>
Two way valve with linear opening characteristic.
</p><p>
This model is based on the partial valve model
<a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve\">
Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve</a>.
Check this model for more information, such
as the regularization near the origin.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 4, 2014, by Michael Wetter:<br/>
Moved the assignment of the flow function <code>phi</code>
to the model instantiation because in its base class,
the keyword <code>input</code>
has been added to the variable <code>phi</code>.
</li>
<li>
March 27, 2014 by Michael Wetter:<br/>
Revised model for implementation of new valve model that computes the flow function
based on a table.
</li>
<li>
February 20, 2012 by Michael Wetter:<br/>
Renamed parameter <code>dp_nominal</code> to <code>dpValve_nominal</code>,
and added new parameter <code>dpFixed_nominal=0</code>.
See
<a href=\"modelica://Buildings.Fluid.Actuators.UsersGuide\">
Buildings.Fluid.Actuators.UsersGuide</a>.
</li>
<li>
June 3, 2008 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end TwoWayLinear;

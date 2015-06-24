within Buildings.Fluid.Actuators.Valves.Data;
record Generic "Generic record for valve parameters"
  extends Modelica.Icons.Record;
  parameter Real y[:](each min=0, each max=1)
    "Valve position, starting with 0 and ending with 1";
  parameter Real phi[size(y,1)](each min=0, each max=1)
    "Normalized volume flow rates for the positions y";
  annotation (
defaultComponentName="datVal",
defaultComponentPrefixes="parameter",
Documentation(info="<html>
<p>
This is a generic record for the normalized volume flow
rates for different valve opening positions.
See the documentation of
<a href=\"modelica://Buildings.Fluid.Actuators.Valves.Data\">
Buildings.Fluid.Actuators.Valves.Data</a>
for how to use this record.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 12, 2014, by Michael Wetter:<br/>
Added annotation <code>defaultComponentPrefixes=\"parameter\"</code>
so that the <code>parameter</code> keyword is added when dragging
the record into a model.
</li>
<li>
March 27, 2014, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Generic;

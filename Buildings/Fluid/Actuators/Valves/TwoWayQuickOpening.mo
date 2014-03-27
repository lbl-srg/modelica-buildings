within Buildings.Fluid.Actuators.Valves;
model TwoWayQuickOpening "Two way valve with linear flow characteristics"
  extends BaseClasses.PartialTwoWayValve;
  parameter Real alp = 2 "Parameter for valve characteristics, alp>0";
  parameter Real delta0 = 0.01 "Range of significant deviation from power law";
  parameter Real l(min=1e-10, max=1) = 0.0001
    "Valve leakage, l=Kv(y=0)/Kv(y=1)";
protected
   parameter Real alpInv = 1/alp;

initial equation
  // Since the flow model Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow computes
  // 1/k^2, the parameter l must not be zero.
  assert(l > 0, "Valve leakage parameter l must be bigger than zero.");

equation
  if homotopyInitialization then
     phi = homotopy(actual=l + Modelica.Fluid.Utilities.regPow(y_actual, alpInv, delta0) * (1 - l),
                    simplified=l + y_actual * (1 - l));
  else
     phi = l + Modelica.Fluid.Utilities.regPow(y_actual, alpInv, delta0) * (1 - l);
  end if;
annotation (
defaultComponentName="val",
Documentation(info="<html>
<p>
Two way valve with a power function for the valve opening characteristic.
Valves that need to open quickly typically have such a valve characteristics.
</p><p>
This model is based on the partial valve model 
<a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve\">
Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve</a>.
Check this model for more information, such
as the leakage flow or regularization near the origin.
</p>
</html>",
revisions="<html>
<ul>
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
March 25, 2011, by Michael Wetter:<br/>
Added homotopy method.
</li>
<li>
June 3, 2008 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end TwoWayQuickOpening;

within Buildings.Fluid.Actuators.Valves;
model TwoWayQuickOpening "Two way valve with linear flow characteristics"
  extends BaseClasses.PartialTwoWayValve;
annotation (
Documentation(info="<html>
<p>
Two way valve with a power function for the valve opening characteristic.
Valves that need to open quickly typically have such a valve characteristics.
</p><p>
This model is based on the partial valve model 
<a href=\"Modelica:Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve\">
PartialTwoWayValve</a>. Check this model for more information, such
as the leakage flow or regularization near the origin.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 3, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  parameter Real alp = 2 "Parameter for valve characteristics, alp>0";
  parameter Real delta0 = 0.01 "Range of significant deviation from power law";
protected
   parameter Real alpInv = 1/alp;
equation
  phi = l + Modelica.Fluid.Utilities.regPow(y, alpInv, delta0) * (1 - l);
end TwoWayQuickOpening;

within Buildings.Fluid.Actuators.Valves;
model TwoWayQuickOpening "Two way valve with linear flow characteristics"
  extends BaseClasses.PartialTwoWayValve;
  parameter Real alp = 2 "Parameter for valve characteristics, alp>0";
  parameter Real delta0 = 0.01 "Range of significant deviation from power law";
protected
   parameter Real alpInv = 1/alp;
equation
  if homotopyInitialization then
     phi = homotopy(actual=l + Modelica.Fluid.Utilities.regPow(y, alpInv, delta0) * (1 - l),
                    simplified=l + y * (1 - l));
  else
     phi = l + Modelica.Fluid.Utilities.regPow(y, alpInv, delta0) * (1 - l);
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
March 25, 2011, by Michael Wetter:<br>
Added homotopy method.
</li>
<li>
June 3, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end TwoWayQuickOpening;

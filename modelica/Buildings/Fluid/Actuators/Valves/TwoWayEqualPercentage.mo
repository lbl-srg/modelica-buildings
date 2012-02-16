within Buildings.Fluid.Actuators.Valves;
model TwoWayEqualPercentage "Two way valve with linear flow characteristics"
  extends BaseClasses.PartialTwoWayValve;
  parameter Real R = 50 "Rangeability, R=50...100 typically";
  parameter Real delta0 = 0.01
    "Range of significant deviation from equal percentage law";
initial equation
 assert(l < 1/R, "Wrong parameters in valve model.\n"
               + "  Rangeability R = " + String(R) +  "\n"
               + "  Leakage flow l = " + String(l) +  "\n"
               + "  Must have l < 1/R = " + String(1/R));

equation
  if homotopyInitialization then
     phi = homotopy(actual=Buildings.Fluid.Actuators.BaseClasses.equalPercentage(y_actual, R, l, delta0),
                    simplified=l + y_actual * (1 - l));
  else
     phi = Buildings.Fluid.Actuators.BaseClasses.equalPercentage(y_actual, R, l, delta0);
  end if;
annotation (
defaultComponentName="val",
Documentation(info="<html>
<p>
Two way valve with an equal percentage valve opening characteristic.
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
February 14, 2012 by Michael Wetter:<br>
Added filter to approximate the travel time of the actuator.
</li>
<li>
March 25, 2011, by Michael Wetter:<br>
Added homotopy method.
</li>
<li>
June 5, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"), Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Text(
          extent={{-74,20},{-36,-24}},
          lineColor={255,255,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="%%")}));
end TwoWayEqualPercentage;

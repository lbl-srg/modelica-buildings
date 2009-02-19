within Buildings.Fluids.Actuators.Valves;
model TwoWayEqualPercentage "Two way valve with linear flow characteristics"
  extends BaseClasses.PartialTwoWayValve;
annotation (
Documentation(info="<html>
<p>
Two way valve with an equal percentage valve opening characteristic.
</p><p>
This model is based on the partial valve model 
<a href=\"Modelica:Buildings.Fluids.Actuators.BaseClasses.PartialTwoWayValve\">
PartialTwoWayValve</a>. Check this model for more information, such
as the leakage flow or regularization near the origin.
</p>
</html>",
revisions="<html>
<ul>
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
  parameter Real R = 50 "Rangeability, R=50...100 typically";
  parameter Real delta0 = 0.01
    "Range of significant deviation from equal percentage law";
initial equation
 assert(l < 1/R, "Wrong parameters in valve model.\n"
               + "  Rangeability R = " + realString(R) +  "\n"
               + "  Leakage flow l = " + realString(l) +  "\n"
               + "  Must have l < 1/R = " + realString(1/R));

equation
  phi = Buildings.Fluids.Actuators.BaseClasses.equalPercentage(y, R, l, delta0);
end TwoWayEqualPercentage;

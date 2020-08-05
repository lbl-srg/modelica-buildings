within Buildings.Fluid.Actuators.Valves;
model ThreeWayLinear "Three way valve with linear characteristics"
    extends BaseClasses.PartialThreeWayValve(
      redeclare TwoWayLinear res1(
        final l=l[1]),
      redeclare TwoWayLinear res3(
        final l=l[2]));

equation
  connect(inv.y, res3.y) annotation (Line(points={{-62.6,46},{20,46},{20,-50},{
          12,-50}},      color={0,0,127}));
  connect(y_actual, inv.u2) annotation (Line(points={{50,70},{88,70},{88,34},{
          -68,34},{-68,41.2}},
                         color={0,0,127}));
  connect(y_actual, res1.y) annotation (Line(points={{50,70},{88,70},{88,34},{
          -50,34},{-50,12}},
        color={0,0,127}));
  annotation (defaultComponentName="val",
Documentation(info="<html>
<p>
Three way valve with linear opening characteristic.
</p><p>
This model is based on the partial valve models
<a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.PartialThreeWayValve\">
Buildings.Fluid.Actuators.BaseClasses.PartialThreeWayValve</a> and
<a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve\">
Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve</a>.
See
<a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.PartialThreeWayValve\">
Buildings.Fluid.Actuators.BaseClasses.PartialThreeWayValve</a>
for the implementation of the three way valve
and see
<a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve\">
Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve</a>
for the implementation of the regularization near the origin.
</p>
</html>",
revisions="<html>
<ul>
<li>
November 5, 2019, by Michael Wetter:<br/>
Moved assignment of leakage from <a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.PartialThreeWayValve\">
Buildings.Fluid.Actuators.BaseClasses.PartialThreeWayValve</a>
to the parent classes.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1227\">#1227</a>.
</li>
<li>
February 20, 2012 by Michael Wetter:<br/>
Renamed parameter <code>dp_nominal</code> to <code>dpValve_nominal</code>,
and added new parameter <code>dpFixed_nominal</code>.
See
<a href=\"modelica://Buildings.Fluid.Actuators.UsersGuide\">
Buildings.Fluid.Actuators.UsersGuide</a>.
</li>
<li>
February 14, 2012 by Michael Wetter:<br/>
Added filter to approximate the travel time of the actuator.
</li>
<li>
March 25, 2011, by Michael Wetter:<br/>
Added homotopy method.
</li>
<li>
June 16, 2008 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ThreeWayLinear;

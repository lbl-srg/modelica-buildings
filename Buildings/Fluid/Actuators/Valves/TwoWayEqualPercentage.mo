within Buildings.Fluid.Actuators.Valves;
model TwoWayEqualPercentage "Two way valve with linear flow characteristics"
  extends BaseClasses.PartialTwoWayValveKv(phi=if homotopyInitialization then
        homotopy(actual=Buildings.Fluid.Actuators.BaseClasses.equalPercentage(
        y_actual,
        R,
        l,
        delta0), simplified=l + y_actual*(1 - l)) else
        Buildings.Fluid.Actuators.BaseClasses.equalPercentage(
        y_actual,
        R,
        l,
        delta0));
  parameter Real R=50 "Rangeability, R=50...100 typically";
  parameter Real delta0=0.01
    "Range of significant deviation from equal percentage law";

initial equation
  // Since the flow model Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow computes
  // 1/k^2, the parameter l must not be zero.
  assert(l > 0, "Valve leakage parameter l must be bigger than zero.");
  assert(l < 1/R, "Wrong parameters in valve model.\n"
                + "  Rangeability R = " + String(R) + "\n"
                + "  Leakage flow l = " + String(l) + "\n"
                + "  Must have l < 1/R = " + String(1/R));
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
as the regularization near the origin.
</p>
</html>", revisions="<html>
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
June 5, 2008 by Michael Wetter:<br/>
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

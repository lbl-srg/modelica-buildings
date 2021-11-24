within Buildings.Fluid.Actuators.Valves;
model TwoWayEqualPercentage
  "Two way valve with equal percentage flow characteristics"
  extends BaseClasses.PartialTwoWayValveKv(
    phi=max(0.1*l, if homotopyInitialization then
        homotopy(actual=Buildings.Fluid.Actuators.BaseClasses.equalPercentage(
        y_actual,
        R,
        l,
        delta0), simplified=l + y_actual*(1 - l)) else
        Buildings.Fluid.Actuators.BaseClasses.equalPercentage(
        y_actual,
        R,
        l,
        delta0)));
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
June 10, 2021, by Michael Wetter:<br/>
Changed implementation of the filter and changed the parameter <code>order</code> to a constant
as most users need not change this value.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1498\">#1498</a>.
</li>
<li>
August 7, 2020, by Ettore Zanetti:<br/>
changed the computation of <code>phi</code> using
<code>max(0.1*l, . )</code> to avoid
phi=0.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1376\">
issue 1376</a>.
</li>
<li>
February 21, 2020, by Michael Wetter:<br/>
Changed icon to display its operating state.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1294\">#1294</a>.
</li>
<li>
November 9, 2019, by Filip Jorissen:<br/>
Guarded the computation of <code>phi</code> using
<code>max(0, . )</code> to avoid
negative phi.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1223\">
issue 1223</a>.
</li>
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
          lineColor=DynamicSelect({255,255,255}, (1-y)*{255,255,255}),
          fillPattern=FillPattern.Solid,
          textString="%%")}));
end TwoWayEqualPercentage;

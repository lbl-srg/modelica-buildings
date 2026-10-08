within Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.Validation;
model HeatingAndCooling "Validation model for the heating or cooling block"

  Buildings.Controls.OBC.DemandFlexibility.ZoneTemperatureSetpointChange.HeatingAndCooling
    heaOrCoo annotation (Placement(transformation(extent={{-26,-58},{18,20}})));
  annotation (experiment(StopTime=172800, Interval=60, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/DemandFlexibility/Generic/Validation/SetpointChange.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.Generic.SetpointChange\">
Buildings.Controls.OBC.DemandFlexibility.Generic.SetpointChange</a>.
</p>
<p>
This validation test uses two constant temperatures, the minimum temperature setpoint
<code>TAllMinSet</code> and the maximum temperature setpoint <code>TAllMaxSet</code>,
to set the inputs <code>uAllMinSet</code> and <code>uAllMaxSet</code>. It also uses
a boolean pulse signal to set the input <code>uEna</code> to enable the setpoint
change.
</p>
<p>
A <code>UnitDelay</code> block emulates the behavior of a temperature setpoint
within an external zone temperature setpoint controller. When this external zone
temperature setpoint controller receives the setpoint <code>y</code> from the
<code>SetpointChange</code> block at
<a href=\"modelica://Buildings.Controls.OBC.DemandFlexibility.Generic.SetpointChange\">
Buildings.Controls.OBC.DemandFlexibility.Generic.SetpointChange</a>, the
temperature setpoint within the external zone temperature setpoint controller will
be changed to <code>y</code> a small time delay later, set to <code>10</code>
seconds, and the new temperature setpoint value will be sent back to the
<code>uCurSet</code> variable in the <code>SetpointChange</code> block, completing a
full control loop.
</p>
<p>
The setpoint change operation is executed every <code>300</code> seconds, which is 
represented by a <code>Sampler</code> block.
</p>
</html>",revisions="<html>
<ul>
<li>
July 20, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-120,-100},{120,100}}),
        graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-120,-100},{120,
            100}})));
end HeatingAndCooling;

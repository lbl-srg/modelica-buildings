within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Subsequences.Validation;
model MappingWithoutWSE
  "Validate sequence of specifying equipment setpoint based on head pressure control loop output"
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Subsequences.MappingWithoutWSE
    fixPumSpe
    "Specify setpoints for plant with constant speed condenser water pumps"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Subsequences.MappingWithoutWSE
    varPumSpe(final have_fixSpeConWatPum=false)
    "Specify setpoints for plant with constant speed condenser water pumps"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse enaPreCon(
    width=0.8,
    period=5) "Constant true"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant desPumSpe(
    k=0.75) "Design condenser water pump speed at current stage"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp conLoo(duration=3.5)
    "Control loop output"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));

equation
  connect(conLoo.y, fixPumSpe.uHeaPreCon)
    annotation (Line(points={{-38,60},{-20,60},{-20,48},{-2,48}}, color={0,0,127}));
  connect(enaPreCon.y, fixPumSpe.uHeaPreEna)
    annotation (Line(points={{-38,0},{-12,0},{-12,32},{-2,32}}, color={255,0,255}));
  connect(conLoo.y, varPumSpe.uHeaPreCon)
    annotation (Line(points={{-38,60},{-20,60},{-20,-32},{-2,-32}}, color={0,0,127}));
  connect(enaPreCon.y, varPumSpe.uHeaPreEna)
    annotation (Line(points={{-38,0},{-12,0},{-12,-48},{-2,-48}}, color={255,0,255}));
  connect(desPumSpe.y, varPumSpe.desConWatPumSpe)
    annotation (Line(points={{-38,-40},{-2,-40}}, color={0,0,127}));

annotation (
  experiment(StopTime=5.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/HeadPressure/Subsequences/Validation/MappingWithoutWSE.mos"
    "Simulate and plot"),
  Documentation(info="<html>

<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Subsequences.MappingWithoutWSE\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Subsequences.MappingWithoutWSE</a>.
It demonstrates the setpoints control based on the output
from the head pressure control loop.
</p>
<p>
The instances <code>fixPumSpe</code> and <code>varPumSpe</code> shows
the control of the plants with the fixed speed condenser water pump
and the variable speed condenser water pump respectively.
</p>
<ul>
<li>
In instance <code>fixPumSpe</code>, the condenser water pump
speed is fixed.
<ul>
<li>
When the loop signal <code>uHeaPreCon</code> changes from 0 to
50%, the maximum cooling tower speed setpoint <code>yMaxTowSpeSet</code>
resets from 100% to the minimum speed <code>minTowSpe</code> (0.1).
</li>
<li>
When the loop signal <code>uHeaPreCon</code> changes from 50% to
100%, the head pressure control valve setpoint <code>yHeaPreConVal</code>
resets from 100% to the
minimum position <code>minHeaPreValPos</code> (0.1).
</li>
</ul>
</li>
<li>
In instance <code>varPumSpe</code>, the condenser water pump
speed is variable.
<ul>
<li>
When the loop signal <code>uHeaPreCon</code> changes from 0 to
50%, the maximum cooling tower speed setpoint <code>yMaxTowSpeSet</code>
resets from 100% to the minimum speed <code>minTowSpe</code> (0.1).
</li>
<li>
When the loop signal <code>uHeaPreCon</code> changes from 50% to
100%, the condenser water pump speed setpoint <code>yConWatPumSpeSet</code>
resets from the design condenser water pump speed <code>desConWatPumSpe</code>
to the minimum speed <code>minConWatPumSpe</code> (0.1).
</li>
</ul>
</li>
<li>
For both instances, when the head pressure control loop becomes disabled,
the head pressure control valve is fully closed; the maximum
tower speed setpoint and the condenser water pump speed
setpoint becomes 0.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
April 1, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end MappingWithoutWSE;

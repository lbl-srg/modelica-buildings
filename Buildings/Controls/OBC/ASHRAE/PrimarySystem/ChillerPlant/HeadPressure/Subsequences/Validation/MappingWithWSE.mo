within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Subsequences.Validation;
model MappingWithWSE
  "Validate sequence of specifying equipment setpoint based on head pressure control loop output"
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Subsequences.MappingWithWSE
    witWSE
    "Specify setpoints for plant when waterside economizer is enabled"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Subsequences.MappingWithWSE
    noWSE
    "Specify setpoints for plant when waterside economizer is disabled"
    annotation (Placement(transformation(extent={{60,-90},{80,-70}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant enaWSE(
    k=true) "Constant true"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant desPumSpe(
    k=0.75) "Design condenser water pump speed at current stage"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp conLoo(duration=3.5)
                "Control loop output"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Buildings.Controls.OBC.CDL.Logical.Not disWSE
    "Disabled economizer"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse enaPreCon(
    width=0.9,
    period=5)
    "Pressure control enabling status"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));

equation
  connect(conLoo.y, witWSE.uHeaPreCon)
    annotation (Line(points={{-38,80},{-24,80},{-24,68},{58,68}}, color={0,0,127}));
  connect(desPumSpe.y, witWSE.desConWatPumSpe)
    annotation (Line(points={{-38,40},{-20,40},{-20,64},{58,64}}, color={0,0,127}));
  connect(enaWSE.y, witWSE.uWSE)
    annotation (Line(points={{-38,0},{-16,0},{-16,56},{58,56}}, color={255,0,255}));
  connect(conLoo.y, noWSE.uHeaPreCon)
    annotation (Line(points={{-38,80},{-24,80},{-24,-72},{58,-72}}, color={0,0,127}));
  connect(desPumSpe.y, noWSE.desConWatPumSpe)
    annotation (Line(points={{-38,40},{-20,40},{-20,-76},{58,-76}}, color={0,0,127}));
  connect(enaWSE.y, disWSE.u)
    annotation (Line(points={{-38,0},{-2,0}}, color={255,0,255}));
  connect(disWSE.y, noWSE.uWSE) annotation (Line(points={{22,0},{40,0},{40,-84},
          {58,-84}}, color={255,0,255}));
  connect(enaPreCon.y, witWSE.uHeaPreEna) annotation (Line(points={{-38,-40},{-12,
          -40},{-12,52},{58,52}}, color={255,0,255}));
  connect(enaPreCon.y, noWSE.uHeaPreEna) annotation (Line(points={{-38,-40},{-12,
          -40},{-12,-88},{58,-88}}, color={255,0,255}));
annotation (
  experiment(StopTime=5.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/HeadPressure/Subsequences/Validation/MappingWithWSE.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Subsequences.MappingWithWSE\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Subsequences.MappingWithWSE</a>.
It demonstrates the setpoints control based on the output
from the head pressure control loop.
</p>
<p>
The instances <code>witWSE</code> and <code>noWSE</code> shows
the control when the waterside economizer is enabled and disabled
respectively.
</p>
<ul>
<li>
In instance <code>withWSE</code>, the economizer is enabled. 
Thus, the maximum tower speed setpoint and the condenser
water pump speed setpoint equal their maximum, which are 1.
The head pressure control valve position <code>yHeaPreConVal</code>
resets from 100% open at 0% loop output to minimum position
<code>minHeaPreValPos</code> (0.1) at 100% loop output.
</li>
<li>
In instance <code>noWSE</code>, the economizer is disabled.
<ul>
<li>
When the loop signal <code>uHeaPreCon</code> changes from 0 to
50%, the maximum cooling tower speed setpoint <code>yMaxTowSpeSet</code>
resets from 100% to the minimum speed <code>minTowSpe</code> (0.1).
</li>
<li>
When the loop signal <code>uHeaPreCon</code> changes from 50% to
100%, the water pump speed setpoint <code>yConWatPumSpeSet</code>
resets from the stage <code>desConWatPumSpe</code> (0.75) to the
minimum speed <code>minConWatPumSpe</code> (0.1).
</li>
<li>
The head pressure control valve is fully open.
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
end MappingWithWSE;

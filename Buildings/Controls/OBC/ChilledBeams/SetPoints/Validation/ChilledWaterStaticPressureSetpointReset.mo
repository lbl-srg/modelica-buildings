within Buildings.Controls.OBC.ChilledBeams.SetPoints.Validation;
model ChilledWaterStaticPressureSetpointReset
  "Validate chilled water static pressure setpoint reset"

  Buildings.Controls.OBC.ChilledBeams.SetPoints.ChilledWaterStaticPressureSetpointReset
    chiWatStaPreSetRes(
    final nVal=2,
    final nPum=2,
    final chiWatStaPreMax=30000,
    final chiWatStaPreMin=20000)
    "Instance of chilled water pressure setpoint reset calculation"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul[2](
    final period=fill(4000, 2))
    "Boolean pulse source"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sin2[2](
    final amplitude=fill(0.5, 2),
    final freqHz=fill(1/1800, 2),
    final phase=fill(1.57, 2),
    final offset=fill(0.5, 2))
    "Sine signal"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));

equation
  connect(booPul.y, chiWatStaPreSetRes.uPumSta) annotation (Line(points={{-38,30},
          {20,30},{20,4},{38,4}},     color={255,0,255}));
  connect(sin2.y, chiWatStaPreSetRes.uValPos) annotation (Line(points={{-38,-30},
          {20,-30},{20,-4},{38,-4}}, color={0,0,127}));
annotation (
  experiment(
      StopTime=3600,
      Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ChilledBeams/SetPoints/Validation/ChilledWaterStaticPressureSetpointReset.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ChilledBeams.SetPoints.ChilledWaterStaticPressureSetpointReset\">
Buildings.Controls.OBC.ChilledBeams.SetPoints.ChilledWaterStaticPressureSetpointReset</a>.
</p>
<p>
It consists of an open-loop setup for block <code>chiWatStaPreSetRes</code> with
a Boolean pulse signal <code>booPul</code> that is used to simulate pump proven on signal
and a sine signal <code>sin2</code> that is used to simulate chilled water control valve position on chilled beams. 
The block determines the pump static pressure setpoint <code>chiWatStaPreSetRes.yStaPreSetPoi</code>
based on a trim-and-respond logic, which is activated if any of the chilled water control valves 
<code>uValPos</code> are open greater than <code>valPosOpe</code> and deactivated
if less than <code>valPosClo</code>.
</p>
<p>
The following observations should be apparent from the simulation plots:
<ol>
<li>
The block <code>chiWatStaPreSetRes</code> generates requests to reset pump static pressure setpoints
(<code>yStaPreSetPoi</code>) when pump proven on signal is true
(<code>uPumSta=true</code>) and chilled water control valve is open greater than 
<code>valPosLowOpe</code> for time period <code>thrTimLow</code> continuously.
</li>
<li>
It generates zero requests when <code>uPumSta=false</code>.
</li>
</ol>
</p>
</html>", revisions="<html>
<ul>
<li>
June 16, 2021, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                         graphics={
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
end ChilledWaterStaticPressureSetpointReset;

within Buildings.Controls.OBC.ChilledBeams.SetPoints.Validation;
model BypassValvePosition
  "Validate bypass valve position setpoint controller"

  Buildings.Controls.OBC.ChilledBeams.SetPoints.BypassValvePosition
    bypValPos(
    nPum=2,
    final k=10,
    final Ti=0.001)
    "Bypass valve position setpoint controller"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pul(
    final amplitude=0.1,
    final period=2000,
    final shift=10,
    final offset=0.1)
    "Real pulse source"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin(
    final amplitude=10000,
    final freqHz=1/1000,
    final offset=45000)
    "Real sine source"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul[2](
    final period=fill(4000,2),
    final shift=fill(10, 2))
    "Boolean pulse source"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));

equation
  connect(booPul.y, bypValPos.uPumSta) annotation (Line(points={{-58,40},{-20,40},
          {-20,6},{-2,6}}, color={255,0,255}));

  connect(pul.y, bypValPos.uPumSpe)
    annotation (Line(points={{-58,0},{-2,0}}, color={0,0,127}));

  connect(sin.y, bypValPos.dpChiWatLoo) annotation (Line(points={{-58,-40},{-20,
          -40},{-20,-6},{-2,-6}}, color={0,0,127}));

annotation (
  experiment(
      StopTime=7200,
      Interval=1,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ChilledBeams/SetPoints/Validation/BypassValvePosition.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ChilledBeams.SetPoints.BypassValvePosition\">
Buildings.Controls.OBC.ChilledBeams.SetPoints.BypassValvePosition</a>.
</p>
<p>
It consists of an open-loop setup for block <code>bypValPos</code> with
a Boolean pulse signal <code>booPul</code> that is used to simulate pump proven on signal, 
a real pulse signal <code>pul</code> that is used to simulate pump speed, 
and a sine signal <code>sin</code> that is used to simulate chilled water loop differential static pressure. 
The block determines the bypass valve position setpoint <code>bypValPos.yBypValPos</code>
based on the pump proven on status <code>uPumSta</code>, measured pump 
speed <code>uPumSpe</code> and measured differential pressure across the
demand loop <code>dpChiWatLoo</code>.
</p>
<p>
The following observations should be apparent from the simulation plots:
<ol>
<li>
When none of the pumps are proven on (<code>bypValPos.uPumSta[1]=false</code> and <code>bypValPos.uPumSta[2]=false</code>)
for times between 2000 and 4000 seconds and for times greater than 6000 seconds, 
the bypass valve position is completely opened (<code>bypValPos.yBypValPos=1</code>).
</li>
<li>
When the pumps are proven on and are running at minimum speed (<code>bypValPos.minPumSpe=0.1</code>), 
the bypass valve position <code>bypValPos.yBypValPos</code> is used to regulate <code>dpChiWatLoo</code> at 
maximum allowed loop pressure <code>dPChiWatMax</code>.
</li>
</ol>
</p>
</html>", revisions="<html>
<ul>
<li>
July 14, 2021, by Karthik Devaprasad:<br/>
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
end BypassValvePosition;

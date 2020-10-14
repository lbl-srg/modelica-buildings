within Buildings.Controls.OBC.FDE;
model LatchExample "Example of latch block to demonstrate expected behavior."
  CDL.Logical.Latch lat
    annotation (Placement(transformation(extent={{38,-10},{58,10}})));
  CDL.Continuous.Sources.Sine sin(
    amplitude=10,
    freqHz=1/4800,
    phase=1.5707963267949,
    offset=10,
    startTime=0)
    annotation (Placement(transformation(extent={{-54,-10},{-34,10}})));
  CDL.Continuous.GreaterThreshold greThr(threshold=8)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  CDL.Continuous.LessThreshold lesThr(threshold=5)
    annotation (Placement(transformation(extent={{-10,-42},{10,-22}})));
equation
  connect(sin.y, greThr.u)
    annotation (Line(points={{-32,0},{-12,0}}, color={0,0,127}));
  connect(greThr.y, lat.u)
    annotation (Line(points={{12,0},{36,0}}, color={255,0,255}));
  connect(sin.y, lesThr.u) annotation (Line(points={{-32,0},{-22,0},{-22,-32},{
          -12,-32}}, color={0,0,127}));
  connect(lesThr.y, lat.clr) annotation (Line(points={{12,-32},{24,-32},{24,-6},
          {36,-6}}, color={255,0,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=4800, __Dymola_Algorithm="Dassl"),
    Documentation(revisions="<html>
<ul>
<li>
October 13, 2020, by Henry Nickels:</br>
First implementation.</li>
</ul>
</html>", info="<html>
<p>
This example simulates
<a href=\"modelica://Buildings.Controls.OBC.CDL.Logical.Latch\">
Buildings.Controls.OBC.CDL.Logical.Latch</a> to demonstrate 
concerns with initial state evaluation.
</p>
</html>"));
end LatchExample;

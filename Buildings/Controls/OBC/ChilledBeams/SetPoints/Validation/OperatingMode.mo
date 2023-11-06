within Buildings.Controls.OBC.ChilledBeams.SetPoints.Validation;
model OperatingMode
  "Validate system operating mode setpoint controller"

  parameter Integer nSchRow = 4
    "Number of rows in schedule table";

  parameter Real schTab[nSchRow,2] = [0,0; 2,1; 18,1; 24,1]
    "Table defining schedule for enabling plant";

  Buildings.Controls.OBC.ChilledBeams.SetPoints.OperatingMode operatingMode
    "Instance of operating mode calculator for validation"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));

protected
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr(
    final t=0.5)
    "Covert Real signal to Boolean"
    annotation (Placement(transformation(extent={{-30,-30},{-10,-10}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable enaSch(
    final table=schTab,
    final smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    final timeScale=3600)
    "Table defining when occupancy is expected"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final period=4000)
    "Boolean pulse source"
    annotation (Placement(transformation(extent={{-30,10},{-10,30}})));

equation
  connect(booPul.y,operatingMode.uOccDet)
    annotation (Line(points={{-8,20},{0,20},{0,4},{8,4}},
                                            color={255,0,255}));
  connect(operatingMode.uOccExp, greThr.y) annotation (Line(points={{8,-4},{0,-4},
          {0,-20},{-8,-20}},  color={255,0,255}));
  connect(greThr.u, enaSch.y[1])
    annotation (Line(points={{-32,-20},{-38,-20}}, color={0,0,127}));
annotation (
  experiment(
      StopTime=14400,
      Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ChilledBeams/SetPoints/Validation/OperatingMode.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ChilledBeams.SetPoints.OperatingMode\">
Buildings.Controls.OBC.ChilledBeams.SetPoints.OperatingMode</a>.
</p>
<p>
It consists of an open-loop setup for block <code>operatingMode</code> with
a Boolean pulse input <code>booPul</code> that is used to simulate the detection of occupancy signal <code>operatingMode.uDetOcc</code>, 
a Boolean inuput <code>greThr</code> from a time table that is used to simulate occupancy schedule signal <code>operatingMode.uOcc</code>, 
and a Integer output <code>operatingMode.yOpeMod</code> that generates system operating mode signal. 
</p>
<p>
The following observations should be apparent from the simulation plots:
<ol>
<li>
When occupancy detected in the zone (<code>uOccDet=true</code>), the system 
operating mode setpoint is 1 (<code>yOpeMod=1</code>).
</li>
<li>
When <code>uOccDet=false</code> and <code>uOccExp=false</code>, 
the setpoint is 2 (<code>yOpeMod=2</code>).
</li>
<li>
When <code>uOccDet=false</code> and <code>uOccExp=true</code>, 
the setpoint is 3 (<code>yOpeMod=3</code>).
</li>
</ol>
</p>
</html>", revisions="<html>
<ul>
<li>
July 1, 2021, by Karthik Devaprasad:<br/>
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
end OperatingMode;

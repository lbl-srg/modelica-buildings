within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChilledBeams.SecondaryPumps.Subsequences.Validation;
model EnableLag_pumpSpeed
  "Validate sequence for enabling variable-speed lag pumps using pump speed"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChilledBeams.SecondaryPumps.Subsequences.EnableLag_pumpSpeed
    enaLagPum
    "Test instance for speed-limit speLim"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold yUp(
    final trueHoldDuration=10,
    final falseHoldDuration=0)
    "Hold stage-up signal for easy visualization"
    annotation (Placement(transformation(extent={{50,20},{70,40}})));

  Buildings.Controls.OBC.CDL.Logical.TrueFalseHold yDow(
    final trueHoldDuration=0,
    final falseHoldDuration=10)
    "Hold stage-down signal for easy visualization"
    annotation (Placement(transformation(extent={{50,-40},{70,-20}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram(
    final height=1,
    final duration=3500,
    final offset=0,
    final startTime=0)
    "Ramp input"
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));

equation
  connect(enaLagPum.yUp, yUp.u) annotation (Line(points={{12,4},{20,4},{20,30},
          {48,30}}, color={255,0,255}));

  connect(enaLagPum.yDown, yDow.u) annotation (Line(points={{12,-4},{20,-4},{20,
          -30},{48,-30}}, color={255,0,255}));

  connect(ram.y, enaLagPum.uPumSpe)
    annotation (Line(points={{-48,0},{-12,0}}, color={0,0,127}));

annotation (
  experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChilledBeams/SecondaryPumps/Subsequences/Validation/EnableLag_pumpSpeed.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChilledBeams.SecondaryPumps.Subsequences.EnableLag_pumpSpeed\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChilledBeams.SecondaryPumps.Subsequences.EnableLag_pumpSpeed</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 26, 2020, by Karthik Devaprasad:<br/>
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
              points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end EnableLag_pumpSpeed;

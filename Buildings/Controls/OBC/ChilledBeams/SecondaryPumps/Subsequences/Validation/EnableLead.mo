within Buildings.Controls.OBC.ChilledBeams.SecondaryPumps.Subsequences.Validation;
model EnableLead
  "Validate sequence for enabling lead pump of chilled beam systems"

  Buildings.Controls.OBC.ChilledBeams.SecondaryPumps.Subsequences.EnableLead
    enaLeaPum(
    final nVal=2)
    "Enable lead chilled water pump"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse pul[2](
    final period={180,360},
    final shift=fill(10, 2))
    "Real pulse source"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));

equation
  connect(pul.y, enaLeaPum.uValPos)
    annotation (Line(points={{-8,0},{8,0}}, color={0,0,127}));

annotation (
  experiment(
    StopTime=720,
    Tolerance=1e-06,
    __Dymola_Algorithm="Dassl"),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ChilledBeams/SecondaryPumps/Subsequences/Validation/EnableLead.mos"
    "Simulate and plot"),
  Documentation(info="<html>
    <p>
    This example validates
    <a href=\"modelica://Buildings.Controls.OBC.ChilledBeams.SecondaryPumps.Subsequences.EnableLead\">
    Buildings.Controls.OBC.ChilledBeams.SecondaryPumps.Subsequences.EnableLead</a>.
    </p>
    </html>", revisions="<html>
    <ul>
    <li>
    June 07, 2021, by Karthik Devaprasad:<br/>
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
end EnableLead;

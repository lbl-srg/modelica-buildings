within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses.Validation;
model NormalizedTimeDelay "Test model for calculating the normalized time delay"
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses.NormalizedTimeDelay
    norTimDel(gamma=3) "Calculate the normalized time delay"
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse rho(
    amplitude=1,
    width=0.7,
    period=1,
    offset=1)
    "Half period ratio"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
equation
  connect(rho.y, norTimDel.rho)
    annotation (Line(points={{-28,0},{-10,0}}, color={0,0,127}));
  annotation (
      experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/Utilities/PIDWithAutotuning/Relay/BaseClasses/Validation/NormalizedTimeDelay.mos" "Simulate and plot"),
      Icon(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}),
      graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
June 1, 2022, by Sen Huang:<br/>
First implementation<br/>
</li>
</ul>
</html>", info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses.NormalizedTimeDelay\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses.NormalizedTimeDelay</a>.
</p>
<p>
The input <code>rho</code> is a step signal that changes from <i>2</i> to <i>1</i> at <i>0.7</i>s.
</p>
</html>"));
end NormalizedTimeDelay;

within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.Validation;
model NormalizedTimeDelay "Test model for NormalizedTimeDelay"
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.NormalizedTimeDelay norTimDel(gamma=4)
    "Calculate the normalized time delay"
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable RefDat(table=[0,0,
        2.051; 0.298,0,2.051; 0.3,0,2.051; 0.3,1,1; 0.698,1,1; 0.7,1,1; 0.7,1.5,0.709;
        0.848,1.5,0.709; 0.85,1.5,0.709; 0.85,2,0.494; 0.998,2, 0.494; 1,2,0.494],
        extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.HoldLastPoint)
    "Data for validating the normalizedTimeDelay block"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

equation
  connect(RefDat.y[1], norTimDel.rho)
    annotation (Line(points={{-38,0},{-10,0}}, color={0,0,127}));
  annotation (
      experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/Utilities/PIDWithAutotuning/Relay/Validation/NormalizedTimeDelay.mos" "Simulate and plot"),
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
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.NormalizedTimeDelay\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.NormalizedTimeDelay</a>.
</p>
</html>"));
end NormalizedTimeDelay;

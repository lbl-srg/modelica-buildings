within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.Validation;
model NormalizedTimeDelay "Test model for NormalizedTimeDelay"
  extends Modelica.Icons.Example;
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable rho(
    table=[0,0; 0.1,0; 0.3,1; 0.7,1.5; 0.83,1.5; 0.85,2],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.HoldLastPoint)
    "The half period ratio"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.NormalizedTimeDelay
    normalizedTimeDelay(gamma=4)
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
  Modelica.Blocks.Sources.RealExpression reference(y=(normalizedTimeDelay.gamma
         - rho.y[1])/(normalizedTimeDelay.gamma - 1)/(0.35*rho.y[1] + 0.65))
    annotation (Placement(transformation(extent={{-8,26},{12,46}})));
equation
  connect(rho.y[1], normalizedTimeDelay.rho)
    annotation (Line(points={{-38,0},{-10,0}}, color={0,0,127}));
  annotation (
      experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/Utilities/PIDWithAutotuning/Relay/Validation/NormalizedTimeDelay.mos" "Simulate and plot"),
      Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
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
<a href=\"modelica://Buildings.Controls.OBC.Utilities.BaseClasses.Relay.NormalizedTimeDelay\">
Buildings.Controls.OBC.Utilities.BaseClasses.Relay.NormalizedTimeDelay</a>.
</p>
</html>"));
end NormalizedTimeDelay;

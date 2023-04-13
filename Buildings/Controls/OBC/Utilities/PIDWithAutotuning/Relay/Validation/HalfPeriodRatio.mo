within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.Validation;
model HalfPeriodRatio "Test model for HalfPeriodRatio"
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.HalfPeriodRatio halPerRat
    "Calculate the half period ratio"
    annotation (Placement(transformation(extent={{-8,-10},{12,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable tOn(
    table=[0,0; 0.1,1; 0.3,1; 0.7,1; 0.83,2; 0.85,6],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.HoldLastPoint)
    "Signal for the length of the On period"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable tOff(
    table=[0,0; 0.1,0; 0.3,0; 0.7,3; 0.83,3; 0.85,3],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.HoldLastPoint)
    "Signal for the length of the Off period"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));

equation
  connect(tOn.y[1], halPerRat.tOn) annotation (Line(points={{-38,30},{-20,30},{
          -20,6},{-10,6}},      color={0,0,127}));
  connect(tOff.y[1], halPerRat.tOff) annotation (Line(points={{-38,-30},{-20,
          -30},{-20,-6},{-10,-6}},      color={0,0,127}));
  annotation (
      experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/Utilities/PIDWithAutotuning/Relay/Validation/HalfPeriodRatio.mos" "Simulate and plot"),
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
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.HalfPeriodRatio\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.HalfPeriodRatio</a>.
</p>
</html>"));
end HalfPeriodRatio;

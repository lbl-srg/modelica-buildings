within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses.Validation;
model HalfPeriodRatio "Test model for calculating the half period ratio"
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses.HalfPeriodRatio
    halPerRat
    "Calculate the half period ratio"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse tOnSig1(
    amplitude=-0.1,
    width=0.1,
    period=1,
    offset=0.1)
    "Block that generates signals for forming the signal of the length of On period"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse tOnSig2(
    amplitude=-0.1,
    width=0.9,
    period=1,
    offset=0.1)
    "Block that generates signals for forming the signal of the length of On period"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Reals.Add tOn
    "The length of the on period"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse tOff(
    amplitude=-0.5,
    width=0.7,
    period=1,
    offset=0.5)
    "The length of the off period"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.SampleTrigger samTri(period=1, shift=0.9)
    "Stop signal for tuning"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
equation
  connect(tOff.y, halPerRat.tOff) annotation (Line(points={{-58,-60},{12,-60},{
          12,-6},{18,-6}}, color={0,0,127}));
  connect(tOnSig2.y, tOn.u1) annotation (Line(points={{-58,80},{-40,80},{-40,66},
          {-22,66}}, color={0,0,127}));
  connect(tOnSig1.y, tOn.u2) annotation (Line(points={{-58,40},{-40,40},{-40,54},
          {-22,54}}, color={0,0,127}));
  connect(tOn.y, halPerRat.tOn)
    annotation (Line(points={{2,60},{10,60},{10,6},{18,6}}, color={0,0,127}));
  connect(samTri.y, halPerRat.TunEnd) annotation (Line(points={{-58,0},{18,0}},
                         color={255,0,255}));
  annotation (
      experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/Utilities/PIDWithAutotuning/Relay/BaseClasses/Validation/HalfPeriodRatio.mos" "Simulate and plot"),
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
First implementation.<br/>
</li>
</ul>
</html>", info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses.HalfPeriodRatio\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses.HalfPeriodRatio</a>.
</p>
<p>
This testing scenario in this example is the same as that in
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses.Validation.TuningMonitor\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses.Validation.TunMonitor</a>.
The lengths of the on period and the off period are sampled at <i>0.9</i>s to
calculate the half period ratio.
</p>
</html>"));
end HalfPeriodRatio;

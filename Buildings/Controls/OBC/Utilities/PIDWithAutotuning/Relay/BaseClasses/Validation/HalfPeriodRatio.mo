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
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse tOnSig2(
    amplitude=-0.1,
    width=0.9,
    period=1,
    offset=0.1)
    "Block that generates signals for forming the signal of the length of On period"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Controls.OBC.CDL.Reals.Add tOn
    "The length of the On period"
    annotation (Placement(transformation(extent={{-34,40},{-14,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse tOff(
    amplitude=-0.5,
    width=0.7,
    period=1,
    offset=0.5)
    "The length of the Off period"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.SampleTrigger samTri(period=1, shift=0.9)
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
equation
  connect(tOff.y, halPerRat.tOff) annotation (Line(points={{-58,-60},{12,-60},{
          12,-6},{18,-6}},    color={0,0,127}));
  connect(tOnSig2.y, tOn.u1) annotation (Line(points={{-58,70},{-40,70},{-40,56},
          {-36,56}}, color={0,0,127}));
  connect(tOnSig1.y, tOn.u2) annotation (Line(points={{-58,30},{-40,30},{-40,44},
          {-36,44}}, color={0,0,127}));
  connect(tOn.y, halPerRat.tOn)
    annotation (Line(points={{-12,50},{0,50},{0,6},{18,6}}, color={0,0,127}));
  connect(samTri.y, halPerRat.TunEnd) annotation (Line(points={{-58,-10},{0,-10},
          {0,0},{18,0}}, color={255,0,255}));
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
First implementation<br/>
</li>
</ul>
</html>", info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses.HalfPeriodRatio\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses.HalfPeriodRatio</a>.
</p>
<p>
This testing scenario in this example is the same as that in <a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses.Validation.TunMonitor\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses.Validation.TunMonitor</a>.
The lengths of the On period and the Off period are sampled at <i>0.9</i>s to calculate the half period ratio.
</p>
</html>"));
end HalfPeriodRatio;

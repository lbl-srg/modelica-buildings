within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses.Validation;
model HalfPeriodRatio "Test model for calculating the half period ratio"
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses.HalfPeriodRatio
    halPerRat "Calculate the half period ratio based on a response from a relay controller"
    annotation (Placement(transformation(extent={{22,-10},{42,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse tOnSig1(
    amplitude=-0.1,
    width=0.2,
    period=1,
    offset=0.1) "Block that generates signals for forming the signal of the length of On period"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse tOnSig2(
    amplitude=-0.1,
    width=0.9,
    period=1,
    offset=0.1) "Block that generates signals for forming the signal of the length of On period"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Add tOn "Blocks that generates the length of the on period"
    annotation (Placement(transformation(extent={{-34,40},{-14,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse tOff(
    amplitude=-0.5,
    width=0.7,
    period=1,
    offset=0.5) "The length of the off period"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
equation
  connect(tOff.y, halPerRat.tOff) annotation (Line(points={{-58,-30},{0,-30},{0,
          -6},{20,-6}},       color={0,0,127}));
  connect(tOnSig2.y, tOn.u1) annotation (Line(points={{-58,70},{-40,70},{-40,56},
          {-36,56}}, color={0,0,127}));
  connect(tOnSig1.y, tOn.u2) annotation (Line(points={{-58,30},{-40,30},{-40,44},
          {-36,44}}, color={0,0,127}));
  connect(tOn.y, halPerRat.tOn)
    annotation (Line(points={{-12,50},{0,50},{0,6},{20,6}}, color={0,0,127}));
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
This example mimics an output from a relay controller.
</p>
<ul>
<li>
At <i>0.1</i>s, the output switches from On to Off.
The length of the On period becomes <i>0.1</i>s.
</li>
<li>
At <i>0.7</i>s, the output switches to On.
The length of the Off period becomes <i>0.5</i>s.
</li>
<li>
At <i>0.9</i>s, the output switches to Off.
The length of the On period becomes <i>0.2</i>s.
</li>
</ul>
</html>"));
end HalfPeriodRatio;

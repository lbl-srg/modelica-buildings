within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses.Validation;
model SamplerWithResetThreshold
  "Test model for a sampler with a reset and a threshold"
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses.SamplerWithResetThreshold
    sam(lowLim=0, y_reset=0) "Sampler"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse resSig(
    width=0.1,
    period=1,
    shift=-0.1) "Reset signal"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse u(
    amplitude=1,
    width=0.7,
    period=0.5,
    offset=-0.5) "Singal to be sampled"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
equation
  connect(u.y, sam.u) annotation (Line(points={{-38,30},{-20,30},{-20,6},{-12,6}},
        color={0,0,127}));
  connect(resSig.y, sam.trigger) annotation (Line(points={{-38,-40},{-20,-40},{-20,
          -6},{-12,-6}}, color={255,0,255}));
  annotation (
      experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/Utilities/PIDWithAutotuning/Relay/BaseClasses/Validation/SamplerWithResetThreshold.mos" "Simulate and plot"),
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
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
September 20, 2023, by Sen Huang:<br/>
First implementation<br/>
</li>
</ul>
</html>", info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses.SamplerWithResetThreshold\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.BaseClasses.SamplerWithResetThreshold</a>.
</p>
This example considers a real input, <code>u</code>, and a boolean input, <code>resSig</code>
<ul>
<li>
At <i>0.5</i>s, <code>u</code> changes from <i>0</i> to <i>1</i>, triggering the sampling;
</li>
<li>
At <i>0.9</i>s, <code>resSig</code> changes into On, triggering the reset.
</li>
</ul>
</html>"));
end SamplerWithResetThreshold;
